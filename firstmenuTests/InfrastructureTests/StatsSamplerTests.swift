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

    // MARK: - Edge Cases

    func testAllProvidersErrorOnFirstSample() async throws {
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

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        XCTAssertNotNil(snapshot, "Should create snapshot with defaults when all providers fail")

        let unwrapped = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrapped.cpuPercentage, 0)
        XCTAssertEqual(unwrapped.ramUsed, 0)
        XCTAssertEqual(unwrapped.ramTotal, 1)  // Default to avoid division by zero
        XCTAssertEqual(unwrapped.storageUsed, 0)
        XCTAssertEqual(unwrapped.storageTotal, 1)  // Default to avoid division by zero
        XCTAssertEqual(unwrapped.networkDownloadBPS, 0)
        XCTAssertEqual(unwrapped.networkUploadBPS, 0)
    }

    func testRALErrorAfterSuccessfulSample() async throws {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await ramProvider.setRAM(used: 8_000_000_000, total: 16_000_000_000)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        // First successful sample
        await sampler.sample()
        var snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.ramUsed, 8_000_000_000)

        // Now make RAM throw error
        await ramProvider.setShouldThrow(true)
        await sampler.sample()

        snapshot = await sampler.currentSnapshot
        // Should use cached value from previous snapshot
        XCTAssertEqual(snapshot?.ramUsed, 8_000_000_000, "Should use cached RAM value on error")
        XCTAssertEqual(snapshot?.ramTotal, 16_000_000_000, "Should use cached RAM total on error")
    }

    func testNetworkErrorAfterSuccessfulSample() async throws {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await networkProvider.setNetwork(downloadBPS: 5_000_000, uploadBPS: 2_000_000)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        // First successful sample
        await sampler.sample()
        var snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.networkDownloadBPS, 5_000_000)

        // Now make network throw error
        await networkProvider.setShouldThrow(true)
        await sampler.sample()

        snapshot = await sampler.currentSnapshot
        // Should use cached value from previous snapshot
        XCTAssertEqual(snapshot?.networkDownloadBPS, 5_000_000, "Should use cached network value on error")
    }

    func testZeroCPUValue() async throws {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await cpuProvider.setCPUPercentage(0)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        let unwrapped = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrapped.cpuPercentage, 0)
    }

    func testMaximumCPUValue() async throws {
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await cpuProvider.setCPUPercentage(100)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        let unwrapped = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrapped.cpuPercentage, 100)
    }

    func testCPUBoundaryValues() async throws {
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

        // Test slightly above 100
        await cpuProvider.setCPUPercentage(101.5)
        await sampler.sample()
        var snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.cpuPercentage, 101.5)

        // Test negative value
        await cpuProvider.setCPUPercentage(-5.0)
        await sampler.sample()
        snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.cpuPercentage, -5.0)
    }

    func testStorageErrorWithCache() async throws {
        let storageProvider = MockStorageProvider()
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let networkProvider = MockNetworkProvider()

        await storageProvider.setStorage(used: 100_000_000_000, total: 500_000_000_000)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        // First sample to populate cache
        await sampler.sample()
        var snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.storageUsed, 100_000_000_000)

        // Make storage throw error
        await storageProvider.setShouldThrow(true)

        // Should use cached value
        await sampler.sample()
        snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.storageUsed, 100_000_000_000, "Should use cached storage on error")
    }

    func testStorageErrorWithoutCache() async throws {
        let storageProvider = MockStorageProvider()
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let networkProvider = MockNetworkProvider()

        await storageProvider.setShouldThrow(true)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        XCTAssertNotNil(snapshot)
        let unwrapped = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrapped.storageUsed, 0, "Should default to 0 when cache is empty and error occurs")
        XCTAssertEqual(unwrapped.storageTotal, 1, "Should default to 1 to avoid division by zero")
    }

    func testIsSamplingFlag() async throws {
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
        XCTAssertFalse(isSampling, "Flag should be reset after sampling completes")
    }

    func testConcurrentSampling() async throws {
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

        // Launch multiple concurrent samples
        async let s1: Void = sampler.sample()
        async let s2: Void = sampler.sample()
        async let s3: Void = sampler.sample()

        await (s1, s2, s3)

        let snapshot = await sampler.currentSnapshot
        XCTAssertNotNil(snapshot, "Concurrent sampling should not cause crashes")
    }

    func testMultipleSequentialSamples() async throws {
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

        // Sample 1
        await cpuProvider.setCPUPercentage(25)
        await sampler.sample()
        var snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.cpuPercentage, 25)

        // Sample 2
        await cpuProvider.setCPUPercentage(50)
        await sampler.sample()
        snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.cpuPercentage, 50)

        // Sample 3
        await cpuProvider.setCPUPercentage(75)
        await sampler.sample()
        snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.cpuPercentage, 75)

        // Sample 4
        await cpuProvider.setCPUPercentage(100)
        await sampler.sample()
        snapshot = await sampler.currentSnapshot
        XCTAssertEqual(snapshot?.cpuPercentage, 100)
    }

    func testStoragePercentageWithZeroTotal() async throws {
        let storageProvider = MockStorageProvider()
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let networkProvider = MockNetworkProvider()

        await storageProvider.setStorage(used: 100_000_000_000, total: 0)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        let unwrapped = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrapped.storageTotal, 0)
        XCTAssertEqual(unwrapped.storagePercentage, 0, "Should handle zero total gracefully")
    }

    func testRAMPercentageWithZeroTotal() async throws {
        let ramProvider = MockRAMProvider()
        let cpuProvider = MockCPUProvider()
        let storageProvider = MockStorageProvider()
        let networkProvider = MockNetworkProvider()

        await ramProvider.setRAM(used: 8_000_000_000, total: 0)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        let unwrapped = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrapped.ramTotal, 0)
        XCTAssertEqual(unwrapped.ramPercentage, 0, "Should handle zero total gracefully")
    }

    func testSnapshotNilBeforeFirstSample() async {
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

        let snapshot = await sampler.currentSnapshot
        XCTAssertNil(snapshot, "Snapshot should be nil before first sample")
    }

    func testSnapshotExistsAfterSample() async throws {
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

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        XCTAssertNotNil(snapshot, "Snapshot should exist after sample")
    }

    func testNetworkWithZeroValues() async throws {
        let networkProvider = MockNetworkProvider()
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()

        await networkProvider.setNetwork(downloadBPS: 0, uploadBPS: 0)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        let unwrapped = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrapped.networkDownloadBPS, 0)
        XCTAssertEqual(unwrapped.networkUploadBPS, 0)
    }

    func testNetworkWithLargeValues() async throws {
        let networkProvider = MockNetworkProvider()
        let cpuProvider = MockCPUProvider()
        let ramProvider = MockRAMProvider()
        let storageProvider = MockStorageProvider()

        // Test with 10 Gbps values
        await networkProvider.setNetwork(downloadBPS: 10_000_000_000, uploadBPS: 5_000_000_000)

        let sampler = StatsSampler(
            cpuProvider: cpuProvider,
            ramProvider: ramProvider,
            storageProvider: storageProvider,
            networkProvider: networkProvider
        )

        await sampler.sample()

        let snapshot = await sampler.currentSnapshot
        let unwrapped = try XCTUnwrap(snapshot)
        XCTAssertEqual(unwrapped.networkDownloadBPS, 10_000_000_000)
        XCTAssertEqual(unwrapped.networkUploadBPS, 5_000_000_000)
    }
}
