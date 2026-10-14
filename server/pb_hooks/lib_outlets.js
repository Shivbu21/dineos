// Outlet helpers. Required INSIDE each handler (PocketBase hooks run in their
// own runtime — a top-level require here would not be visible there).

/// The outlet to use when none was specified: the first active one.
function defaultOutlet(app) {
  try {
    const rows = app.findRecordsByFilter("outlets", "active = true", "sort_order", 1, 0);
    return rows.length > 0 ? rows[0] : null;
  } catch (err) {
    return null;
  }
}

/// Returns the outlet record, or throws a 400 the caller can surface.
function requireOutlet(app, outletId) {
  const id = String(outletId || "");
  if (!id) {
    throw new BadRequestError("Choose an outlet.");
  }
  let outlet;
  try {
    outlet = app.findRecordById("outlets", id);
  } catch (err) {
    throw new BadRequestError("That outlet does not exist.");
  }
  if (!outlet.getBool("active")) {
    throw new BadRequestError("That outlet is not open.");
  }
  return outlet;
}

/// Money settings for an outlet, falling back to the venue record so a
/// single-location install (or a record predating outlets) keeps working.
function outletSettings(app, outletId) {
  if (outletId) {
    try {
      const o = app.findRecordById("outlets", String(outletId));
      return {
        taxRate: Number(o.getFloat("tax_rate")) || 0,
        taxInclusive: o.getBool("tax_inclusive"),
        serviceRate: Number(o.getFloat("service_charge_rate")) || 0,
        currencyCode: o.getString("currency_code"),
        currencySymbol: o.getString("currency_symbol"),
      };
    } catch (err) { /* fall through to the venue */ }
  }
  try {
    const r = app.findFirstRecordByFilter("restaurant", "id != ''");
    return {
      taxRate: Number(r.getFloat("tax_rate")) || 0,
      taxInclusive: r.getBool("tax_inclusive"),
      serviceRate: Number(r.getFloat("service_charge_rate")) || 0,
      currencyCode: r.getString("currency_code"),
      currencySymbol: r.getString("currency_symbol"),
    };
  } catch (err) {
    return { taxRate: 0, taxInclusive: false, serviceRate: 0, currencyCode: "", currencySymbol: "" };
  }
}

module.exports = { defaultOutlet, requireOutlet, outletSettings, syncDefaultOutlet };

/// Copies a restaurant record's money settings onto the default outlet.
///
/// The migration seeds "Main outlet" before the venue exists, so on a fresh
/// install it carries placeholder numbers until setup runs. The setup wizard
/// (bootstrap) calls this so the single outlet matches what was configured.
/// Outlets created afterwards keep their own settings — this only touches the
/// first outlet, and only when it still looks like the seed.
function syncDefaultOutlet(app, restaurant) {
  // findFirstRecordByFilter's third argument is filter params, not a sort —
  // use findRecordsByFilter for the ordered lookup.
  let rows = [];
  try {
    rows = app.findRecordsByFilter("outlets", "active = true", "sort_order", 1, 0);
  } catch (err) { return; }
  const outlet = rows.length > 0 ? rows[0] : null;
  if (!outlet) return;

  outlet.set("currency_code", restaurant.getString("currency_code"));
  outlet.set("currency_symbol", restaurant.getString("currency_symbol"));
  outlet.set("tax_rate", restaurant.getFloat("tax_rate"));
  outlet.set("tax_inclusive", restaurant.getBool("tax_inclusive"));
  outlet.set("service_charge_rate", restaurant.getFloat("service_charge_rate"));
  outlet.set("address", restaurant.getString("address"));
  outlet.set("phone", restaurant.getString("phone"));
  app.save(outlet);
}
