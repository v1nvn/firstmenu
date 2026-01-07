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

    var body: some View {
        switch displayMode {
        case .icon:
            Image(systemName: "cpu")
                .font(.system(size: DesignSystem.MenuBar.iconSize))
                .foregroundStyle(DesignSystem.Colors.menuBarText)
        case .value:
            Text("\(Int(percentage))%")
                .menuBarMonospaced()
        case .both:
            HStack(spacing: DesignSystem.Spacing.tight) {
                Image(systemName: "cpu")
                    .font(.system(size: DesignSystem.MenuBar.iconSize))
                Text("\(Int(percentage))%")
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
        Int(Double(used) / Double(total) * 100)
    }

    var body: some View {
        switch displayMode {
        case .icon:
            Image(systemName: "memorychip")
                .font(.system(size: DesignSystem.MenuBar.iconSize))
                .foregroundStyle(DesignSystem.Colors.menuBarText)
        case .value:
            Text("\(usedGB)G")
                .menuBarMonospaced()
        case .both:
            HStack(spacing: DesignSystem.Spacing.tight) {
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
        Int(Double(used) / Double(total) * 100)
    }

    var body: some View {
        switch displayMode {
        case .icon:
            Image(systemName: "internaldrive")
                .font(.system(size: DesignSystem.MenuBar.iconSize))
                .foregroundStyle(DesignSystem.Colors.menuBarText)
        case .value:
            Text("\(percentage)%")
                .menuBarMonospaced()
        case .both:
            HStack(spacing: DesignSystem.Spacing.tight) {
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

    var body: some View {
        switch displayMode {
        case .icon:
            Image(systemName: sfSymbolName)
                .font(.system(size: DesignSystem.MenuBar.iconSize))
                .foregroundStyle(DesignSystem.Colors.menuBarText)
        case .value:
            Text("\(Int(temperature))°")
                .menuBarMonospaced()
        case .both:
            HStack(spacing: DesignSystem.Spacing.tight) {
                Image(systemName: sfSymbolName)
                    .font(.system(size: DesignSystem.MenuBar.iconSize))
                Text("\(Int(temperature))°")
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
                .foregroundStyle(isActive ? DesignSystem.Colors.menuBarText : DesignSystem.Colors.menuBarTextDimmed)
        case .value:
            Group {
                if isActive {
                    Text("↓\(formatSpeed(downloadBPS)) ↑\(formatSpeed(uploadBPS))")
                } else {
                    Text("— —")
                }
            }
            .menuBarMonospaced()
            .foregroundStyle(isActive ? DesignSystem.Colors.menuBarText : DesignSystem.Colors.menuBarTextDimmed)
        case .both:
            HStack(spacing: DesignSystem.Spacing.tight) {
                Image(systemName: isActive ? "antenna.radiowaves.left.and.right" : "network.slash")
                    .font(.system(size: DesignSystem.MenuBar.iconSize))
                if isActive {
                    Text("↓\(formatSpeed(downloadBPS)) ↑\(formatSpeed(uploadBPS))")
                } else {
                    Text("— —")
                }
            }
            .menuBarMonospaced()
            .foregroundStyle(isActive ? DesignSystem.Colors.menuBarText : DesignSystem.Colors.menuBarTextDimmed)
        }
    }
}

// MARK: - Apps Icon

struct AppsIconView: View {
    var displayMode: MenuBarDisplayMode = .icon

    var body: some View {
        Image(systemName: "app.dashed")
            .font(.system(size: DesignSystem.MenuBar.iconSize))
            .foregroundStyle(DesignSystem.Colors.menuBarText)
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
