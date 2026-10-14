/// <reference path="../pb_data/types.d.ts" />

// The online ordering storefront (Module 1) routes.
//
// A customer orders from the web without signing in, so these routes are the
// entire public surface — the same pattern as the table-side guest routes.
// Nothing about money comes from the request: items are priced from the
// database by guest.buildLine, and the gateway amount is the server-computed
// order total. See lib_payments.js for the provider plumbing.

// GET /api/app/online-config — what the storefront needs to render itself.
routerAdd("GET", "/api/app/online-config", (e) => {
  const pay = require(`${__hooks}/lib_payments.js`);
  const outlets = require(`${__hooks}/lib_outlets.js`);

  let venue = null;
  try {
    venue = e.app.findFirstRecordByFilter("restaurant", "id != ''");
  } catch (err) { /* not set up yet */ }

  if (!venue || !venue.getBool("setup_complete")) {
    return e.json(200, { enabled: false });
  }

  const outletRows = e.app.findRecordsByFilter(
    "outlets", "active = true", "sort_order", 0, 0,
  );

  return e.json(200, {
    enabled: pay.env("DINEOS_ONLINE_ENABLED") !== "false",
    test_mode: pay.testMode(),
    restaurant: {
      name: venue.getString("name"),
      currency_symbol: venue.getString("currency_symbol"),
      currency_code: venue.getString("currency_code"),
    },
    outlets: outletRows.map((o) => ({
      id: o.id,
      name: o.getString("name"),
      address: o.getString("address"),
      currency_symbol: o.getString("currency_symbol"),
      currency_code: o.getString("currency_code"),
    })),
    providers: pay.providers(),
  });
});

// POST /api/app/online-order — raise a takeaway/delivery order and fire it to
// the kitchen immediately.
//
// Unlike a table-side guest order (which lands unsent for a waiter to fire),
// an online order is already the customer's final word: the lines go straight
// onto the KDS with sent_at set. Payment is either settled now through a
// gateway, or left for the counter.
routerAdd("POST", "/api/app/online-order", (e) => {
  const guest = require(`${__hooks}/lib_guest.js`);
  const pay = require(`${__hooks}/lib_payments.js`);
  const outlets = require(`${__hooks}/lib_outlets.js`);

  const body = e.requestInfo().body || {};
  const requested = Array.isArray(body.items) ? body.items : [];

  if (requested.length === 0) {
    return e.json(400, { message: "Your order is empty." });
  }
  if (requested.length > 40) {
    return e.json(400, { message: "That is too many items for one order." });
  }

  // The outlet scopes the menu, the tax, and the order number. Default to the
  // first active outlet so old clients that do not send one keep working.
  let outletId = String(body.outlet || "");
  if (outletId) {
    try {
      outlets.requireOutlet(e.app, outletId);
    } catch (err) {
      return e.json(400, { message: err.message || "Choose an outlet." });
    }
  } else {
    const d = outlets.defaultOutlet(e.app);
    if (d) outletId = d.id;
  }

  const type = String(body.type || "");
  if (type !== "takeaway" && type !== "delivery") {
    return e.json(400, { message: "Choose pickup or delivery." });
  }

  const name = String(body.customer_name || "").trim();
  if (name.length < 1 || name.length > 120) {
    return e.json(400, { message: "Please give a name for the order." });
  }
  const phone = String(body.customer_phone || "").replace(/[^\d+]/g, "");
  if (phone.replace(/\D/g, "").length < 6 || phone.length > 20) {
    return e.json(400, { message: "Please give a reachable phone number." });
  }

  const address = String(body.address || "").trim();
  if (type === "delivery" && address.length < 4) {
    return e.json(400, { message: "A delivery address is needed for delivery." });
  }

  const paymentMode = String(body.payment || "counter");
  const provider = String(body.provider || "");
  if (paymentMode !== "counter" && paymentMode !== "online") {
    return e.json(400, { message: "Choose how to pay." });
  }
  if (paymentMode === "online") {
    if (provider !== "razorpay" && provider !== "stripe") {
      return e.json(400, { message: "Choose Razorpay or Stripe." });
    }
    const ok = provider === "razorpay" ? pay.razorpayConfigured() : pay.stripeConfigured();
    if (!ok) {
      return e.json(409, {
        message: "Online payment is not set up at this restaurant yet. Please pay at the counter.",
      });
    }
  }

  // Price and validate everything before touching the bill.
  const lines = [];
  for (const item of requested) {
    lines.push(guest.buildLine(e.app, item, outletId));
  }

  const order = new Record(e.app.findCollectionByNameOrId("orders"));
  order.set("type", type);
  // "sent", not "open": every line below is fired to the kitchen the moment it
  // is saved, so the order is already on the pass. deriveOrderStatus keeps it
  // honest from here.
  order.set("status", "sent");
  if (outletId) order.set("outlet", outletId);
  order.set("customer_name", name);
  order.set("customer_phone", phone);
  order.set("note", type === "delivery" ? "Delivery to: " + address : "Pickup");
  e.app.save(order);

  // Fire to the kitchen now: sent_at set, status queued. The KDS picks these
  // up exactly like lines a waiter fired from the POS.
  const now = new Date().toISOString();
  const collection = e.app.findCollectionByNameOrId("order_items");
  for (const line of lines) {
    const record = new Record(collection);
    record.set("order", order.id);
    for (const key of Object.keys(line)) {
      record.set(key, line[key]);
    }
    record.set("status", "queued");
    record.set("sent_at", now);
    e.app.save(record);
  }

  // Re-read: the money hooks computed the total as each line was saved.
  const fresh = e.app.findRecordById("orders", order.id);

  if (paymentMode === "counter") {
    return e.json(200, {
      order_number: fresh.getString("number"),
      total: fresh.getFloat("total"),
      payment: { mode: "counter" },
    });
  }

  // Online payment: create the gateway order against the server's total, and
  // remember it in online_payments so the webhook can find the order.
  const checkout = provider === "razorpay"
    ? pay.createRazorpayOrder(fresh)
    : pay.createStripeIntent(fresh);

  const attempts = e.app.findCollectionByNameOrId("online_payments");
  const attempt = new Record(attempts);
  attempt.set("order", fresh.id);
  attempt.set("provider", provider);
  attempt.set("gateway_id", checkout.gateway_id);
  attempt.set("status", "pending");
  e.app.save(attempt);

  return e.json(200, {
    order_number: fresh.getString("number"),
    total: fresh.getFloat("total"),
    payment: Object.assign({ mode: "online", provider: provider }, checkout),
  });
});

