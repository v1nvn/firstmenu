//
//  SettingsView.swift
//  firstmenu
//
//  Native macOS settings view using TabView
//

import SwiftUI

// MARK: - Main Settings View

/// Native macOS settings view using TabView for categories.
/// This follows Apple's recommended pattern for app settings on macOS.
struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            DisplaySettingsView()
                .tabItem {
                    Label("Display", systemImage: "rectangle.on.rectangle")
                }

            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(minWidth: 500, minHeight: 350)
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
        .navigationSplitViewColumnWidth(min: 350, ideal: 400)
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
                displayModePicker(title: "CPU", icon: "cpu", selection: $cpuDisplayMode)
                displayModePicker(title: "Memory", icon: "memorychip", selection: $ramDisplayMode)
                displayModePicker(title: "Storage", icon: "internaldrive", selection: $storageDisplayMode)
                displayModePicker(title: "Weather", icon: "cloud.sun", selection: $weatherDisplayMode)
                displayModePicker(title: "Network", icon: "network", selection: $networkDisplayMode)
            } header: {
                Text("Display Mode")
            }
        }
        .formStyle(.grouped)
    }

    @ViewBuilder
    private func displayModePicker(title: String, icon: String, selection: Binding<String>) -> some View {
        Picker(title, selection: selection) {
            Text("Icon").tag(MenuBarDisplayMode.icon.rawValue)
            Text("Value").tag(MenuBarDisplayMode.value.rawValue)
            Text("Both").tag(MenuBarDisplayMode.both.rawValue)
        }
        .pickerStyle(.radioGroup)
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
                VStack(alignment: .leading, spacing: 12) {
                    Text("firstmenu")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text("Version \(version) (\(build))")
                        .font(.body)
                        .foregroundStyle(.secondary)

                    Text("A minimal macOS menu bar system companion")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
            }

            Section {
                LabeledContent("Version", value: version)
                LabeledContent("Build", value: build)
            } header: {
                Text("Information")
            }

            Section {
                Button("Quit firstmenu") {
                    NSApplication.shared.terminate(nil)
                }
                .controlSize(.large)
            }
        }
        .formStyle(.grouped)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .frame(width: 600, height: 450)
}
