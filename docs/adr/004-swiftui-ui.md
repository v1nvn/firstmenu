# ADR 004: SwiftUI for UI Implementation

## Status
Accepted

## Context
FirstMenu is a macOS menu bar application requiring:
- Compact menu bar labels
- Popover windows for detailed views
- System native appearance
- Efficient rendering (1-second updates)

## Decision
Use SwiftUI for all UI implementation:

**Key Components**:
- `MenuBarExtra`: Native menu bar integration
- `NSPopover`: Popover windows
- `.ultraThinMaterial`: Native frosted glass effect
- `@Observable`: State management

## Rationale
1. **Native Integration**: `MenuBarExtra` is the modern macOS API
2. **Declarative**: UI is expressed concisely
3. **Live Previews**: Rapid development iteration
4. **Future-Proof**: Apple's recommended UI framework

## Implementation Patterns

### Menu Bar Items
```swift
MenuBarExtra("CPU", systemImage: "cpu") {
    CPUPopoverView()
}
.menuBarExtraStyle(.window)
```

### Custom Views as Text
For compact display, we render SwiftUI views to images:
```swift
let renderer = ImageRenderer(content: view)
statusItem.button?.image = renderer.nsImage
```

### State Management
```swift
@Observable
@MainActor
class MenuBarState {
    static let shared = MenuBarState()
    var cpuPercentage: Double = 0
    // ...
}
```

## Trade-offs
**Positive**:
- Modern, Apple-supported framework
- Less boilerplate than AppKit
- Native appearance and behavior
- Excellent dark mode support

**Negative**:
- Some advanced AppKit features unavailable
- Custom menu bar rendering requires workarounds
- SwiftUI learning curve

## Alternatives Considered
1. **Pure AppKit**: NSStatusItem, NSView, etc.
   - Rejected: More boilerplate, less maintainable

2. **AppKit + SwiftUI Hybrid**: AppKit for menu, SwiftUI for popovers
   - Considered: Used where necessary (e.g., `NSPopover`)

3. **UIKit via Catalyst**: iOS UI on Mac
   - Rejected: Not designed for Mac UI patterns
