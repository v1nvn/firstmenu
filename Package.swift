// swift-tools-version: 5.10
// This file is used for SwiftLint integration via SPM

import PackageDescription

let package = Package(
    name: "firstmenu",
    dependencies: [
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.57.0"
        ),
    ]
)
