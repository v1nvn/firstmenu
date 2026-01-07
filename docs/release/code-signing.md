# Code Signing Configuration

This document explains how to configure code signing for firstmenu distribution.

## Overview

firstmenu uses automatic code signing managed by Xcode. The project is configured with:
- **Bundle Identifier:** `space.v1n.firstmenu`
- **Code Signing Style:** Automatic
- **Development Team:** To be configured by the developer

## Initial Setup

### 1. Set Development Team

1. Open `firstmenu.xcodeproj` in Xcode
2. Select the `firstmenu` project in the navigator
3. Choose the `firstmenu` target
4. Go to the **Signing & Capabilities** tab
5. Under **Team**, select your Apple Developer account

### 2. Enable Capabilities (Optional)

The app may need additional capabilities for distribution:
- **App Sandbox:** Required for Mac App Store distribution
- **Network Access:** For weather data fetching
- **Accessibility:** For reading system stats (may require entitlements)

## Distribution Builds

### Ad-Hoc Distribution

For testing outside the development team:

```bash
# Archive the app
xcodebuild archive \
  -project firstmenu.xcodeproj \
  -scheme firstmenu \
  -archivePath build/firstmenu.xcarchive

# Export for ad-hoc distribution
xcodebuild -exportArchive \
  -archivePath build/firstmenu.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist Distribution/ad-hoc-export.plist
```

### Mac App Store Distribution

For App Store submission:

```bash
# Archive the app
xcodebuild archive \
  -project firstmenu.xcodeproj \
  -scheme firstmenu \
  -archivePath build/firstmenu.xcarchive \
  -configuration Release

# Export for App Store
xcodebuild -exportArchive \
  -archivePath build/firstmenu.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist Distribution/app-store-export.plist
```

## Export Options Plists

Create the following plist files in a `Distribution/` directory:

### ad-hoc-export.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
</dict>
</plist>
```

### app-store-export.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
</dict>
</plist>
```

## Continuous Integration

For CI/CD builds, use environment variables:

```bash
# Set your team ID
export DEVELOPMENT_TEAM="YOUR_TEAM_ID"

# Build with automatic signing
xcodebuild archive \
  -project firstmenu.xcodeproj \
  -scheme firstmenu \
  -DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" \
  -archivePath build/firstmenu.xcarchive
```

## Troubleshooting

### "No signing certificate found"

- Open Xcode and go to Preferences > Accounts
- Sign in with your Apple ID
- Select your team and click "Download Manual Profiles"

### "Bundle identifier conflicts"

- Ensure your bundle identifier is unique
- Consider using a reverse domain format: `com.yourname.firstmenu`

### Runtime signing issues

If the app crashes on launch due to code signing:

```bash
# Verify the signature
codesign -dv --verbose=4 /path/to/firstmenu.app

# Re-sign with entitlements
codesign --force --deep --sign "Developer ID Application: Your Name" \
  --entitlements Distribution/entitlements.plist \
  /path/to/firstmenu.app
```

## Hardened Runtime

For distribution outside the App Store, enable the Hardened Runtime:

1. In Xcode, go to **Signing & Capabilities**
2. Click **+ Capability**
3. Add **Hardened Runtime**

## Entitlements

If needed, create an entitlements file at `firstmenu/entitlements.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
    <key>com.apple.security.network.server</key>
    <false/>
</dict>
</plist>
```

Then update the target settings to use this entitlements file.
