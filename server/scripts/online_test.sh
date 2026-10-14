#!/usr/bin/env bash
# Checks the Module 1 online ordering routes: the storefront config, order
# validation, that online orders fire straight to the kitchen (unlike
# table-side guest orders), that every price is server-computed, and that the
# Razorpay/Stripe webhooks only record payments the gateway itself confirms.
#
# Runs in DINEOS_PAYMENTS_TEST_MODE: no real gateway is ever called. A second
# server without test mode checks the honest 409 when online payment is not
# configured and that the test backdoor is closed there.
set -euo pipefail

cd "$(dirname "$0")/.."
export PATH="$HOME/workspace/open-restaurant-rebuild/base/.harness/cache/jq:$PATH"

PORT=8099
API="http://127.0.0.1:${PORT}/api"
DATA="./pb_online_test_data"
DATA2=""
SU_EMAIL="test@local.test"
SU_PASS="testpassword123"

pass=0; fail=0
check() {
  if [ "$2" = "$3" ]; then
    printf '  \033[32mok\033[0m   %-44s %s\n' "$1" "$3"; pass=$((pass+1))
  else
    printf '  \033[31mFAIL\033[0m %-44s expected %s, got %s\n' "$1" "$2" "$3"; fail=$((fail+1))
  fi
}

cleanup() {
  pkill -f "pocketbase serve --dir=${DATA}" 2>/dev/null || true
  pkill -f "pocketbase serve --dir=${DATA2}" 2>/dev/null || true
  rm -rf "$DATA" "$DATA2"
}
trap cleanup EXIT

rm -rf "$DATA"
./bin/pocketbase migrate up --dir="$DATA" --migrationsDir=./pb_migrations >/dev/null
./bin/pocketbase superuser upsert "$SU_EMAIL" "$SU_PASS" --dir="$DATA" >/dev/null 2>&1
DINEOS_PAYMENTS_TEST_MODE=true \
./bin/pocketbase serve --dir="$DATA" --migrationsDir=./pb_migrations --hooksDir=./pb_hooks --publicDir=./pb_public \
  --http="127.0.0.1:${PORT}" >/dev/null 2>&1 &

for _ in $(seq 1 40); do curl -sf "${API}/health" >/dev/null 2>&1 && break; sleep 0.25; done

T=$(curl -sf -X POST "${API}/collections/_superusers/auth-with-password" \
  -H 'Content-Type: application/json' \
  -d "{\"identity\":\"${SU_EMAIL}\",\"password\":\"${SU_PASS}\"}" | jq -r .token)
post() { curl -sf -X POST "${API}/collections/$1/records" -H "Authorization: ${T}" \
  -H 'Content-Type: application/json' -d "$2"; }

post restaurant '{"name":"The Ember","currency_code":"INR","currency_symbol":"\u20b9",
  "tax_rate":0,"service_charge_rate":0,"setup_complete":true}' >/dev/null
CAT=$(post categories '{"name":"Mains","active":true}' | jq -r .id)
ON=$(post menu_items "{\"category\":\"${CAT}\",\"name\":\"Sea bass\",\"price\":850,\"active\":true,\"available\":true}" | jq -r .id)
SIZE=$(post modifier_groups '{"name":"Choose a size","min_select":1,"max_select":1,"required":true}' | jq -r .id)
LARGE=$(post modifiers "{\"group\":\"${SIZE}\",\"name\":\"Large\",\"price_delta\":150,\"active\":true}" | jq -r .id)
post menu_item_modifiers "{\"menu_item\":\"${ON}\",\"modifier_group\":\"${SIZE}\"}" >/dev/null

BODY=/tmp/online_body.json
order() {
  curl -s -o /tmp/o.json -w '%{http_code}' -X POST "${API}/app/online-order" \
    -H 'Content-Type: application/json' --data-binary @"$BODY"
}

echo "Storefront config"
C=$(curl -s "${API}/app/online-config")
check "ordering enabled" "true" "$(echo "$C" | jq -r .enabled)"
check "test mode advertised" "true" "$(echo "$C" | jq -r .test_mode)"
check "razorpay shown" "true" "$(echo "$C" | jq -r .providers.razorpay)"
check "stripe shown" "true" "$(echo "$C" | jq -r .providers.stripe)"
check "venue name" "The Ember" "$(echo "$C" | jq -r .restaurant.name)"

