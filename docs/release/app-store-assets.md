# App Store Assets

This document outlines the required assets for submitting firstmenu to the Mac App Store.

## App Icons

### Required Sizes

The Mac App Store requires app icons in the following sizes:

| Size | Usage |
|------|-------|
| 16x16 | Dock, minimum |
| 32x32 | Dock @2x |
| 128x128 | Finder |
| 256x256 | Finder @2x |
| 512x512 | App Store |
| 1024x1024 | App Store @2x |

### Icon Design Guidelines

**Current Status:** The asset catalog is ready but actual icon files are needed.

**Design Recommendations:**
- Simple, recognizable design reflecting system monitoring
- Use SF Symbols as inspiration: `cpu`, `memorychip`, `internaldrive`, `cloud.sun`
- Consider a monochrome style that works well in dark mode
- Ensure readability at 16x16 pixels

### Creating Icons

1. Design your icon at 1024x1024 points
2. Export at required sizes
3. Add to `firstmenu/Assets.xcassets/AppIcon.appiconset/`

### Icon Asset Structure

```
firstmenu/Assets.xcassets/AppIcon.appiconset/
├── app-icon-16x16.png
├── app-icon-32x32.png
├── app-icon-128x128.png
├── app-icon-256x256.png
├── app-icon-512x512.png
└── app-icon-1024x1024.png
```

## App Store Screenshots

### Required Sizes

Mac App Store screenshots support multiple sizes:

| Size | Dimension |
|------|-----------|
| 1280x800 | 16:10 aspect ratio (recommended) |
| 1440x900 | 16:10 aspect ratio |
| 2560x1600 | Retina @2x |

### Minimum Requirements

- **Minimum:** 1 screenshot
- **Maximum:** 10 screenshots
- **Format:** PNG or JPEG (no transparency)

### Screenshot Topics

Recommended screenshots showcasing firstmenu features:

1. **Menu Bar Overview**
   - All 7 menu bar items visible
   - Clean, uncluttered menu bar

2. **CPU Popover**
   - Real-time CPU usage
   - Core count display

3. **Memory & Storage**
   - Memory usage with percentage
   - Storage available

4. **Weather Integration**
   - Current temperature
   - Weather condition icon

5. **Network Activity**
   - Upload/download speeds
   - Real-time updates

6. **Running Apps**
   - App list with quick quit
   - Keep-awake controls

7. **Settings**
   - Configuration options
   - Weather refresh intervals

8. **About/Info**
   - Version information
   - App attribution

### Creating Screenshots

Using macOS built-in screenshot tools:

```bash
# Capture specific area (Cmd+Shift+4)
screencapture -R <x>,<y>,<width>,<height> screenshot.png

# Capture with shadow
screencapture -C -t png -R <x>,<y>,<width>,<height> screenshot.png
```

### Screenshot Best Practices

1. Use a clean desktop background
2. Ensure menu bar is clearly visible
3. Show one feature per screenshot
4. Add captions to explain each feature
5. Consider adding subtle annotations (optional)

## App Preview (Optional)

Video previews can showcase the app in action:

- **Duration:** 15-30 seconds recommended
- **Resolution:** 1920x1080 or 2560x1600
- **Format:** .mov (H.264 or HEVC)

## App Store Connect Metadata

### App Name

- **Name:** firstmenu
- **Subtitle:** A minimal macOS menu bar system companion

### Description (Draft)

```
firstmenu is a lightweight, elegant system monitoring companion for your Mac menu bar.

Track your system's vital signs at a glance:

• CPU usage with real-time percentage
• Memory consumption with pressure indicators
• Storage availability at a glance
• Current weather with beautiful SF Symbol icons
• Network activity monitoring
• Running applications with quick actions
• Keep-awake controls to prevent sleep

Designed with simplicity in mind, firstmenu puts essential system information right in your menu bar—no clutter, no distractions. Just the information you need, when you need it.

Features:
• 7 menu bar extras for focused information
• Real-time updates every second
• Weather updates from your location (IP-based)
• Quick app quitting from the menu
• Caffeinate controls with preset durations
• Native macOS design with .ultraThinMaterial

Perfect for developers, power users, and anyone who wants to keep tabs on their Mac without interrupting their workflow.
```

### Keywords

`system, monitor, menu bar, cpu, memory, weather, network, macos, productivity, utility`

### Categories

- **Primary:** Productivity
- **Secondary:** Utilities

### Age Rating

**Rating:** 4+ (Contains no objectionable content)

The app:
- Does not collect user data
- Does not contain ads
- Does not contain in-app purchases
- Does not contain user-generated content

## Privacy Policy

Since firstmenu does not collect any user data, a minimal privacy policy is required. See [privacy-policy.md](./privacy-policy.md) for details.

## Review Notes

For App Store review, include these notes:

```
firstmenu is a system monitoring app that displays information in the Mac menu bar.

The app uses standard macOS APIs to:
• Read CPU, memory, and network statistics
• Fetch weather data from IP-based geolocation
• List running applications
• Control system sleep via caffeinate command

No sensitive user data is collected or transmitted. All data remains on-device.
The app requires no special permissions beyond standard system monitoring.
```

## Asset Checklist

Before submitting, verify:

- [ ] App icons in all required sizes
- [ ] At least 3 screenshots (10 maximum)
- [ ] App name and subtitle
- [ ] App description (4000 character limit)
- [ ] Keywords (100 character limit)
- [ ] Privacy policy URL
- [ ] Support URL
- [ ] Marketing URL (optional)
- [ ] Age rating completed
