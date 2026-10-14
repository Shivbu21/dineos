/// <reference path="../pb_data/types.d.ts" />

// Inventory + recipes (Module 3).
//
// 1. `inventory_items`: what the kitchen stocks (flour, milk, chicken…),
//    per outlet. `needs_review` is set server-side when stock goes negative.
// 2. `stock_moves`: an append-only ledger. The current balance is always
//    *derived* from it — there is no mutable counter to drift. Collection
//    rules forbid every client write; only server hooks and the stock API
//    (which computes everything server-side) can add rows.
// 3. `recipe_lines`: bill of materials — menu_item → inventory_item with a
//    quantity per serving. Serving a line auto-deducts through the ledger.
// 4. `order_items.stock_deducted`: idempotency flag so a status flapping
//    between served and ready never deducts twice.

migrate((app) => {
  const STAFF = '@request.auth.id != ""';
  const MANAGER = '@request.auth.role = "owner" || @request.auth.role = "manager"';

  const created = { name: "created", type: "autodate", onCreate: true, onUpdate: false };
  const updated = { name: "updated", type: "autodate", onCreate: true, onUpdate: true };

  const outletsId = app.findCollectionByNameOrId("outlets").id;

  app.save(new Collection({
    type: "base",
    name: "inventory_items",
    listRule: STAFF, viewRule: STAFF,
    createRule: MANAGER, updateRule: MANAGER, deleteRule: MANAGER,
    fields: [
      { name: "name", type: "text", required: true, max: 120 },
      // kg, L, pcs… free text: a restaurant's units don't fit a fixed list.
      { name: "unit", type: "text", required: true, max: 20 },
      { name: "cost_per_unit", type: "number", min: 0 },
      { name: "low_stock_threshold", type: "number", min: 0 },
      { name: "outlet", type: "relation", required: true, maxSelect: 1,
        collectionId: outletsId, cascadeDelete: false },
      { name: "active", type: "bool" },
      // Server-side flag: set when a deduction drives the balance negative,
      // cleared by the next purchase-in that brings it back to zero or above.
      { name: "needs_review", type: "bool" },
      { name: "sort_order", type: "number", onlyInt: true },
      created, updated,
    ],
    indexes: [
      "CREATE INDEX idx_inventory_items_outlet ON inventory_items (outlet)",
    ],
  }));

  const invId = app.findCollectionByNameOrId("inventory_items").id;

  app.save(new Collection({
    type: "base",
    name: "stock_moves",
    listRule: STAFF, viewRule: STAFF,
    // Append-only: the API surface never accepts a client-written row, and
    // even a signed-in manager cannot edit or delete one. Rows are only ever
    // added by server code (lib_inventory.js).
    createRule: null, updateRule: null, deleteRule: null,
    fields: [
      { name: "inventory_item", type: "relation", required: true, maxSelect: 1,
        collectionId: invId, cascadeDelete: true },
      { name: "outlet", type: "relation", required: true, maxSelect: 1,
        collectionId: outletsId, cascadeDelete: false },
      { name: "qty_delta", type: "number", required: true },
      { name: "reason", type: "select", required: true, maxSelect: 1,
        values: ["purchase", "usage", "wastage", "adjustment"] },
      { name: "ref_order", type: "relation", maxSelect: 1,
        collectionId: app.findCollectionByNameOrId("orders").id, cascadeDelete: false },
      { name: "created_by", type: "relation", maxSelect: 1,
        collectionId: app.findCollectionByNameOrId("staff").id, cascadeDelete: false },
      { name: "note", type: "text", max: 300 },
      // The balance right after this move — a convenience copy, written
      // server-side. The truth is always the sum of the ledger.
      { name: "balance_after", type: "number" },
      created, updated,
    ],
    indexes: [
      "CREATE INDEX idx_stock_moves_item ON stock_moves (inventory_item, created)",
    ],
  }));

  app.save(new Collection({
    type: "base",
    name: "recipe_lines",
    listRule: STAFF, viewRule: STAFF,
    createRule: MANAGER, updateRule: MANAGER, deleteRule: MANAGER,
    fields: [
      { name: "menu_item", type: "relation", required: true, maxSelect: 1,
        collectionId: app.findCollectionByNameOrId("menu_items").id, cascadeDelete: true },
      { name: "inventory_item", type: "relation", required: true, maxSelect: 1,
        collectionId: invId, cascadeDelete: false },
      { name: "qty_per_serving", type: "number", required: true, min: 0 },
      { name: "sort_order", type: "number", onlyInt: true },
      created, updated,
    ],
    indexes: [
      "CREATE UNIQUE INDEX idx_recipe_lines_unique ON recipe_lines (menu_item, inventory_item)",
      "CREATE INDEX idx_recipe_lines_menu ON recipe_lines (menu_item)",
    ],
  }));

  // Idempotency flag for the serve → deduct pipeline.
  const oi = app.findCollectionByNameOrId("order_items");
  if (!oi.fields.getByName("stock_deducted")) {
    // fields.add needs a real Field instance — a plain object only works
    // inside the new Collection({...}) constructor.
    oi.fields.add(new BoolField({ name: "stock_deducted" }));
    app.save(oi);
  }
}, (app) => {
  const oi = app.findCollectionByNameOrId("order_items");
  try {
    oi.fields.removeByName("stock_deducted");
    app.save(oi);
  } catch (err) { /* already gone */ }

  for (const name of ["recipe_lines", "stock_moves", "inventory_items"]) {
    try {
      app.delete(app.findCollectionByNameOrId(name));
    } catch (err) { /* already gone */ }
  }
});
