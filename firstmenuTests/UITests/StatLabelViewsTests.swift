//
//  StatLabelViewsTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import XCTest
@testable import firstmenu

@MainActor
final class StatLabelViewsTests: XCTestCase {

    // MARK: - CPUStatLabelView Tests

    func testCPUStatLabelViewCreates() {
        let view = CPUStatLabelView(percentage: 45.5)
        XCTAssertNotNil(view)
        _ = view.body
    }

    func testCPUStatLabelViewWithZeroPercent() {
        let view = CPUStatLabelView(percentage: 0)
        _ = view.body
    }

    func testCPUStatLabelViewWithHundredPercent() {
        let view = CPUStatLabelView(percentage: 100)
        _ = view.body
    }

    func testCPUStatLabelViewWithExtremeValues() {
        let view1 = CPUStatLabelView(percentage: -0.1)
        let view2 = CPUStatLabelView(percentage: 150)
        _ = view1.body
        _ = view2.body
    }

    // MARK: - RAMStatLabelView Tests

    func testRAMStatLabelViewCreates() {
        let view = RAMStatLabelView(used: 8_589_934_592, total: 16_000_000_000)
        XCTAssertNotNil(view)
        _ = view.body
    }

    func testRAMStatLabelViewWithSmallValue() {
        let view = RAMStatLabelView(used: 536_870_912, total: 16_000_000_000)
        _ = view.body
    }

    func testRAMStatLabelViewWithLargeValue() {
        let view = RAMStatLabelView(used: 34_359_738_368, total: 64_000_000_000)
        _ = view.body
    }

    func testRAMStatLabelViewWithTerabytes() {
        let view = RAMStatLabelView(used: 1_500_000_000_000, total: 2_000_000_000_000)
        _ = view.body
    }

    // MARK: - SSDStatLabelView Tests

    func testSSDStatLabelViewCreates() {
        let view = SSDStatLabelView(used: 250_000_000_000, total: 500_000_000_000)
        XCTAssertNotNil(view)
        _ = view.body
    }

    func testSSDStatLabelViewWithLowUsage() {
        let view = SSDStatLabelView(used: 50_000_000_000, total: 500_000_000_000)
        _ = view.body
    }

    func testSSDStatLabelViewWithHighUsage() {
        let view = SSDStatLabelView(used: 450_000_000_000, total: 500_000_000_000)
        _ = view.body
    }

    func testSSDStatLabelViewWithTerabytes() {
        let view = SSDStatLabelView(used: 1_500_000_000_000, total: 2_000_000_000_000)
        _ = view.body
    }

    // MARK: - WeatherStatLabelView Tests

    func testWeatherStatLabelViewCreates() {
        let view = WeatherStatLabelView(temperature: 28, sfSymbolName: "sun.max.fill")
        XCTAssertNotNil(view)
        _ = view.body
    }

    func testWeatherStatLabelViewWithFreezingTemp() {
        let view = WeatherStatLabelView(temperature: -5, sfSymbolName: "snow")
        _ = view.body
    }

    func testWeatherStatLabelViewWithHotTemp() {
        let view = WeatherStatLabelView(temperature: 42, sfSymbolName: "sun.max.fill")
        _ = view.body
    }

    func testWeatherStatLabelViewWithZeroTemp() {
        let view = WeatherStatLabelView(temperature: 0, sfSymbolName: "thermometer.low")
        _ = view.body
    }

    func testWeatherStatLabelViewWithExtremeCold() {
        let view = WeatherStatLabelView(temperature: -273.15, sfSymbolName: "snow")
        _ = view.body
    }

    func testWeatherStatLabelViewWithVariousSymbols() {
        let symbols = ["sun.max.fill", "cloud.fill", "cloud.rain.fill", "cloud.snow.fill", "cloud.bolt.fill"]
        for symbol in symbols {
            let view = WeatherStatLabelView(temperature: 20, sfSymbolName: symbol)
            _ = view.body
        }
    }

    // MARK: - NetworkStatLabelView Tests

    func testNetworkStatLabelViewCreates() {
        let view = NetworkStatLabelView(downloadBPS: 1_048_576, uploadBPS: 0)
        XCTAssertNotNil(view)
        _ = view.body
    }

    func testNetworkStatLabelViewWithActiveUpload() {
        let view = NetworkStatLabelView(downloadBPS: 0, uploadBPS: 524_288)
        _ = view.body
    }

    func testNetworkStatLabelViewWithBothActive() {
        let view = NetworkStatLabelView(downloadBPS: 2_097_152, uploadBPS: 524_288)
        _ = view.body
    }

    func testNetworkStatLabelViewWithNoActivity() {
        let view = NetworkStatLabelView(downloadBPS: 0, uploadBPS: 0)
        _ = view.body
    }

    func testNetworkStatLabelViewWithKilobyteSpeed() {
        let view = NetworkStatLabelView(downloadBPS: 10_000, uploadBPS: 0)
        _ = view.body
    }

    func testNetworkStatLabelViewWithMegabyteSpeed() {
        let view = NetworkStatLabelView(downloadBPS: 1_500_000, uploadBPS: 0)
        _ = view.body
    }

    func testNetworkStatLabelViewWithVeryLowSpeed() {
        let view = NetworkStatLabelView(downloadBPS: 500, uploadBPS: 0)
        _ = view.body
    }

    func testNetworkStatLabelViewWithVeryHighSpeed() {
        let view = NetworkStatLabelView(downloadBPS: 1_000_000_000, uploadBPS: 500_000_000)
        _ = view.body
    }

    // MARK: - AppsIconView Tests

    func testAppsIconViewCreates() {
        let view = AppsIconView()
        XCTAssertNotNil(view)
        _ = view.body
    }
}
