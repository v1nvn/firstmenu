//
//  MachRAMReaderTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

final class MachRAMReaderTests: XCTestCase {

    func testRAMUsageReturnsValidValues() async throws {
        let reader = MachRAMReader()

        let (used, total) = try await reader.ramUsage()

        XCTAssertGreaterThan(total, 0, "Total RAM should be greater than 0")
        XCTAssertGreaterThanOrEqual(used, 0, "Used RAM should be non-negative")
        XCTAssertLessThanOrEqual(used, total, "Used RAM should not exceed total RAM")
    }

    func testRAMValuesAreReasonable() async throws {
        let reader = MachRAMReader()

        let (used, total) = try await reader.ramUsage()

        // Total RAM should be at least 1 GB (in bytes)
        let oneGB: Int64 = 1_073_741_824
        XCTAssertGreaterThanOrEqual(total, oneGB, "Total RAM should be at least 1 GB")

        // Used RAM should be some reasonable fraction of total
        XCTAssertGreaterThan(used, 0, "Some RAM should be in use")
        XCTAssertLessThan(used, total, "Used RAM should be less than total")
    }

    func testRAMUsageIsConsistent() async throws {
        let reader = MachRAMReader()

        // Multiple readings should return consistent values
        let (used1, total1) = try await reader.ramUsage()
        let (used2, total2) = try await reader.ramUsage()

        // Total should not change
        XCTAssertEqual(total1, total2, "Total RAM should remain constant")

        // Used can change, but should stay within valid bounds
        XCTAssertGreaterThanOrEqual(used2, 0)
        XCTAssertLessThanOrEqual(used2, total2)
    }

    func testRAMPercentageCalculation() async throws {
        let reader = MachRAMReader()

        let (used, total) = try await reader.ramUsage()

        let percentage = Double(used) / Double(total) * 100.0

        XCTAssertGreaterThanOrEqual(percentage, 0.0)
        XCTAssertLessThanOrEqual(percentage, 100.0)

        // On a running system, some RAM should be used
        XCTAssertGreaterThan(percentage, 0.0, "Some RAM should be in use")
    }

    func testMultipleReadingsSuccess() async throws {
        let reader = MachRAMReader()

        // Test multiple sequential reads
        for i in 0..<5 {
            let (used, total) = try await reader.ramUsage()
            XCTAssertGreaterThan(total, 0, "Reading \(i): total should be > 0")
            XCTAssertGreaterThanOrEqual(used, 0, "Reading \(i): used should be >= 0")
            XCTAssertLessThanOrEqual(used, total, "Reading \(i): used should be <= total")
        }
    }

    func testConcurrentReadings() async throws {
        let reader = MachRAMReader()

        // Test concurrent reads
        async let r1 = reader.ramUsage()
        async let r2 = reader.ramUsage()
        async let r3 = reader.ramUsage()

        let (used1, total1) = try await r1
        let (used2, total2) = try await r2
        let (used3, total3) = try await r3

        // All should return consistent total values
        XCTAssertEqual(total1, total2, "Total RAM should be consistent")
        XCTAssertEqual(total2, total3, "Total RAM should be consistent")

        // All used values should be valid
        XCTAssertGreaterThanOrEqual(used1, 0)
        XCTAssertLessThanOrEqual(used1, total1)
        XCTAssertGreaterThanOrEqual(used2, 0)
        XCTAssertLessThanOrEqual(used2, total2)
        XCTAssertGreaterThanOrEqual(used3, 0)
        XCTAssertLessThanOrEqual(used3, total3)
    }
}
