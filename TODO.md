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
