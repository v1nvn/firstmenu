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
- [x] **195 tests** across 22 test files
- [x] Domain tests: 25 tests (100% coverage)
- [x] Infrastructure tests: 100 tests (~95% coverage)
- [x] UI tests: 63 tests
- [x] Integration tests: 7 tests
- [x] Mock providers for all infrastructure
- [x] Graceful error handling tests

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

---

## Pending TODO

### Medium Priority

#### Performance
- [ ] Profile RAM usage (target: < 20 MB)
- [ ] Profile CPU idle usage (target: < 0.3%)
- [ ] Optimize wakeups (target: ≤ 1/sec)
- [ ] Binary size check (target: < 10 MB)

#### Visual Polish (Remaining)
- [ ] Menu bar icon design (needs asset catalog entry)
- [ ] Caffeinate state indicator in menu bar icon

#### Code Quality
- [ ] In-code documentation comments
- [ ] Architecture decision records (ADRs)

### Low Priority

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
make test-stats   # Show test statistics
make lint         # SwiftLint check
make lint-fix     # Auto-fix SwiftLint issues
make clean        # Clean build artifacts
make run          # Build and launch the app
```

### Test Stats
- **Total Tests:** 195
- **Domain:** 25 tests (100% coverage)
- **Infrastructure:** 100 tests (~95% coverage)
- **UI:** 63 tests
- **Integration:** 7 tests
- **Test Files:** 22

### File Count
- **Source files:** ~40
- **Test files:** 22
- **Lines of code:** ~5,500 (estimate)
