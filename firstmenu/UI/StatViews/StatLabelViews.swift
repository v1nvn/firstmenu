//
//  StatLabelViews.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI

// MARK: - CPU Stat Label

struct CPUStatLabelView: View {
    let percentage: Double

    var body: some View {
        Text("\(Int(percentage))%")
            .menuBarMonospaced()
    }
}

// MARK: - RAM Stat Label

struct RAMStatLabelView: View {
    let used: Int64
    let total: Int64

    private var usedGB: String {
        String(format: "%.1f", Double(used) / 1_073_741_824)
    }

    var body: some View {
        Text("\(usedGB)G")
            .menuBarMonospaced()
    }
}

// MARK: - SSD Stat Label

struct SSDStatLabelView: View {
    let used: Int64
    let total: Int64

    private var percentage: Int {
        Int(Double(used) / Double(total) * 100)
    }

    var body: some View {
        Text("\(percentage)%")
            .menuBarMonospaced()
    }
}

// MARK: - Weather Stat Label

struct WeatherStatLabelView: View {
    let temperature: Double
    let sfSymbolName: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.tight) {
            Image(systemName: sfSymbolName)
                .font(.system(size: DesignSystem.MenuBar.iconSize))
            Text("\(Int(temperature))°")
                .menuBarMonospaced()
        }
        .menuBarText()
    }
}

// MARK: - Network Stat Label

struct NetworkStatLabelView: View {
    let downloadBPS: Int64
    let uploadBPS: Int64

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
        Group {
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

// MARK: - Apps Icon

struct AppsIconView: View {
    var body: some View {
        Image(systemName: "app.dashed")
            .font(.system(size: DesignSystem.MenuBar.iconSize))
            .foregroundStyle(DesignSystem.Colors.menuBarText)
    }
}

// MARK: - Preview

#Preview("Menu Bar Items") {
    HStack(spacing: DesignSystem.Spacing.standard) {
        CPUStatLabelView(percentage: 45)
        RAMStatLabelView(used: 8_400_000_000, total: 16_000_000_000)
        SSDStatLabelView(used: 200_000_000_000, total: 500_000_000_000)
        WeatherStatLabelView(temperature: 28, sfSymbolName: "sun.max.fill")
        NetworkStatLabelView(downloadBPS: 1_000_000, uploadBPS: 500_000)
        AppsIconView()
    }
    .padding()
    .background(Color.black)
}
