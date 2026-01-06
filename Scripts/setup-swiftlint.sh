#!/bin/bash
# Setup SwiftLint via SPM - Run this once to download SwiftLint

SWIFTLINT_CACHE_DIR="$HOME/Library/Caches/com.firstmenu.SwiftLint"
SWIFTLINT_BIN="$SWIFTLINT_CACHE_DIR/swiftlint"

echo "Setting up SwiftLint..."
mkdir -p "$SWIFTLINT_CACHE_DIR"

# Create a minimal Package.swift for SwiftLint
cat > "$SWIFTLINT_CACHE_DIR/Package.swift" << 'EOF'
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SwiftLintCache",
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.57.0"),
    ]
)
EOF

cd "$SWIFTLINT_CACHE_DIR"

# Build SwiftLint
echo "Downloading SwiftLint via SPM..."
swift package resolve
swift build --product swiftlint --configuration release

# Find the built binary
SWIFTLINT_BUILD=".build/release/swiftlint"
if [ ! -f "$SWIFTLINT_BUILD" ]; then
    SWIFTLINT_BUILD=".build/arm64-apple-macosx/release/swiftlint"
fi

if [ -f "$SWIFTLINT_BUILD" ]; then
    cp "$SWIFTLINT_BUILD" "$SWIFTLINT_BIN"
    echo "SwiftLint installed to: $SWIFTLINT_BIN"
else
    echo "Error: SwiftLint binary not found"
    exit 1
fi
