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
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
                HStack {
                    Text("CPU")
                        .font(.system(size: 13, weight: .semibold))
                    Spacer()
                    Text("\(Int(state.cpuPercentage))%")
                        .font(.system(size: 13, weight: .medium).monospacedDigit())
                        .foregroundStyle(DesignSystem.Colors.progressColor(for: state.cpuPercentage))
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("CPU usage: \(Int(state.cpuPercentage)) percent")

                ProgressView(value: state.cpuPercentage / 100)
                    .progressViewStyle(.linear)
                    .tint(DesignSystem.Colors.progressColor(for: state.cpuPercentage))
                    .accessibilityLabel("CPU usage progress")
                    .accessibilityValue("\(Int(state.cpuPercentage)) percent")

                HStack {
                    Text("Cores")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(state.coreCount)")
                        .font(.system(size: 11).monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(state.coreCount) CPU cores")
            }
            .padding()

            Divider()

            PopoverFooter()
        }
        .frame(width: DesignSystem.Popover.Width.standard)
        .background(.ultraThinMaterial)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("CPU usage panel")
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
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
                HStack {
                    Text("Memory")
                        .font(.system(size: 13, weight: .semibold))
                    Spacer()
                    Text("\(Int(percentage))%")
                        .font(.system(size: 13, weight: .medium).monospacedDigit())
                        .foregroundStyle(DesignSystem.Colors.progressColor(for: percentage))
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Memory usage: \(Int(percentage)) percent")

                ProgressView(value: percentage / 100)
                    .progressViewStyle(.linear)
                    .tint(DesignSystem.Colors.progressColor(for: percentage))
                    .accessibilityLabel("Memory usage progress")
                    .accessibilityValue("\(Int(percentage)) percent")

                HStack {
                    Text(String(format: "%.1f of %.1f GB", usedGB, totalGB))
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .accessibilityLabel("\(String(format: "%.1f", usedGB)) gigabytes used of \(String(format: "%.1f", totalGB)) gigabytes total")
            }
            .padding()

            Divider()

            PopoverFooter()
        }
        .frame(width: DesignSystem.Popover.Width.wide)
        .background(.ultraThinMaterial)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Memory usage panel")
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
        VStack(alignment: .leading, spacing: 0) {
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

            Divider()

            PopoverFooter()
        }
        .frame(width: DesignSystem.Popover.Width.wide)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Weather Popover

struct WeatherPopoverView: View {
    @State private var state = MenuBarState.shared

    private var conditionText: String {
        switch state.conditionCode {
        case 0: return "Clear"
        case 1: return "Mainly clear"
        case 2: return "Partly cloudy"
        case 3: return "Overcast"
        case 45, 48: return "Foggy"
        case 51, 53, 55, 56, 57: return "Drizzle"
        case 61, 63, 65, 66, 67: return "Rainy"
        case 71, 73, 75, 77: return "Snowy"
        case 85, 86: return "Snow showers"
        case 80, 81, 82: return "Rain showers"
        case 95: return "Thunderstorm"
        case 96, 99: return "Thunderstorm with hail"
        default: return "Unknown"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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

            Divider()

            PopoverFooter()
        }
        .frame(width: DesignSystem.Popover.Width.wide)
        .background(.ultraThinMaterial)
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
        VStack(alignment: .leading, spacing: 0) {
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

            Divider()

            PopoverFooter()
        }
        .frame(width: DesignSystem.Popover.Width.standard)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Apps Popover

struct AppsPopoverView: View {
    @State private var state = MenuBarState.shared
    @State private var appManager = AppProcessManager(appLister: NSWorkspaceAppLister())
    @State private var powerController = PowerAssertionController(powerProvider: CaffeinateWrapper())
    @State private var showingQuitAllAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Running Apps")
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
                if !appManager.isLoading && !appManager.runningApps.isEmpty {
                    Text("\(appManager.appCount)")
                        .font(.system(size: 11, weight: .medium).monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            if appManager.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else if appManager.runningApps.isEmpty {
                Text("No running apps")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                // Apps list
                ForEach(appManager.runningApps) { app in
                    AppsListRowView(app: app, onQuit: {
                        Task { try? await appManager.quitApp(bundleIdentifier: app.bundleIdentifier ?? "") }
                    })
                }

                // Quit All button
                Button("Quit All Apps") {
                    showingQuitAllAlert = true
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.red.opacity(0.9))
                .font(.system(size: 11))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.top, 4)
                .padding(.bottom, 10)
                .confirmationDialog(
                    "Quit all running applications?",
                    isPresented: $showingQuitAllAlert,
                    titleVisibility: .visible
                ) {
                    Button("Quit All", role: .destructive) {
                        Task { try? await appManager.quitAll() }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will close all user-facing applications but leave system apps running.")
                }
            }

            // Caffeinate section - separated by opacity instead of divider
            VStack(spacing: 0) {
                HStack {
                    Text("Keep Awake")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Circle()
                        .fill(powerController.isActive ? .green : Color.secondary.opacity(0.4))
                        .frame(width: 6, height: 6)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .padding(.bottom, 4)

                CaffeinatePresetButton(
                    title: "15 min",
                    isActive: false,
                    action: {
                        Task { try? await powerController.keepAwake(for: 15 * 60) }
                    }
                )
                CaffeinatePresetButton(
                    title: "1 hour",
                    isActive: false,
                    action: {
                        Task { try? await powerController.keepAwake(for: 60 * 60) }
                    }
                )
                CaffeinatePresetButton(
                    title: "Indefinitely",
                    isActive: powerController.isIndefinite,
                    action: {
                        Task {
                            if powerController.isIndefinite {
                                try? await powerController.allowSleep()
                            } else {
                                try? await powerController.keepAwakeIndefinitely()
                            }
                        }
                    }
                )
                if powerController.isActive {
                    Button("Disable") {
                        Task { try? await powerController.allowSleep() }
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(.red.opacity(0.9))
                    .font(.system(size: 11))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                }
            }
            .background(Color.black.opacity(0.03))

            Divider()

            PopoverFooter()
        }
        .frame(width: 240)
        .background(.ultraThinMaterial)
        .onAppear {
            Task { await appManager.refresh() }
        }
    }
}

struct CaffeinatePresetButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 12))
                Spacer()
                if isActive {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.green)
                }
            }
        }
        .compactMenuButtonStyle()
    }
}

