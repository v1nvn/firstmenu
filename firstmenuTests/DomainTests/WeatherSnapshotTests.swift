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
}
