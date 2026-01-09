//
//  SettingsMenu.swift
//  firstmenu
//
//  Settings menu view using reusable primitives and HIG styling
//

import SwiftUI

/// Settings menu view for configuring firstmenu.
struct SettingsMenuView: View {
    @AppStorage("weatherRefreshInterval") private var weatherRefreshInterval: Double = 15
    @AppStorage("showCPUInMenuBar") private var showCPUInMenuBar: Bool = true
    @AppStorage("showRAMInMenuBar") private var showRAMInMenuBar: Bool = true
    @AppStorage("showStorageInMenuBar") private var showStorageInMenuBar: Bool = true
    @AppStorage("showWeatherInMenuBar") private var showWeatherInMenuBar: Bool = true
    @AppStorage("showNetworkInMenuBar") private var showNetworkInMenuBar: Bool = true

    // Display modes
    @AppStorage("cpuDisplayMode") private var cpuDisplayMode: String = MenuBarDisplayMode.value.rawValue
    @AppStorage("ramDisplayMode") private var ramDisplayMode: String = MenuBarDisplayMode.value.rawValue
    @AppStorage("storageDisplayMode") private var storageDisplayMode: String = MenuBarDisplayMode.value.rawValue
    @AppStorage("weatherDisplayMode") private var weatherDisplayMode: String = MenuBarDisplayMode.both.rawValue
    @AppStorage("networkDisplayMode") private var networkDisplayMode: String = MenuBarDisplayMode.value.rawValue

    private let version: String = {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }()

    private let build: String = {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Text("Settings")
                .font(.headline)
                .padding(.horizontal, DesignSystem.Spacing.section)
                .padding(.vertical, DesignSystem.Spacing.standard)

            // Weather Section
            SettingsSection(title: "Weather") {
                HStack {
                    Text("Refresh interval")
                        .font(.body)
                    Spacer()
                    Picker("", selection: $weatherRefreshInterval) {
                        Text("5 min").tag(5.0)
                        Text("15 min").tag(15.0)
                        Text("30 min").tag(30.0)
                        Text("1 hour").tag(60.0)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .fixedSize()
                }
                .padding(.horizontal, DesignSystem.Spacing.section)
                .padding(.vertical, DesignSystem.Spacing.tight)

                Text("Location detected from IP address")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, DesignSystem.Spacing.section)
                    .padding(.bottom, DesignSystem.Spacing.standard)
            }

            // Menu Bar Items Visibility Section
            SettingsSection(title: "Menu Bar Items") {
                ToggleRow("CPU Usage", systemImage: "cpu", isOn: $showCPUInMenuBar)
                    .padding(.horizontal, DesignSystem.Spacing.section)
                    .padding(.vertical, DesignSystem.Spacing.tight)

                ToggleRow("Memory", systemImage: "memorychip", isOn: $showRAMInMenuBar)
                    .padding(.horizontal, DesignSystem.Spacing.section)
                    .padding(.vertical, DesignSystem.Spacing.tight)

                ToggleRow("Storage", systemImage: "internaldrive", isOn: $showStorageInMenuBar)
                    .padding(.horizontal, DesignSystem.Spacing.section)
                    .padding(.vertical, DesignSystem.Spacing.tight)

                ToggleRow("Weather", systemImage: "cloud.sun", isOn: $showWeatherInMenuBar)
                    .padding(.horizontal, DesignSystem.Spacing.section)
                    .padding(.vertical, DesignSystem.Spacing.tight)

                ToggleRow("Network", systemImage: "network", isOn: $showNetworkInMenuBar)
                    .padding(.horizontal, DesignSystem.Spacing.section)
                    .padding(.vertical, DesignSystem.Spacing.tight)
                    .padding(.bottom, DesignSystem.Spacing.tight)
            }

            // Display Mode Section
            SettingsSection(title: "Display Mode") {
                DisplayModeRow(title: "CPU", systemImage: "cpu", selection: $cpuDisplayMode)
                DisplayModeRow(title: "Memory", systemImage: "memorychip", selection: $ramDisplayMode)
                DisplayModeRow(title: "Storage", systemImage: "internaldrive", selection: $storageDisplayMode)
                DisplayModeRow(title: "Weather", systemImage: "cloud.sun", selection: $weatherDisplayMode)
                DisplayModeRow(title: "Network", systemImage: "network", selection: $networkDisplayMode)
                    .padding(.bottom, DesignSystem.Spacing.tight)
            }

            // About Section
            SettingsSection(title: "About") {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.tight) {
                    HStack {
                        Text("firstmenu")
                            .font(.body.weight(.medium))
                        Spacer()
                        Text("v\(version) (\(build))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Text("A minimal macOS menu bar system companion")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, DesignSystem.Spacing.section)
                .padding(.vertical, DesignSystem.Spacing.tight)
            }

            // Footer
            HStack {
                Text("Made with SwiftUI")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.borderless)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, DesignSystem.Spacing.section)
            .padding(.vertical, DesignSystem.Spacing.standard)
        }
        .frame(width: 280)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Settings Section

/// A section container for settings with a header.
private struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .sectionHeaderStyle()
                .padding(.horizontal, DesignSystem.Spacing.section)
                .padding(.vertical, DesignSystem.Spacing.standard)
                .padding(.bottom, DesignSystem.Spacing.tight)

            content()
        }
        .background(.fill.quaternary)
    }
}

// MARK: - Display Mode Row

/// A row with a segmented picker for display mode selection.
private struct DisplayModeRow: View {
    let title: String
    let systemImage: String
    @Binding var selection: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.standard) {
            Image(systemName: systemImage)
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            Text(title)
                .font(.body)
            Spacer()
            Picker("", selection: $selection) {
                Text("Icon").tag(MenuBarDisplayMode.icon.rawValue)
                Text("Value").tag(MenuBarDisplayMode.value.rawValue)
                Text("Both").tag(MenuBarDisplayMode.both.rawValue)
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .fixedSize()
        }
        .padding(.horizontal, DesignSystem.Spacing.section)
        .padding(.vertical, DesignSystem.Spacing.tight)
    }
}

#Preview {
    SettingsMenuView()
        .padding()
}
