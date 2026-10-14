/// <reference path="../pb_data/types.d.ts" />

// Online ordering storefront (Module 1) needs two additive schema changes:
//
// 1. `payments.method` gains "razorpay" and "stripe" so gateway-settled
//    payments are recorded with their real method instead of "other".
// 2. A new server-only `online_payments` collection tracks each gateway
//    checkout attempt: which order, which provider, the gateway's id, and
//    whether it settled. Webhooks look the order up by the gateway id here,
//    and the rows double as an audit trail of payment attempts.
//    (`staff` is already optional since the guest-orders migration, so online
//    orders raised by strangers need no system account.)

migrate((app) => {
  const payments = app.findCollectionByNameOrId("payments");
  const method = payments.fields.getByName("method");
  if (method) {
    const values = method.values || [];
    for (const v of ["razorpay", "stripe"]) {
      if (values.indexOf(v) === -1) values.push(v);
    }
    method.values = values;
    app.save(payments);
  }

  const created = { name: "created", type: "autodate", onCreate: true, onUpdate: false };
  const updated = { name: "updated", type: "autodate", onCreate: true, onUpdate: true };

  app.save(new Collection({
    type: "base",
    name: "online_payments",
    listRule: null,
    viewRule: null,
    createRule: null,
    updateRule: null,
    deleteRule: null,
    fields: [
      { name: "order", type: "relation", required: true, maxSelect: 1,
        collectionId: app.findCollectionByNameOrId("orders").id,
        cascadeDelete: true },
      { name: "provider", type: "select", required: true, maxSelect: 1,
        values: ["razorpay", "stripe"] },
      { name: "gateway_id", type: "text", required: true, max: 80 },
      { name: "status", type: "select", required: true, maxSelect: 1,
        values: ["pending", "paid", "failed"] },
      created,
      updated,
    ],
    indexes: [
      "CREATE UNIQUE INDEX idx_online_payments_gateway ON online_payments (provider, gateway_id)",
      "CREATE INDEX idx_online_payments_order ON online_payments (`order`)",
    ],
  }));
}, (app) => {
  const payments = app.findCollectionByNameOrId("payments");
  const method = payments.fields.getByName("method");
  if (method) {
    method.values = (method.values || []).filter(
      (v) => v !== "razorpay" && v !== "stripe",
    );
    app.save(payments);
  }

  try {
    app.delete(app.findCollectionByNameOrId("online_payments"));
  } catch (err) { /* already gone */ }
});
