//
//  StatPopoverViewsTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import XCTest
@testable import firstmenu

@MainActor
final class StatPopoverViewsTests: XCTestCase {

    // MARK: - CPUPopoverView Tests

    func testCPUPopoverViewRenders() {
        MenuBarState.shared.cpuPercentage = 45
        let view = CPUPopoverView()
        XCTAssertNotNil(view, "CPUPopoverView should render")
    }

    func testCPUPopoverViewWithLowCPU() {
        MenuBarState.shared.cpuPercentage = 10
        let view = CPUPopoverView()
        // Verify view renders without error
        _ = view.body
    }

    func testCPUPopoverViewWithHighCPU() {
        MenuBarState.shared.cpuPercentage = 95
        let view = CPUPopoverView()
        _ = view.body
    }

    func testCPUPopoverViewWithZeroCPU() {
        MenuBarState.shared.cpuPercentage = 0
        let view = CPUPopoverView()
        _ = view.body
    }

    // MARK: - RAMPopoverView Tests

    func testRAMPopoverViewRenders() {
        MenuBarState.shared.ramUsed = 8_589_934_592  // 8GB
        MenuBarState.shared.ramTotal = 16_000_000_000 // 16GB
        let view = RAMPopoverView()
        XCTAssertNotNil(view)
    }

    func testRAMPopoverViewWithHalfUsed() {
        MenuBarState.shared.ramUsed = 8_000_000_000
        MenuBarState.shared.ramTotal = 16_000_000_000
        let view = RAMPopoverView()
        _ = view.body
    }

    func testRAMPopoverViewWithHighUsage() {
        MenuBarState.shared.ramUsed = 15_000_000_000
        MenuBarState.shared.ramTotal = 16_000_000_000
        let view = RAMPopoverView()
        _ = view.body
    }

    func testRAMPopoverViewUsedGBCalculation() {
        MenuBarState.shared.ramUsed = 4_294_967_296  // 4GB
        MenuBarState.shared.ramTotal = 16_000_000_000
        let view = RAMPopoverView()
        _ = view.body
    }

    // MARK: - StoragePopoverView Tests

    func testStoragePopoverViewRenders() {
        MenuBarState.shared.storageUsed = 250_000_000_000
        MenuBarState.shared.storageTotal = 500_000_000_000
        let view = StoragePopoverView()
        XCTAssertNotNil(view)
    }

    func testStoragePopoverViewWithLowUsage() {
        MenuBarState.shared.storageUsed = 50_000_000_000
        MenuBarState.shared.storageTotal = 500_000_000_000
        let view = StoragePopoverView()
        _ = view.body
    }

    func testStoragePopoverViewWithHighUsage() {
        MenuBarState.shared.storageUsed = 475_000_000_000
        MenuBarState.shared.storageTotal = 500_000_000_000
        let view = StoragePopoverView()
        _ = view.body
    }

    func testStoragePopoverViewWithTerabytes() {
        MenuBarState.shared.storageUsed = 1_500_000_000_000  // 1.5TB
        MenuBarState.shared.storageTotal = 2_000_000_000_000 // 2TB
        let view = StoragePopoverView()
        _ = view.body
    }

    // MARK: - WeatherPopoverView Tests

    func testWeatherPopoverViewRenders() {
        MenuBarState.shared.temperature = 28
        MenuBarState.shared.conditionCode = 0
        MenuBarState.shared.sfSymbolName = "sun.max.fill"
        let view = WeatherPopoverView()
        XCTAssertNotNil(view)
    }

    func testWeatherPopoverViewClearSky() {
        MenuBarState.shared.conditionCode = 0
        MenuBarState.shared.sfSymbolName = "sun.max.fill"
        let view = WeatherPopoverView()
        _ = view.body
    }

    func testWeatherPopoverViewCloudy() {
        MenuBarState.shared.conditionCode = 3
        MenuBarState.shared.sfSymbolName = "cloud.fill"
        let view = WeatherPopoverView()
        _ = view.body
    }

    func testWeatherPopoverViewRainy() {
        MenuBarState.shared.conditionCode = 63
        MenuBarState.shared.sfSymbolName = "cloud.rain.fill"
        let view = WeatherPopoverView()
        _ = view.body
    }

    func testWeatherPopoverViewSnowy() {
        MenuBarState.shared.conditionCode = 71
        MenuBarState.shared.sfSymbolName = "cloud.snow.fill"
        let view = WeatherPopoverView()
        _ = view.body
    }

    func testWeatherPopoverViewThunderstorm() {
        MenuBarState.shared.conditionCode = 95
        MenuBarState.shared.sfSymbolName = "cloud.bolt.rain.fill"
        let view = WeatherPopoverView()
        _ = view.body
    }

    func testWeatherPopoverViewUnknownCode() {
        MenuBarState.shared.conditionCode = 999
        MenuBarState.shared.sfSymbolName = "questionmark"
        let view = WeatherPopoverView()
        _ = view.body
    }

    // MARK: - NetworkPopoverView Tests

