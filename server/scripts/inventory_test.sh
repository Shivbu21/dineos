#!/usr/bin/env bash
# Module 3 inventory checks: the append-only stock ledger, recipe
# auto-deduction on serve, void restores, per-outlet isolation, low-stock
# alerts, wastage, negative-stock flagging, and valuation.
#
# Kill-by-PID (house rule): pkill -f would match this script's own command
# line, so the server PID is saved at launch and killed directly.
set -euo pipefail

cd "$(dirname "$0")/.."

PORT=8095
API="http://127.0.0.1:${PORT}/api"
DATA="./pb_inventory_test_data"
PIDFILE="/tmp/dineos_inventory_test.pid"

pass=0; fail=0
check() {
  if [ "$2" = "$3" ]; then
    printf '  \033[32mok\033[0m   %-46s %s\n' "$1" "$3"; pass=$((pass+1))
  else
    printf '  \033[31mFAIL\033[0m %-46s expected %s, got %s\n' "$1" "$2" "$3"; fail=$((fail+1))
  fi
}

cleanup() {
  if [ -f "$PIDFILE" ]; then kill "$(cat "$PIDFILE")" 2>/dev/null || true; rm -f "$PIDFILE"; fi
  rm -rf "$DATA"
}
trap cleanup EXIT

rm -rf "$DATA"
./bin/pocketbase migrate up --dir="$DATA" --migrationsDir=./pb_migrations >/dev/null
./bin/pocketbase superuser upsert "test@local.test" "testpassword123" --dir="$DATA" >/dev/null 2>&1
./bin/pocketbase serve --dir="$DATA" --migrationsDir=./pb_migrations --hooksDir=./pb_hooks --publicDir=./pb_public \
  --http="127.0.0.1:${PORT}" >/dev/null 2>&1 &
echo $! > "$PIDFILE"

for _ in $(seq 1 40); do curl -sf "${API}/health" >/dev/null 2>&1 && break; sleep 0.25; done

curl -sf -X POST "${API}/app/bootstrap" -H 'Content-Type: application/json' -d '{
  "restaurant_name":"The Ember","owner_name":"Owner","owner_username":"owner",
  "owner_pin":"1111","currency_code":"INR","currency_symbol":"\u20b9",
  "tax_rate":5,"tax_inclusive":false}' >/dev/null

staff_auth() { # staff_auth <username> <pin> -> token
  curl -sf -X POST "${API}/collections/staff/auth-with-password" \
    -H 'Content-Type: application/json' -d "{\"identity\":\"$1\",\"password\":\"$2\"}" | jq -r .token
}
OWNER_TOKEN=$(staff_auth owner 1111)

auth()  { curl -s -H "Authorization: ${OWNER_TOKEN}" "$@"; }
post()  { auth -X POST "${API}/collections/$1/records" -H 'Content-Type: application/json' -d "$2"; }
patch() { auth -X PATCH "${API}/collections/$1/records/$2" -H 'Content-Type: application/json' -d "$3"; }
code()  { curl -s -o /dev/null -w "%{http_code}" "$@"; }

api_post() { # api_post <path> <json> [token]
  local t="${3:-$OWNER_TOKEN}"
  curl -s -X POST "${API}$1" -H "Authorization: ${t}" -H 'Content-Type: application/json' -d "$2"
}
api_get() { # api_get <path> [token]
  local t="${2:-$OWNER_TOKEN}"
  curl -s -H "Authorization: ${t}" "${API}$1"
}

echo "Setup"
OUTLET_A=$(curl -s "${API}/app/outlets" | jq -r '.outlets[0].id')
OUTLET_B=$(post outlets '{"name":"Branch 2","currency_code":"INR","currency_symbol":"\u20b9",
  "tax_rate":12,"tax_inclusive":false,"active":true,"sort_order":2}' | jq -r .id)
WAITER=$(post staff '{"name":"Waiter","username":"waiter","role":"waiter","active":true,
  "password":"2222","passwordConfirm":"2222"}' | jq -r .id)
