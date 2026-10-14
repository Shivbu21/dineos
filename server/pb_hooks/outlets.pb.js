/// <reference path="../pb_data/types.d.ts" />

// Outlet API (Module 2).
//
// GET /api/app/outlets — the active outlets, for the storefront picker. Public:
// a branch's name and address are already on the restaurant's website.
// GET /api/app/reports/sales-by-outlet — takings broken down per outlet plus
// the combined total. Staff only. Bills are counted by when they closed,
// matching the app's own reporting rule.

routerAdd("GET", "/api/app/outlets", (e) => {
  const rows = e.app.findRecordsByFilter(
    "outlets", "active = true", "sort_order", 0, 0,
  );
  return e.json(200, {
    outlets: rows.map((o) => ({
      id: o.id,
      name: o.getString("name"),
      address: o.getString("address"),
      phone: o.getString("phone"),
      currency_symbol: o.getString("currency_symbol"),
      currency_code: o.getString("currency_code"),
    })),
  });
});

routerAdd("GET", "/api/app/reports/sales-by-outlet", (e) => {
  const caller = e.auth;
  if (!caller) {
    return e.json(401, { message: "Sign in first." });
  }

  const q = e.request.url.query();
  const day = /^\d{4}-\d{2}-\d{2}$/;
  let from = String(q.get("from") || "");
  let to = String(q.get("to") || "");
  const today = new Date().toISOString().slice(0, 10);
  if (!day.test(from)) from = today;
  if (!day.test(to)) to = today;

  const orders = e.app.findRecordsByFilter(
    "orders",
    "status = 'paid' && closed_at >= {:from} && closed_at < {:to}",
    "", 0, 0,
    { from: from + " 00:00:00.000Z", to: to + " 23:59:59.999Z" },
  );

  const names = {};
  try {
    for (const o of e.app.findRecordsByFilter("outlets", "id != ''", "", 0, 0)) {
      names[o.id] = {
        name: o.getString("name"),
        currency_symbol: o.getString("currency_symbol"),
      };
    }
  } catch (err) { /* no outlets yet */ }

  const byOutlet = {};
  const bump = (oid) => {
    if (!byOutlet[oid]) {
      byOutlet[oid] = {
        outlet_id: oid,
        outlet_name: (names[oid] && names[oid].name) || "Unknown outlet",
        currency_symbol: (names[oid] && names[oid].currency_symbol) || "",
        orders: 0,
        gross: 0,
      };
    }
    return byOutlet[oid];
  };

  for (const o of orders) {
    const b = bump(o.getString("outlet") || "none");
    b.orders += 1;
    b.gross = Math.round((b.gross + (Number(o.getFloat("total")) || 0)) * 100) / 100;
  }

  const rows = Object.keys(byOutlet).map((k) => byOutlet[k]);
  rows.sort((a, b) => (a.outlet_name < b.outlet_name ? -1 : 1));

  let combined = 0;
  for (const r of rows) combined = Math.round((combined + r.gross) * 100) / 100;

  return e.json(200, { from: from, to: to, outlets: rows, combined_gross: combined });
});