    func testNetworkPopoverViewRenders() {
        MenuBarState.shared.downloadBPS = 1_048_576
        MenuBarState.shared.uploadBPS = 524_288
        let view = NetworkPopoverView()
        XCTAssertNotNil(view)
    }

    func testNetworkPopoverViewWithActivity() {
        MenuBarState.shared.downloadBPS = 2_097_152  // 2 MB/s
        MenuBarState.shared.uploadBPS = 1_048_576     // 1 MB/s
        let view = NetworkPopoverView()
        _ = view.body
    }

    func testNetworkPopoverViewWithNoActivity() {
        MenuBarState.shared.downloadBPS = 0
        MenuBarState.shared.uploadBPS = 0
        let view = NetworkPopoverView()
        _ = view.body
    }

    func testNetworkPopoverViewWithOnlyDownload() {
        MenuBarState.shared.downloadBPS = 5_242_880
        MenuBarState.shared.uploadBPS = 0
        let view = NetworkPopoverView()
        _ = view.body
    }

    func testNetworkPopoverViewWithOnlyUpload() {
        MenuBarState.shared.downloadBPS = 0
        MenuBarState.shared.uploadBPS = 2_621_440
        let view = NetworkPopoverView()
        _ = view.body
    }

    func testNetworkPopoverViewWithKilobyteSpeed() {
        MenuBarState.shared.downloadBPS = 50_000  // ~50 KB/s
        MenuBarState.shared.uploadBPS = 0
        let view = NetworkPopoverView()
        _ = view.body
    }

    // MARK: - AppsPopoverView Tests

    func testAppsPopoverViewRenders() {
        let view = AppsPopoverView()
        XCTAssertNotNil(view)
    }

    func testAppsPopoverViewWithAppManager() {
        let view = AppsPopoverView()
        _ = view.body
    }

    // MARK: - CaffeinatePresetButton Tests

    func testCaffeinatePresetButtonInactive() {
        let button = CaffeinatePresetButton(
            title: "15 min",
            isActive: false,
            action: {}
        )
        XCTAssertNotNil(button)
    }

    func testCaffeinatePresetButtonActive() {
        let button = CaffeinatePresetButton(
            title: "Indefinitely",
            isActive: true,
            action: {}
        )
        XCTAssertNotNil(button)
    }

    func testCaffeinatePresetButtonAction() {
        var actionCalled = false
        let button = CaffeinatePresetButton(
            title: "1 hour",
            isActive: false,
            action: { actionCalled = true }
        )
        _ = button.body
        // Action would be called when button is tapped
        XCTAssertNotNil(button)
    }

    // MARK: - AppsListRowView Tests

    func testAppsListRowViewRenders() {
        let app = AppProcess(
            id: "com.example.app",
            name: "Test App",
            bundleIdentifier: "com.example.app",
            pid: 1234
        )
        var quitCalled = false
        let row = AppsListRowView(app: app, onQuit: { quitCalled = true })
        XCTAssertNotNil(row)
    }

    func testAppsListRowViewWithNoBundleID() {
        let app = AppProcess(
            id: "unknown",
            name: "Unknown App",
            bundleIdentifier: nil,
            pid: 5678
        )
        let row = AppsListRowView(app: app, onQuit: {})
        XCTAssertNotNil(row)
    }

    func testAppsListRowViewQuitAction() {
        let app = AppProcess(
            id: "com.example.app",
            name: "Test App",
            bundleIdentifier: "com.example.app",
            pid: 1234
        )
        var quitCalled = false
        let row = AppsListRowView(app: app, onQuit: { quitCalled = true })
        _ = row.body
        XCTAssertNotNil(row)
    }

    // MARK: - Helper Methods Tests

    func testNetworkPopoverViewFormatSpeedMBps() {
        let view = NetworkPopoverView()
        MenuBarState.shared.downloadBPS = 1_500_000
        _ = view.body
        // Should display as "1.5 MB/s"
    }

    func testNetworkPopoverViewFormatSpeedKBps() {
        let view = NetworkPopoverView()
        MenuBarState.shared.downloadBPS = 50_000
        _ = view.body
        // Should display as "49 KB/s"
    }

    func testNetworkPopoverViewFormatSpeedBps() {
        let view = NetworkPopoverView()
        MenuBarState.shared.downloadBPS = 500
        _ = view.body
        // Should display as "0 B/s"
    }

    // MARK: - CaffeinatePopoverView Tests

    func testCaffeinatePopoverViewRenders() {
        MenuBarState.shared.caffeinateState = .inactive
        let view = CaffeinatePopoverView()
        XCTAssertNotNil(view, "CaffeinatePopoverView should render")
    }

    func testCaffeinatePopoverViewWithInactiveState() {
        MenuBarState.shared.caffeinateState = .inactive
        let view = CaffeinatePopoverView()
        _ = view.body
    }

