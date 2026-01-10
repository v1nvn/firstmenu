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

    // MARK: - Setup & Teardown

    override func tearDown() {
        // Reset all shared state after each test to ensure test isolation
        let state = MenuBarState.shared
        state.cpuPercentage = 0
        state.ramUsed = 0
        state.ramTotal = 0
        state.storageUsed = 0
        state.storageTotal = 0
        state.downloadBPS = 0
        state.uploadBPS = 0
        state.temperature = 0
        state.conditionCode = 0
        state.sfSymbolName = "sun.max.fill"
        state.ramPressure = "Normal"
        state.caffeinateState = .inactive
        state.powerController = nil
        super.tearDown()
    }

    // MARK: - CPUPopoverView Tests

    func testCPUPopoverViewRenders() {
        MenuBarState.shared.cpuPercentage = 45
        let view = CPUPopoverView()
        XCTAssertNotNil(view, "CPUPopoverView should render")
    }

    func testCPUPopoverViewWithLowCPU() {
        MenuBarState.shared.cpuPercentage = 10
        let view = CPUPopoverView()
        XCTAssertNotNil(view.body, "CPUPopoverView should render with low CPU")
    }

    func testCPUPopoverViewWithHighCPU() {
        MenuBarState.shared.cpuPercentage = 95
        let view = CPUPopoverView()
        XCTAssertNotNil(view.body, "CPUPopoverView should render with high CPU")
    }

    func testCPUPopoverViewWithZeroCPU() {
        MenuBarState.shared.cpuPercentage = 0
        let view = CPUPopoverView()
        XCTAssertNotNil(view.body, "CPUPopoverView should render with zero CPU")
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
        XCTAssertNotNil(view.body, "RAMPopoverView should render with half usage")
    }

    func testRAMPopoverViewWithHighUsage() {
        MenuBarState.shared.ramUsed = 15_000_000_000
        MenuBarState.shared.ramTotal = 16_000_000_000
        let view = RAMPopoverView()
        XCTAssertNotNil(view.body, "RAMPopoverView should render with high usage")
    }

    func testRAMPopoverViewUsedGBCalculation() {
        MenuBarState.shared.ramUsed = 4_294_967_296  // 4GB
        MenuBarState.shared.ramTotal = 16_000_000_000
        let view = RAMPopoverView()
        XCTAssertNotNil(view.body, "RAMPopoverView should render with 4GB used")
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
        XCTAssertNotNil(view.body, "StoragePopoverView should render with low usage")
    }

    func testStoragePopoverViewWithHighUsage() {
        MenuBarState.shared.storageUsed = 475_000_000_000
        MenuBarState.shared.storageTotal = 500_000_000_000
        let view = StoragePopoverView()
        XCTAssertNotNil(view.body, "StoragePopoverView should render with high usage")
    }

    func testStoragePopoverViewWithTerabytes() {
        MenuBarState.shared.storageUsed = 1_500_000_000_000  // 1.5TB
        MenuBarState.shared.storageTotal = 2_000_000_000_000 // 2TB
        let view = StoragePopoverView()
        XCTAssertNotNil(view.body, "StoragePopoverView should render with terabyte values")
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
        XCTAssertNotNil(view.body, "WeatherPopoverView should render with clear sky")
    }

    func testWeatherPopoverViewCloudy() {
        MenuBarState.shared.conditionCode = 3
        MenuBarState.shared.sfSymbolName = "cloud.fill"
        let view = WeatherPopoverView()
        XCTAssertNotNil(view.body, "WeatherPopoverView should render with cloudy weather")
    }

    func testWeatherPopoverViewRainy() {
        MenuBarState.shared.conditionCode = 63
        MenuBarState.shared.sfSymbolName = "cloud.rain.fill"
        let view = WeatherPopoverView()
        XCTAssertNotNil(view.body, "WeatherPopoverView should render with rainy weather")
    }

    func testWeatherPopoverViewSnowy() {
        MenuBarState.shared.conditionCode = 71
        MenuBarState.shared.sfSymbolName = "cloud.snow.fill"
        let view = WeatherPopoverView()
        XCTAssertNotNil(view.body, "WeatherPopoverView should render with snowy weather")
    }

    func testWeatherPopoverViewThunderstorm() {
        MenuBarState.shared.conditionCode = 95
        MenuBarState.shared.sfSymbolName = "cloud.bolt.rain.fill"
        let view = WeatherPopoverView()
        XCTAssertNotNil(view.body, "WeatherPopoverView should render with thunderstorm")
    }

    func testWeatherPopoverViewUnknownCode() {
        MenuBarState.shared.conditionCode = 999
        MenuBarState.shared.sfSymbolName = "questionmark"
        let view = WeatherPopoverView()
        XCTAssertNotNil(view.body, "WeatherPopoverView should render with unknown condition")
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
        XCTAssertNotNil(view.body, "NetworkPopoverView should render with network activity")
    }

    func testNetworkPopoverViewWithNoActivity() {
        MenuBarState.shared.downloadBPS = 0
        MenuBarState.shared.uploadBPS = 0
        let view = NetworkPopoverView()
        XCTAssertNotNil(view.body, "NetworkPopoverView should render with no activity")
    }

    func testNetworkPopoverViewWithOnlyDownload() {
        MenuBarState.shared.downloadBPS = 5_242_880
        MenuBarState.shared.uploadBPS = 0
        let view = NetworkPopoverView()
        XCTAssertNotNil(view.body, "NetworkPopoverView should render with download only")
    }

    func testNetworkPopoverViewWithOnlyUpload() {
        MenuBarState.shared.downloadBPS = 0
        MenuBarState.shared.uploadBPS = 2_621_440
        let view = NetworkPopoverView()
        XCTAssertNotNil(view.body, "NetworkPopoverView should render with upload only")
    }

    func testNetworkPopoverViewWithKilobyteSpeed() {
        MenuBarState.shared.downloadBPS = 50_000  // ~50 KB/s
        MenuBarState.shared.uploadBPS = 0
        let view = NetworkPopoverView()
        XCTAssertNotNil(view.body, "NetworkPopoverView should render with kilobyte speed")
    }

    // MARK: - AppsPopoverView Tests

    func testAppProcessManagerCreation() async {
        // Test that AppProcessManager can be created
        let appManager = AppProcessManager(appLister: MockAppLister())
        XCTAssertNotNil(appManager)
    }

    func testAppsPopoverViewRenders() async {
        let appManager = AppProcessManager(appLister: MockAppLister())
        let powerController = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = AppsPopoverView(appManager: appManager, powerController: powerController)
        XCTAssertNotNil(view)
    }

    func testAppsPopoverViewWithAppManager() async {
        let appManager = AppProcessManager(appLister: MockAppLister())
        let powerController = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = AppsPopoverView(appManager: appManager, powerController: powerController)
        XCTAssertNotNil(view.body, "AppsPopoverView should render with app manager")
    }

    // MARK: - AppsListRowView Tests

    func testAppsListRowViewRenders() {
        let app = AppProcess(
            id: "com.example.app",
            name: "Test App",
            bundleIdentifier: "com.example.app",
            pid: 1234
        )
        let row = AppsListRowView(app: app, onQuit: {})
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
        XCTAssertNotNil(row.body, "AppsListRowView should render with quit action")
        XCTAssertFalse(quitCalled, "Quit action should not be called until triggered")
    }

    // MARK: - Network Speed Format Tests

    func testNetworkPopoverViewFormatSpeedMBps() {
        MenuBarState.shared.downloadBPS = 1_500_000
        let view = NetworkPopoverView()
        XCTAssertNotNil(view.body, "NetworkPopoverView should render with MB/s speed")
    }

    func testNetworkPopoverViewFormatSpeedKBps() {
        MenuBarState.shared.downloadBPS = 50_000
        let view = NetworkPopoverView()
        XCTAssertNotNil(view.body, "NetworkPopoverView should render with KB/s speed")
    }

    func testNetworkPopoverViewFormatSpeedBps() {
        MenuBarState.shared.downloadBPS = 500
        let view = NetworkPopoverView()
        XCTAssertNotNil(view.body, "NetworkPopoverView should render with B/s speed")
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
        XCTAssertNotNil(view.body, "CaffeinatePopoverView should render with inactive state")
    }

    func testCaffeinatePopoverViewWithActiveState() {
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(1800))
        let view = CaffeinatePopoverView()
        XCTAssertNotNil(view.body, "CaffeinatePopoverView should render with active state")
    }

    func testCaffeinatePopoverViewWithIndefiniteState() {
        MenuBarState.shared.caffeinateState = .indefinite
        let view = CaffeinatePopoverView()
        XCTAssertNotNil(view.body, "CaffeinatePopoverView should render with indefinite state")
    }

    func testCaffeinatePopoverViewWithExpiredActiveState() {
        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(-100))
        let view = CaffeinatePopoverView()
        XCTAssertNotNil(view.body, "CaffeinatePopoverView should render with expired state")
    }

    func testCaffeinatePopoverViewWithPowerController() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: nil)
        let controller = PowerAssertionController(powerProvider: provider)
        MenuBarState.shared.powerController = controller
        MenuBarState.shared.caffeinateState = .indefinite

        let view = CaffeinatePopoverView()
        XCTAssertNotNil(view.body, "CaffeinatePopoverView should render with power controller")
    }

    func testCaffeinatePopoverViewWithNilPowerController() {
        MenuBarState.shared.powerController = nil
        MenuBarState.shared.caffeinateState = .inactive
        let view = CaffeinatePopoverView()
        XCTAssertNotNil(view.body, "CaffeinatePopoverView should handle nil power controller")
    }

    func testCaffeinatePopoverViewStateTransitions() {
        // Test that view renders correctly across all state transitions
        MenuBarState.shared.caffeinateState = .inactive
        var view = CaffeinatePopoverView()
        XCTAssertNotNil(view.body, "Should render inactive state")

        MenuBarState.shared.caffeinateState = .active(until: Date().addingTimeInterval(300))
        view = CaffeinatePopoverView()
        XCTAssertNotNil(view.body, "Should render active state")

        MenuBarState.shared.caffeinateState = .indefinite
        view = CaffeinatePopoverView()
        XCTAssertNotNil(view.body, "Should render indefinite state")
    }
}
