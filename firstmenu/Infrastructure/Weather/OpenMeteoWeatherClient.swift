//
//  OpenMeteoWeatherClient.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Weather client using Open-Meteo API (no API key required).
public actor OpenMeteoWeatherClient: WeatherProviding {

    private struct WeatherResponse: Decodable {
        let current: CurrentWeather
        let currentUnits: CurrentUnits

        struct CurrentWeather: Decodable {
            let temperature: Double
            let weatherCode: Int

            enum CodingKeys: String, CodingKey {
                case temperature = "temperature_2m"
                case weatherCode = "weather_code"
            }
        }

        struct CurrentUnits: Decodable {
            let temperature: String

            enum CodingKeys: String, CodingKey {
                case temperature = "temperature_2m"
            }
        }
    }

    private let urlSession: URLSession
    private let cacheFile: URL
    private let cacheTTL: TimeInterval = 15 * 60  // 15 minutes

    private let baseURL = "https://api.open-meteo.com/v1/forecast?current=temperature_2m,weather_code"

    public init(urlSession: URLSession = .shared) throws {
        self.urlSession = urlSession

        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.cacheFile = cacheDir.appendingPathComponent("com.firstmenu.weather.cache")

        // Ensure cache directory exists
        try FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
    }

    public func currentWeather() async throws -> WeatherSnapshot {
        // Try to load from cache first
        if let cached = try loadFromCache() {
            return cached
        }

        // Detect location from IP (using ipapi.co for free location detection)
        let location = try await detectLocation()
        let lat = location.lat
        let lon = location.lon

        let urlString = "\(baseURL)&latitude=\(lat)&longitude=\(lon)"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        let (data, _) = try await urlSession.data(from: url)
        let response = try JSONDecoder().decode(WeatherResponse.self, from: data)

        let snapshot = WeatherSnapshot(
            temperature: response.current.temperature,
            conditionCode: response.current.weatherCode
        )

        // Cache the result
        try saveToCache(snapshot)

        return snapshot
    }

    private func detectLocation() async throws -> (lat: Double, lon: Double) {
        // Use ipapi.co for free IP-based geolocation
        guard let url = URL(string: "https://ipapi.co/json/") else {
            throw WeatherError.locationDetectionFailed
        }

        let (data, _) = try await urlSession.data(from: url)

        // Only decode latitude and longitude
        struct LocationResponse: Decodable {
            let latitude: Double
            let longitude: Double
        }

        let location = try JSONDecoder().decode(LocationResponse.self, from: data)
        return (lat: location.latitude, lon: location.longitude)
    }

    private func loadFromCache() throws -> WeatherSnapshot? {
        guard FileManager.default.fileExists(atPath: cacheFile.path) else {
            return nil
        }

        let attributes = try FileManager.default.attributesOfItem(atPath: cacheFile.path)
        guard let modificationDate = attributes[.modificationDate] as? Date else {
            return nil
        }

        if Date().timeIntervalSince(modificationDate) > cacheTTL {
            return nil
        }

        let data = try Data(contentsOf: cacheFile)
        return try JSONDecoder().decode(WeatherSnapshot.self, from: data)
    }

    private func saveToCache(_ snapshot: WeatherSnapshot) throws {
        let data = try JSONEncoder().encode(snapshot)
        try data.write(to: cacheFile)
    }
}

public enum WeatherError: Error {
    case invalidURL
    case locationDetectionFailed
    case decodingFailed
}
