# Version Tagging and Release Strategy

This document describes the versioning scheme and release process for firstmenu.

## Version Format

firstmenu uses **Semantic Versioning 2.0.0**: `MAJOR.MINOR.PATCH`

- **MAJOR:** Incompatible API changes (unlikely for a menu bar app)
- **MINOR:** New features or significant functionality additions
- **PATCH:** Bug fixes and minor improvements

### Example Versions

| Version | Type | Description |
|---------|------|-------------|
| 1.0.0 | Major | Initial stable release |
| 1.1.0 | Minor | Added caffeinate state indicator |
| 1.1.1 | Patch | Fixed weather data display bug |
| 2.0.0 | Major | Redesigned UI or major feature overhaul |

## Release Branch Strategy

For development, firstmenu uses a simplified Git workflow:

```
main (development branch)
  └── All commits happen here
  └── Tags are created for releases
```

### Branch Rules

1. **main** - Primary development branch
   - All features are developed directly on main
   - Always releasable (tests pass, builds successfully)
   - Protected from force pushes

2. **release/X.Y.Z** - Release preparation (optional)
   - Created only for complex releases
   - Used for final testing and documentation
   - Merged back to main after release

## Creating a Release

### Prerequisites

Before creating a release:

- [ ] All tests passing (`make pulse`)
- [ ] Documentation updated
- [ ] Version numbers updated in all locations
- [ ] CHANGELOG.md updated with release notes
- [ ] No outstanding critical bugs

### Version Update Locations

Update these files when bumping the version:

1. **Xcode Project:**
   - Target: firstmenu
   - Version: `CFBundleShortVersionString`
   - Build: `CFBundleVersion`

2. **Package.swift:**
   ```swift
   .package(version: "X.Y.Z", ...)
   ```

3. **CHANGELOG.md:**
   - Add release notes under new version header

### Release Checklist

```bash
# 1. Update version in Xcode project
# Open firstmenu.xcodeproj and update:
# - Marketing Version: X.Y.Z
# - Build: 1 (or increment)

# 2. Run full test suite
make pulse

# 3. Build release binary
make build-release

# 4. Create git tag
git tag -a vX.Y.Z -m "Release vX.Y.Z"

# 5. Push tag to remote
git push origin vX.Y.Z

# 6. Create GitHub Release
# (See GitHub Releases section below)
```

## GitHub Releases

### Automated Release Creation

After pushing a tag, create a GitHub Release with:

1. Go to https://github.com/v1nit/firstmenu/releases
2. Click "Draft a new release"
3. Choose the tag (vX.Y.Z)
4. Use the format:

```
## firstmenu X.Y.Z

### What's New
- Feature 1 description
- Feature 2 description

### Bug Fixes
- Bug fix description

### Known Issues
- Any known issues (optional)

### Installation
Download the attached `firstmenu.dmg` and drag to Applications.
```

5. Attach the built DMG file
6. Publish as "Latest release" if this is the newest stable version

### Release Assets

Each release should include:

- **firstmenu.dmg** - Disk image for installation
- **checksums.txt** - SHA256 checksums for verification

#### Building Release Assets

```bash
# Build the app
xcodebuild archive \
  -project firstmenu.xcodeproj \
  -scheme firstmenu \
  -archivePath build/firstmenu.xcarchive \
  -configuration Release

# Create DMG
hdiutil create \
  -volname "firstmenu" \
  -srcfolder /path/to/firstmenu.app \
  -ov -format UDZO \
  build/firstmenu.dmg

# Generate checksums
shasum -a 256 build/firstmenu.dmg > checksums.txt
```

## Pre-Release Versions

For beta or testing releases:

### Alpha Versions

Format: `X.Y.Z-alpha.N`

Example: `1.2.0-alpha.1`

Use for:
- Early testing of incomplete features
- Internal testing
- Feature branches

### Beta Versions

Format: `X.Y.Z-beta.N`

Example: `1.2.0-beta.1`

Use for:
- Feature-complete releases
- Public testing
- Release candidates

### Release Candidates

Format: `X.Y.Z-rc.N`

Example: `1.2.0-rc.1`

Use for:
- Final testing before stable release
- Bug fix testing
- "Freeze" except for critical fixes

## Changelog Format

Maintain a `CHANGELOG.md` file with the following format:

```markdown
# Changelog

All notable changes to firstmenu will be documented in this file.

## [Unreleased]

### Added
- Feature being worked on

### Changed
- Modification in progress

## [1.1.0] - 2026-01-07

### Added
- Caffeinate state indicator in menu bar
- 28 new tests for caffeinate functionality

### Changed
- Updated test count to 357 total tests

## [1.0.0] - 2025-12-15

### Added
- Initial release
- CPU, RAM, Storage monitoring
- Weather integration
- Network stats
- Running apps manager
```

## Hotfix Procedure

For critical bug fixes that can't wait for the next release:

```bash
# 1. Create hotfix branch from latest release tag
git checkout -b hotfix/vX.Y.Z+1 vX.Y.Z

# 2. Apply the fix
# Make changes and commit

# 3. Update PATCH version
# Bump to X.Y.(Z+1)

# 4. Create release tag
git tag -a vX.Y.Z+1 -m "Hotfix: description"

# 5. Merge back to main
git checkout main
git merge hotfix/vX.Y.Z+1

# 6. Push
git push origin main --tags
```

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.1.0 | TBD | Caffeinate state indicator, more tests |
| 1.0.0 | TBD | Initial stable release |

## Continuous Integration

The CI pipeline should:

1. Run tests on every push (`make pulse`)
2. Build the app (`make build`)
3. Check code style (`make lint`)
4. Fail on any test failure or lint error

### Release Automation (Future)

Consider automating with GitHub Actions:

- Auto-create GitHub Release on tag push
- Auto-build DMG as release asset
- Auto-generate checksums
- Update Homebrew formula
