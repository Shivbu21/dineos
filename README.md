# dineos

**Open-source restaurant management: POS, kitchen display, and online ordering.**

Point of sale, kitchen display, back-office management, and a customer-facing
online ordering storefront — in one self-hosted system that runs on the
restaurant's own hardware. No cloud account, no subscription, no telemetry.

dineos is a fork of [Mise-Kal](https://github.com/thewoldaa/mise-kal-standalone)
(MIT), itself derived from
[Mise](https://github.com/devShakib015/mise). All credit for the POS, kitchen
display, and back-office core belongs to those projects; this fork adds the
online-ordering layer and keeps everything else intact.

| | |
|---|---|
| **License** | MIT |
| **Platform** | Windows, macOS, Linux, Android, iOS |
| **Backend** | PocketBase (single binary) |
| **Application** | Flutter |
| **Status** | Pre-1.0, active development |

---

## What dineos adds over the base

**Module 1 — online ordering storefront** (`/order` on the same server port):
- Customer-facing web ordering: browse menu, cart, checkout for pickup or delivery
- Online orders land in the same kitchen display pipeline as POS orders
- Payment hooks for Razorpay and Stripe (sandbox/test mode clearly marked until real credentials are configured)
- Money is only ever computed server-side — the storefront never decides what a bill costs

Everything else — POS floor plan, KDS, menu management, QR table-side ordering,
thermal printing, offline-first queue — is inherited from the Mise-Kal base.

## Quick start

Same as upstream: install the server, run the bootstrap once, connect the app.
See `docs/install-windows.md` / `docs/install-macos.md`, and `MODULE1.md` for
the online ordering configuration (payment provider keys, webhook URLs).

## Testing

Backend suites run against a throwaway database; none touch real data:

```bash
# from server/
./scripts/online_test.sh   # Module 1: storefront order flow + payment webhooks
./scripts/guest_test.sh    # table-side ordering (upstream, must keep passing)
./scripts/smoke_test.sh    # money hooks
```

## License

MIT — see [LICENSE](LICENSE). Original copyright retained; dineos
modifications are also MIT.
