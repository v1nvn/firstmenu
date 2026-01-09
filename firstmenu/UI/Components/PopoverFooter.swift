//
//  PopoverFooter.swift
//  firstmenu
//
//  Shared footer component for all menu popovers
//

import SwiftUI
import AppKit

// MARK: - Popover Footer View

/// A standardized footer for all menu popovers.
///
/// Provides consistent access to Settings and Quit actions
/// across all menu bar items. Uses Apple's native SettingsLink.
struct PopoverFooter: View {
    var body: some View {
        HStack {
            SettingsLink {
                Label("Settings", systemImage: "gearshape")
            }
            .footerButtonStyle()
            .accessibilityLabel("Open Settings")
            .accessibilityHint("Opens the settings panel")

            Spacer()

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Quit", systemImage: "power")
            }
            .footerButtonStyle()
            .accessibilityLabel("Quit firstmenu")
            .accessibilityHint("Quits the application")
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.quinary)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Menu options")
    }
}
