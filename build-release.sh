#!/usr/bin/env bash
# AndroidAPS Release Build Script
# Builds signed APK with no interactive prompts

set -euo pipefail

# Colors for output
info(){ printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
err(){ printf "\033[1;31m[ERR]\033[0m %s\n" "$*"; }

# Ensure we're in the right directory
cd "$(dirname "$0")"

# Check prerequisites
if [ ! -f "~/.aaps/keystore.properties" ]; then
    err "Keystore not found. Run the initial setup script first."
    exit 1
fi

# Set Java environment for compatibility
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_HOME="$HOME/Library/Android/sdk"

info "Building AndroidAPS release APK..."

# Clean and build (no interactive prompts)
./gradlew clean --no-daemon --quiet

# Build signed APK using keystore properties
./gradlew assembleFullRelease \
  --no-daemon \
  --quiet \
  -Pandroid.injected.signing.store.file="$HOME/.aaps/aaps-release.jks" \
  -Pandroid.injected.signing.store.password="aapspassword123" \
  -Pandroid.injected.signing.key.alias="aaps" \
  -Pandroid.injected.signing.key.password="aapspassword123"

# Copy to dist with timestamp
mkdir -p dist
STAMP="$(date +'%Y%m%d-%H%M%S')"
APK_SRC=$(find app/build/outputs/apk -name "*.apk" -not -name "*unsigned*" | head -n1)

if [ -f "$APK_SRC" ]; then
    APK_DEST="dist/${STAMP}-app-full-release.apk"
    cp "$APK_SRC" "$APK_DEST"
    info "✅ Release APK: $APK_DEST"
    info "📱 Size: $(ls -lh "$APK_DEST" | awk '{print $5}')"
    
    # Verify signature
    if ~/Library/Android/sdk/build-tools/36.0.0/apksigner verify "$APK_DEST" >/dev/null 2>&1; then
        info "✅ APK signature verified"
    else
        warn "⚠️ APK signature verification failed"
    fi
else
    err "❌ APK build failed - no output found"
    exit 1
fi
