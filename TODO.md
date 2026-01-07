# firstmenu — TODO

This file tracks pending work. All planned 1.0 features are complete.

**Status:** Feature-complete. Ready for release.

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
