//
//  StatsSamplerTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

@MainActor
final class StatsSamplerTests: XCTestCase {
    func testSampleCreatesSnapshot() async throws {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await cpuProvider.setCPUPercentage(75.0)
        await ramProvider.setRAM(used: 12_000_000_000, total: 16_000_000_000)
        await storageProvider.setStorage(used: 300_000_000_000, total: 500_000_000_000)
        await networkProvider.setNetwork(downloadBPS: 2_000_000, uploadBPS: 1_000_000)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        let unwrappedSnapshot = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrappedSnapshot.cpuPercentage, 75.0)
        XCTAssertEqual(unwrappedSnapshot.ramUsed, 12_000_000_000)
        XCTAssertEqual(unwrappedSnapshot.ramTotal, 16_000_000_000)
        XCTAssertEqual(unwrappedSnapshot.storageUsed, 300_000_000_000)
        XCTAssertEqual(unwrappedSnapshot.storageTotal, 500_000_000_000)
        XCTAssertEqual(unwrappedSnapshot.networkDownloadBPS, 2_000_000)
        XCTAssertEqual(unwrappedSnapshot.networkUploadBPS, 1_000_000)
    }

    func testSampleWithCPUError() async throws {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await cpuProvider.setShouldThrow(true)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        // sample() now handles errors gracefully instead of throwing
        await sampler.sample()

        // Snapshot should still be created with default value for CPU
        let snapshot = await sampler.currentSnapshot
        XCTAssertNotNil(snapshot)

        // CPU should be 0 (default when error occurs)
        if let s = snapshot {
            XCTAssertEqual(s.cpuPercentage, 0)
        }
    }

    func testRamPercentageCalculation() async throws {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await ramProvider.setRAM(used: 4_000_000_000, total: 16_000_000_000)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        let unwrappedSnapshot = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrappedSnapshot.ramPercentage, 25.0, accuracy: 0.1)
    }

    func testStoragePercentageCalculation() async throws {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await storageProvider.setStorage(used: 125_000_000_000, total: 500_000_000_000)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        let unwrappedSnapshot = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrappedSnapshot.storagePercentage, 25.0, accuracy: 0.1)
    }

    func testStorageCaching() async throws {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await storageProvider.setStorage(used: 100_000_000_000, total: 500_000_000_000)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        // First call should fetch from provider
        await sampler.sample()

        var snapshot = await sampler.currentSnapshot
        var unwrappedSnapshot = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrappedSnapshot.storageUsed, 100_000_000_000)

        // Change the storage provider's value
        await storageProvider.setStorage(used: 200_000_000_000, total: 500_000_000_000)

        // Immediately sampling again should use cached value
        await sampler.sample()

        snapshot = await sampler.currentSnapshot
        unwrappedSnapshot = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrappedSnapshot.storageUsed, 100_000_000_000)  // Still cached value

        // Invalidate cache and sample again
        await sampler.invalidateStorageCache()
        await sampler.sample()

        snapshot = await sampler.currentSnapshot
        unwrappedSnapshot = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrappedSnapshot.storageUsed, 200_000_000_000)  // New value
    }
}
