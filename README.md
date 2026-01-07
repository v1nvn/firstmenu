# firstmenu

A minimalist macOS menu bar utility for system health, connectivity, and contextual actions.

**Built with pure SwiftUI. No dependencies. No Electron. No bloat.**

```
CPU 12% • RAM 9.4G • SSD 62% • ☀︎ 28° • ↓ 32 ↑ 8
```

## Features

### Menu Bar Display
- **CPU** — Real-time CPU usage percentage
- **RAM** — Memory used / total
- **Storage** — System disk usage percentage
- **Weather** — Current temperature with SF Symbol icon
- **Network** — Download / upload speeds
- **Apps** — Running applications with quick quit actions

### Menu Actions

**Running Applications**
- List of user-facing apps
- Quit individual apps
- Quit All (with confirmation)
- Keep Awake controls integrated

**Caffeinate Utility**
- Toggle "Keep Awake"
- Quick presets: 15 min, 1 hour, Indefinite
- Status indicator (green dot when active)

**Settings**
- Weather refresh interval (5/15/30/60 min)
- Toggle menu bar items visibility
- About / version info

## Installation

### Build from Source

```bash
git clone https://github.com/vineet/firstmenu.git
cd firstmenu
make build
```

### Development Build

```bash
git clone https://github.com/vineet/firstmenu.git
cd firstmenu
make pulse
```

## Usage

Launch `firstmenu.app` to add it to your menu bar. Click the menu bar icon to:

1. View running applications and quit apps
2. Enable caffeinate (prevent sleep)
3. Configure display settings

## Development

firstmenu follows strict TDD with a CLI-first workflow.

### Prerequisites

- macOS 26.2+ (Sequoia)
- Xcode 17.2+
- Swift 6.0+

### Makefile Commands

```bash
make pulse        # Run full test suite
make probe        # Fast domain tests only (TDD loop)
make test-stats   # Show test statistics
make lint         # SwiftLint check
make lint-fix     # Auto-fix SwiftLint issues
make format       # Format code with SwiftLint
make clean        # Clean build artifacts
make run          # Build and launch the app
```

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      SwiftUI Views                          │
│  MenuBarLabelView • MenuBarWindowView • Menus              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    Domain Use Cases                         │
│  StatsSampler • WeatherSampler • AppProcessManager         │
│  PowerAssertionController                                   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                   Infrastructure Layer                       │
│  MachCPUReader • MachRAMReader • FileSystemStorageReader   │
│  InterfaceNetworkReader • OpenMeteoWeatherClient           │
│  NSWorkspaceAppLister • CaffeinateWrapper                   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    System APIs / Kernel                     │
│  host_statistics • getifaddrs • NSWorkspace • Process       │
└─────────────────────────────────────────────────────────────┘
```

### Project Structure

```
firstmenu/
├── App/                    # App entry point
├── Domain/                 # Business logic (pure)
│   ├── Models/            # Data models
│   ├── Protocols/         # Abstractions
│   └── UseCases/          # Orchestration
├── Infrastructure/         # System integration (isolated)
│   ├── CPU/
│   ├── RAM/
│   ├── Storage/
│   ├── Network/
│   ├── Weather/
│   ├── Apps/
│   └── Power/
├── UI/                     # SwiftUI views
│   ├── MenuBar/
│   ├── Menus/
│   └── Formatting/
└── Tests/                  # TDD test suites
```

### Testing

```bash
# Run all tests
make pulse

# Run domain tests only (fast feedback for TDD)
make probe

# Show test statistics
make test-stats

# Run specific test
xcodebuild test -scheme firstmenu -only-testing:firstmenuTests/StatsSamplerTests
```

**Current Coverage:**
- **195 tests** across 22 test files
- Domain: 25 tests (100%)
- Infrastructure: 100 tests (~95%)
- UI: 63 tests
- Integration: 7 tests

## Design Principles

1. **UI is dumb** — All logic lives in Domain layer
2. **Domain is pure** — No direct system dependencies
3. **System access is isolated** — Thin Infrastructure layer
4. **Everything testable first** — TDD workflow
5. **CLI is a first-class citizen** — Makefile-driven dev

## Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| RAM    | < 20 MB | TBD |
| CPU    | < 0.3%  | TBD |
| Binary | < 10 MB | TBD |

## Permissions

| Capability | Required | Notes |
|------------|----------|-------|
| App Sandbox | ✅ | Yes |
| Network Outgoing | ✅ | Weather API |
| Location | ❌ | IP-based only |
| Accessibility | ❌ | Not needed |
| Full Disk Access | ❌ | Not needed |

## Roadmap

See [TODO.md](TODO.md) for detailed tracking.

### Completed ✅
- [x] Core infrastructure (CPU, RAM, Storage, Network)
- [x] Weather integration (Open-Meteo, no API key)
- [x] Caffeinate wrapper with preset durations
- [x] AppsPopoverView with running apps list
- [x] SettingsMenuView with configuration options
- [x] Domain tests (25 tests)
- [x] Infrastructure tests (64 tests)
- [x] Integration tests (7 tests)
- [x] Graceful error handling for all providers
- [x] `.ultraThinMaterial` background styling

### In Progress 🚧
- [ ] Performance profiling and optimization
- [ ] Menu bar icon design
- [ ] In-code documentation

### Future 📋
- [ ] Code signing setup
- [ ] App Store assets
- [ ] Homebrew formula
- [ ] Custom weather location

## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow TDD: write tests first
4. Run `make lint` before committing
5. Submit a pull request

## License

Copyright © 2026 Vineet Kumar. All rights reserved.

---

**firstmenu** — A first-class macOS menu bar system companion.