echo
echo "Validation"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"A","customer_phone":"+911234567890","payment":"counter","items":[]}
JSON
check "empty order refused" "400" "$(order)"
cat > "$BODY" <<JSON
{"type":"dinein","customer_name":"A","customer_phone":"+911234567890","payment":"counter","items":[{"item_id":"${ON}","qty":1,"modifiers":["${LARGE}"]}]}
JSON
check "bad order type refused" "400" "$(order)"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"","customer_phone":"+911234567890","payment":"counter","items":[{"item_id":"${ON}","qty":1,"modifiers":["${LARGE}"]}]}
JSON
check "nameless order refused" "400" "$(order)"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"A","customer_phone":"123","payment":"counter","items":[{"item_id":"${ON}","qty":1,"modifiers":["${LARGE}"]}]}
JSON
check "bad phone refused" "400" "$(order)"
cat > "$BODY" <<JSON
{"type":"delivery","customer_name":"A","customer_phone":"+911234567890","payment":"counter","items":[{"item_id":"${ON}","qty":1,"modifiers":["${LARGE}"]}]}
JSON
check "delivery without address refused" "400" "$(order)"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"A","customer_phone":"+911234567890","payment":"counter","items":[{"item_id":"nope","qty":1,"modifiers":["${LARGE}"]}]}
JSON
check "unknown item refused" "400" "$(order)"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"A","customer_phone":"+911234567890","payment":"counter","items":[{"item_id":"${ON}","qty":1}]}
JSON
check "missing required choice refused" "400" "$(order)"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"A","customer_phone":"+911234567890","payment":"online","provider":"paypal","items":[{"item_id":"${ON}","qty":1,"modifiers":["${LARGE}"]}]}
JSON
check "unknown provider refused" "400" "$(order)"

echo
echo "A pay-at-counter order fires to the kitchen"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"Meera","customer_phone":"+919876543210","payment":"counter",
 "items":[{"item_id":"${ON}","qty":2,"modifiers":["${LARGE}"],"note":"no chilli"}]}
JSON
check "accepted" "200" "$(order)"
check "order number issued" "001" "$(jq -r .order_number /tmp/o.json)"
check "total is server-computed" "2000" "$(jq -r .total /tmp/o.json)"
check "counter mode echoed" "counter" "$(jq -r .payment.mode /tmp/o.json)"
OID=$(curl -sf -G "${API}/collections/orders/records" -H "Authorization: ${T}" \
  --data-urlencode "filter=customer_name='Meera'" | jq -r '.items[0].id')
check "type is takeaway" "takeaway" "$(curl -sf "${API}/collections/orders/records/${OID}" -H "Authorization: ${T}" | jq -r .type)"
check "order is on the pass, not open" "sent" "$(curl -sf "${API}/collections/orders/records/${OID}" -H "Authorization: ${T}" | jq -r .status)"
check "customer name kept" "Meera" "$(curl -sf "${API}/collections/orders/records/${OID}" -H "Authorization: ${T}" | jq -r .customer_name)"
check "lines are fired" "1" \
  "$(curl -sf -G "${API}/collections/order_items/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID}' && sent_at != null && status = 'queued'" | jq -r '.items|length')"
check "kitchen note kept" "no chilli" \
  "$(curl -sf -G "${API}/collections/order_items/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID}'" | jq -r '.items[0].note')"

echo
echo "An online Razorpay order (test mode)"
cat > "$BODY" <<JSON
{"type":"delivery","customer_name":"Arjun","customer_phone":"+919999999999","address":"12 MG Road","payment":"online","provider":"razorpay",
 "items":[{"item_id":"${ON}","qty":1,"modifiers":["${LARGE}"]}]}
JSON
check "accepted" "200" "$(order)"
check "online mode echoed" "online" "$(jq -r .payment.mode /tmp/o.json)"
RP_GW=$(jq -r .payment.gateway_id /tmp/o.json)
check "test gateway id" "test_rp_order_" "$(echo "$RP_GW" | cut -c1-14)"
check "amount in paise" "100000" "$(jq -r .payment.amount /tmp/o.json)"
check "test key flagged" "true" "$(jq -r .payment.test /tmp/o.json)"
OID2=$(curl -sf -G "${API}/collections/orders/records" -H "Authorization: ${T}" \
  --data-urlencode "filter=customer_name='Arjun'" | jq -r '.items[0].id')
check "gateway attempt stored" "pending" \
  "$(curl -sf -G "${API}/collections/online_payments/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID2}'" | jq -r '.items[0].status')"
check "attempt has gateway id" "${RP_GW}" \
  "$(curl -sf -G "${API}/collections/online_payments/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID2}'" | jq -r '.items[0].gateway_id')"
check "not yet paid" "false" "$(curl -sf "${API}/collections/orders/records/${OID2}" -H "Authorization: ${T}" | jq -r .paid)"

echo
echo "The Razorpay webhook"
WB() { curl -s -o /tmp/w.json -w '%{http_code}' -X POST "$1" -H 'Content-Type: application/json' --data-binary @"$2"; }
cat > /tmp/wb.json <<JSON
{"test_event":true,"payment_id":"pay_test_1","gateway_id":"${RP_GW}"}
JSON
check "confirmed" "200" "$(WB "${API}/app/payments/razorpay/webhook" /tmp/wb.json)"
check "payment recorded" "1" \
  "$(curl -sf -G "${API}/collections/payments/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID2}'" | jq -r '.items|length')"
check "method is razorpay" "razorpay" \
  "$(curl -sf -G "${API}/collections/payments/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID2}'" | jq -r '.items[0].method')"
