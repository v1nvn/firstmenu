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

            // Create new settings window
            let contentView = SettingsMenuView()
            let hostingController = NSHostingController(rootView: contentView)

            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 500),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            window.title = "firstmenu Settings"
            window.contentViewController = hostingController
            window.center()
            window.setFrameAutosaveName("SettingsWindow")
            window.isReleasedWhenClosed = false

            // Make it behave like a proper settings window
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.styleMask = [.fullSizeContentView, .borderless]

            // Apply native styling
            window.backgroundColor = .clear
            window.contentView?.wantsLayer = true
            window.contentView?.layer?.backgroundColor = NSColor.clear.cgColor

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

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .footerButtonStyle()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.05))
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

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .footerButtonStyle()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.05))
    }
}
