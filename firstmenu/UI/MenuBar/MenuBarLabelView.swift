//
//  MenuBarLabelView.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI

/// The main menu bar label view that displays stats in a single line.
struct MenuBarLabelView: View {
    let statsSnapshot: StatsSnapshot
    let weatherSnapshot: WeatherSnapshot?

    var body: some View {
        HStack(spacing: 4) {
            Text("CPU \(formatCpu(statsSnapshot.cpuPercentage))")
            Text("•")
            Text("RAM \(formatRam(statsSnapshot.ramUsed, total: statsSnapshot.ramTotal))")
            Text("•")
            Text("SSD \(formatSsd(statsSnapshot.storageUsed, total: statsSnapshot.storageTotal))")
            if let weather = weatherSnapshot {
                Text("•")
                Image(systemName: weather.sfSymbolName)
                    .font(.system(size: 11))
                Text("\(formatTemperature(weather.temperature))")
            }
            if statsSnapshot.networkDownloadBPS > 0 || statsSnapshot.networkUploadBPS > 0 {
                Text("•")
                Text("↓ \(formatNetwork(statsSnapshot.networkDownloadBPS))")
                Text("↑ \(formatNetwork(statsSnapshot.networkUploadBPS))")
            }
        }
        .font(.system(size: 11, weight: .medium).monospacedDigit())
    }

    private func formatCpu(_ percentage: Double) -> String {
        String(format: "%.0f%%", percentage)
    }

    private func formatRam(_ used: Int64, total: Int64) -> String {
        String(format: "%.1fG", Double(used) / 1_073_741_824)
    }

    private func formatSsd(_ used: Int64, total: Int64) -> String {
        String(format: "%.0f%%", Double(used) / Double(total) * 100)
    }

    private func formatTemperature(_ celsius: Double) -> String {
        String(format: "%.0f°", celsius)
    }

    private func formatNetwork(_ bps: Int64) -> String {
        let kb = Double(bps) / 1024
        let mb = kb / 1024
        if mb >= 1 {
            return String(format: "%.0fM", mb)
        } else if kb >= 1 {
            return String(format: "%.0fK", kb)
        }
        return "0"
    }
}

#Preview {
    MenuBarLabelView(
        statsSnapshot: StatsSnapshot(
            cpuPercentage: 12,
            ramUsed: 10_000_000_000,
            ramTotal: 16_000_000_000,
            storageUsed: 200_000_000_000,
            storageTotal: 500_000_000_000,
            networkDownloadBPS: 1_000_000,
            networkUploadBPS: 500_000
        ),
        weatherSnapshot: WeatherSnapshot(temperature: 28, conditionCode: 0)
    )
    .padding()
}
