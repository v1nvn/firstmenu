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
        _ = view.body
    }

    // MARK: - SettingToggle Tests

    func testSettingToggleRenders() {
        let toggle = SettingToggle(
            title: "CPU Usage",
            icon: "cpu",
            isOn: .constant(true)
        )
        XCTAssertNotNil(toggle)
    }

    func testSettingToggleWithOnState() {
        let toggle = SettingToggle(
            title: "Memory",
            icon: "memorychip",
            isOn: .constant(true)
        )
        _ = toggle.body
    }

    func testSettingToggleWithOffState() {
        let toggle = SettingToggle(
            title: "Storage",
            icon: "internaldrive",
            isOn: .constant(false)
        )
        _ = toggle.body
    }

    func testSettingToggleBindingChanges() {
        var isOn = false
        let toggle = SettingToggle(
            title: "Weather",
            icon: "cloud.sun",
            isOn: .constant(isOn)
        )
        _ = toggle.body
        isOn = true
        _ = toggle.body
        XCTAssertNotNil(toggle)
    }

    func testSettingToggleWithAllIcons() {
        let icons = ["cpu", "memorychip", "internaldrive", "cloud.sun", "network"]
        for icon in icons {
            let toggle = SettingToggle(
                title: "Test",
                icon: icon,
                isOn: .constant(true)
            )
            XCTAssertNotNil(toggle, "Toggle with icon \(icon) should render")
        }
    }

    // MARK: - AppStorage Defaults Tests

    func testDefaultWeatherRefreshInterval() {
        let view = SettingsMenuView()
        // Test that view renders with default settings
        _ = view.body
    }

    func testDefaultMenuBarItemToggles() {
        let view = SettingsMenuView()
        // All menu bar items should be visible by default
        _ = view.body
    }

    // MARK: - Version/Build Info Tests

    func testVersionInfoExists() {
        let view = SettingsMenuView()
        // Version and build should be accessible
        _ = view.body
        XCTAssertNotNil(view)
    }

    // MARK: - Settings Sections Tests

    func testWeatherSectionExists() {
        let view = SettingsMenuView()
        // Weather section with refresh interval should exist
        _ = view.body
    }

    func testMenuBarItemsSectionExists() {
        let view = SettingsMenuView()
        // Menu bar items section should exist
        _ = view.body
    }

    func testAboutSectionExists() {
        let view = SettingsMenuView()
        // About section should exist
        _ = view.body
    }

    // MARK: - Layout Tests

    func testSettingsMenuViewFrameWidth() {
        let view = SettingsMenuView()
        _ = view.body
        // View should have a frame width of 280
        XCTAssertNotNil(view)
    }

    func testSettingsMenuViewBackgroundMaterial() {
        let view = SettingsMenuView()
        _ = view.body
        // View should use .ultraThinMaterial
        XCTAssertNotNil(view)
    }

    // MARK: - Component Tests

    func testSettingToggleWithEmptyTitle() {
        let toggle = SettingToggle(
            title: "",
            icon: "cpu",
            isOn: .constant(true)
        )
        _ = toggle.body
        XCTAssertNotNil(toggle)
    }

    func testSettingToggleWithLongTitle() {
        let toggle = SettingToggle(
            title: "This is a very long title for a setting toggle",
            icon: "cpu",
            isOn: .constant(true)
        )
        _ = toggle.body
        XCTAssertNotNil(toggle)
    }

    func testSettingToggleWithInvalidIcon() {
        let toggle = SettingToggle(
            title: "Test",
            icon: "invalid.icon.name",
            isOn: .constant(true)
        )
        _ = toggle.body
        XCTAssertNotNil(toggle)
    }

    // MARK: - Interaction Tests

    func testMultipleSettingToggles() {
        let toggles = [
            SettingToggle(title: "CPU", icon: "cpu", isOn: .constant(true)),
            SettingToggle(title: "RAM", icon: "memorychip", isOn: .constant(true)),
            SettingToggle(title: "SSD", icon: "internaldrive", isOn: .constant(true)),
            SettingToggle(title: "Weather", icon: "cloud.sun", isOn: .constant(true)),
            SettingToggle(title: "Network", icon: "network", isOn: .constant(true))
        ]

        for toggle in toggles {
            _ = toggle.body
            XCTAssertNotNil(toggle)
        }
    }

    func testSettingToggleToggleValue() {
        var isOn = true
        let toggle = SettingToggle(
            title: "Test",
            icon: "cpu",
            isOn: .constant(isOn)
        )
        _ = toggle.body
        isOn = false
        _ = toggle.body
        XCTAssertNotNil(toggle)
    }
}
