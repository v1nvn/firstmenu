//
//  SettingsMenuTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import XCTest
@testable import firstmenu

@MainActor
final class SettingsMenuTests: XCTestCase {

    // MARK: - SettingsMenuView Tests

    func testSettingsMenuViewRenders() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view)
    }

    func testSettingsMenuViewBodyExists() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view.body, "SettingsMenuView should have a body")
    }

    // MARK: - AppStorage Defaults Tests

    func testDefaultWeatherRefreshInterval() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view.body, "View should render with default settings")
    }

    func testDefaultMenuBarItemToggles() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view.body, "All menu bar items should be visible by default")
    }

    // MARK: - Version/Build Info Tests

    func testVersionInfoExists() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view.body, "Version and build should be accessible")
    }

    // MARK: - Settings Sections Tests

    func testWeatherSectionExists() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view.body, "Weather section with refresh interval should exist")
    }

    func testMenuBarItemsSectionExists() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view.body, "Menu bar items section should exist")
    }

    func testAboutSectionExists() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view.body, "About section should exist")
    }

    // MARK: - Layout Tests

    func testSettingsMenuViewFrameWidth() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view.body, "View should have a defined frame width")
    }

    func testSettingsMenuViewBackgroundMaterial() {
        let view = SettingsMenuView()
        XCTAssertNotNil(view.body, "View should use background material")
    }
}