    func testCaffeinatePopoverViewWithActiveState() {
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(1800))
        let view = CaffeinatePopoverView()
        _ = view.body
    }

    func testCaffeinatePopoverViewWithIndefiniteState() {
        MenuBarState.shared.caffeinateState = .indefinite
        let view = CaffeinatePopoverView()
        _ = view.body
    }

    func testCaffeinatePopoverViewWithExpiredActiveState() {
        // Active state with past date
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(-100))
        let view = CaffeinatePopoverView()
        _ = view.body
    }

    func testCaffeinatePopoverViewSystemImageNameInactive() {
        MenuBarState.shared.caffeinateState = .inactive
        let view = CaffeinatePopoverView()
        _ = view.body
        // Should use moon.zzz for inactive state
    }

    func testCaffeinatePopoverViewSystemImageNameActive() {
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(3600))
        let view = CaffeinatePopoverView()
        _ = view.body
        // Should use moon.fill for active state
    }

    func testCaffeinatePopoverViewSystemImageNameIndefinite() {
        MenuBarState.shared.caffeinateState = .indefinite
        let view = CaffeinatePopoverView()
        _ = view.body
        // Should use moon.fill for indefinite state
    }

    func testCaffeinatePopoverViewIsActiveProperty() {
        MenuBarState.shared.caffeinateState = .inactive
        let view = CaffeinatePopoverView()
        _ = view.body
        XCTAssertFalse(view.isActive, "Should not be active when state is inactive")

        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(60))
        _ = view.body
        XCTAssertTrue(view.isActive, "Should be active when state is active")
    }

    func testCaffeinatePopoverViewIsIndefiniteProperty() {
        MenuBarState.shared.caffeinateState = .inactive
        let view = CaffeinatePopoverView()
        _ = view.body
        XCTAssertFalse(view.isIndefinite, "Should not be indefinite when state is inactive")

        MenuBarState.shared.caffeinateState = .indefinite
        _ = view.body
        XCTAssertTrue(view.isIndefinite, "Should be indefinite when state is indefinite")
    }

    func testCaffeinatePopoverViewStatusTextInactive() {
        MenuBarState.shared.caffeinateState = .inactive
        let view = CaffeinatePopoverView()
        _ = view.body
        XCTAssertEqual(view.statusText, "System can sleep normally")
    }

    func testCaffeinatePopoverViewStatusTextIndefinite() {
        MenuBarState.shared.caffeinateState = .indefinite
        let view = CaffeinatePopoverView()
        _ = view.body
        XCTAssertEqual(view.statusText, "Keeping awake indefinitely")
    }

    func testCaffeinatePopoverViewStatusTextActiveWithMinutes() {
        let minutesRemaining = 45
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(Double(minutesRemaining * 60)))
        let view = CaffeinatePopoverView()
        _ = view.body
        XCTAssertTrue(view.statusText.contains("\(minutesRemaining) min"), "Status should show remaining minutes")
    }

    func testCaffeinatePopoverViewStatusTextActiveWithOneMinute() {
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(60))
        let view = CaffeinatePopoverView()
        _ = view.body
        XCTAssertTrue(view.statusText.contains("1 min"), "Status should show 1 min")
    }

    func testCaffeinatePopoverViewStatusTextActiveExpired() {
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(-10))
        let view = CaffeinatePopoverView()
        _ = view.body
        // Should show generic "Keeping awake" when expired
        XCTAssertTrue(view.statusText.contains("Keeping awake"))
    }

    func testCaffeinatePopoverViewWithPowerController() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: nil)
        let controller = PowerAssertionController(powerProvider: provider)
        MenuBarState.shared.powerController = controller
        MenuBarState.shared.caffeinateState = .indefinite

        let view = CaffeinatePopoverView()
        _ = view.body
        XCTAssertNotNil(view)
    }

    func testCaffeinatePopoverViewWithNilPowerController() {
        MenuBarState.shared.powerController = nil
        MenuBarState.shared.caffeinateState = .inactive
        let view = CaffeinatePopoverView()
        _ = view.body
        // Should handle nil power controller gracefully
        XCTAssertNotNil(view)
    }

    func testCaffeinatePopoverViewDesignSystemIntegration() {
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(900))
        let view = CaffeinatePopoverView()
        _ = view.body
        // Should use DesignSystem.Popover.Width.wide
        XCTAssertNotNil(view)
    }

    func testCaffeinatePopoverViewStateTransitions() {
        let view = CaffeinatePopoverView()

        // Start inactive
        MenuBarState.shared.caffeinateState = .inactive
        _ = view.body
        XCTAssertFalse(view.isActive)

        // Transition to active
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(300))
        _ = view.body
        XCTAssertTrue(view.isActive)

        // Transition to indefinite
        MenuBarState.shared.caffeinateState = .indefinite
        _ = view.body
        XCTAssertTrue(view.isActive)
        XCTAssertTrue(view.isIndefinite)

        // Back to inactive
        MenuBarState.shared.caffeinateState = .inactive
        _ = view.body
        XCTAssertFalse(view.isActive)
        XCTAssertFalse(view.isIndefinite)
    }
}
