/// <reference path="../pb_data/types.d.ts" />

// Multi-location outlets (Module 2).
//
// 1. New `outlets` collection: each outlet carries its own money settings
//    (currency, tax, service charge) so a second branch can run different
//    numbers from the first.
// 2. An `outlet` relation on orders, order_items (denormalized for KDS
//    filtering), tables, menu_items, categories, printers, shifts, and staff
//    (optional there: unset means the staff member can work any outlet).
// 3. Backfill: every existing record lands on a "Main outlet" seeded from the
//    current `restaurant` settings, so a single-location install behaves
//    exactly as before.

migrate((app) => {
  const STAFF = '@request.auth.id != ""';
  const MANAGER = '@request.auth.role = "owner" || @request.auth.role = "manager"';

  const created = { name: "created", type: "autodate", onCreate: true, onUpdate: false };
  const updated = { name: "updated", type: "autodate", onCreate: true, onUpdate: true };

  app.save(new Collection({
    type: "base",
    name: "outlets",
    listRule: STAFF, viewRule: STAFF,
    createRule: MANAGER, updateRule: MANAGER, deleteRule: MANAGER,
    fields: [
      { name: "name", type: "text", required: true, max: 120 },
      { name: "address", type: "text", max: 300 },
      { name: "phone", type: "text", max: 40 },
      { name: "currency_code", type: "text", required: true, max: 3 },
      { name: "currency_symbol", type: "text", required: true, max: 4 },
      { name: "tax_rate", type: "number", min: 0, max: 100 },
      { name: "tax_inclusive", type: "bool" },
      { name: "service_charge_rate", type: "number", min: 0, max: 100 },
      { name: "receipt_header", type: "text", max: 300 },
      { name: "receipt_footer", type: "text", max: 300 },
      { name: "active", type: "bool" },
      { name: "sort_order", type: "number", onlyInt: true },
      created, updated,
    ],
    indexes: ["CREATE INDEX idx_outlets_sort ON outlets (sort_order)"],
  }));

  const outletsId = app.findCollectionByNameOrId("outlets").id;

  for (const name of ["orders", "order_items", "tables", "menu_items", "categories", "printers", "shifts", "staff"]) {
    const c = app.findCollectionByNameOrId(name);
    if (!c.fields.getByName("outlet")) {
      // fields.add needs a real Field instance — a plain object only works
      // inside the new Collection({...}) constructor above.
      c.fields.add(new RelationField({
        name: "outlet",
        required: false,
        maxSelect: 1,
        collectionId: outletsId,
        cascadeDelete: false,
      }));
      app.save(c);
    }
  }

  // Seed the default outlet from the venue's current money settings.
  let venue = null;
  try {
    venue = app.findFirstRecordByFilter("restaurant", "id != ''");
  } catch (err) { /* fresh install; setup wizard creates the venue later */ }

  let main = null;
  try {
    const rows = app.findRecordsByFilter("outlets", "id != ''", "sort_order", 1, 0);
    if (rows.length > 0) main = rows[0];
  } catch (err) { /* none yet */ }

  if (!main) {
    main = new Record(app.findCollectionByNameOrId("outlets"));
    main.set("name", "Main outlet");
    main.set("address", venue ? venue.getString("address") : "");
    main.set("phone", venue ? venue.getString("phone") : "");
    main.set("currency_code", venue ? venue.getString("currency_code") : "USD");
    main.set("currency_symbol", venue ? venue.getString("currency_symbol") : "$");
    main.set("tax_rate", venue ? venue.getFloat("tax_rate") : 0);
    main.set("tax_inclusive", venue ? venue.getBool("tax_inclusive") : false);
    main.set("service_charge_rate", venue ? venue.getFloat("service_charge_rate") : 0);
    main.set("receipt_header", venue ? venue.getString("receipt_header") : "");
    main.set("receipt_footer", venue ? venue.getString("receipt_footer") : "");
    main.set("active", true);
    main.set("sort_order", 1);
    app.save(main);
  }

  // Backfill: every pre-outlet record belongs to the main outlet.
  // order_items inherit from their parent order so the KDS never splits a bill.
  const backfill = (collection, getOutletId) => {
    let page = 1;
    for (;;) {
      const rows = app.findRecordsByFilter(collection, "outlet = ''", "created", 200, page);
      if (rows.length === 0) break;
      for (const r of rows) {
        const oid = getOutletId(r);
        if (oid) {
          r.set("outlet", oid);
          app.save(r);
        }
      }
      if (rows.length < 200) break;
      page++;
    }
  };

  const mainId = main.id;
  const orderOutlet = {};
  backfill("orders", () => mainId);
  // Remember where each order landed so its lines follow.
  for (const o of app.findRecordsByFilter("orders", "id != ''", "", 500, 0)) {
    orderOutlet[o.id] = o.getString("outlet") || mainId;
  }
  backfill("order_items", (r) => orderOutlet[r.getString("order")] || mainId);
  backfill("tables", () => mainId);
  backfill("menu_items", () => mainId);
  backfill("categories", () => mainId);
  backfill("printers", () => mainId);
  backfill("shifts", () => mainId);
  // staff.outlet stays unset (null = may work any outlet) — do not backfill.
}, (app) => {
  for (const name of ["orders", "order_items", "tables", "menu_items", "categories", "printers", "shifts", "staff"]) {
    try {
      const c = app.findCollectionByNameOrId(name);
      c.fields.removeByName("outlet");
      app.save(c);
    } catch (err) { /* already gone */ }
  }
  try {
    app.delete(app.findCollectionByNameOrId("outlets"));
  } catch (err) { /* already gone */ }
});
