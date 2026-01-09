//
//  ButtonStyles.swift
//  firstmenu
//
//  Native macOS button styles
//

import SwiftUI

// MARK: - Footer Button Style

/// A button style for footer actions (Settings, Quit, etc.)
/// Uses native macOS styling with subtle hover feedback.
struct FooterButtonStyle: ButtonStyle {
    @State private var isHovering = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(isHovering || configuration.isPressed ? Color.primary.opacity(0.1) : Color.clear)
            )
            .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .onHover { hovering in
                isHovering = hovering
            }
            .animation(.easeInOut(duration: 0.15), value: isHovering)
    }
}

// MARK: - View Extensions

extension View {
    /// Applies the footer button style.
    func footerButtonStyle() -> some View {
        self.buttonStyle(FooterButtonStyle())
    }
}