check "reference kept" "pay_test_1" \
  "$(curl -sf -G "${API}/collections/payments/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID2}'" | jq -r '.items[0].reference')"
check "order now paid" "true" "$(curl -sf "${API}/collections/orders/records/${OID2}" -H "Authorization: ${T}" | jq -r .paid)"
check "attempt marked paid" "paid" \
  "$(curl -sf -G "${API}/collections/online_payments/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID2}'" | jq -r '.items[0].status')"
check "replayed webhook is idempotent" "200" "$(WB "${API}/app/payments/razorpay/webhook" /tmp/wb.json)"
check "still one payment" "1" \
  "$(curl -sf -G "${API}/collections/payments/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID2}'" | jq -r '.items|length')"
cat > /tmp/wb.json <<JSON
{"test_event":true,"payment_id":"pay_test_x","gateway_id":"does_not_exist"}
JSON
check "unknown order refused" "404" "$(WB "${API}/app/payments/razorpay/webhook" /tmp/wb.json)"

echo
echo "An online Stripe order (test mode)"
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"Sara","customer_phone":"+918888888888","payment":"online","provider":"stripe",
 "items":[{"item_id":"${ON}","qty":1,"modifiers":["${LARGE}"]}]}
JSON
check "accepted" "200" "$(order)"
ST_GW=$(jq -r .payment.gateway_id /tmp/o.json)
check "test intent id" "test_pi_" "$(echo "$ST_GW" | cut -c1-8)"
OID3=$(curl -sf -G "${API}/collections/orders/records" -H "Authorization: ${T}" \
  --data-urlencode "filter=customer_name='Sara'" | jq -r '.items[0].id')
cat > /tmp/wb.json <<JSON
{"test_event":true,"gateway_id":"${ST_GW}"}
JSON
check "confirmed" "200" "$(WB "${API}/app/payments/stripe/webhook" /tmp/wb.json)"
check "method is stripe" "stripe" \
  "$(curl -sf -G "${API}/collections/payments/records" -H "Authorization: ${T}" \
     --data-urlencode "filter=order='${OID3}'" | jq -r '.items[0].method')"
check "order now paid" "true" "$(curl -sf "${API}/collections/orders/records/${OID3}" -H "Authorization: ${T}" | jq -r .paid)"

echo
echo "Without test mode: honest failures"
PORT2=8100
API2="http://127.0.0.1:${PORT2}/api"
DATA2="./pb_online_test_data2"
rm -rf "$DATA2"
./bin/pocketbase migrate up --dir="$DATA2" --migrationsDir=./pb_migrations >/dev/null
./bin/pocketbase superuser upsert "$SU_EMAIL" "$SU_PASS" --dir="$DATA2" >/dev/null 2>&1
./bin/pocketbase serve --dir="$DATA2" --migrationsDir=./pb_migrations --hooksDir=./pb_hooks --publicDir=./pb_public \
  --http="127.0.0.1:${PORT2}" >/dev/null 2>&1 &
for _ in $(seq 1 40); do curl -sf "${API2}/health" >/dev/null 2>&1 && break; sleep 0.25; done
T2=$(curl -sf -X POST "${API2}/collections/_superusers/auth-with-password" \
  -H 'Content-Type: application/json' \
  -d "{\"identity\":\"${SU_EMAIL}\",\"password\":\"${SU_PASS}\"}" | jq -r .token)
curl -sf -X POST "${API2}/collections/restaurant/records" -H "Authorization: ${T2}" \
  -H 'Content-Type: application/json' \
  -d '{"name":"The Ember","currency_code":"INR","currency_symbol":"\u20b9","setup_complete":true}' >/dev/null
cat > "$BODY" <<JSON
{"type":"takeaway","customer_name":"A","customer_phone":"+911234567890","payment":"online","provider":"razorpay",
 "items":[{"item_id":"${ON}","qty":1,"modifiers":["${LARGE}"]}]}
JSON
check "no keys, no online payment" "409" \
  "$(curl -s -o /tmp/o2.json -w '%{http_code}' -X POST "${API2}/app/online-order" \
     -H 'Content-Type: application/json' --data-binary @"$BODY")"
cat > /tmp/wb.json <<JSON
{"test_event":true,"payment_id":"pay_forged","gateway_id":"anything"}
JSON
check "test backdoor closed in prod mode" "400" "$(WB "${API2}/app/payments/razorpay/webhook" /tmp/wb.json)"
check "test mode not advertised" "false" "$(curl -s "${API2}/app/online-config" | jq -r .test_mode)"
check "no providers shown" "false" "$(curl -s "${API2}/app/online-config" | jq -r .providers.razorpay)"

echo
echo "The storefront page is served"
check "order page loads" "200" "$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:${PORT}/order/")"
check "page is the ordering storefront" "1" "$(curl -s "http://127.0.0.1:${PORT}/order/" | grep -c '<title>Order online</title>')"

echo
printf '\033[1m%d passed, %d failed\033[0m\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
