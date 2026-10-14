// Inventory math (Module 3). All stock arithmetic lives here, on the server.
//
// The model is an append-only ledger: stock_moves rows are never edited or
// deleted, and the current balance of an item is always the sum of its moves.
// There is no mutable counter to drift out of sync. Collection rules forbid
// every client write to stock_moves; the only writer is recordMove below.

function round3(n) {
  return Math.round(n * 1000) / 1000;
}

// Current stock of one inventory item, derived from the ledger.
function stockBalance(app, itemId) {
  const moves = app.findRecordsByFilter(
    "stock_moves", "inventory_item = {:id}", "", 0, 0, { id: itemId },
  );
  let b = 0;
  for (const m of moves) b += Number(m.getFloat("qty_delta")) || 0;
  return round3(b);
}

// The single writer. Every stock change — purchase, auto-deduction, wastage,
// adjustment — flows through here so balance_after is always consistent and
// the negative-stock flag is maintained in one place.
//
// opts: { itemId, delta, reason, outletId?, refOrderId?, createdBy?, note? }
// The outlet defaults to the item's own outlet; callers never invent one.
function recordMove(app, opts) {
  if (!(opts.delta > 0) && !(opts.delta < 0)) {
    throw new BadRequestError("The quantity has to be non-zero.");
  }

  const item = app.findRecordById("inventory_items", opts.itemId);
  if (!item.getBool("active")) {
    throw new BadRequestError("That stock item is switched off.");
  }

  const balance = round3(stockBalance(app, opts.itemId) + opts.delta);

  const move = new Record(app.findCollectionByNameOrId("stock_moves"));
  move.set("inventory_item", opts.itemId);
  move.set("outlet", opts.outletId || item.getString("outlet"));
  move.set("qty_delta", opts.delta);
  move.set("reason", opts.reason);
  if (opts.refOrderId) move.set("ref_order", opts.refOrderId);
  if (opts.createdBy) move.set("created_by", opts.createdBy);
  move.set("note", String(opts.note || ""));
  move.set("balance_after", balance);
  app.save(move);

  // A kitchen can't stop mid-service, so a deduction is never refused for
  // lack of stock — but a negative balance flags the item for review until
  // the next purchase-in brings it back to zero or above.
  const flagged = item.getBool("needs_review");
  if (balance < 0 && !flagged) {
    item.set("needs_review", true);
    app.save(item);
  } else if (balance >= 0 && flagged && opts.reason === "purchase") {
    item.set("needs_review", false);
    app.save(item);
  }

  return move;
}

// Deduct one served line's recipe from stock. Idempotent: a line whose
// stock_deducted flag is set is left alone, so a status flapping between
// served and ready can never deduct twice.
function deductForLine(app, line) {
  if (line.getBool("stock_deducted")) return 0;

  const menuItemId = line.getString("menu_item");
  if (!menuItemId) return 0;
  const servings = Number(line.getFloat("qty")) || 0;
  if (servings <= 0) return 0;

  const outletId = line.getString("outlet");
  const recipes = app.findRecordsByFilter(
    "recipe_lines", "menu_item = {:m}", "sort_order", 0, 0, { m: menuItemId },
  );

  let count = 0;
  for (const r of recipes) {
    const itemId = r.getString("inventory_item");
    if (!itemId) continue;

    let item;
    try {
      item = app.findRecordById("inventory_items", itemId);
    } catch (err) {
      continue; // ingredient deleted; the serve must not fail because of it
    }
    if (outletId && item.getString("outlet") !== outletId) {
      // Belt and braces: the recipe API refuses cross-outlet lines, so this
      // should never happen. Never deduct from another outlet's stock.
      console.warn("dineos: skipping cross-outlet recipe line " + r.id);
      continue;
    }

    const per = Number(r.getFloat("qty_per_serving")) || 0;
    if (per <= 0) continue;

    recordMove(app, {
      itemId: itemId,
      outletId: item.getString("outlet"),
      delta: -round3(per * servings),
      reason: "usage",
      refOrderId: line.getString("order"),
      note: "auto-deduct: " + line.getString("name_snapshot") + " x" + servings,
    });
    count++;
  }

  line.set("stock_deducted", true);
  app.save(line);
  return count;
}

// Compensating entries for a voided line that was already deducted. The
// original usage rows stay in the ledger — voids restore, they never erase.
function restoreForLine(app, line) {
  if (!line.getBool("stock_deducted")) return 0;

  const menuItemId = line.getString("menu_item");
  const servings = Number(line.getFloat("qty")) || 0;

  if (menuItemId && servings > 0) {
    const recipes = app.findRecordsByFilter(
      "recipe_lines", "menu_item = {:m}", "sort_order", 0, 0, { m: menuItemId },
    );
    for (const r of recipes) {
      const itemId = r.getString("inventory_item");
      if (!itemId) continue;

      let item;
      try {
        item = app.findRecordById("inventory_items", itemId);
      } catch (err) {
        continue;
      }

      const per = Number(r.getFloat("qty_per_serving")) || 0;
      if (per <= 0) continue;

      recordMove(app, {
        itemId: itemId,
        outletId: item.getString("outlet"),
        delta: round3(per * servings),
        reason: "adjustment",
        refOrderId: line.getString("order"),
        note: "void restore: " + line.getString("name_snapshot") + " x" + servings,
      });
    }
  }

  line.set("stock_deducted", false);
  app.save(line);
  return 1;
}

