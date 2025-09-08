#!/usr/bin/env bash
set -euo pipefail
LATEST=$(ls -t dist/*.apk 2>/dev/null | head -n1 || true)
[ -n "$LATEST" ] || { echo "[ERR] No APKs in dist/"; exit 70; }
scripts/adb-install-apk.sh "$LATEST"
