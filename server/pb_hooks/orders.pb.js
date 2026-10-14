/// <reference path="../pb_data/types.d.ts" />

// Order lifecycle: sequential daily numbers, and money columns that the client
// cannot forge.

// ---------------------------------------------------------------- order_items
// Line totals are derived, never accepted from the client.

onRecordCreate((e) => {
  const money = require(`${__hooks}/lib_money.js`);
  money.applyLineTotals(e.record);
  // Denormalize the outlet from the parent order so the KDS can filter
  // tickets per outlet without a join.
  if (!e.record.getString("outlet")) {
    try {
      const order = e.app.findRecordById("orders", e.record.getString("order"));
      const oid = order.getString("outlet");
      if (oid) e.record.set("outlet", oid);
    } catch (err) { /* order gone; the line cannot be saved anyway */ }
  }
  e.next();
}, "order_items");

// A line can change parent — that is what merging two bills does. Code before
// e.next() runs pre-save and code after runs post-save, so this one hook can
// note which bill the line is leaving and then recompute *both*. Recomputing
// only the new parent would leave the old bill showing a total it no longer has.
onRecordUpdate((e) => {
  const money = require(`${__hooks}/lib_money.js`);

  let leaving = "";
  let prevStatus = "";
  let wasDeducted = false;
  try {
    const prev = e.app.findRecordById("order_items", e.record.id);
    leaving = prev.getString("order");
    prevStatus = prev.getString("status");
    wasDeducted = prev.getBool("stock_deducted");
  } catch (err) { /* new enough that there is no stored row yet */ }

  money.applyLineTotals(e.record);

  e.next();

  const joined = e.record.getString("order");
  money.recomputeOrder(e.app, joined);

  const kitchen = require(`${__hooks}/lib_kitchen.js`);
  kitchen.deriveOrderStatus(e.app, joined);

  if (leaving && leaving !== joined) {
    money.recomputeOrder(e.app, leaving);
    kitchen.deriveOrderStatus(e.app, leaving);
  }

  // Inventory (Module 3): a line deducts from stock the moment it is served,
  // and a voided line that was already deducted writes compensating entries.
  // The lib is idempotent via stock_deducted, and failures are logged rather
  // than failing the serve — the kitchen must never stop for stock.
  const inv = require(`${__hooks}/lib_inventory.js`);
  const newStatus = e.record.getString("status");
  try {
    if (newStatus === "served" && prevStatus !== "served" && !wasDeducted) {
      inv.deductForLine(e.app, e.record);
    } else if (newStatus === "void" && prevStatus !== "void" && wasDeducted) {
      inv.restoreForLine(e.app, e.record);
    }
  } catch (err) {
    console.warn("dineos: stock pipeline failed for line " + e.record.id, err);
  }
}, "order_items");

// Any change to a line rolls up into the parent order: its money, and — for
// order_items — how far through the kitchen it is.
const rollUp = (e) => {
  e.next();
  const orderId = e.record.getString("order");
  const money = require(`${__hooks}/lib_money.js`);
  money.recomputeOrder(e.app, orderId);
};

const rollUpLine = (e) => {
  e.next();
  const orderId = e.record.getString("order");
  const money = require(`${__hooks}/lib_money.js`);
  money.recomputeOrder(e.app, orderId);
  const kitchen = require(`${__hooks}/lib_kitchen.js`);
  kitchen.deriveOrderStatus(e.app, orderId);
  // A line created already served (rare — data imports) still deducts once.
  // findRecordById throws for the after-delete case, which is caught and
  // ignored: deleting a line is not a serve.
  if (e.record.getString("status") === "served") {
    try {
      const fresh = e.app.findRecordById("order_items", e.record.id);
      const inv = require(`${__hooks}/lib_inventory.js`);
      inv.deductForLine(e.app, fresh);
    } catch (err) { /* deleted line, or the serve already succeeded */ }
  }
};

