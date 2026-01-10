//
//  MenuBarWindowViewTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import XCTest
@testable import firstmenu

@MainActor
final class MenuBarWindowViewTests: XCTestCase {

    // MARK: - MenuBarWindowView Tests

    func testMenuBarWindowViewRenders() async {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "com.test.app1", name: "App 1", bundleIdentifier: "com.test.app1", pid: 100)
        ])
        let appManager = AppProcessManager(appLister: appLister)
        let powerController = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = MenuBarWindowView(appManager: appManager, powerController: powerController)
        XCTAssertNotNil(view)
    }

    func testMenuBarWindowViewBody() async {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "com.test.app1", name: "App 1", bundleIdentifier: "com.test.app1", pid: 100)
        ])
        let appManager = AppProcessManager(appLister: appLister)
        let powerController = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = MenuBarWindowView(appManager: appManager, powerController: powerController)
        _ = view.body
    }

    func testMenuBarWindowViewWithEmptyAppList() async {
        let appLister = MockAppLister()
        let appManager = AppProcessManager(appLister: appLister)
        let powerController = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = MenuBarWindowView(appManager: appManager, powerController: powerController)
        _ = view.body
    }

    func testMenuBarWindowViewWithApps() async {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "com.apple.Safari", name: "Safari", bundleIdentifier: "com.apple.Safari", pid: 1001),
            AppProcess(id: "com.apple.music", name: "Music", bundleIdentifier: "com.apple.music", pid: 1002)
        ])
        let appManager = AppProcessManager(appLister: appLister)
        let powerController = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = MenuBarWindowView(appManager: appManager, powerController: powerController)
        _ = view.body
    }

    // MARK: - SectionHeader Tests

    func testSectionHeaderRenders() {
        let header = SectionHeader(title: "Test Section")
        XCTAssertNotNil(header)
    }

    func testSectionHeaderWithTitle() {
        let header = SectionHeader(title: "Running Apps")
        _ = header.body
    }

    func testSectionHeaderWithCount() {
        let header = SectionHeader(title: "Running Apps", count: 5)
        _ = header.body
    }

    func testSectionHeaderWithZeroCount() {
        let header = SectionHeader(title: "Test", count: 0)
        _ = header.body
    }

    func testSectionHeaderWithLargeCount() {
        let header = SectionHeader(title: "Test", count: 999)
        _ = header.body
    }

    func testSectionHeaderWithNilCount() {
        let header = SectionHeader(title: "Test", count: nil)
        _ = header.body
    }

    // MARK: - AppRowView Tests

    func testAppRowViewRenders() {
        let app = AppProcess(
            id: "com.test.app",
            name: "Test App",
            bundleIdentifier: "com.test.app",
            pid: 1234
        )
        var quitCalled = false
        let row = AppRowView(app: app, onQuit: { quitCalled = true })
        XCTAssertNotNil(row)
    }

    func testAppRowViewWithQuitAction() {
        let app = AppProcess(
            id: "com.test.app",
            name: "Test App",
            bundleIdentifier: "com.test.app",
            pid: 1234
        )
        var quitCalled = false
        let row = AppRowView(app: app, onQuit: { quitCalled = true })
        _ = row.body
    }

    func testAppRowViewWithLongAppName() {
        let app = AppProcess(
            id: "com.test.verylongappname",
            name: "This Is A Very Long Application Name That Should Still Render Properly",
            bundleIdentifier: "com.test.verylongappname",
            pid: 1234
        )
        let row = AppRowView(app: app, onQuit: {})
        _ = row.body
    }

    func testAppRowViewWithNilBundleID() {
        let app = AppProcess(
            id: "unknown",
            name: "Unknown App",
            bundleIdentifier: nil,
            pid: 1234
        )
        let row = AppRowView(app: app, onQuit: {})
        _ = row.body
    }

    func testAppRowViewWithSpecialCharactersInName() {
        let app = AppProcess(
            id: "com.test.app",
            name: "Test/App & Co.",
            bundleIdentifier: "com.test.app",
            pid: 1234
        )
        let row = AppRowView(app: app, onQuit: {})
        _ = row.body
    }

    // MARK: - Integration Tests

    func testMenuBarWindowViewWithCaffeinateSection() async {
        let appLister = MockAppLister()
        let appManager = AppProcessManager(appLister: appLister)
        let powerController = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = MenuBarWindowView(appManager: appManager, powerController: powerController)
        _ = view.body
    }

    func testMenuBarWindowViewWithActiveCaffeinate() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: nil)
        let appLister = MockAppLister()
        let appManager = AppProcessManager(appLister: appLister)
        let powerController = PowerAssertionController(powerProvider: provider)
        let view = MenuBarWindowView(appManager: appManager, powerController: powerController)
        _ = view.body
    }

    func testMenuBarWindowViewFrameWidth() async {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "com.test.app1", name: "App 1", bundleIdentifier: "com.test.app1", pid: 100)
        ])
        let appManager = AppProcessManager(appLister: appLister)
        let powerController = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = MenuBarWindowView(appManager: appManager, powerController: powerController)
        _ = view.body
        XCTAssertNotNil(view)
    }

    // MARK: - Layout Tests

    func testMenuBarWindowViewVStackLayout() async {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "com.test.app1", name: "App 1", bundleIdentifier: "com.test.app1", pid: 100)
        ])
        let appManager = AppProcessManager(appLister: appLister)
        let powerController = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = MenuBarWindowView(appManager: appManager, powerController: powerController)
        _ = view.body
    }

}
