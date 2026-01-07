//
//  MenuBarManager.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import Observation

/// Shared state for all menu bar items - singleton accessible from popover views
@Observable
@MainActor
class MenuBarState {
    static let shared = MenuBarState()

    var cpuPercentage: Double = 0
    var ramUsed: Int64 = 0
    var ramTotal: Int64 = 0
    var storageUsed: Int64 = 0
    var storageTotal: Int64 = 0
    var temperature: Double = 0
    var conditionCode: Int = 0
    var sfSymbolName: String = "sun.max.fill"
    var downloadBPS: Int64 = 0
    var uploadBPS: Int64 = 0
    var coreCount: Int = 0
    var ramPressure: String = "Normal"

    /// Caffeinate (keep-awake) state for the power controller
    var caffeinateState: CaffeinateState = .inactive
    var powerController: PowerAssertionController?

    private var statsSampler: StatsSampler?
    private var weatherSampler: WeatherSampler?

    private init() {}

    func startUpdating() {
        // Initial sample
        Task { await sample() }

        // Update every second
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.sampleStats()
            }
        }

        // Weather updates less frequently - every 15 minutes
        Timer.scheduledTimer(withTimeInterval: 15 * 60, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.sampleWeather()
            }
        }
    }

    private func sample() async {
        try? await statsSampler?.sample()
        await weatherSampler?.sample()
        updateFromSamplers()
    }

    private func sampleStats() async {
        try? await statsSampler?.sample()
        updateFromSamplers()
    }

    private func sampleWeather() async {
        await weatherSampler?.sample()
        updateFromSamplers()
    }

    private func updateFromSamplers() {
        guard let snapshot = statsSampler?.currentSnapshot,
              let weather = weatherSampler?.currentWeather else {
            return
        }

        cpuPercentage = snapshot.cpuPercentage
        ramUsed = snapshot.ramUsed
        ramTotal = snapshot.ramTotal
        storageUsed = snapshot.storageUsed
        storageTotal = snapshot.storageTotal
        downloadBPS = snapshot.networkDownloadBPS
        uploadBPS = snapshot.networkUploadBPS
        temperature = weather.temperature
        conditionCode = weather.conditionCode
        sfSymbolName = weather.sfSymbolName
        coreCount = cpuCoreCount()
        ramPressure = calculateRamPressure()

        // Update caffeinate state from power controller
        caffeinateState = powerController?.state ?? .inactive
    }

    private func cpuCoreCount() -> Int {
        var count: Int = 0
        var size: Int = MemoryLayout<Int>.size
        sysctlbyname("hw.logicalcpu", &count, &size, nil, 0)
        return max(count, 1)
    }

    private func calculateRamPressure() -> String {
        let percent = Double(ramUsed) / Double(ramTotal) * 100
        if percent > 90 {
            return "Critical"
        } else if percent > 75 {
            return "High"
        }
        return "Normal"
    }

    func setSamplers(stats: StatsSampler, weather: WeatherSampler) {
        self.statsSampler = stats
        self.weatherSampler = weather
    }

    func setPowerController(_ controller: PowerAssertionController) {
        self.powerController = controller
    }
}
