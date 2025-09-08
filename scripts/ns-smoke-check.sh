#!/usr/bin/env bash
set -euo pipefail
BASE="${1:-}"
if [ -z "$BASE" ]; then
  echo "[ERR] Provide Nightscout base URL, e.g.: scripts/ns-smoke-check.sh https://YOUR-NIGHTSCOUT"
  exit 64
fi
[[ "$BASE" == *"/api/v1"* ]] || BASE="${BASE%/}/api/v1"
URL="${BASE%/}/status"
TMP="$(mktemp -t ns_status.XXXX.json)"
code=$(curl -sS -m 10 -w '%{http_code}' -o "$TMP" "$URL" || true)
if [ "$code" != "200" ]; then echo "[ERR] HTTP $code from $URL"; rm -f "$TMP"; exit 2; fi
if command -v jq >/dev/null 2>&1; then jq '{status,name,version} | with_entries(select(.value!=null))' "$TMP" || true
else head -c 300 "$TMP"; fi
rm -f "$TMP"
