//
//  WeatherProviding.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Provides weather data.
public protocol WeatherProviding: Sendable {
    /// Returns the current weather conditions.
    /// - Returns: A `WeatherSnapshot` containing current temperature and condition.
    /// - Throws: An error if weather data cannot be retrieved.
    func currentWeather() async throws -> WeatherSnapshot
}
