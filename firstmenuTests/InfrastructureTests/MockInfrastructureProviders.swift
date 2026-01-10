//
//  MockInfrastructureProviders.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation
@testable import firstmenu

// MARK: - Mock CPU Provider

actor MockCPUProvider: CPUProviding {
    private var _cpuPercentage: Double = 50.0
    private var _shouldThrow: Bool = false

    func cpuPercentage() async throws -> Double {
        if _shouldThrow {
            throw CPUError.readFailed
        }
        return _cpuPercentage
    }

    func setCPUPercentage(_ value: Double) {
        _cpuPercentage = value
    }

    func setShouldThrow(_ value: Bool) {
        _shouldThrow = value
    }
}

// MARK: - Mock RAM Provider

actor MockRAMProvider: RAMProviding {
    private var _ramUsed: Int64 = 8_000_000_000
    private var _ramTotal: Int64 = 16_000_000_000
    private var _shouldThrow: Bool = false

    func ramUsage() async throws -> (used: Int64, total: Int64) {
        if _shouldThrow {
            throw RAMError.readFailed
        }
        return (used: _ramUsed, total: _ramTotal)
    }

    func setRAM(used: Int64, total: Int64) {
        _ramUsed = used
        _ramTotal = total
    }

    func setShouldThrow(_ value: Bool) {
        _shouldThrow = value
    }
}

// MARK: - Mock Storage Provider

actor MockStorageProvider: StorageProviding {
    private var _storageUsed: Int64 = 250_000_000_000
    private var _storageTotal: Int64 = 500_000_000_000
    private var _shouldThrow: Bool = false

    func storageUsage() async throws -> (used: Int64, total: Int64) {
        if _shouldThrow {
            throw StorageError.readFailed
        }
        return (used: _storageUsed, total: _storageTotal)
    }

    func setStorage(used: Int64, total: Int64) {
        _storageUsed = used
        _storageTotal = total
    }

    func setShouldThrow(_ value: Bool) {
        _shouldThrow = value
    }
}

// MARK: - Mock Network Provider

actor MockNetworkProvider: NetworkProviding {
    private var _downloadBPS: Int64 = 1_000_000
    private var _uploadBPS: Int64 = 500_000
    private var _shouldThrow: Bool = false

    func networkSpeed() async throws -> (downloadBPS: Int64, uploadBPS: Int64) {
        if _shouldThrow {
            throw NetworkError.readFailed
        }
        return (downloadBPS: _downloadBPS, uploadBPS: _uploadBPS)
    }

    func setNetwork(downloadBPS: Int64, uploadBPS: Int64) {
        _downloadBPS = downloadBPS
        _uploadBPS = uploadBPS
    }

    func setShouldThrow(_ value: Bool) {
        _shouldThrow = value
    }
}

// MARK: - Mock Weather Provider

actor MockWeatherProvider: WeatherProviding {
    private var _weather: WeatherSnapshot = WeatherSnapshot(temperature: 25, conditionCode: 0)
    private var _shouldThrow: Bool = false

    func currentWeather() async throws -> WeatherSnapshot {
        if _shouldThrow {
            throw WeatherError.locationDetectionFailed
        }
        return _weather
    }

    func setWeather(_ weather: WeatherSnapshot) {
        _weather = weather
    }

    func setShouldThrow(_ value: Bool) {
        _shouldThrow = value
    }
}

// MARK: - Mock App Lister

actor MockAppLister: AppListing {
    private var _apps: [AppProcess] = []
    private var _shouldThrow: Bool = false
    private var _quitCallCount: [String] = []

    func runningApps() async throws -> [AppProcess] {
        if _shouldThrow {
            throw AppError.notFound
        }
        return _apps
    }

    func quitApp(bundleIdentifier: String) async throws {
        if _shouldThrow {
            throw AppError.terminateFailed
        }
        // Check if app exists (comparing nil-coalesced to empty string for nil bundle IDs)
        let appExists = _apps.contains(where: { ($0.bundleIdentifier ?? "") == bundleIdentifier })
        guard appExists else {
            throw AppError.notFound
        }
        _quitCallCount.append(bundleIdentifier)
        // Actually remove the app from the list (simulating real behavior)
        _apps.removeAll { ($0.bundleIdentifier ?? "") == bundleIdentifier }
    }

    func setApps(_ apps: [AppProcess]) {
        _apps = apps
    }

    func setShouldThrow(_ value: Bool) {
        _shouldThrow = value
    }

    func quitCallCount() -> [String] {
        _quitCallCount
    }
}

// MARK: - Mock Power Provider

@MainActor
@Observable
final class MockPowerProvider: PowerAssertionProviding {
    public private(set) var state: CaffeinateState = .inactive
    private var _shouldThrow: Bool = false

    public init() {}

    public func activate(duration: TimeInterval?) async throws {
        if _shouldThrow {
            throw PowerError.activationFailed
        }

        if let duration = duration {
            self.state = .active(until: Date().addingTimeInterval(duration))
        } else {
            self.state = .indefinite
        }
    }

    public func deactivate() async throws {
        if _shouldThrow {
            throw PowerError.deactivationFailed
        }
        self.state = .inactive
    }

    public func reset(duration: TimeInterval) async throws {
        if _shouldThrow {
            throw PowerError.activationFailed
        }
        self.state = .active(until: Date().addingTimeInterval(duration))
    }

    func setShouldThrow(_ value: Bool) {
        _shouldThrow = value
    }
}
