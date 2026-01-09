//
//  ButtonStyles.swift
//  firstmenu
//
//  Native macOS button styles following Human Interface Guidelines
//

import SwiftUI

// MARK: - Accessory Button Style

/// A subtle button style for footer and accessory actions.
/// Uses semantic colors for automatic dark mode support.
struct AccessoryButtonStyle: ButtonStyle {
    @State private var isHovering = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.horizontal, DesignSystem.Spacing.standard)
            .padding(.vertical, DesignSystem.Spacing.tight)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(backgroundColor(isPressed: configuration.isPressed))
            )
            .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .onHover { hovering in
                isHovering = hovering
            }
            .animation(.easeInOut(duration: 0.15), value: isHovering)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        if isPressed {
            return .primary.opacity(0.12)
        } else if isHovering {
            return .primary.opacity(0.06)
        }
        return .clear
    }
}

// MARK: - Row Button Style

/// A button style for interactive list rows.
/// Provides full-width tap target with subtle hover feedback.
struct RowButtonStyle: ButtonStyle {
    @State private var isHovering = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                configuration.isPressed
                    ? Color.primary.opacity(0.1)
                    : (isHovering ? Color.primary.opacity(0.06) : Color.clear)
            )
            .contentShape(Rectangle())
            .onHover { hovering in
                isHovering = hovering
            }
            .animation(.easeInOut(duration: 0.15), value: isHovering)
    }
}

// MARK: - View Extensions

extension View {
    /// Applies the accessory button style for footer/secondary actions.
    func accessoryButtonStyle() -> some View {
        self.buttonStyle(AccessoryButtonStyle())
    }

    /// Applies the row button style for list items.
    func rowButtonStyle() -> some View {
        self.buttonStyle(RowButtonStyle())
    }
}

// MARK: - Deprecated

/// Legacy name - use `accessoryButtonStyle()` instead.
extension View {
    @available(*, deprecated, renamed: "accessoryButtonStyle")
    func footerButtonStyle() -> some View {
        self.buttonStyle(AccessoryButtonStyle())
    }
}
