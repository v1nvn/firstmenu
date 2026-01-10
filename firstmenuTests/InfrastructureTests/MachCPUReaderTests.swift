//
//  MachCPUReaderTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

final class MachCPUReaderTests: XCTestCase {

    func testCPUPercentageReturnsValidValue() async throws {
        let reader = MachCPUReader()

        // First call should return a value between 0 and 100
        let percentage1 = try await reader.cpuPercentage()
        XCTAssertGreaterThanOrEqual(percentage1, 0.0)
        XCTAssertLessThanOrEqual(percentage1, 100.0)

        // Wait a bit and call again to get delta-based reading
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let percentage2 = try await reader.cpuPercentage()
        XCTAssertGreaterThanOrEqual(percentage2, 0.0)
        XCTAssertLessThanOrEqual(percentage2, 100.0)
    }

    func testCPUPercentageClampsToValidRange() async throws {
        let reader = MachCPUReader()

        // Multiple calls should always return valid values
        for _ in 0..<10 {
            let percentage = try await reader.cpuPercentage()
            XCTAssertGreaterThanOrEqual(percentage, 0.0, "CPU percentage should be >= 0")
            XCTAssertLessThanOrEqual(percentage, 100.0, "CPU percentage should be <= 100")
        }
    }

    func testCPUPercentageIsConsistent() async throws {
        let reader = MachCPUReader()

        // First reading establishes baseline
        _ = try await reader.cpuPercentage()

        // Wait for measurable activity
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Subsequent reading should use delta calculation
        let percentage = try await reader.cpuPercentage()
        XCTAssertGreaterThanOrEqual(percentage, 0.0)
        XCTAssertLessThanOrEqual(percentage, 100.0)
    }

    func testMultipleReadingsSuccess() async throws {
        let reader = MachCPUReader()

        // Test multiple sequential reads
        for i in 0..<5 {
            let percentage = try await reader.cpuPercentage()
            XCTAssertTrue(percentage >= 0.0 && percentage <= 100.0, "Reading \(i) failed: \(percentage)")
        }
    }

    func testConcurrentReadings() async throws {
        let reader = MachCPUReader()

        // Test concurrent reads
        async let p1 = reader.cpuPercentage()
        async let p2 = reader.cpuPercentage()
        async let p3 = reader.cpuPercentage()

        let (r1, r2, r3) = try await (p1, p2, p3)

        XCTAssertTrue(r1 >= 0.0 && r1 <= 100.0)
        XCTAssertTrue(r2 >= 0.0 && r2 <= 100.0)
        XCTAssertTrue(r3 >= 0.0 && r3 <= 100.0)
    }
}
