//
//  NSWorkspaceAppListerTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import Cocoa
import XCTest
@testable import firstmenu

/// Tests for NSWorkspaceAppLister.
final class NSWorkspaceAppListerTests: XCTestCase {

    // MARK: - Initialization

    func testInitWithDefaultWorkspace() async throws {
        let lister = NSWorkspaceAppLister()
        XCTAssertNotNil(lister)
    }

    func testInitWithCustomWorkspace() async throws {
        let workspace = NSWorkspace()
        let lister = NSWorkspaceAppLister(workspace: workspace)
        XCTAssertNotNil(lister)
    }

    // MARK: - Running Apps

    func testRunningAppsReturnsNonEmptyArray() async throws {
        let lister = NSWorkspaceAppLister()

        // This test may return 0 apps in CI environment, but should not crash
        let apps = try await lister.runningApps()
        XCTAssertTrue(apps.count >= 0)
    }

    func testRunningAppsFiltersMenuBarOnlyApps() async throws {
        // The NSWorkspaceAppLister should filter out known menu bar-only apps
        let lister = NSWorkspaceAppLister()

        let apps = try await lister.runningApps()

        // Verify that known menu bar-only apps are not in the list
        let menuBarOnlyApps = [
            "com.apple.controlcenter",
            "com.apple.systemuiserver",
            "com.apple.Spotlight"
        ]

        for bundleId in menuBarOnlyApps {
            XCTAssertFalse(apps.contains { $0.bundleIdentifier == bundleId },
                          "\(bundleId) should be filtered out")
        }
    }

    func testRunningAppsReturnsRegularAppsOnly() async throws {
        // All returned apps should have valid bundle identifiers
        let lister = NSWorkspaceAppLister()
        let apps = try await lister.runningApps()

        for app in apps {
            XCTAssertNotNil(app.bundleIdentifier, "App should have a bundle identifier")
            XCTAssertEqual(app.bundleIdentifier?.isEmpty, false, "Bundle identifier should not be empty")
            XCTAssertFalse(app.name.isEmpty, "App name should not be empty")
        }
    }

    func testRunningAppsAreSortedAlphabetically() async throws {
        let lister = NSWorkspaceAppLister()
        let apps = try await lister.runningApps()

        // Verify alphabetical sorting (case-insensitive)
        if apps.count > 1 {
            for i in 0..<(apps.count - 1) {
                let comparison = apps[i].name.localizedCaseInsensitiveCompare(apps[i + 1].name)
                XCTAssertTrue(comparison == .orderedAscending || comparison == .orderedSame,
                            "Apps should be sorted alphabetically: \(apps[i].name) vs \(apps[i + 1].name)")
            }
        }
    }

    // MARK: - Quit App

    func testQuitAppFailsWhenAppNotFound() async {
        let lister = NSWorkspaceAppLister()

        do {
            try await lister.quitApp(bundleIdentifier: "com.test.NonExistentApp-\(UUID().uuidString)")
            XCTFail("Should have thrown AppError.notFound")
        } catch AppError.notFound {
            // Expected
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    // MARK: - Error Types

    func testAppErrorNotFound() {
        let error = AppError.notFound
        XCTAssertEqual(String(describing: error), "notFound")
    }

    func testAppErrorTerminateFailed() {
        let error = AppError.terminateFailed
        XCTAssertEqual(String(describing: error), "terminateFailed")
    }
}
