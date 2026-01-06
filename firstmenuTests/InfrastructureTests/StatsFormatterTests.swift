//
//  StatsFormatterTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

final class StatsFormatterTests: XCTestCase {
    // MARK: - Percentage Formatting

    func testFormatPercentage() {
        XCTAssertEqual(StatsFormatter.formatPercentage(50.5), "50%")
        XCTAssertEqual(StatsFormatter.formatPercentage(0), "0%")
        XCTAssertEqual(StatsFormatter.formatPercentage(99.9), "100%")
        XCTAssertEqual(StatsFormatter.formatPercentage(0.1), "0%")
    }

    // MARK: - Bytes Formatting

    func testFormatBytes_Gigabytes() {
        XCTAssertEqual(StatsFormatter.formatBytes(1_073_741_824), "1.0 GB")      // 1 GB
        XCTAssertEqual(StatsFormatter.formatBytes(2_147_483_648), "2.0 GB")     // 2 GB
        XCTAssertEqual(StatsFormatter.formatBytes(536_870_912), "512 MB")       // 512 MB
        XCTAssertEqual(StatsFormatter.formatBytes(10_737_418_240), "10.0 GB")   // 10 GB
    }

    func testFormatBytes_Megabytes() {
        XCTAssertEqual(StatsFormatter.formatBytes(1_048_576), "1 MB")         // 1 MB
        XCTAssertEqual(StatsFormatter.formatBytes(10_485_760), "10 MB")       // 10 MB
        XCTAssertEqual(StatsFormatter.formatBytes(512_000), "500 KB")        // 500 KB
    }

    func testFormatBytes_Kilobytes() {
        XCTAssertEqual(StatsFormatter.formatBytes(1024), "1 KB")            // 1 KB
        XCTAssertEqual(StatsFormatter.formatBytes(10_240), "10 KB")         // 10 KB
        XCTAssertEqual(StatsFormatter.formatBytes(512), "0 KB")            // < 1 KB
    }

    func testFormatBytes_Zero() {
        XCTAssertEqual(StatsFormatter.formatBytes(0), "0 KB")
    }

    // MARK: - Network Speed Formatting

    func testFormatNetworkSpeed_MegabytesPerSecond() {
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(1_048_576), "1.0 MB/s")      // 1 MB/s
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(10_485_760), "10.0 MB/s")    // 10 MB/s
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(524_288), "512 KB/s")       // 512 KB/s
    }

    func testFormatNetworkSpeed_KilobytesPerSecond() {
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(1024), "1 KB/s")           // 1 KB/s
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(10_240), "10 KB/s")       // 10 KB/s
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(512), "0 B/s")          // < 1 KB/s
    }

    func testFormatNetworkSpeed_Zero() {
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(0), "0 B/s")
    }

    // MARK: - Temperature Formatting

    func testFormatTemperature() {
        XCTAssertEqual(StatsFormatter.formatTemperature(0), "0°")
        XCTAssertEqual(StatsFormatter.formatTemperature(25.5), "26°")
        XCTAssertEqual(StatsFormatter.formatTemperature(30.2), "30°")
        XCTAssertEqual(StatsFormatter.formatTemperature(-5), "-5°")
    }

    // MARK: - Edge Cases

    func testFormatPercentage_EdgeCases() {
        XCTAssertEqual(StatsFormatter.formatPercentage(-1), "0%")
        XCTAssertEqual(StatsFormatter.formatPercentage(100.5), "100%")
        XCTAssertEqual(StatsFormatter.formatPercentage(50), "50%")
    }

    func testFormatBytes_LargeValues() {
        XCTAssertEqual(StatsFormatter.formatBytes(1_099_511_627_776), "1.0 TB")      // 1 TB
        XCTAssertEqual(StatsFormatter.formatBytes(1_125_899_906_842_624), "1.0 PB")   // 1 PB
    }

    func testFormatBytes_Precision() {
        XCTAssertEqual(StatsFormatter.formatBytes(1_234_567), "1.2 MB")
        XCTAssertEqual(StatsFormatter.formatBytes(1_294_567), "1.2 MB")
        XCTAssertEqual(StatsFormatter.formatBytes(1_600_000), "1.5 MB")
    }

    func testFormatNetworkSpeed_Precision() {
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(1_300_000), "1.2 MB/s")
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(1_600_000), "1.5 MB/s")
        XCTAssertEqual(StatsFormatter.formatNetworkSpeed(1_990_000), "1.9 MB/s")
    }

    func testFormatTemperature_EdgeCases() {
        XCTAssertEqual(StatsFormatter.formatTemperature(-100), "-100°")
        XCTAssertEqual(StatsFormatter.formatTemperature(100), "100°")
        XCTAssertEqual(StatsFormatter.formatTemperature(0.4), "0°")
        XCTAssertEqual(StatsFormatter.formatTemperature(0.6), "1°")
    }
}
