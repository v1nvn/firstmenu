//
//  ButtonStyles.swift
//  firstmenu
//
//  Native macOS button styles with proper hover states
//

import SwiftUI

// MARK: - Native Menu Button Style

/// A button style that provides native macOS menu-like hover behavior.
///
/// This style mimics the appearance of native menu items with:
/// - Transparent background by default
/// - Semi-transparent blue/gray background on hover
/// - Rounded corners matching macOS menus
/// - Proper press animation
struct NativeMenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(configuration.isPressed ? Color.accentColor.opacity(0.2) :
                          Color(nsColor: .controlAccentColor).opacity(configuration.isPressed ? 0.3 : 0.1))
                    .opacity(configuration.isPressed || hoverPhase != .idle ? 1 : 0)
            )
            .contentShape(Rectangle())
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.15)) {
                    if hovering {
                        hoverPhase = .hovering
                    } else {
                        hoverPhase = .idle
                    }
                }
            }
    }

    @State private var hoverPhase: HoverPhase = .idle

    private enum HoverPhase {
        case idle, hovering
    }
}

// MARK: - Compact Menu Button Style

/// A more compact version of the native menu button style for tighter layouts.
struct CompactMenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(nsColor: .controlAccentColor).opacity((hoverState || configuration.isPressed) ? 0.15 : 0))
                    .animation(.easeInOut(duration: 0.1), value: hoverState)
                    .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            )
            .contentShape(Rectangle())
            .onHover { hovering in
                hoverState = hovering
            }
    }

    @State private var hoverState = false
}

// MARK: - Footer Button Style

/// A button style for footer actions (Settings, Quit, etc.)
/// Provides subtle hover feedback appropriate for footer buttons.
struct FooterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 11))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(nsColor: .controlAccentColor).opacity((hoverState || configuration.isPressed) ? 0.1 : 0))
                    .animation(.easeInOut(duration: 0.1), value: hoverState)
            )
            .contentShape(Rectangle())
            .onHover { hovering in
                hoverState = hovering
            }
    }

    @State private var hoverState = false
}

// MARK: - View Extensions

extension View {
    /// Applies the native menu button style.
    func nativeMenuButtonStyle() -> some View {
        self.buttonStyle(NativeMenuButtonStyle())
    }

    /// Applies the compact menu button style.
    func compactMenuButtonStyle() -> some View {
        self.buttonStyle(CompactMenuButtonStyle())
    }

    /// Applies the footer button style.
    func footerButtonStyle() -> some View {
        self.buttonStyle(FooterButtonStyle())
    }
}
