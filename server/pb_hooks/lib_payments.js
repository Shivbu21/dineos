// Payment provider plumbing for online orders (Module 1).
//
// Two providers, both optional and configured by environment only — secrets
// never live in the database or the repository:
//
//   DINEOS_RP_KEY_ID / DINEOS_RP_KEY_SECRET / DINEOS_RP_WEBHOOK_SECRET
//   DINEOS_STRIPE_SECRET_KEY / DINEOS_STRIPE_PUBLISHABLE_KEY / DINEOS_STRIPE_WEBHOOK_SECRET
//   DINEOS_PAYMENTS_TEST_MODE=true  — sandbox mode: no real gateway calls, the
//     storefront shows a TEST MODE banner, and webhooks accept signed test
//     events. Real credentials always win over test mode is false by default.
//
// Money rule, same as everywhere in this codebase: the amount sent to the
// gateway is the order total the server computed. The client never names a
// price. Webhooks re-confirm with the gateway (status + amount) before any
// payment record is written, so a forged callback cannot mark an order paid.

function env(name) {
  try {
    const v = $os.getenv(name);
    return v ? String(v).trim() : "";
  } catch (err) {
    return "";
  }
}

function testMode() {
  return env("DINEOS_PAYMENTS_TEST_MODE") === "true";
}

function razorpayConfigured() {
  return testMode() || (env("DINEOS_RP_KEY_ID") !== "" && env("DINEOS_RP_KEY_SECRET") !== "");
}

function stripeConfigured() {
  return testMode() || env("DINEOS_STRIPE_SECRET_KEY") !== "";
}

function providers() {
  return { razorpay: razorpayConfigured(), stripe: stripeConfigured() };
}

function toMinor(total) {
  // INR's smallest unit is the paise; both gateways bill in it.
  return Math.round((Number(total) || 0) * 100);
}

function basicAuth(user, pass) {
  return "Basic " + base64Encode(user + ":" + pass);
}

// Tiny base64 encoder: the JSVM has no btoa, and this avoids depending on a
// $security helper that may not exist on every build.
function base64Encode(input) {
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  let out = "";
  for (let i = 0; i < input.length; i += 3) {
    const a = input.charCodeAt(i);
    const b = i + 1 < input.length ? input.charCodeAt(i + 1) : 0;
    const c = i + 2 < input.length ? input.charCodeAt(i + 2) : 0;
    const n = (a << 16) | (b << 8) | c;
    out += chars[(n >> 18) & 63] + chars[(n >> 12) & 63] +
      (i + 1 < input.length ? chars[(n >> 6) & 63] : "=") +
      (i + 2 < input.length ? chars[n & 63] : "=");
  }
  return out;
}

/// Creates a Razorpay order for an already-priced dineos order.
/// Returns { gateway_id, key_id, amount, currency }.
function createRazorpayOrder(order) {
  const amount = toMinor(order.getFloat("total"));
  if (amount < 100) {
    throw new BadRequestError("That total is too small to pay online.");
  }

  if (testMode()) {
    return {
      gateway_id: "test_rp_order_" + order.id.slice(0, 12),
      key_id: "rzp_test_00000000000000",
      amount: amount,
      currency: "INR",
      test: true,
    };
  }

  const res = $http.send({
    url: "https://api.razorpay.com/v1/orders",
    method: "POST",
    headers: {
      "Authorization": basicAuth(env("DINEOS_RP_KEY_ID"), env("DINEOS_RP_KEY_SECRET")),
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      amount: amount,
      currency: "INR",
      receipt: "dineos-" + order.getString("number"),
      notes: { dineos_order: order.id },
    }),
    timeout: 20,
  });

  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw new BadRequestError("The payment provider refused the order. Please try paying at the counter.");
  }
  const data = res.json();
  return {
    gateway_id: data.id,
    key_id: env("DINEOS_RP_KEY_ID"),
    amount: amount,
    currency: "INR",
    test: false,
  };
}

