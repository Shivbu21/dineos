/// <reference path="../pb_data/types.d.ts" />

// Inventory API (Module 3).
//
// Stock itself is only ever written by lib_inventory.js — the API takes human
// intent (bought 20kg, wasted 1kg, recount says +2) and lets the server do the
// arithmetic. Clients never submit a balance or a ledger row.
//
// House rule: shared code is required INSIDE each handler. A function declared
// at the top of this file would not be defined inside the handler.
//
// GET  /api/app/inventory/alerts?outlet=    — staff: items at/below threshold
// GET  /api/app/inventory/valuation?outlet=  — staff: per-item stock value
// POST /api/app/inventory/purchase           — manager: { inventory_item, qty, cost_per_unit?, note? }
// POST /api/app/inventory/wastage           — staff:   { inventory_item, qty, note? }
// POST /api/app/inventory/adjust            — manager: { inventory_item, qty_delta, note? }

routerAdd("GET", "/api/app/inventory/alerts", (e) => {
  const inv = require(`${__hooks}/lib_inventory.js`);
  if (!inv.requireAuth(e)) return;
  const outlet = inv.resolveOutlet(e, e.app);
  if (!outlet) return;

  return e.json(200, {
    outlet_id: outlet.id,
    alerts: inv.lowStockAlerts(e.app, outlet.id),
  });
});

routerAdd("GET", "/api/app/inventory/valuation", (e) => {
  const inv = require(`${__hooks}/lib_inventory.js`);
  if (!inv.requireAuth(e)) return;
  const outlet = inv.resolveOutlet(e, e.app);
  if (!outlet) return;

  const val = inv.inventoryValuation(e.app, outlet.id);
  return e.json(200, {
    outlet_id: outlet.id,
    currency_symbol: outlet.getString("currency_symbol"),
    total_value: val.total_value,
    items: val.items,
  });
});

routerAdd("POST", "/api/app/inventory/purchase", (e) => {
  const inv = require(`${__hooks}/lib_inventory.js`);
  const caller = inv.requireManager(e);
  if (!caller) return;

  const body = e.requestInfo().body || {};
  const itemId = String(body.inventory_item || "");
  const qty = Number(body.qty);

  if (!itemId) return e.json(400, { message: "Which stock item?" });
  if (!(qty > 0)) return e.json(400, { message: "The quantity has to be more than zero." });

  let item;
  try {
    item = e.app.findRecordById("inventory_items", itemId);
  } catch (err) {
    return e.json(404, { message: "That stock item no longer exists." });
  }

  // Restocking at today's price updates the valuation basis. Documented in
  // MODULE3.md: latest-cost, not a weighted average.
  const unitCost = Number(body.cost_per_unit);
  if (unitCost > 0 && unitCost !== item.getFloat("cost_per_unit")) {
    item.set("cost_per_unit", unitCost);
    e.app.save(item);
  }

  const move = inv.recordMove(e.app, {
    itemId: itemId,
    outletId: item.getString("outlet"),
    delta: inv.round3(qty),
    reason: "purchase",
    createdBy: caller.id,
    note: String(body.note || ""),
  });

  return e.json(200, {
    ok: true,
    move_id: move.id,
    balance_after: move.getFloat("balance_after"),
  });
});

routerAdd("POST", "/api/app/inventory/wastage", (e) => {
  const inv = require(`${__hooks}/lib_inventory.js`);
  const caller = inv.requireAuth(e);
  if (!caller) return;

  const body = e.requestInfo().body || {};
  const itemId = String(body.inventory_item || "");
  const qty = Number(body.qty);

  if (!itemId) return e.json(400, { message: "Which stock item?" });
  if (!(qty > 0)) return e.json(400, { message: "The quantity has to be more than zero." });

  let item;
  try {
    item = e.app.findRecordById("inventory_items", itemId);
  } catch (err) {
    return e.json(404, { message: "That stock item no longer exists." });
  }

  const move = inv.recordMove(e.app, {
    itemId: itemId,
    outletId: item.getString("outlet"),
    delta: -inv.round3(qty),
    reason: "wastage",
    createdBy: caller.id,
    note: String(body.note || ""),
  });

  return e.json(200, {
    ok: true,
    move_id: move.id,
    balance_after: move.getFloat("balance_after"),
  });
});

routerAdd("POST", "/api/app/inventory/adjust", (e) => {
  const inv = require(`${__hooks}/lib_inventory.js`);
  const caller = inv.requireManager(e);
  if (!caller) return;

  const body = e.requestInfo().body || {};
  const itemId = String(body.inventory_item || "");
  const delta = Number(body.qty_delta);
  const note = String(body.note || "").trim();

  if (!itemId) return e.json(400, { message: "Which stock item?" });
  if (!(delta > 0) && !(delta < 0)) {
    return e.json(400, { message: "The adjustment has to be non-zero." });
  }
  if (!note) {
    return e.json(400, { message: "Say why — adjustments are audited." });
  }

  let item;
  try {
    item = e.app.findRecordById("inventory_items", itemId);
  } catch (err) {
    return e.json(404, { message: "That stock item no longer exists." });
  }

  const move = inv.recordMove(e.app, {
    itemId: itemId,
    outletId: item.getString("outlet"),
    delta: inv.round3(delta),
    reason: "adjustment",
    createdBy: caller.id,
    note: note,
  });

  return e.json(200, {
    ok: true,
    move_id: move.id,
    balance_after: move.getFloat("balance_after"),
  });
});

// A recipe line only makes sense when the dish and the ingredient belong to
// the same outlet; the check lives in the lib (see the note at the top).
onRecordCreate((e) => {
  const inv = require(`${__hooks}/lib_inventory.js`);
  inv.checkRecipeLine(e.app, e.record);
  e.next();
}, "recipe_lines");

onRecordUpdate((e) => {
  const inv = require(`${__hooks}/lib_inventory.js`);
  inv.checkRecipeLine(e.app, e.record);
  e.next();
}, "recipe_lines");
