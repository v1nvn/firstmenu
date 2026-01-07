//
//  AppDelegateTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 07/01/26.
//

import XCTest
@testable import firstmenu

/// Tests for the app lifecycle and dependency setup.
///
/// Note: These tests focus on the dependency injection and state management
/// aspects. Since MenuBarState is a shared singleton, we document the expected
/// behavior rather than testing the initial state (which can be polluted by other tests).
@MainActor
final class AppDelegateTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Reset state to defaults before each test to avoid pollution
        let state = MenuBarState.shared
        state.cpuPercentage = 0
        state.ramUsed = 0
        state.ramTotal = 0
        state.storageUsed = 0
        state.storageTotal = 0
        state.temperature = 0
        state.conditionCode = 0
        state.downloadBPS = 0
        state.uploadBPS = 0
    }

    // MARK: - Singleton Access

    func testMenuBarStateSharedInstanceExists() {
        let state = MenuBarState.shared
        XCTAssertNotNil(state)
    }

    // MARK: - Core Count Calculation

    func testCoreCountIsPositive() {
        let state = MenuBarState.shared
        XCTAssertGreaterThan(state.coreCount, 0, "Core count should be positive")
    }

    // MARK: - Dependency Setup

    func testSetSamplersDoesNotCrash() async {
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

        // Verify the method completes without error
        XCTAssertNotNil(state)
    }

    func testSetPowerControllerDoesNotCrash() {
        let state = MenuBarState.shared
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)

        // Should not crash when setting power controller
        state.setPowerController(controller)

        XCTAssertNotNil(state.powerController)
    }

    // MARK: - Stats Sampling with Samplers Set

    func testStateUpdatesAfterSampling() async {
        let state = MenuBarState.shared

        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await cpuProvider.setCPUPercentage(65.5)
        await ramProvider.setRAM(used: 10_000_000_000, total: 16_000_000_000)
        await storageProvider.setStorage(used: 300_000_000_000, total: 500_000_000_000)
        await networkProvider.setNetwork(downloadBPS: 5_000_000, uploadBPS: 2_000_000)

        let statsSampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        let weatherProvider = MockWeatherProvider()
        await weatherProvider.setWeather(WeatherSnapshot(temperature: 22, conditionCode: 1))
        let weatherSampler = WeatherSampler(weatherProvider: weatherProvider)

        await state.setSamplers(stats: statsSampler, weather: weatherSampler)

        // Perform a sample to update state
        await statsSampler.sample()
        await weatherSampler.sample()

        // Verify the samplers have the correct data
        var snapshot = await statsSampler.currentSnapshot
        var weather = await weatherSampler.currentWeather

        XCTAssertNotNil(snapshot)
        XCTAssertNotNil(weather)

        if let s = snapshot {
            XCTAssertEqual(s.cpuPercentage, 65.5)
            XCTAssertEqual(s.ramUsed, 10_000_000_000)
            XCTAssertEqual(s.ramTotal, 16_000_000_000)
        }

        if let w = weather {
            XCTAssertEqual(w.temperature, 22)
            XCTAssertEqual(w.conditionCode, 1)
        }
    }

    // MARK: - Power Controller State

    func testPowerControllerInitialState() {
        let state = MenuBarState.shared
        // Initially may be nil until set
        let controller = state.powerController
        if controller != nil {
            XCTAssertEqual(state.caffeinateState, .inactive)
        }
    }

    func testPowerControllerStateReflectsInMenuBarState() async {
        let state = MenuBarState.shared
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)

        state.setPowerController(controller)

        // Initial state should be inactive
        XCTAssertEqual(state.caffeinateState, .inactive)

        // Activate caffeinate
        try? await controller.keepAwake(for: 300)

        // State should be updated
        XCTAssertTrue(controller.isActive)
    }

    // MARK: - Caffeinate State Transitions

    func testCaffeinateStateTransitions() async {
        let state = MenuBarState.shared
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)

        state.setPowerController(controller)

        // Start inactive
        XCTAssertEqual(state.caffeinateState, .inactive)

        // Transition to active
        try? await controller.keepAwake(for: 60)
        XCTAssertTrue(controller.isActive)

        // Transition back to inactive
        try? await controller.allowSleep()
        XCTAssertFalse(controller.isActive)
    }

    // MARK: - Multiple Sampler Updates

    func testMultipleSamplerUpdates() async {
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

        await state.setSamplers(stats: statsSampler, weather: weatherSampler)

        // First sample with initial values
        await cpuProvider.setCPUPercentage(50.0)
        await statsSampler.sample()
        var snapshot = await statsSampler.currentSnapshot
        XCTAssertEqual(snapshot?.cpuPercentage, 50.0)

        // Second sample with updated values
        await cpuProvider.setCPUPercentage(75.0)
        await statsSampler.sample()
        snapshot = await statsSampler.currentSnapshot
        XCTAssertEqual(snapshot?.cpuPercentage, 75.0)

        // Third sample with error handling
        await cpuProvider.setShouldThrow(true)
        await statsSampler.sample()
        snapshot = await statsSampler.currentSnapshot
        // Should keep last known value on error
        XCTAssertEqual(snapshot?.cpuPercentage, 75.0)
    }

    // MARK: - Storage Caching Behavior

    func testStorageCachingAcrossMultipleSamples() async {
        let storageProvider = MockStorageProvider()
        await storageProvider.setStorage(used: 100_000_000_000, total: 500_000_000_000)

        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let networkProvider = MockNetworkProvider()

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        // First sample
        await sampler.sample()
        var snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.storageUsed, 100_000_000_000)

        // Change provider value
        await storageProvider.setStorage(used: 200_000_000_000, total: 500_000_000_000)

        // Immediate sample should use cache
        await sampler.sample()
        snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.storageUsed, 100_000_000_000, "Should use cached value")

        // Invalidate cache
        await sampler.invalidateStorageCache()

        // Now should get new value
        await sampler.sample()
        snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.storageUsed, 200_000_000_000, "Should get fresh value after invalidation")
    }

    // MARK: - Weather Sampling Error Handling

    func testWeatherSamplingErrorHandling() async {
        let weatherProvider = MockWeatherProvider()
        await weatherProvider.setShouldThrow(true)

        let sampler = WeatherSampler(weatherProvider: weatherProvider)

        // First sample with error should use placeholder
        await sampler.sample()
        let weather = await sampler.currentWeather

        XCTAssertNotNil(weather)
        XCTAssertEqual(weather?.temperature, 0, "Should use placeholder temperature on error")
        XCTAssertEqual(weather?.conditionCode, -1, "Should use error condition code")
    }

    func testWeatherSamplingCachedOnError() async {
        let weatherProvider = MockWeatherProvider()
        await weatherProvider.setWeather(WeatherSnapshot(temperature: 25, conditionCode: 0))

        let sampler = WeatherSampler(weatherProvider: weatherProvider)

        // First successful sample
        await sampler.sample()
        var weather = await sampler.currentWeather
        XCTAssertEqual(weather?.temperature, 25)

        // Second sample with error should use cached value
        await weatherProvider.setShouldThrow(true)
        await sampler.sample()
        weather = await sampler.currentWeather
        XCTAssertEqual(weather?.temperature, 25, "Should use cached value on error")
    }

    // MARK: - Network Speed Error Handling

    func testNetworkSpeedErrorHandling() async {
        let networkProvider = MockNetworkProvider()
        await networkProvider.setShouldThrow(true)

        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        // Sample with network error
        await sampler.sample()
        let snapshot = await sampler.currentSnapshot

        XCTAssertNotNil(snapshot)
        XCTAssertEqual(snapshot?.networkDownloadBPS, 0, "Should default to 0 on first error")
        XCTAssertEqual(snapshot?.networkUploadBPS, 0, "Should default to 0 on first error")

        // Set a value and sample again
        await networkProvider.setShouldThrow(false)
        await networkProvider.setNetwork(downloadBPS: 1_000_000, uploadBPS: 500_000)
        await sampler.sample()

        var snapshot2 = await sampler.currentSnapshot
        XCTAssertEqual(snapshot2?.networkDownloadBPS, 1_000_000)

        // Now error again - should use cached value
        await networkProvider.setShouldThrow(true)
        await sampler.sample()

        snapshot2 = await sampler.currentSnapshot
        XCTAssertEqual(snapshot2?.networkDownloadBPS, 1_000_000, "Should use cached value on subsequent error")
    }

    // MARK: - All Providers Error Handling

    func testAllProvidersErrorHandling() async {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await cpuProvider.setShouldThrow(true)
        await ramProvider.setShouldThrow(true)
        await storageProvider.setShouldThrow(true)
        await networkProvider.setShouldThrow(true)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        // Should not throw, but create snapshot with defaults
        await sampler.sample()
        let snapshot = await sampler.currentSnapshot

        XCTAssertNotNil(snapshot, "Should create snapshot even when all providers fail")
        XCTAssertEqual(snapshot?.cpuPercentage, 0, "CPU should default to 0")
        XCTAssertEqual(snapshot?.ramUsed, 0, "RAM used should default to 0")
        XCTAssertEqual(snapshot?.ramTotal, 1, "RAM total should default to 1 to avoid division by zero")
    }

    // MARK: - Stats Snapshot Edge Cases

    func testStatsSnapshotWithZeroValues() async {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await cpuProvider.setCPUPercentage(0)
        await ramProvider.setRAM(used: 0, total: 0)
        await storageProvider.setStorage(used: 0, total: 0)
        await networkProvider.setNetwork(downloadBPS: 0, uploadBPS: 0)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()
        let snapshot = await sampler.currentSnapshot

        XCTAssertNotNil(snapshot)

        if let s = snapshot {
            // Zero values should not cause crashes
            XCTAssertEqual(s.cpuPercentage, 0)
            XCTAssertEqual(s.ramPercentage, 0, "RAM percentage should handle zero total")
            XCTAssertEqual(s.storagePercentage, 0, "Storage percentage should handle zero total")
        }
    }

    func testStatsSnapshotWithMaximumValues() async {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await cpuProvider.setCPUPercentage(100)
        await ramProvider.setRAM(used: Int64.max, total: Int64.max)
        await storageProvider.setStorage(used: Int64.max, total: Int64.max)
        await networkProvider.setNetwork(downloadBPS: Int64.max, uploadBPS: Int64.max)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()
        let snapshot = await sampler.currentSnapshot

        XCTAssertNotNil(snapshot)

        if let s = snapshot {
            XCTAssertEqual(s.cpuPercentage, 100)
            XCTAssertEqual(s.ramUsed, Int64.max)
            XCTAssertEqual(s.ramTotal, Int64.max)
            XCTAssertEqual(s.storageUsed, Int64.max)
            XCTAssertEqual(s.storageTotal, Int64.max)
            XCTAssertEqual(s.networkDownloadBPS, Int64.max)
            XCTAssertEqual(s.networkUploadBPS, Int64.max)
        }
    }

    // MARK: - Sampling State Management

    func testIsSamplingFlag() async {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        var isSampling = await sampler.isSampling
        XCTAssertFalse(isSampling)

        await sampler.sample()

        isSampling = await sampler.isSampling
        XCTAssertFalse(isSampling, "Sampling flag should be reset after sampling completes")
    }

    // MARK: - Concurrent Sampling

    func testConcurrentSampling() async {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await cpuProvider.setCPUPercentage(50)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        // Launch concurrent samples
        async let sample1: Void = sampler.sample()
        async let sample2: Void = sampler.sample()
        async let sample3: Void = sampler.sample()

        // Wait for all to complete
        _ = await (sample1, sample2, sample3)

        let snapshot = await sampler.currentSnapshot
        XCTAssertNotNil(snapshot, "Concurrent sampling should not cause crashes")
    }

    // MARK: - State Persistence Across Operations

    func testStatePersistence() async {
        let state = MenuBarState.shared

        // Set some values
        state.cpuPercentage = 42.0
        state.ramUsed = 8_000_000_000
        state.ramTotal = 16_000_000_000
        state.temperature = 20

        // Values should persist
        XCTAssertEqual(state.cpuPercentage, 42.0)
        XCTAssertEqual(state.ramUsed, 8_000_000_000)
        XCTAssertEqual(state.temperature, 20)

        // Reset for other tests
        state.cpuPercentage = 0
        state.ramUsed = 0
        state.ramTotal = 0
        state.temperature = 0
    }
}
