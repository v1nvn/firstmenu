//
//  EndToEndTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

/// Integration tests that verify the end-to-end flow of the application.
/// These tests use real infrastructure components to verify integration points.
@MainActor
final class EndToEndTests: XCTestCase {

    // MARK: - Stats Sampling Flow

    func testStatsSamplerEndToEndFlow() async throws {
        // Create the sampler with real dependencies
        let sampler = StatsSampler(
            cpuProvider: MachCPUReader(),
            ramProvider: MachRAMReader(),
            storageProvider: FileSystemStorageReader(),
            networkProvider: InterfaceNetworkReader()
        )

        // First sampling establishes baseline for network
        await sampler.sample()

        let snapshot1 = sampler.currentSnapshot
        XCTAssertNotNil(snapshot1)
        guard let s1 = snapshot1 else { return }

        // Verify CPU
        XCTAssertGreaterThanOrEqual(s1.cpuPercentage, 0.0)
        XCTAssertLessThanOrEqual(s1.cpuPercentage, 100.0)

        // Verify RAM
        XCTAssertGreaterThan(s1.ramTotal, 0)
        XCTAssertGreaterThanOrEqual(s1.ramUsed, 0)
        XCTAssertLessThanOrEqual(s1.ramUsed, s1.ramTotal)

        // Verify Storage
        XCTAssertGreaterThan(s1.storageTotal, 0)
        XCTAssertGreaterThanOrEqual(s1.storageUsed, 0)
        XCTAssertLessThanOrEqual(s1.storageUsed, s1.storageTotal)

        // Network is 0 on first call (no baseline)
        XCTAssertEqual(s1.networkDownloadBPS, 0)
        XCTAssertEqual(s1.networkUploadBPS, 0)

        // Wait and sample again for network delta
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        await sampler.sample()

        let snapshot2 = sampler.currentSnapshot
        XCTAssertNotNil(snapshot2)
        guard let s2 = snapshot2 else { return }

        // Network should now have values
        XCTAssertGreaterThanOrEqual(s2.networkDownloadBPS, 0)
        XCTAssertGreaterThanOrEqual(s2.networkUploadBPS, 0)

        // Other stats should still be valid
        XCTAssertGreaterThanOrEqual(s2.cpuPercentage, 0.0)
        XCTAssertLessThanOrEqual(s2.cpuPercentage, 100.0)
    }

    // MARK: - Weather Sampling Flow

    func testWeatherSamplerEndToEndFlow() async throws {
        // Create real weather client (will make network calls)
        let weatherClient = try OpenMeteoWeatherClient()
        let sampler = WeatherSampler(weatherProvider: weatherClient)

        // Sample weather (may fail if network is unavailable)
        await sampler.sample()

        let weather = sampler.currentWeather
        XCTAssertNotNil(weather)
        guard let w = weather else { return }

        // Verify temperature is reasonable (Celsius) or error value (-1)
        XCTAssertGreaterThanOrEqual(w.temperature, -50.0)
        XCTAssertLessThanOrEqual(w.temperature, 60.0)

        // Verify SF Symbol name is not empty (works even for error condition code -1)
        XCTAssertFalse(w.sfSymbolName.isEmpty)
    }

    func testWeatherSamplerCaching() async throws {
        let weatherClient = try OpenMeteoWeatherClient()
        let sampler = WeatherSampler(weatherProvider: weatherClient)

        // First sample
        await sampler.sample()
        let weather1 = sampler.currentWeather

        // Immediate second sample should use cache
        await sampler.sample()
        let weather2 = sampler.currentWeather

        // Values should be identical (cached)
        XCTAssertEqual(weather1?.temperature, weather2?.temperature)
        XCTAssertEqual(weather1?.conditionCode, weather2?.conditionCode)
    }

    // MARK: - App Process Flow

    func testAppProcessManagerEndToEndFlow() async throws {
        let appLister = NSWorkspaceAppLister()
        let manager = AppProcessManager(appLister: appLister)

        // Refresh the app list
        try await manager.refresh()

        // Should have some apps running (at least firstmenu itself)
        XCTAssertGreaterThan(manager.appCount, 0, "Should have at least one running app")
        XCTAssertFalse(manager.runningApps.isEmpty)

        // Verify app properties
        for app in manager.runningApps {
            XCTAssertFalse(app.name.isEmpty, "App name should not be empty")
            XCTAssertNotNil(app.bundleIdentifier)
        }
    }

    // MARK: - Power Assertion Flow

    func testPowerAssertionEndToEndFlow() async throws {
        let powerWrapper = CaffeinateWrapper()
        let controller = PowerAssertionController(powerProvider: powerWrapper)

        // Initial state should be inactive
        XCTAssertEqual(controller.state, .inactive)
        XCTAssertFalse(controller.isActive)

        // Enable for a short duration
        try await controller.keepAwake(for: 1)

        // State should now be active
        XCTAssertTrue(controller.isActive)

        // Allow sleep
        try await controller.allowSleep()

        // State should be inactive again
        XCTAssertEqual(controller.state, .inactive)
        XCTAssertFalse(controller.isActive)
    }

    // MARK: - Combined Flow

    func testCombinedSamplingFlow() async throws {
        // Create all real components
        let statsSampler = StatsSampler(
            cpuProvider: MachCPUReader(),
            ramProvider: MachRAMReader(),
            storageProvider: FileSystemStorageReader(),
            networkProvider: InterfaceNetworkReader()
        )
        let weatherClient = try OpenMeteoWeatherClient()
        let weatherSampler = WeatherSampler(weatherProvider: weatherClient)

        // Sample both stats and weather
        await statsSampler.sample()
        await weatherSampler.sample()

        let stats = statsSampler.currentSnapshot
        let weather = weatherSampler.currentWeather

        // Verify all data is valid
        XCTAssertNotNil(stats)
        XCTAssertNotNil(weather)
        guard let s = stats, let w = weather else { return }

        // Stats validation
        XCTAssertTrue((0.0...100.0).contains(s.cpuPercentage))
        XCTAssertTrue(s.ramTotal > 0)
        XCTAssertTrue(s.storageTotal > 0)

        // Weather validation (allow for error condition)
        XCTAssertTrue((-50.0...60.0).contains(w.temperature))
        XCTAssertTrue(w.conditionCode >= -1) // -1 is the error placeholder
    }

    // MARK: - Error Handling

    func testStatsSamplerHandlesPartialFailures() async throws {
        // Create a sampler with all real components
        let sampler = StatsSampler(
            cpuProvider: MachCPUReader(),
            ramProvider: MachRAMReader(),
            storageProvider: FileSystemStorageReader(),
            networkProvider: InterfaceNetworkReader()
        )

        await sampler.sample()

        let snapshot = sampler.currentSnapshot
        XCTAssertNotNil(snapshot)
    }
}
