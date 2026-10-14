#!/usr/bin/env bash
# Module 2 outlet checks: the outlets collection and its public endpoint,
# per-outlet menu scoping, cross-outlet order isolation, per-outlet order
# numbering and tax math, and the staff-only sales-by-outlet report.
#
# Kill-by-PID (house rule): pkill -f would match this script's own command
# line, so the server PID is saved at launch and killed directly.
set -euo pipefail

cd "$(dirname "$0")/.."
export PATH="$HOME/workspace/open-restaurant-rebuild/base/.harness/cache/jq:$PATH"

PORT=8099
API="http://127.0.0.1:${PORT}/api"
DATA="./pb_outlet_test_data"
PIDFILE="/tmp/dineos_outlet_test.pid"

pass=0; fail=0
check() {
  if [ "$2" = "$3" ]; then
    printf '  \033[32mok\033[0m   %-44s %s\n' "$1" "$3"; pass=$((pass+1))
  else
    printf '  \033[31mFAIL\033[0m %-44s expected %s, got %s\n' "$1" "$2" "$3"; fail=$((fail+1))
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

# Bootstrap the venue and its first owner. The migration seeds "Main outlet"
# from these money settings (5% tax, exclusive).
curl -sf -X POST "${API}/app/bootstrap" -H 'Content-Type: application/json' -d '{
  "restaurant_name":"The Ember","owner_name":"Owner","owner_username":"owner",
  "owner_pin":"1111","currency_code":"INR","currency_symbol":"\u20b9",
  "tax_rate":5,"tax_inclusive":false}' >/dev/null

OWNER_TOKEN=$(curl -s -X POST "${API}/collections/staff/auth-with-password" \
  -H 'Content-Type: application/json' -d '{"identity":"owner","password":"1111"}' | jq -r .token)
auth() { curl -s -H "Authorization: ${OWNER_TOKEN}" "$@"; }
post() { auth -X POST "${API}/collections/$1/records" -H 'Content-Type: application/json' -d "$2"; }

echo "Outlets"
OUTLETS=$(curl -s "${API}/app/outlets")
check "public outlets endpoint lists the seeded outlet" "1" "$(echo "$OUTLETS" | jq '.outlets | length')"
check "seeded outlet is called Main outlet" "Main outlet" "$(echo "$OUTLETS" | jq -r '.outlets[0].name')"
OUTLET_A=$(echo "$OUTLETS" | jq -r '.outlets[0].id')
OUTLET_B=$(post outlets '{"name":"Branch 2","currency_code":"INR","currency_symbol":"\u20b9",
  "tax_rate":12,"tax_inclusive":false,"active":true,"sort_order":2}' | jq -r .id)
check "second outlet created" "Branch 2" "$(curl -s "${API}/app/outlets" | jq -r '.outlets[1].name')"
check "config advertises both outlets" "2" "$(curl -s "${API}/app/online-config" | jq '.outlets | length')"

echo
echo "Menu scoping"
CAT_A=$(post categories "{\"name\":\"Mains A\",\"active\":true,\"outlet\":\"${OUTLET_A}\"}" | jq -r .id)
ITEM_A=$(post menu_items "{\"category\":\"${CAT_A}\",\"name\":\"Thali A\",\"price\":100,
  \"active\":true,\"available\":true,\"outlet\":\"${OUTLET_A}\"}" | jq -r .id)
CAT_B=$(post categories "{\"name\":\"Mains B\",\"active\":true,\"outlet\":\"${OUTLET_B}\"}" | jq -r .id)
ITEM_B=$(post menu_items "{\"category\":\"${CAT_B}\",\"name\":\"Thali B\",\"price\":200,
  \"active\":true,\"available\":true,\"outlet\":\"${OUTLET_B}\"}" | jq -r .id)
check "menu for outlet A shows only its item" "Thali A" \
  "$(curl -s "${API}/app/menu?outlet=${OUTLET_A}" | jq -r '.items[0].name')"
check "menu for outlet A hides outlet B items" "1" \
  "$(curl -s "${API}/app/menu?outlet=${OUTLET_A}" | jq '.items | length')"
