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

    private var progressColor: Color {
        DesignSystem.Colors.progressColor(for: state.cpuPercentage)
    }

    var body: some View {
        PopoverContainer(width: 200) {
            PopoverSection {
                PopoverHeader("CPU", systemImage: "cpu", value: "\(Int(state.cpuPercentage))%", valueColor: progressColor)
                    .accessibilityLabel("CPU usage: \(Int(state.cpuPercentage)) percent")

                StatGaugeRow(value: state.cpuPercentage, tintColor: progressColor)
                    .accessibilityLabel("CPU usage")
                    .accessibilityValue("\(Int(state.cpuPercentage)) percent")

                InfoRow(label: "Cores", value: "\(state.coreCount)")
            }
        }
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
        guard state.ramTotal > 0 else { return 0 }
        return Double(state.ramUsed) / Double(state.ramTotal) * 100
    }

    private var progressColor: Color {
        DesignSystem.Colors.progressColor(for: percentage)
    }

    var body: some View {
        PopoverContainer {
            PopoverSection {
                PopoverHeader("Memory", systemImage: "memorychip", value: "\(Int(percentage))%", valueColor: progressColor)
                    .accessibilityLabel("Memory usage: \(Int(percentage)) percent")

                StatGaugeRow(value: percentage, tintColor: progressColor)
                    .accessibilityLabel("Memory usage")
                    .accessibilityValue("\(Int(percentage)) percent")

                InfoRow(label: "Used", value: String(format: "%.1f of %.1f GB", usedGB, totalGB))
            }
        }
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
        guard state.storageTotal > 0 else { return 0 }
        return Double(state.storageUsed) / Double(state.storageTotal) * 100
    }

    private var progressColor: Color {
        DesignSystem.Colors.progressColor(for: percentage, thresholds: (80, 95))
    }

    var body: some View {
        PopoverContainer {
            PopoverSection {
                PopoverHeader("Storage", systemImage: "internaldrive", value: "\(Int(percentage))%", valueColor: progressColor)

                StatGaugeRow(value: percentage, tintColor: progressColor)

                InfoRow(label: "Available", value: String(format: "%.0f of %.0f GB", totalGB - usedGB, totalGB))
            }
        }
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
        PopoverContainer {
            PopoverSection {
                HStack {
                    Label("Weather", systemImage: "cloud.sun")
                        .font(.headline)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: state.sfSymbolName)
                            .symbolRenderingMode(.multicolor)
                        Text("\(Int(state.temperature))°")
                            .font(.system(.title2, design: .rounded, weight: .medium))
                    }
                }

                InfoRow(label: "Condition", value: conditionText)

                Text("Location detected via IP address")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
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
        PopoverContainer {
            PopoverSection {
                Label("Network", systemImage: "network")
                    .font(.headline)

                Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 6) {
                    GridRow {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundStyle(.green)
                        Text("Download")
                            .foregroundStyle(.secondary)
                        Text(formatSpeed(state.downloadBPS))
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    GridRow {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundStyle(.blue)
                        Text("Upload")
                            .foregroundStyle(.secondary)
                        Text(formatSpeed(state.uploadBPS))
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .font(.subheadline)

                if state.downloadBPS == 0 && state.uploadBPS == 0 {
                    Text("No network activity")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }
}

// MARK: - Apps Popover

struct AppsPopoverView: View {
    @State private var appManager = AppProcessManager(appLister: NSWorkspaceAppLister())
    @State private var powerController = PowerAssertionController(powerProvider: CaffeinateWrapper())
    @State private var showingQuitAllAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Label("Running Apps", systemImage: "app.badge")
                    .font(.headline)
                Spacer()
                if !appManager.isLoading && !appManager.runningApps.isEmpty {
                    Text("\(appManager.appCount)")
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.quaternary, in: Capsule())
                }
            }
            .padding()

            if appManager.isLoading {
                ProgressView()
                    .controlSize(.small)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else if appManager.runningApps.isEmpty {
                PopoverEmptyState("No Apps", systemImage: "app.dashed", description: "No user apps running")
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(appManager.runningApps) { app in
                            AppsListRowView(app: app, onQuit: {
                                Task { try? await appManager.quitApp(bundleIdentifier: app.bundleIdentifier ?? "") }
                            })
                        }
                    }
                }
                .frame(maxHeight: 200)

                Button("Quit All Apps", role: .destructive) {
                    showingQuitAllAlert = true
                }
                .buttonStyle(.plain)
                .font(.subheadline)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 8)
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

            Divider()

            // Keep Awake section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("Keep Awake", systemImage: powerController.isActive ? "moon.fill" : "moon.zzz")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                    StatusIndicator(isActive: powerController.isActive)
                }

                HStack(spacing: 8) {
                    ForEach(["15m", "1h", "∞"], id: \.self) { preset in
                        Button(preset) {
                            Task {
                                switch preset {
                                case "15m": try? await powerController.keepAwake(for: 15 * 60)
                                case "1h": try? await powerController.keepAwake(for: 60 * 60)
                                case "∞":
                                    if powerController.isIndefinite {
                                        try? await powerController.allowSleep()
                                    } else {
                                        try? await powerController.keepAwakeIndefinitely()
                                    }
                                default: break
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .tint(preset == "∞" && powerController.isIndefinite ? .green : nil)
                    }

                    if powerController.isActive && !powerController.isIndefinite {
                        Button("Off") {
                            Task { try? await powerController.allowSleep() }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .tint(.red)
                    }
                }
            }
            .padding()
            .background(.quinary)

            Divider()

            PopoverFooter()
        }
        .frame(width: 260)
        .background(.regularMaterial)
        .onAppear {
            Task { await appManager.refresh() }
        }
    }
}

// MARK: - App List Row View

struct AppsListRowView: View {
    let app: AppProcess
    let onQuit: () -> Void
    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "app.fill")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(app.name)
                .font(.subheadline)
                .lineLimit(1)
            Spacer()
            Button(action: onQuit) {
                Image(systemName: "xmark.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .opacity(isHovering ? 1 : 0.5)
            .help("Quit \(app.name)")
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(isHovering ? Color.primary.opacity(0.05) : Color.clear)
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovering = hovering
        }
        .contextMenu {
            Button("Quit", role: .destructive) {
                onQuit()
            }
        }
    }
}

