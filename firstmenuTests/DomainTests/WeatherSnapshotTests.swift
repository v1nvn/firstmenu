//
//  WeatherSnapshotTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

final class WeatherSnapshotTests: XCTestCase {
    func testWeatherSnapshotInitialization() {
        let snapshot = WeatherSnapshot(temperature: 25.0, conditionCode: 0)

        XCTAssertEqual(snapshot.temperature, 25.0)
        XCTAssertEqual(snapshot.conditionCode, 0)
    }

    func testSFSymbolNameForClearSky() {
        let snapshot = WeatherSnapshot(temperature: 30, conditionCode: 0)
        XCTAssertEqual(snapshot.sfSymbolName, "sun.max.fill")
    }

    func testSFSymbolNameForPartlyCloudy() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 1).sfSymbolName, "sun.max.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 2).sfSymbolName, "cloud.sun.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 3).sfSymbolName, "cloud.fill")
    }

    func testSFSymbolNameForFog() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 45).sfSymbolName, "cloud.fog.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 48).sfSymbolName, "cloud.fog.fill")
    }

    func testSFSymbolNameForDrizzle() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 51).sfSymbolName, "cloud.drizzle.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 53).sfSymbolName, "cloud.drizzle.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 55).sfSymbolName, "cloud.drizzle.fill")
    }

    func testSFSymbolNameForRain() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 61).sfSymbolName, "cloud.rain.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 63).sfSymbolName, "cloud.rain.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 65).sfSymbolName, "cloud.rain.fill")
    }

    func testSFSymbolNameForSnow() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 71).sfSymbolName, "cloud.snow.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 73).sfSymbolName, "cloud.snow.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 75).sfSymbolName, "cloud.snow.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 77).sfSymbolName, "cloud.snow.fill")
    }

    func testSFSymbolNameForRainShowers() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 80).sfSymbolName, "cloud.heavyrain.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 81).sfSymbolName, "cloud.heavyrain.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 82).sfSymbolName, "cloud.heavyrain.fill")
    }

    func testSFSymbolNameForThunderstorm() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 95).sfSymbolName, "cloud.bolt.rain.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 96).sfSymbolName, "cloud.bolt.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 99).sfSymbolName, "cloud.bolt.fill")
    }

    func testSFSymbolNameForUnknownCode() {
        let snapshot = WeatherSnapshot(temperature: 0, conditionCode: 999)
        XCTAssertEqual(snapshot.sfSymbolName, "questionmark")
    }

    func testCodable() throws {
        let snapshot = WeatherSnapshot(temperature: 28.5, conditionCode: 0)

        let encoder = JSONEncoder()
        let data = try encoder.encode(snapshot)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(WeatherSnapshot.self, from: data)

        XCTAssertEqual(decoded.temperature, snapshot.temperature)
        XCTAssertEqual(decoded.conditionCode, snapshot.conditionCode)
    }

    // MARK: - Edge Cases

    func testNegativeTemperature() {
        let snapshot = WeatherSnapshot(temperature: -20.5, conditionCode: 71)  // Snow
        XCTAssertEqual(snapshot.temperature, -20.5)
        XCTAssertEqual(snapshot.sfSymbolName, "cloud.snow.fill")
    }

    func testExtremeHotTemperature() {
        let snapshot = WeatherSnapshot(temperature: 50, conditionCode: 0)  // Clear
        XCTAssertEqual(snapshot.temperature, 50)
        XCTAssertEqual(snapshot.sfSymbolName, "sun.max.fill")
    }

    func testFreezingDrizzleCodes() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 56).sfSymbolName, "cloud.drizzle.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 57).sfSymbolName, "cloud.drizzle.fill")
    }

    func testFreezingRainCodes() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 66).sfSymbolName, "cloud.rain.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 67).sfSymbolName, "cloud.rain.fill")
    }

    func testSnowShowers() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 85).sfSymbolName, "cloud.snow.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 86).sfSymbolName, "cloud.snow.fill")
    }

    func testThunderstormWithHail() {
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 96).sfSymbolName, "cloud.bolt.fill")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 99).sfSymbolName, "cloud.bolt.fill")
    }

    func testNegativeConditionCode() {
        let snapshot = WeatherSnapshot(temperature: 20, conditionCode: -1)
        XCTAssertEqual(snapshot.sfSymbolName, "questionmark", "Negative codes should return questionmark")
    }

    func testZeroTemperature() {
        let snapshot = WeatherSnapshot(temperature: 0, conditionCode: 0)
        XCTAssertEqual(snapshot.temperature, 0)
    }

    func testFractionalTemperature() {
        let snapshot = WeatherSnapshot(temperature: 23.7, conditionCode: 0)
        XCTAssertEqual(snapshot.temperature, 23.7, accuracy: 0.01)
    }

    func testAllWMOCodesHaveSymbols() {
        // Test all defined WMO codes
        let definedCodes = [0, 1, 2, 3, 45, 48, 51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 71, 73, 75, 77, 80, 81, 82, 85, 86, 95, 96, 99]

        for code in definedCodes {
            let snapshot = WeatherSnapshot(temperature: 20, conditionCode: code)
            let symbol = snapshot.sfSymbolName
            XCTAssertNotEqual(symbol, "questionmark", "Code \(code) should have a defined symbol")
        }
    }

    func testUndefinedCodesReturnQuestionmark() {
        let undefinedCodes = [4, 5, 10, 20, 30, 40, 50, 60, 70, 90, 100, 1000]

        for code in undefinedCodes {
            let snapshot = WeatherSnapshot(temperature: 20, conditionCode: code)
            XCTAssertEqual(snapshot.sfSymbolName, "questionmark", "Undefined code \(code) should return questionmark")
        }
    }

    func testEquatable() {
        let snapshot1 = WeatherSnapshot(temperature: 25, conditionCode: 0)
        let snapshot2 = WeatherSnapshot(temperature: 25, conditionCode: 0)
        let snapshot3 = WeatherSnapshot(temperature: 26, conditionCode: 0)
        let snapshot4 = WeatherSnapshot(temperature: 25, conditionCode: 1)

        XCTAssertEqual(snapshot1, snapshot2, "Snapshots with same values should be equal")
        XCTAssertNotEqual(snapshot1, snapshot3, "Snapshots with different temperatures should not be equal")
        XCTAssertNotEqual(snapshot1, snapshot4, "Snapshots with different condition codes should not be equal")
    }

    func testCodableWithExtremeValues() throws {
        let snapshot = WeatherSnapshot(temperature: -100, conditionCode: 999)

        let encoder = JSONEncoder()
        let data = try encoder.encode(snapshot)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(WeatherSnapshot.self, from: data)

        XCTAssertEqual(decoded.temperature, -100)
        XCTAssertEqual(decoded.conditionCode, 999)
    }

    func testCodablePreservesSFSymbolName() throws {
        let snapshot = WeatherSnapshot(temperature: 20, conditionCode: 95)  // Thunderstorm

        let encoder = JSONEncoder()
        let data = try encoder.encode(snapshot)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(WeatherSnapshot.self, from: data)

        XCTAssertEqual(decoded.sfSymbolName, "cloud.bolt.rain.fill")
    }

    func testBoundaryConditionCodes() {
        // Test codes around defined ranges
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 43).sfSymbolName, "questionmark")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 44).sfSymbolName, "questionmark")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 45).sfSymbolName, "cloud.fog.fill")

        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 49).sfSymbolName, "questionmark")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 50).sfSymbolName, "questionmark")
        XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: 51).sfSymbolName, "cloud.drizzle.fill")
    }

    func testAllRainCodes() {
        let rainCodes = [61, 63, 65, 66, 67]
        for code in rainCodes {
            XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: code).sfSymbolName, "cloud.rain.fill")
        }
    }

    func testAllDrizzleCodes() {
        let drizzleCodes = [51, 53, 55, 56, 57]
        for code in drizzleCodes {
            XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: code).sfSymbolName, "cloud.drizzle.fill")
        }
    }

    func testAllSnowCodes() {
        let snowCodes = [71, 73, 75, 77, 85, 86]
        for code in snowCodes {
            XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: code).sfSymbolName, "cloud.snow.fill")
        }
    }

    func testAllRainShowerCodes() {
        let rainShowerCodes = [80, 81, 82]
        for code in rainShowerCodes {
            XCTAssertEqual(WeatherSnapshot(temperature: 0, conditionCode: code).sfSymbolName, "cloud.heavyrain.fill")
        }
    }

    func testAllThunderstormCodes() {
        let thunderstormCodes = [95, 96, 99]
        for code in thunderstormCodes {
            let symbol = WeatherSnapshot(temperature: 0, conditionCode: code).sfSymbolName
            XCTAssertTrue(symbol.contains("bolt"), "Thunderstorm code \(code) should have bolt in symbol name")
        }
    }

    func testTemperatureDoesNotAffectSymbol() {
        let coldClear = WeatherSnapshot(temperature: -30, conditionCode: 0)
        let hotClear = WeatherSnapshot(temperature: 50, conditionCode: 0)

        XCTAssertEqual(coldClear.sfSymbolName, hotClear.sfSymbolName, "Temperature should not affect symbol selection")
    }

    func testZeroConditionCode() {
        let snapshot = WeatherSnapshot(temperature: 20, conditionCode: 0)
        XCTAssertEqual(snapshot.conditionCode, 0)
        XCTAssertEqual(snapshot.sfSymbolName, "sun.max.fill")
    }

    func testVeryLargeConditionCode() {
        let snapshot = WeatherSnapshot(temperature: 20, conditionCode: Int.max)
        XCTAssertEqual(snapshot.sfSymbolName, "questionmark")
    }
}
