//
//  StatsSnapshotTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

final class StatsSnapshotTests: XCTestCase {
    func testStatsSnapshotInitialization() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 50.0,
            ramUsed: 8_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 250_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 1_000_000,
            networkUploadBPS: 500_000
        )

        XCTAssertEqual(snapshot.cpuPercentage, 50.0)
        XCTAssertEqual(snapshot.ramUsed, 8_000_000_000)
        XCTAssertEqual(snapshot.ramTotal, 16_000_000_000)
        XCTAssertEqual(snapshot.storageUsed, 250_000_000_000)
        XCTAssertEqual(snapshot.storageTotal, 500_000_000_000)
        XCTAssertEqual(snapshot.networkDownloadBPS, 1_000_000)
        XCTAssertEqual(snapshot.networkUploadBPS, 500_000)
    }

    func testRamPercentage() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 0,
            ramUsed: 8_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 0,
            storageTotal: 1,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )

        XCTAssertEqual(snapshot.ramPercentage, 50.0, accuracy: 0.1)
    }

    func testStoragePercentage() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 0,
            ramUsed: 0,
            ramTotal: 1,
            storageUsed: 250_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )

        XCTAssertEqual(snapshot.storagePercentage, 50.0, accuracy: 0.1)
    }

    func testZeroTotalReturnsZeroPercentage() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 0,
            ramUsed: 8_000_000_000,
            ramTotal: 0,
            storageUsed: 250_000_000_000,
            storageTotal: 0,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )

        XCTAssertEqual(snapshot.ramPercentage, 0)
        XCTAssertEqual(snapshot.storagePercentage, 0)
    }

    func testEquatable() {
        let snapshot1 = StatsSnapshot(
            cpuPercentage: 50.0,
            ramUsed: 8_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 250_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )

        let snapshot2 = StatsSnapshot(
            cpuPercentage: 50.0,
            ramUsed: 8_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 250_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )

        XCTAssertEqual(snapshot1, snapshot2)
    }
}