WAITER_TOKEN=$(staff_auth waiter 2222)
CAT=$(post categories "{\"name\":\"Mains\",\"active\":true,\"outlet\":\"${OUTLET_A}\"}" | jq -r .id)
BREAD=$(post menu_items "{\"category\":\"${CAT}\",\"name\":\"Bread\",\"price\":50,
  \"active\":true,\"available\":true,\"outlet\":\"${OUTLET_A}\"}" | jq -r .id)
FLOUR=$(post inventory_items "{\"name\":\"Flour\",\"unit\":\"kg\",\"cost_per_unit\":40,
  \"low_stock_threshold\":5,\"outlet\":\"${OUTLET_A}\",\"active\":true}" | jq -r .id)
SUGAR=$(post inventory_items "{\"name\":\"Sugar\",\"unit\":\"kg\",\"cost_per_unit\":45,
  \"low_stock_threshold\":2,\"outlet\":\"${OUTLET_A}\",\"active\":true}" | jq -r .id)
FLOUR_B=$(post inventory_items "{\"name\":\"Flour\",\"unit\":\"kg\",\"cost_per_unit\":50,
  \"low_stock_threshold\":2,\"outlet\":\"${OUTLET_B}\",\"active\":true}" | jq -r .id)
check "two outlets seeded" "2" "$(curl -s "${API}/app/outlets" | jq '.outlets | length')"
check "inventory item created in outlet A" "Flour" "$(auth "${API}/collections/inventory_items/records/${FLOUR}" | jq -r .name)"

echo
echo "Purchase-in writes a ledger move and sets the balance"
R=$(api_post /app/inventory/purchase "{\"inventory_item\":\"${FLOUR}\",\"qty\":10}")
check "purchase ok" "true" "$(echo "$R" | jq -r .ok)"
check "balance_after is 10" "10" "$(echo "$R" | jq -r .balance_after)"
V=$(api_get "/app/inventory/valuation?outlet=${OUTLET_A}")
check "valuation sees flour at 10" "10" "$(echo "$V" | jq -r '.items[] | select(.item_id=="'"${FLOUR}"'") | .balance')"
check "flour value is 400" "400" "$(echo "$V" | jq -r '.items[] | select(.item_id=="'"${FLOUR}"'") | .value')"

echo
echo "Serving a line auto-deducts its recipe"
post recipe_lines "{\"menu_item\":\"${BREAD}\",\"inventory_item\":\"${FLOUR}\",
  \"qty_per_serving\":0.5}" >/dev/null
NOW=$(date -u +"%Y-%m-%d %H:%M:%S.000Z")
O=$(post orders "{\"type\":\"takeaway\",\"staff\":\"${WAITER}\",\"outlet\":\"${OUTLET_A}\",
  \"status\":\"open\"}" | jq -r .id)
L=$(post order_items "{\"order\":\"${O}\",\"menu_item\":\"${BREAD}\",\"name_snapshot\":\"Bread\",
  \"qty\":2,\"unit_price\":50,\"status\":\"queued\",\"sent_at\":\"${NOW}\"}" | jq -r .id)
patch orders "$O" '{"status":"sent"}' >/dev/null
patch order_items "$L" '{"status":"served"}' >/dev/null
BAL=$(api_get "/app/inventory/valuation?outlet=${OUTLET_A}" | jq -r '.items[] | select(.item_id=="'"${FLOUR}"'") | .balance')
check "10 - 2x0.5 = 9" "9" "$BAL"
check "line flagged deducted" "true" "$(auth "${API}/collections/order_items/records/${L}" | jq -r .stock_deducted)"
patch order_items "$L" '{"status":"ready"}' >/dev/null
patch order_items "$L" '{"status":"served"}' >/dev/null
BAL=$(api_get "/app/inventory/valuation?outlet=${OUTLET_A}" | jq -r '.items[] | select(.item_id=="'"${FLOUR}"'") | .balance')
check "re-serve does not double-deduct" "9" "$BAL"

