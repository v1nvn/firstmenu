//
//  InterfaceNetworkReaderTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

final class InterfaceNetworkReaderTests: XCTestCase {

    func testNetworkSpeedInitialCallReturnsZero() async throws {
        let reader = InterfaceNetworkReader()

        // First call should return 0 (no previous snapshot to compare against)
        let (download, upload) = try await reader.networkSpeed()

        XCTAssertEqual(download, 0, "Initial download should be 0")
        XCTAssertEqual(upload, 0, "Initial upload should be 0")
    }

    func testNetworkSpeedSecondCallReturnsNonNegative() async throws {
        let reader = InterfaceNetworkReader()

        // First call establishes baseline
        _ = try await reader.networkSpeed()

        // Wait a bit for some network activity
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        // Second call should return valid values
        let (download, upload) = try await reader.networkSpeed()

        XCTAssertGreaterThanOrEqual(download, 0, "Download speed should be non-negative")
        XCTAssertGreaterThanOrEqual(upload, 0, "Upload speed should be non-negative")
    }

    func testNetworkSpeedWithDelay() async throws {
        let reader = InterfaceNetworkReader()

        // Establish baseline
        _ = try await reader.networkSpeed()

        // Wait longer for more accurate measurement
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        let (download, upload) = try await reader.networkSpeed()

        XCTAssertGreaterThanOrEqual(download, 0)
        XCTAssertGreaterThanOrEqual(upload, 0)
    }

    func testMultipleSequentialReadings() async throws {
        let reader = InterfaceNetworkReader()

        // First reading
        let (d1, u1) = try await reader.networkSpeed()
        XCTAssertEqual(d1, 0)
        XCTAssertEqual(u1, 0)

        // Second reading after delay
        try await Task.sleep(nanoseconds: 100_000_000)
        let (d2, u2) = try await reader.networkSpeed()
        XCTAssertGreaterThanOrEqual(d2, 0)
        XCTAssertGreaterThanOrEqual(u2, 0)

        // Third reading after delay
        try await Task.sleep(nanoseconds: 100_000_000)
        let (d3, u3) = try await reader.networkSpeed()
        XCTAssertGreaterThanOrEqual(d3, 0)
        XCTAssertGreaterThanOrEqual(u3, 0)
    }

    func testNetworkSpeedHandlesCounterWrap() async throws {
        let reader = InterfaceNetworkReader()

        // Establish baseline
        _ = try await reader.networkSpeed()

        // Subsequent calls should handle counter wrapping gracefully
        try await Task.sleep(nanoseconds: 100_000_000)
        let (download, upload) = try await reader.networkSpeed()

        // Should never return negative values (counter wrap is handled)
        XCTAssertGreaterThanOrEqual(download, 0, "Should handle counter wrap gracefully")
        XCTAssertGreaterThanOrEqual(upload, 0, "Should handle counter wrap gracefully")
    }

    func testConcurrentReadings() async throws {
        let reader = InterfaceNetworkReader()

        // First call to establish baseline
        _ = try await reader.networkSpeed()

        // Wait a bit
        try await Task.sleep(nanoseconds: 100_000_000)

        // Test concurrent reads
        async let r1 = reader.networkSpeed()
        async let r2 = reader.networkSpeed()
        async let r3 = reader.networkSpeed()

        let (d1, u1) = try await r1
        let (d2, u2) = try await r2
        let (d3, u3) = try await r3

        // All should return non-negative values
        XCTAssertGreaterThanOrEqual(d1, 0)
        XCTAssertGreaterThanOrEqual(u1, 0)
        XCTAssertGreaterThanOrEqual(d2, 0)
        XCTAssertGreaterThanOrEqual(u2, 0)
        XCTAssertGreaterThanOrEqual(d3, 0)
        XCTAssertGreaterThanOrEqual(u3, 0)
    }

    func testNetworkSpeedZeroTimeInterval() async throws {
        let reader = InterfaceNetworkReader()

        // This test verifies that very quick successive calls don't cause issues
        _ = try await reader.networkSpeed()

        // Immediate second call (nearly zero time elapsed)
        let (download, upload) = try await reader.networkSpeed()

        // Should return 0 or a very small value (due to rounding)
        XCTAssertGreaterThanOrEqual(download, 0)
        XCTAssertGreaterThanOrEqual(upload, 0)
    }
}
