//
//  SettingsView.swift
//  firstmenu
//
//  Native macOS settings view using sidebar navigation
//

import SwiftUI

// MARK: - Settings Navigation

enum SettingsTab: String, CaseIterable, Identifiable {
    case general
    case display
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .general: return "General"
        case .display: return "Display"
        case .about: return "About"
        }
    }

    var icon: String {
        switch self {
        case .general: return "gearshape"
        case .display: return "rectangle.on.rectangle"
        case .about: return "info.circle"
        }
    }
}

// MARK: - Main Settings View

/// Native macOS settings view using sidebar navigation.
/// This follows Apple's System Settings pattern for macOS 26+.
struct SettingsView: View {
    @State private var selectedTab: SettingsTab = .general

    var body: some View {
        NavigationSplitView {
            List(SettingsTab.allCases, selection: $selectedTab) { tab in
                Label(tab.title, systemImage: tab.icon)
                    .tag(tab)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            switch selectedTab {
            case .general:
                GeneralSettingsView()
            case .display:
                DisplaySettingsView()
            case .about:
                AboutSettingsView()
            }
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

// MARK: - General Settings View

struct GeneralSettingsView: View {
    @AppStorage("weatherRefreshInterval") private var weatherRefreshInterval: Double = 15

    var body: some View {
        Form {
            Section {
                Picker("Refresh Interval", selection: $weatherRefreshInterval) {
                    Text("5 minutes").tag(5.0)
                    Text("15 minutes").tag(15.0)
                    Text("30 minutes").tag(30.0)
                    Text("1 hour").tag(60.0)
                }
                .pickerStyle(.radioGroup)
            } header: {
                Text("Weather")
            } footer: {
                Text("Location is detected automatically from your IP address.")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("General")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Display Settings View

struct DisplaySettingsView: View {
    @AppStorage("showCPUInMenuBar") private var showCPUInMenuBar: Bool = true
    @AppStorage("showRAMInMenuBar") private var showRAMInMenuBar: Bool = true
    @AppStorage("showStorageInMenuBar") private var showStorageInMenuBar: Bool = true
    @AppStorage("showWeatherInMenuBar") private var showWeatherInMenuBar: Bool = true
    @AppStorage("showNetworkInMenuBar") private var showNetworkInMenuBar: Bool = true

    @AppStorage("cpuDisplayMode") private var cpuDisplayMode: String = MenuBarDisplayMode.value.rawValue
    @AppStorage("ramDisplayMode") private var ramDisplayMode: String = MenuBarDisplayMode.value.rawValue
    @AppStorage("storageDisplayMode") private var storageDisplayMode: String = MenuBarDisplayMode.value.rawValue
    @AppStorage("weatherDisplayMode") private var weatherDisplayMode: String = MenuBarDisplayMode.both.rawValue
    @AppStorage("networkDisplayMode") private var networkDisplayMode: String = MenuBarDisplayMode.value.rawValue

    var body: some View {
        Form {
            Section {
                Toggle("CPU Usage", isOn: $showCPUInMenuBar)
                Toggle("Memory", isOn: $showRAMInMenuBar)
                Toggle("Storage", isOn: $showStorageInMenuBar)
                Toggle("Weather", isOn: $showWeatherInMenuBar)
                Toggle("Network", isOn: $showNetworkInMenuBar)
            } header: {
                Text("Menu Bar Items")
            }

            Section {
                displayModePicker(title: "CPU", selection: $cpuDisplayMode)
                displayModePicker(title: "Memory", selection: $ramDisplayMode)
                displayModePicker(title: "Storage", selection: $storageDisplayMode)
                displayModePicker(title: "Weather", selection: $weatherDisplayMode)
                displayModePicker(title: "Network", selection: $networkDisplayMode)
            } header: {
                Text("Display Mode")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Display")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func displayModePicker(title: String, selection: Binding<String>) -> some View {
        Picker(title, selection: selection) {
            Text("Icon").tag(MenuBarDisplayMode.icon.rawValue)
            Text("Value").tag(MenuBarDisplayMode.value.rawValue)
            Text("Both").tag(MenuBarDisplayMode.both.rawValue)
        }
        .pickerStyle(.segmented)
    }
}

// MARK: - About Settings View

struct AboutSettingsView: View {
    private let version: String = {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }()

    private let build: String = {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }()

    var body: some View {
        Form {
            Section {
                HStack(spacing: 16) {
                    if let appIcon = NSApplication.shared.applicationIconImage {
                        Image(nsImage: appIcon)
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("firstmenu")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Version \(version) (\(build))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
            }

            Section {
                Text("A minimal macOS menu bar system companion")
                    .foregroundStyle(.secondary)
            }

            Section {
                LabeledContent("Version", value: version)
                LabeledContent("Build", value: build)
            } header: {
                Text("Information")
            }

            Section {
                Button("Quit firstmenu", role: .destructive) {
                    NSApplication.shared.terminate(nil)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("About")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .frame(width: 600, height: 450)
}