echo
echo "Voiding a deducted line writes a compensating entry"
patch order_items "$L" '{"status":"void","void_reason":"test"}' >/dev/null
BAL=$(api_get "/app/inventory/valuation?outlet=${OUTLET_A}" | jq -r '.items[] | select(.item_id=="'"${FLOUR}"'") | .balance')
check "balance restored to 10" "10" "$BAL"
check "line flag cleared" "false" "$(auth "${API}/collections/order_items/records/${L}" | jq -r .stock_deducted)"
USAGE=$(auth "${API}/collections/stock_moves/records?filter=inventory_item%3D%22${FLOUR}%22&sort=-created&perPage=5" | jq -r '.items[0].reason')
NOTE=$(auth "${API}/collections/stock_moves/records?filter=inventory_item%3D%22${FLOUR}%22&sort=-created&perPage=5" | jq -r '.items[0].note')
check "latest move is an adjustment" "adjustment" "$USAGE"
check "note says void restore" "void restore: Bread x2" "$NOTE"

echo
echo "Per-outlet isolation"
R=$(api_post /app/inventory/purchase "{\"inventory_item\":\"${FLOUR_B}\",\"qty\":5}")
check "outlet B flour at 5" "5" "$(echo "$R" | jq -r .balance_after)"
O2=$(post orders "{\"type\":\"takeaway\",\"staff\":\"${WAITER}\",\"outlet\":\"${OUTLET_A}\",
  \"status\":\"open\"}" | jq -r .id)
L2=$(post order_items "{\"order\":\"${O2}\",\"menu_item\":\"${BREAD}\",\"name_snapshot\":\"Bread\",
  \"qty\":1,\"unit_price\":50,\"status\":\"queued\",\"sent_at\":\"${NOW}\"}" | jq -r .id)
patch orders "$O2" '{"status":"sent"}' >/dev/null
patch order_items "$L2" '{"status":"served"}' >/dev/null
check "outlet A flour at 9.5" "9.5" "$(api_get "/app/inventory/valuation?outlet=${OUTLET_A}" | jq -r '.items[] | select(.item_id=="'"${FLOUR}"'") | .balance')"
check "outlet B flour untouched" "5" "$(api_get "/app/inventory/valuation?outlet=${OUTLET_B}" | jq -r '.items[] | select(.item_id=="'"${FLOUR_B}"'") | .balance')"

echo
echo "Low-stock alerts"
patch inventory_items "$FLOUR" '{"low_stock_threshold":12}' >/dev/null
A=$(api_get "/app/inventory/alerts?outlet=${OUTLET_A}")
check "flour flagged low" "Flour" "$(echo "$A" | jq -r '.alerts[0].name')"
check "alert carries balance" "9.5" "$(echo "$A" | jq -r '.alerts[0].balance')"
check "alert carries last restock" "true" "$(echo "$A" | jq -r '(.alerts[0].last_restock | length) > 0')"
B=$(api_get "/app/inventory/alerts?outlet=${OUTLET_B}")
check "outlet B has no alerts" "0" "$(echo "$B" | jq '.alerts | length')"

echo
echo "Wastage"
R=$(api_post /app/inventory/wastage "{\"inventory_item\":\"${FLOUR}\",\"qty\":1,\"note\":\"spilled\"}" "$WAITER_TOKEN")
check "waiter can log wastage" "true" "$(echo "$R" | jq -r .ok)"
check "balance_after 8.5" "8.5" "$(echo "$R" | jq -r .balance_after)"

echo
echo "Negative stock is allowed but flagged"
O3=$(post orders "{\"type\":\"takeaway\",\"staff\":\"${WAITER}\",\"outlet\":\"${OUTLET_A}\",
  \"status\":\"open\"}" | jq -r .id)
L3=$(post order_items "{\"order\":\"${O3}\",\"menu_item\":\"${BREAD}\",\"name_snapshot\":\"Bread\",
  \"qty\":30,\"unit_price\":50,\"status\":\"queued\",\"sent_at\":\"${NOW}\"}" | jq -r .id)
