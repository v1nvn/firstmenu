//
//  FirstMenuApp.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import AppKit

/// The main app entry point.
///
/// This app creates 7 menu bar extras for system monitoring:
/// - CPU: Real-time CPU usage percentage
/// - RAM: Memory used / total
/// - Storage: Disk usage percentage
/// - Weather: Current temperature with SF Symbol
/// - Network: Download / upload speeds
/// - Apps: Running applications with quick quit actions
/// - Caffeinate: Keep-awake state with dynamic icon indicator
///
/// The app uses a clean architecture with Domain, Infrastructure, and UI layers.
/// All system access is isolated to the Infrastructure layer, making the Domain
/// layer testable and independent of system APIs.
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
        CaffeinateMenuBarExtra()
    }
}

// MARK: - Menu Bar Extra Scenes

/// CPU menu bar extra showing current CPU usage.
struct CPUMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("CPU", systemImage: "cpu") {
            CPUPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

/// RAM menu bar extra showing memory usage.
struct RAMMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("RAM", systemImage: "memorychip") {
            RAMPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

/// Storage menu bar extra showing disk usage.
struct StorageMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("Storage", systemImage: "internaldrive") {
            StoragePopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

/// Weather menu bar extra showing current temperature.
struct WeatherMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("Weather", systemImage: "cloud.sun") {
            WeatherPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

/// Network menu bar extra showing current network speeds.
struct NetworkMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("Network", systemImage: "network") {
            NetworkPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

/// Apps menu bar extra showing running applications.
struct AppsMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("Apps", systemImage: "app.dashed") {
            AppsPopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

/// Caffeinate menu bar extra showing keep-awake state with dynamic icon.
///
/// The icon changes based on caffeinate state:
/// - Inactive: moon outline (moon.zzz)
/// - Active with timer: moon.fill with green accent
/// - Indefinite: moon.fill with lock overlay
struct CaffeinateMenuBarExtra: Scene {
    var body: some Scene {
        MenuBarExtra("Caffeinate", systemImage: "moon.zzz") {
            CaffeinatePopoverView()
        }
        .menuBarExtraStyle(.window)
    }
}

// MARK: - App Delegate

/// App delegate handling application lifecycle and dependency setup.
///
/// The AppDelegate:
/// 1. Sets the activation policy to `.accessory` (menu bar only, no dock icon)
/// 2. Wire up all infrastructure providers to the domain layer
/// 3. Starts periodic updates for menu bar state
/// 4. Ensures clean deactivation of power assertions on quit
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

    /// Sets up the dependency injection graph.
    ///
    /// Infrastructure providers are created and injected into use cases.
    /// The use cases are then set on the shared MenuBarState for UI access.
    private func setupDependencies() {
        // Infrastructure: System stat readers
        let cpuReader = MachCPUReader()
        let ramReader = MachRAMReader()
        let storageReader = FileSystemStorageReader()
        let networkReader = InterfaceNetworkReader()

        // Infrastructure: Weather client
        let weatherClient: OpenMeteoWeatherClient
        do {
            weatherClient = try OpenMeteoWeatherClient()
        } catch {
            fatalError("Failed to initialize weather client: \(error)")
        }

        // Infrastructure: Power assertion wrapper
        let powerWrapper = CaffeinateWrapper()

        // Domain: Use cases
        let statsSampler = StatsSampler(
            cpuProvider: cpuReader,
            ramProvider: ramReader,
            storageProvider: storageReader,
            networkProvider: networkReader
        )

        let weatherSampler = WeatherSampler(weatherProvider: weatherClient)

        // Wire up shared state
        MenuBarState.shared.setSamplers(stats: statsSampler, weather: weatherSampler)

        // Create and wire power controller
        powerController = PowerAssertionController(powerProvider: powerWrapper)
        MenuBarState.shared.setPowerController(powerController!)
    }

    /// Ensures clean shutdown by deactivating any active caffeinate assertions.
    func applicationWillTerminate(_ notification: Notification) {
        Task { [weak self] in
            try? await self?.powerController?.allowSleep()
        }
    }
}
