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
        // No scenes needed for menu bar only app
        Settings {
            EmptyView()
        }
    }
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var statsSampler: StatsSampler?
    var weatherSampler: WeatherSampler?
    var appManager: AppProcessManager?
    var powerController: PowerAssertionController?
    var updateTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Ensure app is menu bar only - no dock icon
        NSApp.setActivationPolicy(.accessory)

        // Setup status item
        setupStatusBar()

        // Initialize dependencies
        setupDependencies()

        // Start periodic updates
        startPeriodicUpdates()

        // Initial sampling
        Task {
            await initialSample()
        }
    }

    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    private func setupDependencies() {
        // Infrastructure layer
        let cpuReader = MachCPUReader()
        let ramReader = MachRAMReader()
        let storageReader = FileSystemStorageReader()
        let networkReader = InterfaceNetworkReader()
        let weatherClient: OpenMeteoWeatherClient
        let appLister = NSWorkspaceAppLister()
        let powerWrapper = CaffeinateWrapper()

        do {
            weatherClient = try OpenMeteoWeatherClient()
        } catch {
            // If weather client fails to initialize, we'll run without it
            fatalError("Failed to initialize weather client: \(error)")
        }

        // Domain use cases
        statsSampler = StatsSampler(
            cpuProvider: cpuReader,
            ramProvider: ramReader,
            storageProvider: storageReader,
            networkProvider: networkReader
        )

        weatherSampler = WeatherSampler(weatherProvider: weatherClient)
        appManager = AppProcessManager(appLister: appLister)
        powerController = PowerAssertionController(powerProvider: powerWrapper)
    }

    private func startPeriodicUpdates() {
        // Update every second for stats
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.updateStats()
            }
        }

        // Weather updates less frequently - every 15 minutes
        Timer.scheduledTimer(withTimeInterval: 15 * 60, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.weatherSampler?.sample()
                await self?.updateMenuBarText()
            }
        }
    }

    private func initialSample() async {
        try? await statsSampler?.sample()
        await weatherSampler?.sample()
        updateMenuBarText()
    }

    private func updateStats() async {
        try? await statsSampler?.sample()
        updateMenuBarText()
    }

    private func updateMenuBarText() {
        guard let snapshot = statsSampler?.currentSnapshot,
              let weather = weatherSampler?.currentWeather else {
            statusItem?.button?.title = "..."
            return
        }

        let labelView = MenuBarLabelView(
            statsSnapshot: snapshot,
            weatherSnapshot: weather
        )

        // Create image from SwiftUI view
        let renderer = ImageRenderer(content: labelView)
        renderer.scale = 2.0  // Retina

        if let nsImage = renderer.nsImage {
            statusItem?.button?.image = nsImage
            statusItem?.button?.title = ""
        } else {
            // Fallback to text rendering
            statusItem?.button?.image = nil
            statusItem?.button?.title = formatMenuBarText(snapshot: snapshot, weather: weather)
        }
    }

    private func formatMenuBarText(snapshot: StatsSnapshot, weather: WeatherSnapshot) -> String {
        var parts: [String] = []

        parts.append(String(format: "CPU %.0f%%", snapshot.cpuPercentage))
        parts.append(String(format: "RAM %.1fG", Double(snapshot.ramUsed) / 1_073_741_824))
        parts.append(String(format: "SSD %.0f%%", snapshot.storagePercentage))
        parts.append("☀︎")
        parts.append(String(format: "%.0f°", weather.temperature))

        if snapshot.networkDownloadBPS > 0 || snapshot.networkUploadBPS > 0 {
            parts.append("↓ \(formatSpeed(snapshot.networkDownloadBPS))")
            parts.append("↑ \(formatSpeed(snapshot.networkUploadBPS))")
        }

        return parts.joined(separator: " • ")
    }

    private func formatSpeed(_ bps: Int64) -> String {
        let mbps = Double(bps) / (1024 * 1024)
        let kbps = Double(bps) / 1024

        if mbps >= 1 {
            return String(format: "%.0fM", mbps)
        } else if kbps >= 1 {
            return String(format: "%.0fK", kbps)
        }
        return "0"
    }

    @objc private func togglePopover() {
        if let popover = popover, popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }

    private func showPopover() {
        guard let statusButton = statusItem?.button,
              let appManager = appManager,
              let powerController = powerController else {
            return
        }

        // Refresh app list when showing popover
        Task { await appManager.refresh() }

        if popover == nil {
            popover = NSPopover()
            popover?.behavior = .transient
            popover?.contentSize = NSSize(width: 280, height: 400)
        }

        popover?.contentViewController = NSHostingController(
            rootView: MenuBarWindowView(
                appManager: appManager,
                powerController: powerController
            )
        )

        popover?.show(relativeTo: statusButton.bounds, of: statusButton, preferredEdge: .minY)

        // Activate app to ensure keyboard navigation works
        NSApp.activate(ignoringOtherApps: true)
    }

    private func closePopover() {
        popover?.performClose(nil)
    }

    func applicationWillTerminate(_ notification: Notification) {
        updateTimer?.invalidate()
        // Deactivate caffeinate if active
        Task { [weak self] in
            try? await self?.powerController?.allowSleep()
        }
    }
}