patch orders "$O3" '{"status":"sent"}' >/dev/null
patch order_items "$L3" '{"status":"served"}' >/dev/null
check "balance went negative" "-6.5" "$(api_get "/app/inventory/valuation?outlet=${OUTLET_A}" | jq -r '.items[] | select(.item_id=="'"${FLOUR}"'") | .balance')"
check "item flagged for review" "true" "$(auth "${API}/collections/inventory_items/records/${FLOUR}" | jq -r .needs_review)"
api_post /app/inventory/purchase "{\"inventory_item\":\"${FLOUR}\",\"qty\":10}" >/dev/null
check "purchase clears the flag" "false" "$(auth "${API}/collections/inventory_items/records/${FLOUR}" | jq -r .needs_review)"

echo
echo "The ledger is append-only"
MOVE=$(auth "${API}/collections/stock_moves/records?filter=inventory_item%3D%22${FLOUR}%22&perPage=1" | jq -r '.items[0].id')
check "ledger update rejected" "403" "$(code -X PATCH -H "Authorization: ${OWNER_TOKEN}" -H 'Content-Type: application/json' -d '{"note":"x"}' "${API}/collections/stock_moves/records/${MOVE}")"
check "ledger delete rejected" "403" "$(code -X DELETE -H "Authorization: ${OWNER_TOKEN}" "${API}/collections/stock_moves/records/${MOVE}")"
check "direct ledger insert rejected" "403" "$(code -X POST -H "Authorization: ${OWNER_TOKEN}" -H 'Content-Type: application/json' -d '{"inventory_item":"'"${FLOUR}"'","qty_delta":99,"reason":"purchase"}' "${API}/collections/stock_moves/records")"

echo
echo "Auth and validation"
check "alerts need sign-in" "401" "$(code "${API}/app/inventory/alerts")"
check "waiter cannot purchase" "403" "$(code -X POST -H "Authorization: ${WAITER_TOKEN}" -H 'Content-Type: application/json' -d "{\"inventory_item\":\"${FLOUR}\",\"qty\":1}" "${API}/app/inventory/purchase")"
check "waiter cannot adjust" "403" "$(code -X POST -H "Authorization: ${WAITER_TOKEN}" -H 'Content-Type: application/json' -d "{\"inventory_item\":\"${FLOUR}\",\"qty_delta\":1,\"note\":\"x\"}" "${API}/app/inventory/adjust")"
check "zero-qty purchase rejected" "400" "$(code -X POST -H "Authorization: ${OWNER_TOKEN}" -H 'Content-Type: application/json' -d "{\"inventory_item\":\"${FLOUR}\",\"qty\":0}" "${API}/app/inventory/purchase")"
check "unknown item rejected" "404" "$(code -X POST -H "Authorization: ${OWNER_TOKEN}" -H 'Content-Type: application/json' -d '{"inventory_item":"nope","qty":1}' "${API}/app/inventory/purchase")"
check "cross-outlet recipe rejected" "400" "$(code -X POST -H "Authorization: ${OWNER_TOKEN}" -H 'Content-Type: application/json' -d "{\"menu_item\":\"${BREAD}\",\"inventory_item\":\"${FLOUR_B}\",\"qty_per_serving\":1}" "${API}/collections/recipe_lines/records")"
check "zero-qty recipe rejected" "400" "$(code -X POST -H "Authorization: ${OWNER_TOKEN}" -H 'Content-Type: application/json' -d "{\"menu_item\":\"${BREAD}\",\"inventory_item\":\"${SUGAR}\",\"qty_per_serving\":0}" "${API}/collections/recipe_lines/records")"
check "adjust needs a reason note" "400" "$(code -X POST -H "Authorization: ${OWNER_TOKEN}" -H 'Content-Type: application/json' -d "{\"inventory_item\":\"${SUGAR}\",\"qty_delta\":2}" "${API}/app/inventory/adjust")"

echo
echo "Valuation math"
V=$(api_get "/app/inventory/valuation?outlet=${OUTLET_A}")
# flour 3.5 x 40 = 140, sugar 0, flour_B is outlet B
check "total value 140" "140" "$(echo "$V" | jq -r .total_value)"
check "currency symbol" "₹" "$(echo "$V" | jq -r .currency_symbol)"

echo
printf '\033[1m%d passed, %d failed\033[0m\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