// Items at or below their low-stock threshold for one outlet, with the date
// of their most recent purchase so the manager knows what to reorder.
function lowStockAlerts(app, outletId) {
  const items = app.findRecordsByFilter(
    "inventory_items", "outlet = {:o} && active = true", "name", 0, 0,
    { o: outletId },
  );

  const alerts = [];
  for (const it of items) {
    const balance = stockBalance(app, it.id);
    const threshold = Number(it.getFloat("low_stock_threshold")) || 0;
    if (balance > threshold) continue;

    let lastRestock = "";
    const recent = app.findRecordsByFilter(
      "stock_moves", "inventory_item = {:id} && reason = 'purchase'",
      "-created", 1, 0, { id: it.id },
    );
    if (recent.length > 0) lastRestock = recent[0].getString("created");

    alerts.push({
      item_id: it.id,
      name: it.getString("name"),
      unit: it.getString("unit"),
      balance: balance,
      threshold: threshold,
      needs_review: it.getBool("needs_review"),
      last_restock: lastRestock,
    });
  }
  return alerts;
}

// Σ(balance × cost_per_unit) over the outlet's active items, plus the
// per-item rows so the dashboard needs no second call.
function inventoryValuation(app, outletId) {
  const items = app.findRecordsByFilter(
    "inventory_items", "outlet = {:o} && active = true", "sort_order,name",
    0, 0, { o: outletId },
  );

  const rows = [];
  let total = 0;
  for (const it of items) {
    const balance = stockBalance(app, it.id);
    const cost = Number(it.getFloat("cost_per_unit")) || 0;
    const value = round3(balance * cost);
    total = round3(total + value);
    rows.push({
      item_id: it.id,
      name: it.getString("name"),
      unit: it.getString("unit"),
      balance: balance,
      threshold: Number(it.getFloat("low_stock_threshold")) || 0,
      cost_per_unit: cost,
      value: value,
      needs_review: it.getBool("needs_review"),
      low: balance <= (Number(it.getFloat("low_stock_threshold")) || 0),
    });
  }
  return { items: rows, total_value: total };
}

module.exports = {
  round3: round3,
  stockBalance: stockBalance,
  recordMove: recordMove,
  deductForLine: deductForLine,
  restoreForLine: restoreForLine,
  lowStockAlerts: lowStockAlerts,
  inventoryValuation: inventoryValuation,
  // Route-handler guards. These live here (not at the top of inventory.pb.js)
  // because PocketBase compiles each handler in its own context: a function
  // declared at the top of a .pb.js file is not defined inside the handler.
  requireAuth: requireAuth,
  requireManager: requireManager,
  resolveOutlet: resolveOutlet,
  checkRecipeLine: checkRecipeLine,
};

// --- handler guards -------------------------------------------------------

function requireAuth(e) {
  if (!e.auth) {
    e.json(401, { message: "Sign in first." });
    return null;
  }
  return e.auth;
}

function requireManager(e) {
  const caller = requireAuth(e);
  if (!caller) return null;
  const role = caller.getString("role");
  if (role !== "owner" && role !== "manager") {
    e.json(403, { message: "Only an owner or manager can do that." });
    return null;
  }
  return caller;
}

// ?outlet=, else the default outlet. Sends the 400 itself and returns null
// when the outlet is unknown, switched off, or none exists yet.
function resolveOutlet(e, app) {
  const outlets = require(`${__hooks}/lib_outlets.js`);
  const q = e.request.url.query();
  const id = String(q.get("outlet") || "");

  let outlet = null;
  if (id) {
    try {
      outlet = app.findRecordById("outlets", id);
    } catch (err) {
      e.json(400, { message: "Unknown outlet." });
      return null;
    }
    if (!outlet.getBool("active")) {
      e.json(400, { message: "That outlet is switched off." });
      return null;
    }
  } else {
    outlet = outlets.defaultOutlet(app);
  }

  if (!outlet) {
    e.json(400, { message: "No outlet is set up yet." });
    return null;
  }
  return outlet;
}

// A recipe line only makes sense when the dish and the ingredient belong to
// the same outlet, and a zero-quantity line would deduct nothing forever.
function checkRecipeLine(app, record) {
  const menuId = record.getString("menu_item");
  const itemId = record.getString("inventory_item");
  const qty = Number(record.getFloat("qty_per_serving"));

  if (!(qty > 0)) {
    throw new BadRequestError("A recipe line needs a quantity per serving above zero.");
  }

  let menu, item;
  try {
    menu = app.findRecordById("menu_items", menuId);
  } catch (err) {
    throw new BadRequestError("That menu item no longer exists.");
  }
  try {
    item = app.findRecordById("inventory_items", itemId);
  } catch (err) {
    throw new BadRequestError("That stock item no longer exists.");
  }

  if (menu.getString("outlet") !== item.getString("outlet")) {
    throw new BadRequestError("The dish and the ingredient belong to different outlets.");
  }
}
