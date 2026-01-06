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
    /// Based on WMO weather interpretation codes (WW).
    public var sfSymbolName: String {
        switch conditionCode {
        // Clear sky
        case 0:
            return "sun.max.fill"

        // Partly cloudy (1-3)
        case 1:
            return "sun.max.fill"           // Mainly clear
        case 2:
            return "cloud.sun.fill"         // Partly cloudy
        case 3:
            return "cloud.fill"             // Overcast

        // Fog (45, 48)
        case 45, 48:
            return "cloud.fog.fill"

        // Drizzle (51-55, 56-57)
        case 51, 53, 55:
            return "cloud.drizzle.fill"
        case 56, 57:
            return "cloud.drizzle.fill"     // Freezing drizzle

        // Rain (61-65, 66-67)
        case 61, 63, 65:
            return "cloud.rain.fill"
        case 66, 67:
            return "cloud.rain.fill"        // Freezing rain

        // Snow (71-77)
        case 71, 73, 75, 77:
            return "cloud.snow.fill"

        // Snow showers (85-86)
        case 85, 86:
            return "cloud.snow.fill"

        // Rain showers (80-82)
        case 80, 81, 82:
            return "cloud.heavyrain.fill"

        // Thunderstorm (95-99)
        case 95:
            return "cloud.bolt.rain.fill"
        case 96, 99:
            return "cloud.bolt.fill"        // Thunderstorm with hail

        default:
            return "questionmark"
        }
    }
}
