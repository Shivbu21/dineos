# dineos 1.0.0 — Release Notes

**Build date:** 2026-10-14
**License:** MIT (see LICENSE; fork of thewoldaa/mise-kal-standalone with attribution)
**Codename:** dineos (working name — not final branding)

## What it is

An open-source all-in-one restaurant management platform: point of sale, kitchen
display, online ordering storefront, multi-location support, Indian-language UI,
and inventory with recipe management — Flutter app + PocketBase server.

## Verified this release

- Backend suites — **210/210 checks pass**: online 50, guest 26, smoke 19,
  payments 18, kitchen 10, staff 16, setup 12, outlet 21, inventory 38
- `flutter test` — **82/82 pass** (78 baseline + 4 inventory model tests)
- `dart analyze` — no errors; only the 5 pre-existing baseline issues
  (2 pubspec asset-dir warnings, 3 infos)

## Modules included

1. **Online ordering** — customer storefront at `/order` on the same PocketBase
   server; menu browse/search, modifiers, cart, pickup/delivery checkout; orders
   flow straight into the kitchen display; Razorpay + Stripe webhooks with
   settlement re-confirmation (forged callbacks can't mark paid), idempotent
   retries, sandbox test mode
2. **Multi-location + Indian languages** — outlets with per-outlet menus, pricing,
   tax, and order numbering; outlet-scoped POS/KDS/storefront; cross-outlet sales
   reports; Hindi, Tamil, Telugu, Kannada, Malayalam + English (64 storefront
   strings × 6, 227 Flutter keys, zero fallbacks)
3. **Inventory + recipes** — per-outlet inventory items, append-only stock ledger
   (no client writes — server only), recipe bill-of-materials per dish,
   auto-deduction when items are served, void-restore compensating entries,
   low-stock alerts, wastage logging, stock valuation; manager Inventory section
   in the app

Base (Mise-Kal) provides: POS sale flow, floor/table management, KDS, menu
management, QR ordering, staff/shift management.

## Run it

```bash
cd dineos-1.0.0
# Start the server (downloads PocketBase on first run):
cd server && ./dev.sh
# In another terminal, run the app:
cd ../app && flutter run
```

The online storefront is served by the PocketBase server at `/order/`.

## Going live — required

- **Razorpay / Stripe** accounts + webhook secrets for live payments
  (test mode available via `DINEOS_PAYMENTS_TEST_MODE=true`)
- A host for the PocketBase server; Flutter builds per target
  (Android/iOS/macOS/Windows/web via `flutter build`)

## Honest limitations

- Live gateway paths were not tested — no real Razorpay/Stripe credentials
- Translations are hand-written, not native-speaker reviewed
- Multi-outlet tested with seed data only; outlet-specific printer routing not covered
- `?lang=` / `?outlet=` need a trailing slash (`/order/?lang=hi`) — PocketBase's
  static redirect strips query strings
- Concurrent serves from two terminals could interleave `balance_after` copies
  (the ledger sum stays correct); a row-locked RPC would harden this
- No Android APK in this release (no Android toolchain in the build environment);
  build with `flutter build apk` on a machine with the Android SDK
