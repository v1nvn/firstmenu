//
//  WeatherSamplerTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

@MainActor
final class WeatherSamplerTests: XCTestCase {
    func testSampleSetsCurrentWeather() async throws {
        let weatherProvider = MockWeatherProvider()
        let expectedWeather = WeatherSnapshot(temperature: 28.5, conditionCode: 0)
        await weatherProvider.setWeather(expectedWeather)

        let sampler = WeatherSampler(weatherProvider: weatherProvider)
        await sampler.sample()

        XCTAssertEqual(sampler.currentWeather?.temperature, expectedWeather.temperature)
        XCTAssertEqual(sampler.currentWeather?.conditionCode, expectedWeather.conditionCode)
    }

    func testSampleUsesCachedData() async throws {
        let weatherProvider = MockWeatherProvider()
        let initialWeather = WeatherSnapshot(temperature: 25, conditionCode: 1)
        await weatherProvider.setWeather(initialWeather)

        let sampler = WeatherSampler(weatherProvider: weatherProvider)
        await sampler.sample()

        XCTAssertEqual(sampler.currentWeather?.temperature, 25)

        // Change the provider's return value
        let newWeather = WeatherSnapshot(temperature: 30, conditionCode: 0)
        await weatherProvider.setWeather(newWeather)

        // Immediately sampling again should use cached value (15 min cache)
        await sampler.sample()

        XCTAssertEqual(sampler.currentWeather?.temperature, 25)  // Still cached
    }

    func testRefreshBypassesCache() async throws {
        let weatherProvider = MockWeatherProvider()
        let initialWeather = WeatherSnapshot(temperature: 25, conditionCode: 1)
        await weatherProvider.setWeather(initialWeather)

        let sampler = WeatherSampler(weatherProvider: weatherProvider)
        await sampler.sample()

        XCTAssertEqual(sampler.currentWeather?.temperature, 25)

        // Change the provider's return value
        let newWeather = WeatherSnapshot(temperature: 35, conditionCode: 0)
        await weatherProvider.setWeather(newWeather)

        // Refresh should bypass cache
        await sampler.refresh()

        XCTAssertEqual(sampler.currentWeather?.temperature, 35)  // New value
    }

    func testSampleWithProviderError() async throws {
        let weatherProvider = MockWeatherProvider()
        await weatherProvider.setShouldThrow(true)

        let sampler = WeatherSampler(weatherProvider: weatherProvider)
        await sampler.sample()

        // On error, should keep nil or set default
        // The implementation sets a default placeholder on first failure
        XCTAssertNotNil(sampler.currentWeather)
    }

    func testSampleWithProviderErrorAfterSuccess() async throws {
        let weatherProvider = MockWeatherProvider()
        let initialWeather = WeatherSnapshot(temperature: 25, conditionCode: 1)
        await weatherProvider.setWeather(initialWeather)

        let sampler = WeatherSampler(weatherProvider: weatherProvider)
        await sampler.sample()

        XCTAssertEqual(sampler.currentWeather?.temperature, 25)

        // Provider fails
        await weatherProvider.setShouldThrow(true)

        await sampler.sample()

        // Should keep the cached value from previous successful fetch
        XCTAssertEqual(sampler.currentWeather?.temperature, 25)
    }
}
