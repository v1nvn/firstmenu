# Changelog

All notable changes to firstmenu will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Code signing configuration for distribution
- App Store assets documentation
- Privacy policy documentation
- Version tagging strategy

### Changed
- Updated test count to 357 total tests
- Updated lines of code estimate to ~7,000

## [1.1.0] - 2026-01-07

### Added
- **Caffeinate state indicator** - New 7th menu bar extra showing keep-awake status
  - Moon icon that changes based on caffeinate state
  - Visual indicator (green circle) when active
  - Status text showing remaining time or "indefinitely"
  - Integration with MenuBarState for real-time updates
- **CaffeinatePopoverView** - Dedicated popover for keep-awake controls
  - Quick preset buttons (15 min, 1 hour, indefinitely)
  - Disable button when active
- **28 new tests** for caffeinate functionality

### Changed
- MenuBarManager now tracks caffeinate state and power controller
- FirstMenuApp updated to include 7 menu bar extras (was 6)
- CaffeinatePopoverView now uses MenuBarState.shared for live updates

## [1.0.0] - TBD

### Added
- Initial release of firstmenu
- **6 menu bar extras** for system monitoring:
  - CPU: Real-time CPU usage percentage
  - RAM: Memory used / total
  - Storage: Disk usage percentage
  - Weather: Current temperature with SF Symbol
  - Network: Download / upload speeds
  - Apps: Running applications with quick quit actions
- **Caffeinate controls** embedded in Apps popover
- **Settings menu** for configuration
- **329 tests** across 28 test files with excellent coverage
- Clean architecture with Domain, Infrastructure, and UI layers
- `.ultraThinMaterial` background styling on all popovers

[Unreleased]: https://github.com/v1nit/firstmenu/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/v1nit/firstmenu/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/v1nit/firstmenu/releases/tag/v1.0.0
