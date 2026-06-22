#!/usr/bin/env bash
# Connect anderhausconstruction.com to the Worker (requires DNS edit permission).
# Usage:
#   export CLOUDFLARE_API_TOKEN="your-token-with-zone-dns-edit"
#   ./scripts/connect-domain.sh

set -euo pipefail

ZONE_ID="cf32ebb3c5f85789ef25fe8088fae317"
ACCOUNT_ID="a0d6591fc135a7069b2487a1f5fd5aa7"
DOMAIN="anderhausconstruction.com"

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "Set CLOUDFLARE_API_TOKEN (Zone DNS Edit + Workers Scripts Edit)."
  echo "Create at: https://dash.cloudflare.com/profile/api-tokens"
  exit 1
fi

auth=( -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" -H "Content-Type: application/json" )

echo "Listing DNS records..."
curl -s "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?per_page=100" "${auth[@]}" \
  | python3 -c "
import sys, json
data = json.load(sys.stdin)
if not data.get('success'):
    raise SystemExit(data.get('errors'))
for r in data['result']:
    if r['type'] in ('A','AAAA','CNAME') and r['name'] in ('${DOMAIN}', 'www.${DOMAIN}'):
        print(r['id'], r['type'], r['name'], '->', r['content'])
" > /tmp/records-to-delete.txt

while read -r id type name rest; do
  echo "Deleting $type $name ..."
  curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${id}" "${auth[@]}" \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print('  ok' if d.get('success') else d.get('errors'))"
done < /tmp/records-to-delete.txt

for host in "$DOMAIN" "www.$DOMAIN"; do
  echo "Attaching Worker custom domain: $host"
  curl -s -X PUT "https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/workers/domains" \
    "${auth[@]}" \
    --data "{\"hostname\":\"${host}\",\"service\":\"anderhausconstruction\",\"environment\":\"production\",\"zone_id\":\"${ZONE_ID}\"}" \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print('  ok' if d.get('success') else d.get('errors'))"
done

echo "Done. Verify: curl -sI https://${DOMAIN}/ | head -3"