check "menu for outlet B shows only its item" "Thali B" \
  "$(curl -s "${API}/app/menu?outlet=${OUTLET_B}" | jq -r '.items[0].name')"
check "unknown outlet refused" "404" \
  "$(curl -s -o /dev/null -w '%{http_code}' "${API}/app/menu?outlet=nope")"

echo
echo "Cross-outlet isolation"
BODY=/tmp/outlet_body.json
order() {
  curl -s -o /tmp/oo.json -w '%{http_code}' -X POST "${API}/app/online-order" \
    -H 'Content-Type: application/json' --data-binary @"$BODY"
}
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"A","customer_phone":"+911234567890","payment":"counter",
 "outlet":"${OUTLET_A}","items":[{"item_id":"${ITEM_B}","qty":1}]}
JSON
check "item from another outlet refused" "400" "$(order)"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"A","customer_phone":"+911234567890","payment":"counter",
 "outlet":"${OUTLET_A}","items":[{"item_id":"${ITEM_A}","qty":1}]}
JSON
check "order at outlet A accepted" "200" "$(order)"
NUM_A1=$(jq -r .order_number < /tmp/oo.json)
OID_A1=$(auth "${API}/collections/orders/records?filter=number%3D%27${NUM_A1}%27" | jq -r '.items[0].id')
check "order stamped with outlet A" "${OUTLET_A}" \
  "$(auth "${API}/collections/orders/records/${OID_A1}" | jq -r .outlet)"

echo
echo "Per-outlet numbering"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"B","customer_phone":"+911234567891","payment":"counter",
 "outlet":"${OUTLET_B}","items":[{"item_id":"${ITEM_B}","qty":1}]}
JSON
check "order at outlet B accepted" "200" "$(order)"
NUM_B1=$(jq -r .order_number < /tmp/oo.json)
check "outlet B runs its own sequence from 001" "001" "$NUM_B1"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"C","customer_phone":"+911234567892","payment":"counter",
 "outlet":"${OUTLET_A}","items":[{"item_id":"${ITEM_A}","qty":1}]}
JSON
order >/dev/null
NUM_A2=$(jq -r .order_number < /tmp/oo.json)
check "outlet A sequence continues independently" "002" "$NUM_A2"

echo
echo "Per-outlet tax math"
# Outlet A: 100 + 5% = 105. Outlet B: 200 + 12% = 224.
check "outlet A total uses 5% tax" "105" \
  "$(auth "${API}/collections/orders/records/${OID_A1}" | jq -r .total)"
OID_B1=$(auth "${API}/collections/orders/records?filter=number%3D%27001%27%20%26%26%20outlet%3D%27${OUTLET_B}%27" | jq -r '.items[0].id')
check "outlet B total uses 12% tax" "224" \
  "$(auth "${API}/collections/orders/records/${OID_B1}" | jq -r .total)"

echo
echo "Sales-by-outlet report"
check "report needs sign-in" "401" \
  "$(curl -s -o /dev/null -w '%{http_code}' "${API}/app/reports/sales-by-outlet")"
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
for oid in "$OID_A1" "$OID_B1"; do
  auth -X PATCH "${API}/collections/orders/records/${oid}" \
    -H 'Content-Type: application/json' \
    -d "{\"status\":\"paid\",\"closed_at\":\"${NOW}\"}" >/dev/null
done
REP=$(auth "${API}/app/reports/sales-by-outlet")
check "report lists both outlets" "2" "$(echo "$REP" | jq '.outlets | length')"
check "outlet A gross" "105" "$(echo "$REP" | jq -r '.outlets[] | select(.outlet_id=="'"${OUTLET_A}"'") | .gross')"
check "outlet B gross" "224" "$(echo "$REP" | jq -r '.outlets[] | select(.outlet_id=="'"${OUTLET_B}"'") | .gross')"
check "combined gross" "329" "$(echo "$REP" | jq -r .combined_gross)"

echo
if [ "$fail" -eq 0 ]; then printf '\033[1m%d passed, 0 failed\033[0m\n' "$pass"; else
  printf '\033[1m%d passed, %d failed\033[0m\n' "$pass" "$fail"; exit 1; fi
