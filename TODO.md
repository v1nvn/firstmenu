# firstmenu — TODO

This file tracks pending work based on [MASTER_PLAN.md](MASTER_PLAN.md).

**Status:** Feature-complete. Testing complete. Documentation and release prep remain.

---

## Completed ✅

### Domain Layer
- [x] Models: StatsSnapshot, WeatherSnapshot, AppProcess, CaffeinateState
- [x] Protocols: CPUProviding, RAMProviding, StorageProviding, NetworkProviding, WeatherProviding, AppListing, PowerAssertionProviding
- [x] UseCases: StatsSampler, WeatherSampler, AppProcessManager, PowerAssertionController

### Infrastructure Layer
- [x] MachCPUReader (host_statistics)
- [x] MachRAMReader (host_statistics64)
- [x] FileSystemStorageReader
- [x] InterfaceNetworkReader (getifaddrs)
- [x] OpenMeteoWeatherClient (no API key, IP-based location)
- [x] NSWorkspaceAppLister
- [x] CaffeinateWrapper

### UI Layer
- [x] MenuBarLabelView (single-line compact display)
- [x] MenuBarWindowView (popover)
- [x] CaffeinateMenu (toggle, presets: 15min, 1hr, indefinite)
- [x] StatsFormatter (CPU, RAM, storage, network, temperature)
- [x] **AppsPopoverView** — Running apps with quit actions and "Quit All"
- [x] **SettingsMenuView** — Weather refresh interval, menu bar toggles, about info
- [x] **.ultraThinMaterial** background styling on all popovers
- [x] **Improved weather SF Symbols** — Detailed WMO code mapping
- [x] **Opacity hierarchy** — Section separation via subtle backgrounds

### App Entry Point
- [x] FirstMenuApp.swift with AppDelegate
- [x] Timer-based updates (1s stats, 15min weather)
- [x] Menu bar extras for CPU, RAM, Storage, Weather, Network, Apps
- [x] Settings scene wired to SettingsMenuView

### Testing
- [x] **478 tests** across 29 test files (357 original + 121 new edge case tests)
- [x] Domain tests: 56 tests (100% coverage, added 31 edge case tests)
- [x] Infrastructure tests: 220 tests (~95% coverage, added 120 edge case tests)
- [x] UI tests: 195 tests
- [x] Integration tests: 7 tests
- [x] Mock providers for all infrastructure
- [x] Graceful error handling tests
- [x] **Comprehensive edge case coverage** - Zero values, maximum values, concurrent operations, error states

### Error Handling
- [x] Graceful degradation when providers fail
- [x] Cached values used on error
- [x] Default placeholders for first failure

### Tooling
- [x] Makefile with CLI-first targets
- [x] SwiftLint integration (SPM, no Homebrew)
- [x] test-stats target for test coverage reporting

### Documentation
- [x] README.md with feature overview
- [x] Installation and usage instructions
- [x] Architecture diagrams
- [x] **Comprehensive in-code documentation comments**
- [x] **Architecture Decision Records (ADRs)** in docs/adr/

### Performance
- [x] Binary size check: **1.3 MB (Release)** — well under 10 MB target
- [x] Actor isolation ensures thread safety

---

## Pending TODO

### High Priority — UI/UX Issues

#### ~~1. Remove "Hello World" Window on App Launch~~ ✅ COMPLETED
**Issue:** Running `make run` opens a default SwiftUI window (shows "firstmenu" or "Hello World" content)
**Root Cause:** The `Settings` scene in `FirstMenuApp.swift:38-40` creates a default window that opens on launch
**File:** `firstmenu/App/FirstMenuApp.swift`
**Fix:** Removed the `Settings` scene from FirstMenuApp.swift. Settings now only accessible from menu item popovers.

#### ~~2. Add Quit and Settings Buttons to All Menu Popovers~~ ✅ COMPLETED
**Issue:** Every menu dropdown/popover should have a quit and settings button
**Current State:** Only the SettingsMenuView has a quit button; individual popovers (CPU, RAM, Storage, Weather, Network, Apps, Caffeinate) lack these actions
**Files:**
- `firstmenu/UI/StatViews/StatPopoverViews.swift` (CPU, RAM, Storage, Weather, Network, Caffeinate, Apps)
**Fix:** Added consistent `PopoverFooter` component with "Settings..." and "Quit" buttons to all popover views.

