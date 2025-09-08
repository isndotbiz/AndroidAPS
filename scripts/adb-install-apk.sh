#!/usr/bin/env bash
set -euo pipefail
APK="${1:-}"; [ -z "$APK" ] && { echo "[ERR] pass an APK path, e.g. scripts/adb-install-apk.sh dist/*.apk"; exit 64; }
[ -f "$APK" ] || { echo "[ERR] APK not found: $APK"; exit 66; }
command -v adb >/dev/null || { echo "[ERR] adb not on PATH. Install Android SDK Platform-Tools."; exit 69; }
adb start-server >/dev/null 2>&1 || true
DEVS=$(adb devices | awk 'NR>1 && $2=="device"{print $1}')
[ -n "$DEVS" ] || { echo "[ERR] No authorized device. Enable USB debugging and accept RSA prompt."; exit 67; }
echo "$DEVS" | sed 's/^/  - /'
echo "[INFO] Installing $APK …"
adb install -r "$APK"
echo "[OK] Install complete."