// MARK: - App List Row View

struct AppsListRowView: View {
    let app: AppProcess
    let onQuit: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "app.dashed")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
            Text(app.name)
                .font(.system(size: 12))
                .lineLimit(1)
            Spacer()
            Button(action: onQuit) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary.opacity(0.7))
            }
            .buttonStyle(.borderless)
            .help("Quit \(app.name)")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Quit", role: .destructive) {
                onQuit()
            }
        }
    }
}

// MARK: - Caffeinate Popover

/// Popover view for caffeinate (keep-awake) controls.
///
/// Displays the current keep-awake state with a visual indicator
/// and provides quick access to preset durations.
struct CaffeinatePopoverView: View {
    @State private var state = MenuBarState.shared

    var statusText: String {
        switch MenuBarState.shared.caffeinateState {
        case .inactive:
            return "System can sleep normally"
        case .active(let until):
            let remaining = until.timeIntervalSinceNow
            if remaining > 0 {
                let minutes = Int(remaining / 60)
                return "Keeping awake for \(minutes) min"
            } else {
                return "Keeping awake"
            }
        case .indefinite:
            return "Keeping awake indefinitely"
        }
    }

    var isActive: Bool {
        MenuBarState.shared.caffeinateState.isActive
    }

    var isIndefinite: Bool {
        MenuBarState.shared.caffeinateState.isIndefinite
    }

    var systemImageName: String {
        switch MenuBarState.shared.caffeinateState {
        case .inactive:
            return "moon.zzz"
        case .active:
            return "moon.fill"
        case .indefinite:
            return "moon.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
                // Header with status
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: systemImageName)
                            .font(.system(size: 12))
                            .foregroundStyle(isActive ? .green : .secondary)
                        Text("Keep Awake")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    Spacer()
                    Circle()
                        .fill(isActive ? .green : Color.secondary.opacity(0.4))
                        .frame(width: 8, height: 8)
                }

                // Status text
                Text(statusText)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)

                Divider()

                // Presets
                VStack(spacing: 0) {
                    CaffeinatePresetButton(
                        title: "15 Minutes",
                        isActive: false,
                        action: {
                            Task { try? await MenuBarState.shared.powerController?.keepAwake(for: 15 * 60) }
                        }
                    )

                    CaffeinatePresetButton(
                        title: "1 Hour",
                        isActive: false,
                        action: {
                            Task { try? await MenuBarState.shared.powerController?.keepAwake(for: 60 * 60) }
                        }
                    )

                    CaffeinatePresetButton(
                        title: "Indefinitely",
                        isActive: isIndefinite,
                        action: {
                            Task {
                                if isIndefinite {
                                    try? await MenuBarState.shared.powerController?.allowSleep()
                                } else {
                                    try? await MenuBarState.shared.powerController?.keepAwakeIndefinitely()
                                }
                            }
                        }
                    )

                    if isActive {
                        Divider()
                            .padding(.vertical, 4)

                        Button("Disable Keep Awake") {
                            Task { try? await MenuBarState.shared.powerController?.allowSleep() }
                        }
                        .buttonStyle(.borderless)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                    }
                }
            }
            .padding()

            Divider()

            PopoverFooter()
        }
        .frame(width: DesignSystem.Popover.Width.wide)
        .background(.ultraThinMaterial)
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

#Preview("Caffeinate") {
    CaffeinatePopoverView()
        .padding()
        .background(Color.black)
}
