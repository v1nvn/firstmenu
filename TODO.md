# firstmenu — TODO

This file tracks pending work based on [MASTER_PLAN.md](MASTER_PLAN.md).

**Status:** Core implementation complete. Visual polish, integration testing, and packaging remain.

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

### App Entry Point
- [x] FirstMenuApp.swift with AppDelegate
- [x] Timer-based updates (1s stats, 15min weather)

### Testing
- [x] Domain tests: 25 tests passing
- [x] Infrastructure tests: 21 tests passing
- [x] Mock providers for all infrastructure
- [x] Test coverage for all use cases

### Tooling
- [x] Makefile with CLI-first targets
- [x] SwiftLint integration (SPM, no Homebrew)

---

## Pending TODO

### High Priority

#### UI Components
- [ ] **AppListMenu.swift** — Running applications menu
  - List of currently running user-facing apps
  - Per-app quit action
  - "Quit All" with confirmation
  - Filter out menu bar apps and system apps

- [ ] **SettingsMenu.swift** — Settings (if needed)
  - Weather refresh interval
  - Toggle which stats appear in menu bar
  - About / version info

#### Visual Polish
- [ ] Menu bar icon design (needs asset catalog entry)
- [ ] Caffeinate state indicator in menu bar icon
- [ ] `.ultraThinMaterial` background styling
- [ ] Proper SF Symbols for weather conditions
- [ ] Monospaced digit alignment for stats
- [ ] Opacity hierarchy instead of separators

#### Integration
- [ ] Wire AppListMenu to MenuBarWindowView
- [ ] Wire SettingsMenu to MenuBarWindowView
- [ ] Verify TimelineView update strategy

### Medium Priority

#### Testing
- [ ] **IntegrationTests** directory (empty)
  - End-to-end app flow tests
  - Menu interaction tests
- [ ] Increase test coverage to 100% for Domain layer
- [ ] UI tests for menu interactions

#### Performance
- [ ] Profile RAM usage (target: < 20 MB)
- [ ] Profile CPU idle usage (target: < 0.3%)
- [ ] Optimize wakeups (target: ≤ 1/sec)
- [ ] Binary size check (target: < 10 MB)

#### Error Handling
- [ ] Graceful degradation when weather API fails
- [ ] User-facing error messages (if any)
- [ ] Crash reporting strategy (decide if needed)

### Low Priority

#### Documentation
- [ ] README.md with:
  - Feature overview
  - Installation instructions
  - Usage guide
  - Screenshot(s)
- [ ] In-code documentation comments
- [ ] Architecture decision records (ADRs)

#### Release Preparation
- [ ] Code signing setup
- [ ] App Store assets (icons, screenshots)
- [ ] Privacy policy (if collecting any data)
- [ ] Version tagging strategy
- [ ] Homebrew formula (optional)
- [ ] GitHub Releases automation

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
make lint         # SwiftLint check
make lint-fix     # Auto-fix SwiftLint issues
make clean        # Clean build artifacts
```

### Test Stats
- **Domain Tests:** 25 passing
- **Infrastructure Tests:** 21 passing
- **Total:** 46 tests, 0 failures

### File Count
- **Source files:** ~30
- **Test files:** 12
- **Lines of code:** ~2,500 (estimate)
