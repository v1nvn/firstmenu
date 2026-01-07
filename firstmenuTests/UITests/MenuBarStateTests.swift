//
//  MenuBarStateTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import XCTest
@testable import firstmenu

/// Tests for MenuBarState shared state.
@MainActor
final class MenuBarStateTests: XCTestCase {

    // MARK: - Singleton

    func testSharedInstanceExists() {
        let state = MenuBarState.shared
        XCTAssertNotNil(state)
    }

    func testSharedIsSameInstance() {
        let state1 = MenuBarState.shared
        let state2 = MenuBarState.shared
        XCTAssertTrue(state1 === state2, "Shared should return the same instance")
    }

    // MARK: - Initial Values

    func testInitialCPUPercentage() {
        let state = MenuBarState.shared
        XCTAssertEqual(state.cpuPercentage, 0)
    }

    func testInitialRAMValues() {
        let state = MenuBarState.shared
        XCTAssertEqual(state.ramUsed, 0)
        XCTAssertEqual(state.ramTotal, 0)
    }

    func testInitialStorageValues() {
        let state = MenuBarState.shared
        XCTAssertEqual(state.storageUsed, 0)
        XCTAssertEqual(state.storageTotal, 0)
    }

    func testInitialTemperature() {
        let state = MenuBarState.shared
        XCTAssertEqual(state.temperature, 0)
    }

    func testInitialWeatherCondition() {
        let state = MenuBarState.shared
        XCTAssertEqual(state.conditionCode, 0)
        XCTAssertEqual(state.sfSymbolName, "sun.max.fill")
    }

    func testInitialNetworkSpeeds() {
        let state = MenuBarState.shared
        XCTAssertEqual(state.downloadBPS, 0)
        XCTAssertEqual(state.uploadBPS, 0)
    }

    func testInitialCoreCount() {
        let state = MenuBarState.shared
        // coreCount is computed by sysctl, so it should be >= 1
        XCTAssertGreaterThanOrEqual(state.coreCount, 1)
    }

    func testInitialRAMPressure() {
        let state = MenuBarState.shared
        XCTAssertEqual(state.ramPressure, "Normal")
    }

    // MARK: - State Updates

    func testCanUpdateCPUPercentage() {
        let state = MenuBarState.shared
        state.cpuPercentage = 75.5
        XCTAssertEqual(state.cpuPercentage, 75.5)

        // Reset for other tests
        state.cpuPercentage = 0
    }

    func testCanUpdateRAMValues() {
        let state = MenuBarState.shared
        state.ramUsed = 8_000_000_000
        state.ramTotal = 16_000_000_000
        XCTAssertEqual(state.ramUsed, 8_000_000_000)
        XCTAssertEqual(state.ramTotal, 16_000_000_000)

        // Reset
        state.ramUsed = 0
        state.ramTotal = 0
    }

    func testCanUpdateStorageValues() {
        let state = MenuBarState.shared
        state.storageUsed = 250_000_000_000
        state.storageTotal = 500_000_000_000
        XCTAssertEqual(state.storageUsed, 250_000_000_000)
        XCTAssertEqual(state.storageTotal, 500_000_000_000)

        // Reset
        state.storageUsed = 0
        state.storageTotal = 0
    }

    func testCanUpdateWeather() {
        let state = MenuBarState.shared
        state.temperature = 28
        state.conditionCode = 1
        state.sfSymbolName = "cloud.sun.fill"
        XCTAssertEqual(state.temperature, 28)
        XCTAssertEqual(state.conditionCode, 1)
        XCTAssertEqual(state.sfSymbolName, "cloud.sun.fill")

        // Reset
        state.temperature = 0
        state.conditionCode = 0
        state.sfSymbolName = "sun.max.fill"
    }

    func testCanUpdateNetworkSpeeds() {
        let state = MenuBarState.shared
        state.downloadBPS = 1_000_000
        state.uploadBPS = 500_000
        XCTAssertEqual(state.downloadBPS, 1_000_000)
        XCTAssertEqual(state.uploadBPS, 500_000)

        // Reset
        state.downloadBPS = 0
        state.uploadBPS = 0
    }

    func testCanUpdateRAMPressure() {
        let state = MenuBarState.shared
        state.ramPressure = "High"
        XCTAssertEqual(state.ramPressure, "High")

        // Reset
        state.ramPressure = "Normal"
    }

    // MARK: - SetSamplers

    func testSetSamplers() async {
        let state = MenuBarState.shared

        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        let statsSampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        let weatherProvider = MockWeatherProvider()
        let weatherSampler = WeatherSampler(weatherProvider: weatherProvider)

        // Should not crash when setting samplers
        await state.setSamplers(stats: statsSampler, weather: weatherSampler)

        // Verify samplers are set (no way to directly access private properties,
        // but we can verify the method completes without error)
        XCTAssertNotNil(state)
    }
}
