//
//  FileSystemStorageReaderTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

final class FileSystemStorageReaderTests: XCTestCase {

    func testStorageUsageReturnsValidValues() async throws {
        let reader = FileSystemStorageReader()

        let (used, total) = try await reader.storageUsage()

        XCTAssertGreaterThan(total, 0, "Total storage should be greater than 0")
        XCTAssertGreaterThanOrEqual(used, 0, "Used storage should be non-negative")
        XCTAssertLessThanOrEqual(used, total, "Used storage should not exceed total storage")
    }

    func testStorageValuesAreReasonable() async throws {
        let reader = FileSystemStorageReader()

        let (used, total) = try await reader.storageUsage()

        // Total storage should be at least 10 GB (for a modern system)
        let tenGB: Int64 = 10 * 1_073_741_824
        XCTAssertGreaterThanOrEqual(total, tenGB, "Total storage should be at least 10 GB")

        // Used storage should be some reasonable amount
        XCTAssertGreaterThan(used, 0, "Some storage should be in use")
        XCTAssertLessThan(used, total, "Used storage should be less than total")
    }

    func testStoragePercentageCalculation() async throws {
        let reader = FileSystemStorageReader()

        let (used, total) = try await reader.storageUsage()

        let percentage = Double(used) / Double(total) * 100.0

        XCTAssertGreaterThanOrEqual(percentage, 0.0)
        XCTAssertLessThanOrEqual(percentage, 100.0)

        // On a running system, some storage should be used
        XCTAssertGreaterThan(percentage, 0.0, "Some storage should be in use")
        // And typically not completely full
        XCTAssertLessThan(percentage, 100.0, "Storage should not be completely full")
    }

    func testStorageUsageIsConsistent() async throws {
        let reader = FileSystemStorageReader()

        // Multiple readings should return consistent values
        let (used1, total1) = try await reader.storageUsage()
        let (used2, total2) = try await reader.storageUsage()

        // Total should not change
        XCTAssertEqual(total1, total2, "Total storage should remain constant")

        // Used can change slightly (due to temp files), but should be similar
        let difference = abs(used1 - used2)
        let oneMB: Int64 = 1_048_576
        XCTAssertLessThan(difference, oneMB, "Used storage should be relatively stable")
    }

    func testMultipleReadingsSuccess() async throws {
        let reader = FileSystemStorageReader()

        // Test multiple sequential reads
        for i in 0..<5 {
            let (used, total) = try await reader.storageUsage()
            XCTAssertGreaterThan(total, 0, "Reading \(i): total should be > 0")
            XCTAssertGreaterThanOrEqual(used, 0, "Reading \(i): used should be >= 0")
            XCTAssertLessThanOrEqual(used, total, "Reading \(i): used should be <= total")
        }
    }

    func testCustomPathInitializer() async throws {
        // Test with root path (default)
        let reader1 = FileSystemStorageReader(path: "/")
        let (used1, total1) = try await reader1.storageUsage()
        XCTAssertGreaterThan(total1, 0)

        // Test with system path
        let reader2 = FileSystemStorageReader(path: "/System")
        let (used2, total2) = try await reader2.storageUsage()
        XCTAssertGreaterThan(total2, 0)
    }

    func testConcurrentReadings() async throws {
        let reader = FileSystemStorageReader()

        // Test concurrent reads
        async let r1 = reader.storageUsage()
        async let r2 = reader.storageUsage()
        async let r3 = reader.storageUsage()

        let (used1, total1) = try await r1
        let (used2, total2) = try await r2
        let (used3, total3) = try await r3

        // All should return consistent total values
        XCTAssertEqual(total1, total2, "Total storage should be consistent")
        XCTAssertEqual(total2, total3, "Total storage should be consistent")

        // All used values should be valid
        XCTAssertGreaterThanOrEqual(used1, 0)
        XCTAssertLessThanOrEqual(used1, total1)
        XCTAssertGreaterThanOrEqual(used2, 0)
        XCTAssertLessThanOrEqual(used2, total2)
        XCTAssertGreaterThanOrEqual(used3, 0)
        XCTAssertLessThanOrEqual(used3, total3)
    }
}
