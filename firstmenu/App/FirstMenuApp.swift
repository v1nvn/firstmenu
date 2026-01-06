//
//  FirstMenuApp.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import AppKit

@main
struct FirstMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        CPUMenuBarExtra()
        RAMMenuBarExtra()
        StorageMenuBarExtra()
        WeatherMenuBarExtra()
        NetworkMenuBarExtra()
        AppsMenuBarExtra()

        Settings {
            SettingsMenuView()
        }
    }
}

// MARK: - Menu Bar Extra Scenes

struct CPUMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("CPU", systemImage: "cpu") {
            CPUPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

struct RAMMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("RAM", systemImage: "memorychip") {
            RAMPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

struct StorageMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("Storage", systemImage: "internaldrive") {
            StoragePopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

struct WeatherMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("Weather", systemImage: "cloud.sun") {
            WeatherPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

struct NetworkMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("Network", systemImage: "network") {
            NetworkPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

struct AppsMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("Apps", systemImage: "app.dashed") {
            AppsPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

// MARK: - App Delegate

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var powerController: PowerAssertionController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Ensure app is menu bar only - no dock icon
        NSApp.setActivationPolicy(.accessory)

        // Initialize dependencies
        setupDependencies()

        // Start updating menu bar state
        MenuBarState.shared.startUpdating()
    }

    private func setupDependencies() {
        let cpuReader = MachCPUReader()
        let ramReader = MachRAMReader()
        let storageReader = FileSystemStorageReader()
        let networkReader = InterfaceNetworkReader()

        let weatherClient: OpenMeteoWeatherClient
        do {
            weatherClient = try OpenMeteoWeatherClient()
        } catch {
            fatalError("Failed to initialize weather client: \(error)")
        }

        let powerWrapper = CaffeinateWrapper()

        let statsSampler = StatsSampler(
            cpuProvider: cpuReader,
            ramProvider: ramReader,
            storageProvider: storageReader,
            networkProvider: networkReader
        )

        let weatherSampler = WeatherSampler(weatherProvider: weatherClient)

        MenuBarState.shared.setSamplers(stats: statsSampler, weather: weatherSampler)
        powerController = PowerAssertionController(powerProvider: powerWrapper)
    }

    func applicationWillTerminate(_ notification: Notification) {
        Task { [weak self] in
            try? await self?.powerController?.allowSleep()
        }
    }
}