onRecordAfterCreateSuccess(rollUpLine, "order_items");
onRecordAfterDeleteSuccess(rollUpLine, "order_items");
// No after-update hook for order_items: onRecordUpdate above already handles
// both sides of a reparent, and running this too would double the work.
onRecordAfterCreateSuccess(rollUp, "payments");
onRecordAfterUpdateSuccess(rollUp, "payments");
onRecordAfterDeleteSuccess(rollUp, "payments");

// --------------------------------------------------------------------- orders

onRecordCreate((e) => {
  const money = require(`${__hooks}/lib_money.js`);

  // Sequential per-day number, reset each morning: 001, 002, 003...
  // Scoped per outlet so each branch runs its own sequence; an order without
  // an outlet keeps the old venue-wide sequence.
  if (!e.record.getString("number")) {
    const now = new Date();
    const dayStart = now.toISOString().slice(0, 10) + " 00:00:00.000Z";

    const outletId = e.record.getString("outlet");
    let filter = "created >= {:from}";
    const params = { from: dayStart };
    if (outletId) {
      filter += " && outlet = {:outlet}";
      params.outlet = outletId;
    }

    let seq = 1;
    try {
      const todays = e.app.findRecordsByFilter(
        "orders", filter, "-created", 1, 0, params,
      );
      if (todays.length > 0) {
        const last = parseInt(todays[0].getString("number"), 10);
        if (!isNaN(last)) seq = last + 1;
      }
    } catch (err) { /* first order of the day */ }

    e.record.set("number", String(seq).padStart(3, "0"));
  }

  if (e.record.getString("opened_at") === "") {
    e.record.set("opened_at", new Date().toISOString());
  }

  money.applyOrderTotals(e.app, e.record);
  e.next();
}, "orders");

// Recompute in place on every save so a discount edit can't desync the total.
// This mutates the record mid-save rather than saving again, so it can't loop.
onRecordUpdate((e) => {
  const money = require(`${__hooks}/lib_money.js`);
  money.applyOrderTotals(e.app, e.record);

  let status = e.record.getString("status");

  // A bill settles itself once it is covered. Deciding this here rather than in
  // the app means a split paid across two terminals still closes exactly once,
  // and only ever when the money actually adds up.
  const inService = ["open", "sent", "preparing", "ready", "served"].indexOf(status) !== -1;
  if (inService && e.record.getBool("paid")) {
    status = "paid";
    e.record.set("status", status);
  }

  // getString, not get: an empty date field is a zero DateTime *object*, which
  // is truthy, so `!record.get(...)` never fires. Its zero value stringifies
  // to "".
  const alreadyClosed = e.record.getString("closed_at") !== "";
  if ((status === "paid" || status === "cancelled") && !alreadyClosed) {
    e.record.set("closed_at", new Date().toISOString());
  }

  e.next();
}, "orders");

// Refuse money against a bill nobody owes anything on. Without this a stray
// terminal could keep taking payments on a cancelled order.
onRecordCreate((e) => {
  let order;
  try {
    order = e.app.findRecordById("orders", e.record.getString("order"));
  } catch (err) {
    throw new BadRequestError("That bill no longer exists.");
  }

  if (order.getString("status") === "cancelled") {
    throw new BadRequestError("This bill was cancelled.");
  }

  const amount = Number(e.record.getFloat("amount")) || 0;
  if (amount <= 0) {
    throw new BadRequestError("A payment has to be for more than zero.");
  }

  e.next();
}, "payments");

// A closed order frees its table.
onRecordAfterUpdateSuccess((e) => {
  e.next();

  const status = e.record.getString("status");
  if (status !== "paid" && status !== "cancelled") return;

  const tableId = e.record.getString("table");
  if (!tableId) return;

  try {
    const open = e.app.findRecordsByFilter(
      "orders",
      "table = {:t} && status != 'paid' && status != 'cancelled'",
      "", 1, 0, { t: tableId },
    );
    if (open.length > 0) return; // another party is still seated there

    const table = e.app.findRecordById("tables", tableId);
    table.set("status", "cleaning");
    e.app.save(table);
  } catch (err) { /* table removed */ }
}, "orders");