// POST /api/app/payments/razorpay/webhook — Razorpay payment events.
//
// Verification is done by asking Razorpay about the payment, not by trusting
// the callback: status must be captured and the amount must equal the bill.
routerAdd("POST", "/api/app/payments/razorpay/webhook", (e) => {
  const pay = require(`${__hooks}/lib_payments.js`);

  const body = e.requestInfo().body || {};
  let paymentId = "";
  let gatewayId = "";

  if (pay.testMode() && body.test_event === true) {
    paymentId = String(body.payment_id || "");
    gatewayId = String(body.gateway_id || "");
  } else {
    try {
      const entity = body.payload.payment.entity;
      paymentId = String(entity.id || "");
      gatewayId = String(body.payload.order.entity.id || "");
    } catch (err) {
      return e.json(400, { message: "Unrecognised webhook payload." });
    }
  }

  if (!paymentId || !gatewayId) {
    return e.json(400, { message: "Unrecognised webhook payload." });
  }

  const found = pay.findOnlineAttempt(e.app, "razorpay", gatewayId);
  if (!found) {
    return e.json(404, { message: "No matching order." });
  }
  if (found.attempt.getString("status") === "paid") {
    // A retried callback: the money is already recorded, say so plainly.
    return e.json(200, { ok: true, already_settled: true, order_number: found.order.getString("number") });
  }

  try {
    pay.confirmRazorpayPayment(e.app, found.order, paymentId, found.attempt);
  } catch (err) {
    return e.json(400, { message: err.message || "Payment could not be confirmed." });
  }

  return e.json(200, { ok: true, order_number: found.order.getString("number") });
});

// POST /api/app/payments/stripe/webhook — Stripe payment events.
//
// Same rule: Stripe's own API is the source of truth for status and amount.
routerAdd("POST", "/api/app/payments/stripe/webhook", (e) => {
  const pay = require(`${__hooks}/lib_payments.js`);

  const body = e.requestInfo().body || {};
  let intentId = "";

  if (pay.testMode() && body.test_event === true) {
    intentId = String(body.gateway_id || "");
  } else {
    try {
      const obj = body.data.object;
      if (obj.object !== "payment_intent") {
        return e.json(200, { ok: true, ignored: true });
      }
      intentId = String(obj.id || "");
    } catch (err) {
      return e.json(400, { message: "Unrecognised webhook payload." });
    }
  }

  if (!intentId) {
    return e.json(400, { message: "Unrecognised webhook payload." });
  }

  const found = pay.findOnlineAttempt(e.app, "stripe", intentId);
  if (!found) {
    return e.json(404, { message: "No matching order." });
  }
  if (found.attempt.getString("status") === "paid") {
    return e.json(200, { ok: true, already_settled: true, order_number: found.order.getString("number") });
  }

  try {
    pay.confirmStripePayment(e.app, found.order, intentId, found.attempt);
  } catch (err) {
    return e.json(400, { message: err.message || "Payment could not be confirmed." });
  }

  return e.json(200, { ok: true, order_number: found.order.getString("number") });
});

