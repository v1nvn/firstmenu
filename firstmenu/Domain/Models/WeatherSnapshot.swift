//
//  WeatherSnapshot.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// A snapshot of weather conditions at a point in time.
public struct WeatherSnapshot: Sendable, Equatable, Codable {
    /// Temperature in Celsius
    public let temperature: Double

    /// Weather condition code for icon mapping
    public let conditionCode: Int

    public init(temperature: Double, conditionCode: Int) {
        self.temperature = temperature
        self.conditionCode = conditionCode
    }

    /// Returns the SF Symbol name for the current weather condition.
    public var sfSymbolName: String {
        switch conditionCode {
        case 0:       return "sun.max.fill"           // Clear sky
        case 1, 2, 3: return "cloud.sun.fill"         // Partly cloudy
        case 45, 48:  return "cloud.fill"             // Foggy
        case 51, 53, 55: return "cloud.drizzle.fill"  // Drizzle
        case 61, 63, 65: return "cloud.rain.fill"     // Rain
        case 71, 73, 75, 77: return "cloud.snow.fill" // Snow
        case 80, 81, 82: return "cloud.heavyrain.fill" // Rain showers
        case 95, 96, 99: return "cloud.bolt.fill"     // Thunderstorm
        default:       return "questionmark"
        }
    }
}