/// Creates a Stripe PaymentIntent for an already-priced dineos order.
/// Returns { gateway_id, publishable_key, client_secret, amount, currency }.
function createStripeIntent(order) {
  const amount = toMinor(order.getFloat("total"));
  if (amount < 100) {
    throw new BadRequestError("That total is too small to pay online.");
  }

  if (testMode()) {
    return {
      gateway_id: "test_pi_" + order.id.slice(0, 12),
      publishable_key: "pk_test_00000000000000",
      client_secret: "test_pi_secret_00000000000000",
      amount: amount,
      currency: "inr",
      test: true,
    };
  }

  const params = "amount=" + amount +
    "&currency=inr" +
    "&metadata[dineos_order]=" + encodeURIComponent(order.id) +
    "&metadata[order_number]=" + encodeURIComponent(order.getString("number")) +
    "&description=" + encodeURIComponent("dineos order " + order.getString("number"));

  const res = $http.send({
    url: "https://api.stripe.com/v1/payment_intents",
    method: "POST",
    headers: {
      "Authorization": "Bearer " + env("DINEOS_STRIPE_SECRET_KEY"),
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: params,
    timeout: 20,
  });

  if (res.statusCode < 200 || res.statusCode >= 300) {
    throw new BadRequestError("The payment provider refused the order. Please try paying at the counter.");
  }
  const data = res.json();
  return {
    gateway_id: data.id,
    publishable_key: env("DINEOS_STRIPE_PUBLISHABLE_KEY"),
    client_secret: data.client_secret,
    amount: amount,
    currency: "inr",
    test: false,
  };
}

/// Confirms a Razorpay payment with Razorpay itself, then records it.
/// A forged callback cannot pass because Razorpay's own API is the source of
/// truth for status and amount.
function confirmRazorpayPayment(app, order, razorpayPaymentId, attempt) {
  let entity;
  if (testMode()) {
    entity = { id: razorpayPaymentId, status: "captured", amount: toMinor(order.getFloat("total")), currency: "INR" };
  } else {
    const res = $http.send({
      url: "https://api.razorpay.com/v1/payments/" + encodeURIComponent(razorpayPaymentId),
      method: "GET",
      headers: {
        "Authorization": basicAuth(env("DINEOS_RP_KEY_ID"), env("DINEOS_RP_KEY_SECRET")),
      },
      timeout: 20,
    });
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw new BadRequestError("Could not verify the payment with Razorpay.");
    }
    entity = res.json();
  }

  if (entity.status !== "captured") {
    throw new BadRequestError("That payment has not been captured yet.");
  }
  if (Number(entity.amount) !== toMinor(order.getFloat("total"))) {
    throw new BadRequestError("The paid amount does not match the bill.");
  }

  recordOnlinePayment(app, order, "razorpay", order.getFloat("total"), entity.id, attempt);
}

/// Confirms a Stripe PaymentIntent with Stripe itself, then records it.
function confirmStripePayment(app, order, paymentIntentId, attempt) {
  let intent;
  if (testMode()) {
    intent = { id: paymentIntentId, status: "succeeded", amount: toMinor(order.getFloat("total")), currency: "inr" };
  } else {
    const res = $http.send({
      url: "https://api.stripe.com/v1/payment_intents/" + encodeURIComponent(paymentIntentId),
      method: "GET",
      headers: { "Authorization": "Bearer " + env("DINEOS_STRIPE_SECRET_KEY") },
      timeout: 20,
    });
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw new BadRequestError("Could not verify the payment with Stripe.");
    }
    intent = res.json();
  }

  if (intent.status !== "succeeded") {
    throw new BadRequestError("That payment has not succeeded yet.");
  }
  if (Number(intent.amount) !== toMinor(order.getFloat("total"))) {
    throw new BadRequestError("The paid amount does not match the bill.");
  }

  recordOnlinePayment(app, order, "stripe", order.getFloat("total"), intent.id, attempt);
}

/// Writes the payment record. The money hooks roll it into paid_amount and
/// flip the order to paid; the payments guard refuses cancelled bills.
function recordOnlinePayment(app, order, method, amount, reference, attempt) {
  // Idempotent: a retried webhook must not double-count.
  try {
    const existing = app.findFirstRecordByFilter(
      "payments", "order = {:o} && reference = {:r}", { o: order.id, r: reference },
    );
    if (existing) return existing;
  } catch (err) { /* first time */ }

  const collection = app.findCollectionByNameOrId("payments");
  const payment = new Record(collection);
  payment.set("order", order.id);
  payment.set("method", method);
  payment.set("amount", Number(amount));
  payment.set("reference", reference);
  app.save(payment);

  // The attempt is settled now; a late duplicate webhook finds nothing pending.
  if (attempt) {
    attempt.set("status", "paid");
    app.save(attempt);
  }

  return payment;
}

/// Finds an online payment attempt by provider + gateway id, with its order
/// attached. Returns null when there is no such attempt.
function findOnlineAttempt(app, provider, gatewayId) {
  let attempt;
  try {
    attempt = app.findFirstRecordByFilter(
      "online_payments",
      "provider = {:p} && gateway_id = {:g}",
      { p: provider, g: gatewayId },
    );
  } catch (err) {
    return null;
  }
  let order;
  try {
    order = app.findRecordById("orders", attempt.getString("order"));
  } catch (err) {
    return null;
  }
  return { attempt: attempt, order: order };
}

module.exports = {
  env: env,
  testMode: testMode,
  providers: providers,
  razorpayConfigured: razorpayConfigured,
  stripeConfigured: stripeConfigured,
  createRazorpayOrder: createRazorpayOrder,
  createStripeIntent: createStripeIntent,
  confirmRazorpayPayment: confirmRazorpayPayment,
  confirmStripePayment: confirmStripePayment,
  findOnlineAttempt: findOnlineAttempt,
};
