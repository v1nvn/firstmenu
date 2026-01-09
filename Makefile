# firstmenu Makefile
# CLI-first development interface

.PHONY: all build clean test lint lint-fix format probe watch run stop help setup-lint

# SwiftLint cache location
SWIFTLINT_CACHE=$(HOME)/Library/Caches/com.firstmenu.SwiftLint
SWIFTLINT_BIN=$(SWIFTLINT_CACHE)/swiftlint

# Default target - includes lint check
all: lint build

# Setup SwiftLint via SPM (run once)
setup-lint:
	@echo "Setting up SwiftLint via SPM..."
	@bash Scripts/setup-swiftlint.sh

# Build the app
build:
	@echo "Building firstmenu..."
	xcodebuild -scheme firstmenu -configuration Debug build

# Clean build artifacts
clean:
	@echo "Cleaning derived data..."
	xcodebuild -scheme firstmenu clean
	rm -rf ~/Library/Developer/Xcode/DerivedData/firstmenu-*

# Run SwiftLint (uses SPM-cached binary)
lint:
	@echo "Running SwiftLint..."
	@if [ -f "$(SWIFTLINT_BIN)" ]; then \
		$(SWIFTLINT_BIN) lint --strict; \
	else \
		echo "SwiftLint not found. Run: make setup-lint"; \
		exit 1; \
	fi

# Auto-fix SwiftLint issues
lint-fix:
	@echo "Auto-fixing SwiftLint issues..."
	@if [ -f "$(SWIFTLINT_BIN)" ]; then \
		$(SWIFTLINT_BIN) --fix --strict; \
	else \
		echo "SwiftLint not found. Run: make setup-lint"; \
		exit 1; \
	fi

# Format code with SwiftLint
format:
	@echo "Formatting code..."
	@if [ -f "$(SWIFTLINT_BIN)" ]; then \
		$(SWIFTLINT_BIN) --fix; \
	else \
		echo "SwiftLint not found. Run: make setup-lint"; \
		exit 1; \
	fi

# Run full test suite (alias for pulse)
test pulse:
	@echo "Running full test suite..."
	xcodebuild test -scheme firstmenu -destination 'platform=macOS'

# Run tests quickly (domain only - fast TDD loop)
probe:
	@echo "Running domain tests..."
	xcodebuild test -scheme firstmenu -destination 'platform=macOS' -only-testing:firstmenuTests/DomainTests

# Show test statistics
test-stats:
	@echo "Test Statistics:"
	@echo "=================="
	@echo "Total test functions: $$(grep -r 'func test' firstmenuTests --include='*.swift' | wc -l | tr -d ' ')"
	@echo "Test files: $$(find firstmenuTests -name '*.swift' | wc -l | tr -d ' ')"
	@echo ""
	@echo "Test breakdown:"
	@echo "  Domain: $$(grep -r 'func test' firstmenuTests/DomainTests --include='*.swift' | wc -l | tr -d ' ') tests"
	@echo "  Infrastructure: $$(grep -r 'func test' firstmenuTests/InfrastructureTests --include='*.swift' | wc -l | tr -d ' ') tests"
	@echo "  Integration: $$(grep -r 'func test' firstmenuTests/IntegrationTests --include='*.swift' | wc -l | tr -d ' ') tests"

# Auto-run lint and tests on file changes
watch:
	@echo "Watching for changes..."
	@which entr > /dev/null || (echo "entr not installed. Run: brew install entr" && exit 1)
	@find firstmenu -name "*.swift" | entr -c sh -c 'make lint && make test'

# Run the app
run:
	@echo "Launching firstmenu..."
	@APP_PATH=$$(xcodebuild -scheme firstmenu -showBuildSettings 2>/dev/null | grep -m1 "BUILT_PRODUCTS_DIR" | awk '{print $$NF}')/firstmenu.app; \
	if [ -d "$$APP_PATH" ]; then \
		echo "Building..."; \
		xcodebuild -scheme firstmenu -configuration Debug build >/dev/null 2>&1 && \
		pkill -x firstmenu 2>/dev/null; sleep 0.5; \
		echo "Opening $$APP_PATH"; \
		open "$$APP_PATH"; \
	else \
		echo "Building..."; \
		xcodebuild -scheme firstmenu -configuration Debug build && \
		pkill -x firstmenu 2>/dev/null; sleep 0.5; \
		APP_PATH=$$(xcodebuild -scheme firstmenu -showBuildSettings 2>/dev/null | grep -m1 "BUILT_PRODUCTS_DIR" | awk '{print $$NF}')/firstmenu.app; \
		echo "Opening $$APP_PATH"; \
		open "$$APP_PATH"; \
	fi

# Stop the app
stop:
	@echo "Stopping firstmenu..."
	@if pkill -x firstmenu 2>/dev/null; then \
		echo "firstmenu stopped."; \
	else \
		echo "firstmenu was not running."; \
	fi

# Show help
help:
	@echo "firstmenu - Makefile targets"
	@echo ""
	@echo "  make all       - Lint and build (default)"
	@echo "  make build     - Build the app"
	@echo "  make clean     - Clean build artifacts"
	@echo "  make setup-lint - Setup SwiftLint via SPM (run once)"
	@echo "  make lint      - Run SwiftLint checks"
	@echo "  make lint-fix  - Auto-fix SwiftLint issues"
	@echo "  make format    - Format code with SwiftLint"
	@echo "  make test      - Run full test suite (make pulse)"
	@echo "  make pulse     - Run full test suite"
	@echo "  make probe     - Run domain tests only (fast TDD loop)"
	@echo "  make test-stats - Show test statistics"
	@echo "  make watch     - Auto-run lint and tests on file changes"
	@echo "  make run       - Build and launch the app"
	@echo "  make stop      - Stop the running app"
	@echo "  make help      - Show this help message"