#### ~~3. Create Native Settings Panel for All Menu Items~~ ✅ COMPLETED
**Issue:** Need a unified, native settings experience accessible from each menu
**Current State:** Settings are only accessible through the separate Settings scene (which has the hello world window issue)
**File:** `firstmenu/UI/Components/PopoverFooter.swift`
**Fix:** Created `SettingsWindowManager` that opens a native NSWindow with the SettingsMenuView content, accessible from any popover's "Settings..." button.

#### ~~4. Add Icon/Value Display Toggle for Each Menu Item~~ ✅ COMPLETED
**Issue:** Users should be able to choose whether to show the icon or the value (e.g., CPU: show "cpu" icon or "45%" usage)
**Files:**
- `firstmenu/UI/StatViews/StatLabelViews.swift` (menu bar labels)
- `firstmenu/UI/Menus/SettingsMenu.swift` (settings UI)
- `firstmenu/App/FirstMenuApp.swift` (menu bar extras)
**Fix:**
- Added `MenuBarDisplayMode` enum with icon/value/both options
- Updated all StatLabelViews (CPU, RAM, Storage, Weather, Network) to support display mode switching
- Added `@AppStorage` properties for each menu item's display mode
- Created `DisplayModePicker` component for settings UI
- Created custom menu bar labels that respect @AppStorage settings

#### 5. Improve Native Feel Throughout the App
**Issue:** The UI doesn't fully feel native to macOS
**Areas to Address:**
- ~~Button hover states~~ ✅ COMPLETED - Added `CompactMenuButtonStyle` with hover effects
- Native menu behaviors (right-click handling, keyboard navigation)
- Proper use of NSPanel for popovers vs window style
- Native animations and transitions
- Native color schemes and materials
- Proper accessibility labels and VoiceOver support
**Files:** All UI files in `firstmenu/UI/`

#### ~~6. Fix Hover Highlighting on Dropdown Selectors~~ ✅ COMPLETED
**Issue:** In dropdowns with selectors (like Keep Awake), items don't get highlighted on hover
**Root Cause:** Buttons using `.buttonStyle(.borderless)` don't provide visual hover feedback
**Files:**
- `firstmenu/UI/Design/ButtonStyles.swift` (new `CompactMenuButtonStyle`)
- `firstmenu/UI/StatViews/StatPopoverViews.swift` (updated `CaffeinatePresetButton`)
**Fix:** Created custom `CompactMenuButtonStyle` with proper hover states using `@State` tracking and `.controlAccentColor` opacity changes.

### Low Priority

#### Release Preparation
- [x] Code signing setup (docs/release/code-signing.md)
- [x] App Store assets guide (docs/release/app-store-assets.md)
- [x] Privacy policy (docs/release/privacy-policy.md)
- [x] Version tagging strategy (docs/release/version-strategy.md)
- [x] Homebrew formula guide (docs/release/homebrew-formula.md)
- [x] GitHub CI/CD workflow (.github/workflows/ci.yml)
- [x] GitHub Releases automation (.github/workflows/release.yml)
- [ ] Menu bar icon design (needs actual icon files — asset catalog is ready)

---

## Future Enhancements (Post-1.0)

These are intentionally deferred to avoid scope creep:

- [ ] Custom weather location (currently IP-based)
- [ ] GPU stats (if possible without permissions)
- [ ] Battery stats for laptops
- [ ] Custom color themes
- [ ] Multiple network interface selection
- [ ] Historical stats (graphs)
- [ ] Export/import settings

---

## Quick Reference

### Build Commands
```bash
make pulse        # Run all tests
make probe        # Fast domain tests only
make test-stats   # Show test statistics
make lint         # SwiftLint check
make lint-fix     # Auto-fix SwiftLint issues
make clean        # Clean build artifacts
make run          # Build and launch the app
```

### Test Stats
- **Total Tests:** 478 (357 original + 121 new edge case tests)
- **Domain:** 56 tests (100% coverage)
- **Infrastructure:** 220 tests (~95% coverage)
- **UI:** 195 tests
- **Integration:** 7 tests
- **Test Files:** 29

### File Count
- **Source files:** 33
- **Test files:** 28
- **Lines of code:** ~7,000 (estimate)
