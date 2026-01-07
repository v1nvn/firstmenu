//
//  MenuBarLabelViewTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import XCTest
@testable import firstmenu

@MainActor
final class MenuBarLabelViewTests: XCTestCase {

    // MARK: - MenuBarLabelView Tests

    func testMenuBarLabelViewRenders() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 45,
            ramUsed: 8_589_934_592,
            ramTotal: 16_000_000_000,
            storageUsed: 250_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 1_048_576,
            networkUploadBPS: 524_288
        )
        let weather = WeatherSnapshot(temperature: 28, conditionCode: 0)
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: weather)
        XCTAssertNotNil(view)
    }

    func testMenuBarLabelViewWithAllStats() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 50,
            ramUsed: 8_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 250_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 2_000_000,
            networkUploadBPS: 1_000_000
        )
        let weather = WeatherSnapshot(temperature: 25, conditionCode: 1)
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: weather)
        _ = view.body
    }

    func testMenuBarLabelViewWithoutWeather() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 30,
            ramUsed: 4_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 100_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: nil)
        _ = view.body
    }

    func testMenuBarLabelViewWithoutNetworkActivity() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 20,
            ramUsed: 6_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 200_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let weather = WeatherSnapshot(temperature: 20, conditionCode: 0)
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: weather)
        _ = view.body
    }

    func testMenuBarLabelViewWithZeroCPU() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 0,
            ramUsed: 4_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 100_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: nil)
        _ = view.body
    }

    func testMenuBarLabelViewWithMaxCPU() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 100,
            ramUsed: 16_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 500_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: nil)
        _ = view.body
    }

    func testMenuBarLabelViewCPUDecimalFormatting() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 45.6,
            ramUsed: 4_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 100_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: nil)
        _ = view.body
    }

    func testMenuBarLabelViewRAMFormatting() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 10,
            ramUsed: 1_234_567_890,
            ramTotal: 16_000_000_000,
            storageUsed: 100_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: nil)
        _ = view.body
    }

    func testMenuBarLabelViewSSDPercentage() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 10,
            ramUsed: 4_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 123_456_789_012,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: nil)
        _ = view.body
    }

    func testMenuBarLabelViewTemperatureFormatting() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 10,
            ramUsed: 4_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 100_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let weather = WeatherSnapshot(temperature: 28.6, conditionCode: 0)
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: weather)
        _ = view.body
    }

    func testMenuBarLabelViewNegativeTemperature() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 10,
            ramUsed: 4_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 100_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let weather = WeatherSnapshot(temperature: -5.3, conditionCode: 71)
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: weather)
        _ = view.body
    }

    func testMenuBarLabelViewNetworkKilobyteSpeed() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 10,
            ramUsed: 4_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 100_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 50_000,
            networkUploadBPS: 10_000
        )
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: nil)
        _ = view.body
    }

    func testMenuBarLabelViewNetworkMegabyteSpeed() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 10,
            ramUsed: 4_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 100_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 1_500_000,
            networkUploadBPS: 500_000
        )
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: nil)
        _ = view.body
    }

    func testMenuBarLabelViewWithVariousWeatherCodes() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 10,
            ramUsed: 4_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 100_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )

        let weatherCodes = [0, 1, 2, 3, 45, 63, 71, 95]
        for code in weatherCodes {
            let weather = WeatherSnapshot(temperature: 20, conditionCode: code)
            let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: weather)
            _ = view.body
            XCTAssertNotNil(view)
        }
    }

    func testMenuBarLabelViewSpacing() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 45,
            ramUsed: 8_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 250_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 1_000_000,
            networkUploadBPS: 500_000
        )
        let weather = WeatherSnapshot(temperature: 25, conditionCode: 0)
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: weather)
        _ = view.body
    }

    func testMenuBarLabelViewHStack() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 30,
            ramUsed: 6_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 150_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 0,
            networkUploadBPS: 0
        )
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: nil)
        _ = view.body
    }

    func testMenuBarLabelViewWithSeparatorDots() {
        let snapshot = StatsSnapshot(
            cpuPercentage: 25,
            ramUsed: 5_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 125_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 100_000,
            networkUploadBPS: 50_000
        )
        let weather = WeatherSnapshot(temperature: 22, conditionCode: 2)
        let view = MenuBarLabelView(statsSnapshot: snapshot, weatherSnapshot: weather)
        _ = view.body
    }
}
