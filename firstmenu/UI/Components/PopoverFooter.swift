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
                HStack(spacing: 4) {
                    Image(systemName: "gearshape")
                        .imageScale(.small)
                    Text("Settings")
                        .font(.system(size: 11))
                }
            }
            .footerButtonStyle()
            .accessibilityLabel("Open Settings")
            .accessibilityHint("Opens the settings panel")

            Spacer()

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "power")
                        .imageScale(.small)
                    Text("Quit")
                        .font(.system(size: 11))
                }
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
            SettingsLink {
                HStack(spacing: 4) {
                    Image(systemName: "gearshape")
                        .imageScale(.small)
                    Text("Settings")
                        .font(.system(size: 11))
                }
            }
            .footerButtonStyle()
            .accessibilityLabel("Open Settings")

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "power")
                        .imageScale(.small)
                    Text("Quit")
                        .font(.system(size: 11))
                }
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
