//
//  StatPopoverViews.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI

// MARK: - CPU Popover

struct CPUPopoverView: View {
    @State private var state = MenuBarState.shared

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
            HStack {
                Text("CPU")
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
                Text("\(Int(state.cpuPercentage))%")
                    .font(.system(size: 13, weight: .medium).monospacedDigit())
                    .foregroundStyle(DesignSystem.Colors.progressColor(for: state.cpuPercentage))
            }

            ProgressView(value: state.cpuPercentage / 100)
                .progressViewStyle(.linear)
                .tint(DesignSystem.Colors.progressColor(for: state.cpuPercentage))

            HStack {
                Text("Cores")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(state.coreCount)")
                    .font(.system(size: 11).monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(width: DesignSystem.Popover.Width.standard)
    }
}

// MARK: - RAM Popover

struct RAMPopoverView: View {
    @State private var state = MenuBarState.shared

    private var usedGB: Double {
        Double(state.ramUsed) / 1_073_741_824
    }

    private var totalGB: Double {
        Double(state.ramTotal) / 1_073_741_824
    }

    private var percentage: Double {
        Double(state.ramUsed) / Double(state.ramTotal) * 100
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
            HStack {
                Text("Memory")
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
                Text("\(Int(percentage))%")
                    .font(.system(size: 13, weight: .medium).monospacedDigit())
                    .foregroundStyle(DesignSystem.Colors.progressColor(for: percentage))
            }

            ProgressView(value: percentage / 100)
                .progressViewStyle(.linear)
                .tint(DesignSystem.Colors.progressColor(for: percentage))

            HStack {
                Text(String(format: "%.1f of %.1f GB", usedGB, totalGB))
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding()
        .frame(width: DesignSystem.Popover.Width.wide)
    }
}

// MARK: - Storage Popover

struct StoragePopoverView: View {
    @State private var state = MenuBarState.shared

    private var usedGB: Double {
        Double(state.storageUsed) / 1_073_741_824
    }

    private var totalGB: Double {
        Double(state.storageTotal) / 1_073_741_824
    }

    private var percentage: Double {
        Double(state.storageUsed) / Double(state.storageTotal) * 100
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
            HStack {
                Text("Storage")
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
                Text("\(Int(percentage))%")
                    .font(.system(size: 13, weight: .medium).monospacedDigit())
                    .foregroundStyle(DesignSystem.Colors.progressColor(for: percentage, thresholds: (80, 95)))
            }

            ProgressView(value: percentage / 100)
                .progressViewStyle(.linear)
                .tint(DesignSystem.Colors.progressColor(for: percentage, thresholds: (80, 95)))

            HStack {
                Text(String(format: "%.0f of %.0f GB free", totalGB - usedGB, totalGB))
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding()
        .frame(width: DesignSystem.Popover.Width.wide)
    }
}

// MARK: - Weather Popover

struct WeatherPopoverView: View {
    @State private var state = MenuBarState.shared

    private var conditionText: String {
        switch state.conditionCode {
        case 0: return "Clear"
        case 1...3: return "Partly cloudy"
        case 45, 48: return "Foggy"
        case 51...67: return "Rainy"
        case 71...77: return "Snowy"
        case 80...82: return "Showers"
        case 95...99: return "Thunderstorm"
        default: return "Unknown"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
            HStack {
                Text("Weather")
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
                HStack(spacing: DesignSystem.Spacing.tight) {
                    Image(systemName: state.sfSymbolName)
                    Text("\(Int(state.temperature))°")
                        .font(.system(size: 13, weight: .medium).monospacedDigit())
                }
            }

            HStack {
                Text(conditionText)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("IP-based")
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .frame(width: DesignSystem.Popover.Width.wide)
    }
}

// MARK: - Network Popover

struct NetworkPopoverView: View {
    @State private var state = MenuBarState.shared

    private func formatSpeed(_ bps: Int64) -> String {
        let kb = Double(bps) / 1024
        let mb = kb / 1024
        if mb >= 1 {
            return String(format: "%.1f MB/s", mb)
        } else if kb >= 1 {
            return String(format: "%.0f KB/s", kb)
        }
        return "0 B/s"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
            HStack {
                Text("Network")
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
            }

            HStack {
                Image(systemName: "arrow.down")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                Text(formatSpeed(state.downloadBPS))
                    .font(.system(size: 12, weight: .medium).monospacedDigit())
                Spacer()
            }

            HStack {
                Image(systemName: "arrow.up")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                Text(formatSpeed(state.uploadBPS))
                    .font(.system(size: 12, weight: .medium).monospacedDigit())
                Spacer()
            }

            if state.downloadBPS == 0 && state.uploadBPS == 0 {
                Text("No activity")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .frame(width: DesignSystem.Popover.Width.standard)
    }
}

// MARK: - Apps Popover (placeholder)

struct AppsPopoverView: View {
    var body: some View {
        Text("Apps coming soon")
            .padding()
    }
}

// MARK: - Previews

#Preview("CPU") {
    CPUPopoverView()
        .padding()
        .background(Color.black)
}

#Preview("RAM") {
    RAMPopoverView()
        .padding()
        .background(Color.black)
}

#Preview("Storage") {
    StoragePopoverView()
        .padding()
        .background(Color.black)
}

#Preview("Weather") {
    WeatherPopoverView()
        .padding()
        .background(Color.black)
}

#Preview("Network") {
    NetworkPopoverView()
        .padding()
        .background(Color.black)
}
