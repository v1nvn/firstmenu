//
//  PopoverFooter.swift
//  firstmenu
//
//  Shared footer component for all menu popovers
//

import SwiftUI
import AppKit

// MARK: - Settings Window Manager

/// Manages the shared settings window for the app.
class SettingsWindowManager {
    static let shared = SettingsWindowManager()

    private var settingsWindow: NSWindow?

    private init() {}

    /// Shows the settings window, bringing it to front if already open.
    func showSettings() {
        DispatchQueue.main.async {
            if let existingWindow = self.settingsWindow {
                existingWindow.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
                return
            }

            // Create new settings window with native macOS style
            let contentView = SettingsView()
            let hostingController = NSHostingController(rootView: contentView)

            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 700, height: 450),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )
            window.title = "Settings"
            window.contentViewController = hostingController
            window.center()
            window.setFrameAutosaveName("SettingsWindow")
            window.isReleasedWhenClosed = false

            // Enable full-size content view with native titlebar
            window.titlebarAppearsTransparent = false
            window.titleVisibility = .visible
            window.styleMask.remove(.fullSizeContentView)

            // Set min size
            window.minSize = NSSize(width: 550, height: 350)

            // Make it a proper utility/settings window
            window.level = .floating
            window.collectionBehavior = [.moveToActiveSpace]

            self.settingsWindow = window
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    /// Closes the settings window if open.
    func closeSettings() {
        DispatchQueue.main.async {
            self.settingsWindow?.close()
            self.settingsWindow = nil
        }
    }
}

// MARK: - Popover Footer View

/// A standardized footer for all menu popovers.
///
/// Provides consistent access to Settings and Quit actions
/// across all menu bar items.
struct PopoverFooter: View {
    var body: some View {
        HStack {
            Button("Settings…") {
                SettingsWindowManager.shared.showSettings()
            }
            .footerButtonStyle()
            .accessibilityLabel("Open Settings")
            .accessibilityHint("Opens the settings panel")

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .footerButtonStyle()
            .accessibilityLabel("Quit firstmenu")
            .accessibilityHint("Quits the application")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.05))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Menu options")
    }
}

// MARK: - Compact Footer View

/// A more compact footer variant for smaller popovers.
struct CompactPopoverFooter: View {
    var body: some View {
        HStack(spacing: 16) {
            Button("Settings…") {
                SettingsWindowManager.shared.showSettings()
            }
            .footerButtonStyle()
            .accessibilityLabel("Open Settings")

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .footerButtonStyle()
            .accessibilityLabel("Quit firstmenu")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.05))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Menu options")
    }
}