// MARK: - Caffeinate Popover

/// Popover view for caffeinate (keep-awake) controls.
struct CaffeinatePopoverView: View {
    @State private var state = MenuBarState.shared

    private var statusText: String {
        switch state.caffeinateState {
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

    private var isActive: Bool {
        state.caffeinateState.isActive
    }

    private var isIndefinite: Bool {
        state.caffeinateState.isIndefinite
    }

    private var systemImageName: String {
        isActive ? "moon.fill" : "moon.zzz"
    }

    var body: some View {
        PopoverContainer {
            PopoverSection(spacing: 12) {
                // Header with status
                HStack {
                    Label("Keep Awake", systemImage: systemImageName)
                        .font(.headline)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(isActive ? .green : .primary)
                    Spacer()
                    StatusIndicator(isActive: isActive)
                }

                // Status text
                Text(statusText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Divider()

                // Duration presets
                VStack(alignment: .leading, spacing: 8) {
                    PopoverSectionHeader(title: "Duration")

                    HStack(spacing: 8) {
                        ForEach(["15 min", "1 hour", "∞"], id: \.self) { preset in
                            Button(preset) {
                                Task {
                                    switch preset {
                                    case "15 min": try? await state.powerController?.keepAwake(for: 15 * 60)
                                    case "1 hour": try? await state.powerController?.keepAwake(for: 60 * 60)
                                    case "∞":
                                        if isIndefinite {
                                            try? await state.powerController?.allowSleep()
                                        } else {
                                            try? await state.powerController?.keepAwakeIndefinitely()
                                        }
                                    default: break
                                    }
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .tint(preset == "∞" && isIndefinite ? .green : nil)
                        }
                    }
                }

                if isActive && !isIndefinite {
                    Button("Disable", role: .destructive) {
                        Task { try? await state.powerController?.allowSleep() }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
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
