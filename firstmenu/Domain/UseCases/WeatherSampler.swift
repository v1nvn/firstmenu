//
//  WeatherSampler.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation
import Observation

/// Samples weather data periodically.
@MainActor
@Observable
public final class WeatherSampler {
    private let weatherProvider: WeatherProviding

    private var cachedWeather: WeatherSnapshot?
    private var lastUpdate: Date?
    private let cacheInterval: TimeInterval = 15 * 60  // 15 minutes

    public var currentWeather: WeatherSnapshot?

    public init(weatherProvider: WeatherProviding) {
        self.weatherProvider = weatherProvider
    }

    /// Samples the current weather, using cached data if available and fresh.
    public func sample() async {
        let now = Date()

        if let cached = cachedWeather,
           let lastUpdate = lastUpdate,
           now.timeIntervalSince(lastUpdate) < cacheInterval {
            currentWeather = cached
            return
        }

        do {
            let weather = try await weatherProvider.currentWeather()
            cachedWeather = weather
            lastUpdate = now
            currentWeather = weather
        } catch {
            // On error, keep using cached data if available
            if cachedWeather == nil {
                // Provide a default placeholder on first failure
                currentWeather = WeatherSnapshot(temperature: 0, conditionCode: -1)
            }
        }
    }

    /// Forces a refresh of weather data, bypassing the cache.
    public func refresh() async {
        cachedWeather = nil
        lastUpdate = nil
        await sample()
    }
}
