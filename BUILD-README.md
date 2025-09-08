# AndroidAPS Build Setup

Personal fork of [nightscout/AndroidAPS](https://github.com/nightscout/AndroidAPS) with custom build scripts.

## Quick Build

```bash
# Build release APK (automated, no prompts)
./build-release.sh
```

The signed APK will be created in `dist/` with a timestamp.

## Helper Scripts

### Build & Install
- `./build-release.sh` - Build signed APK (no interactive prompts)
- `./scripts/auto-install-latest-apk.sh` - Install latest APK via ADB

### Individual Tools  
- `./scripts/adb-install-apk.sh <apk-file>` - Install specific APK
- `./scripts/ns-smoke-check.sh <nightscout-url>` - Test Nightscout connectivity

## Prerequisites

- **Java 21** (Temurin recommended)
- **Android SDK** with Platform Tools (for ADB)
- **Keystore** at `~/.aaps/aaps-release.jks`

## Configuration

### Nightscout
- URL: `https://jdmallin.ns.nightscout4u.com`
- API_SECRET: (configured in app)

### Build Environment
```bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
```

## Git Configuration

Configured to avoid interactive prompts:
```bash
git config --global core.editor "echo"
git config --global advice.detachedHead false  
git config --global push.default simple
```

## Safety Notes

⚠️ **Medical Device Software**: Always verify:
- BG readings match your CGM
- Nightscout synchronization works  
- Start in open-loop mode first
- Keep backup monitoring methods ready

## Sync with Upstream

```bash
# Fetch latest from nightscout/AndroidAPS
git fetch upstream
git merge upstream/master

# Push updates to your fork
git push origin master
```

## Build Output

APKs are created in `dist/` with format: `YYYYMMDD-HHMMSS-app-full-release.apk`

Build artifacts are excluded from Git (see `.gitignore`).
