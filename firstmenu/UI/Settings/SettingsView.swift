//
//  SettingsView.swift
//  firstmenu
//
//  Native macOS-style settings window with sidebar
//

import SwiftUI

// MARK: - Settings Navigation Item

enum SettingsNavigationItem: String, CaseIterable {
    case general = "General"
    case display = "Display"
    case about = "About"

    var icon: String {
        switch self {
        case .general: return "gearshape"
        case .display: return "rectangle.on.rectangle"
        case .about: return "info.circle"
        }
    }
}

// MARK: - Main Settings View

/// Native macOS-style settings window with sidebar navigation.
struct SettingsView: View {
    @State private var selectedSidebar: SettingsNavigationItem = .general

    var body: some View {
        NavigationSplitView {
            List(SettingsNavigationItem.allCases, id: \.self, selection: $selectedSidebar) { item in
                Label(item.rawValue, systemImage: item.icon)
                    .tag(item)
            }
            .navigationSplitViewColumnWidth(min: 150, ideal: 180)
            .listStyle(.sidebar)
        } detail: {
            switch selectedSidebar {
            case .general:
                GeneralSettingsView()
                    .navigationTitle(SettingsNavigationItem.general.rawValue)
            case .display:
                DisplaySettingsView()
                    .navigationTitle(SettingsNavigationItem.display.rawValue)
            case .about:
                AboutSettingsView()
                    .navigationTitle(SettingsNavigationItem.about.rawValue)
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
            Section("Weather") {
                Picker("Refresh Interval", selection: $weatherRefreshInterval) {
                    Text("5 minutes").tag(5.0)
                    Text("15 minutes").tag(15.0)
                    Text("30 minutes").tag(30.0)
                    Text("1 hour").tag(60.0)
                }
                .pickerStyle(.radioGroup)

                Text("Location is detected automatically from your IP address.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
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
            Section("Menu Bar Items") {
                Toggle("CPU Usage", isOn: $showCPUInMenuBar)
                Toggle("Memory", isOn: $showRAMInMenuBar)
                Toggle("Storage", isOn: $showStorageInMenuBar)
                Toggle("Weather", isOn: $showWeatherInMenuBar)
                Toggle("Network", isOn: $showNetworkInMenuBar)
            }

            Section("Display Mode") {
                displayModePicker(title: "CPU", icon: "cpu", selection: $cpuDisplayMode)
                displayModePicker(title: "Memory", icon: "memorychip", selection: $ramDisplayMode)
                displayModePicker(title: "Storage", icon: "internaldrive", selection: $storageDisplayMode)
                displayModePicker(title: "Weather", icon: "cloud.sun", selection: $weatherDisplayMode)
                displayModePicker(title: "Network", icon: "network", selection: $networkDisplayMode)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func displayModePicker(title: String, icon: String, selection: Binding<String>) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .frame(width: 120, alignment: .leading)
            Picker("", selection: selection) {
                Text("Icon").tag(MenuBarDisplayMode.icon.rawValue)
                Text("Value").tag(MenuBarDisplayMode.value.rawValue)
                Text("Both").tag(MenuBarDisplayMode.both.rawValue)
            }
            .pickerStyle(.radioGroup)
        }
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
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("firstmenu")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Version \(version) (\(build))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("A minimal macOS menu bar system companion")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "menubar.rectangle")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                        .symbolRenderingMode(.hierarchical)
                }
                .padding(.vertical, 8)
            }

            Section("Information") {
                LabeledContent("Version", value: version)
                LabeledContent("Build", value: build)
                LabeledContent("Author", value: "Vineet Kumar")
            }

            Section {
                Button("Quit firstmenu") {
                    NSApplication.shared.terminate(nil)
                }
                .controlSize(.large)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .frame(width: 700, height: 500)
}
