//
//  SettingsMenu.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
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
                .font(.system(size: 13, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

            // Weather Section
            VStack(spacing: 0) {
                Text("Weather")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .padding(.bottom, 4)

                HStack {
                    Text("Refresh interval")
                        .font(.system(size: 12))
                    Spacer()
                    Picker("", selection: $weatherRefreshInterval) {
                        Text("5 min").tag(5.0)
                        Text("15 min").tag(15.0)
                        Text("30 min").tag(30.0)
                        Text("1 hour").tag(60.0)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 140)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)

                Text("Location detected from IP address")
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)
            }
            .background(Color.black.opacity(0.03))

            // Menu Bar Section
            VStack(spacing: 0) {
                Text("Menu Bar Items")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .padding(.bottom, 4)

                SettingToggle(
                    title: "CPU Usage",
                    icon: "cpu",
                    isOn: $showCPUInMenuBar
                )

                SettingToggle(
                    title: "Memory",
                    icon: "memorychip",
                    isOn: $showRAMInMenuBar
                )

                SettingToggle(
                    title: "Storage",
                    icon: "internaldrive",
                    isOn: $showStorageInMenuBar
                )

                SettingToggle(
                    title: "Weather",
                    icon: "cloud.sun",
                    isOn: $showWeatherInMenuBar
                )

                SettingToggle(
                    title: "Network",
                    icon: "network",
                    isOn: $showNetworkInMenuBar
                )
                .padding(.bottom, 6)
            }
            .background(Color.black.opacity(0.03))

            // About Section
            VStack(spacing: 0) {
                Text("About")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .padding(.bottom, 4)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("firstmenu")
                            .font(.system(size: 12, weight: .semibold))
                        Spacer()
                        Text("v\(version) (\(build))")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    Text("A minimal macOS menu bar system companion")
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }
            .background(Color.black.opacity(0.03))

            // Footer
            HStack {
                Text("Made with SwiftUI")
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.borderless)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 280)
        .background(.ultraThinMaterial)
    }
}

struct SettingToggle: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .frame(width: 16)
            Text(title)
                .font(.system(size: 12))
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .controlSize(.small)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
    }
}

#Preview {
    SettingsMenuView()
        .padding()
}
