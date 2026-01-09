//
//  StatLabelViews.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI

// MARK: - Display Mode

/// Display mode for menu bar items
enum MenuBarDisplayMode: String {
    case icon = "icon"
    case value = "value"
    case both = "both"

    var displayName: String {
        switch self {
        case .icon: return "Icon"
        case .value: return "Value"
        case .both: return "Both"
        }
    }
}

// MARK: - CPU Stat Label

struct CPUStatLabelView: View {
    let percentage: Double
    var displayMode: MenuBarDisplayMode = .value

    private var safePercentage: Int {
        guard percentage.isFinite else { return 0 }
        return max(0, min(100, Int(percentage)))
    }

    var body: some View {
        switch displayMode {
        case .icon:
            Image(systemName: "cpu")
                .font(.system(size: DesignSystem.MenuBar.iconSize))
                .foregroundStyle(.primary)
        case .value:
            Text("\(safePercentage)%")
                .menuBarMonospaced()
        case .both:
            HStack(spacing: DesignSystem.Spacing.extraTight) {
                Image(systemName: "cpu")
                    .font(.system(size: DesignSystem.MenuBar.iconSize))
                Text("\(safePercentage)%")
                    .menuBarMonospaced()
            }
        }
    }
}

// MARK: - RAM Stat Label

struct RAMStatLabelView: View {
    let used: Int64
    let total: Int64
    var displayMode: MenuBarDisplayMode = .value

    private var usedGB: String {
        String(format: "%.1f", Double(used) / 1_073_741_824)
    }

    private var percentage: Int {
        guard total > 0 else { return 0 }
        return Int(Double(used) / Double(total) * 100)
    }

    var body: some View {
        switch displayMode {
        case .icon:
            Image(systemName: "memorychip")
                .font(.system(size: DesignSystem.MenuBar.iconSize))
                .foregroundStyle(.primary)
        case .value:
            Text("\(usedGB)G")
                .menuBarMonospaced()
        case .both:
            HStack(spacing: DesignSystem.Spacing.extraTight) {
                Image(systemName: "memorychip")
                    .font(.system(size: DesignSystem.MenuBar.iconSize))
                Text("\(usedGB)G")
                    .menuBarMonospaced()
            }
        }
    }
}

// MARK: - SSD Stat Label

struct SSDStatLabelView: View {
    let used: Int64
    let total: Int64
    var displayMode: MenuBarDisplayMode = .value

    private var percentage: Int {
        guard total > 0 else { return 0 }
        return Int(Double(used) / Double(total) * 100)
    }

    var body: some View {
        switch displayMode {
        case .icon:
            Image(systemName: "internaldrive")
                .font(.system(size: DesignSystem.MenuBar.iconSize))
                .foregroundStyle(.primary)
        case .value:
            Text("\(percentage)%")
                .menuBarMonospaced()
        case .both:
            HStack(spacing: DesignSystem.Spacing.extraTight) {
                Image(systemName: "internaldrive")
                    .font(.system(size: DesignSystem.MenuBar.iconSize))
                Text("\(percentage)%")
                    .menuBarMonospaced()
            }
        }
    }
}

// MARK: - Weather Stat Label

struct WeatherStatLabelView: View {
    let temperature: Double
    let sfSymbolName: String
    var displayMode: MenuBarDisplayMode = .both

    private var safeTemperature: Int {
        guard temperature.isFinite else { return 0 }
        return Int(temperature)
    }

    var body: some View {
        switch displayMode {
        case .icon:
            Image(systemName: sfSymbolName)
                .font(.system(size: DesignSystem.MenuBar.iconSize))
                .foregroundStyle(.primary)
        case .value:
            Text("\(safeTemperature)°")
                .menuBarMonospaced()
        case .both:
            HStack(spacing: DesignSystem.Spacing.extraTight) {
                Image(systemName: sfSymbolName)
                    .font(.system(size: DesignSystem.MenuBar.iconSize))
                Text("\(safeTemperature)°")
                    .menuBarMonospaced()
            }
        }
    }
}

// MARK: - Network Stat Label

struct NetworkStatLabelView: View {
    let downloadBPS: Int64
    let uploadBPS: Int64
    var displayMode: MenuBarDisplayMode = .value

    private func formatSpeed(_ bps: Int64) -> String {
        let kb = Double(bps) / 1024
        let mb = kb / 1024
        if mb >= 1 {
            return String(format: "%.0fM", mb)
        } else if kb >= 1 {
            return String(format: "%.0fK", kb)
        }
        return "0"
    }

    private var isActive: Bool {
        downloadBPS > 0 || uploadBPS > 0
    }

    var body: some View {
        switch displayMode {
        case .icon:
            Image(systemName: isActive ? "antenna.radiowaves.left.and.right" : "network.slash")
                .font(.system(size: DesignSystem.MenuBar.iconSize))
                .foregroundStyle(isActive ? .primary : .secondary)
        case .value:
            networkSpeedView
                .menuBarMonospaced()
                .foregroundStyle(isActive ? .primary : .secondary)
        case .both:
            HStack(spacing: DesignSystem.Spacing.extraTight) {
                Image(systemName: isActive ? "antenna.radiowaves.left.and.right" : "network.slash")
                    .font(.system(size: DesignSystem.MenuBar.iconSize))
                networkSpeedView
            }
            .menuBarMonospaced()
            .foregroundStyle(isActive ? .primary : .secondary)
        }
    }

    @ViewBuilder
    private var networkSpeedView: some View {
        if isActive {
            HStack(spacing: 2) {
                Image(systemName: "arrow.down")
                    .font(.system(size: 9, weight: .medium))
                Text(formatSpeed(downloadBPS))
                Image(systemName: "arrow.up")
                    .font(.system(size: 9, weight: .medium))
                Text(formatSpeed(uploadBPS))
            }
        } else {
            Text("- -")
        }
    }
}

// MARK: - Apps Icon

struct AppsIconView: View {
    var displayMode: MenuBarDisplayMode = .icon

    var body: some View {
        Image(systemName: "app.dashed")
            .font(.system(size: DesignSystem.MenuBar.iconSize))
            .foregroundStyle(.primary)
    }
}

// MARK: - Preview

#Preview("Menu Bar Items") {
    HStack(spacing: DesignSystem.Spacing.standard) {
        CPUStatLabelView(percentage: 45, displayMode: .value)
        RAMStatLabelView(used: 8_400_000_000, total: 16_000_000_000, displayMode: .value)
        SSDStatLabelView(used: 200_000_000_000, total: 500_000_000_000, displayMode: .value)
        WeatherStatLabelView(temperature: 28, sfSymbolName: "sun.max.fill", displayMode: .both)
        NetworkStatLabelView(downloadBPS: 1_000_000, uploadBPS: 500_000, displayMode: .value)
        AppsIconView(displayMode: .icon)
    }
    .padding()
    .background(Color.black)
}
