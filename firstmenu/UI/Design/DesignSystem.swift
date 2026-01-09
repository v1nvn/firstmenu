//
//  DesignSystem.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI

// MARK: - Design System

/// Centralized styling system for consistent UI across the app.
/// Uses semantic colors and native SwiftUI types for automatic dark mode support.
enum DesignSystem {

    // MARK: - Colors

    enum Colors {
        /// Progress bar colors based on percentage thresholds.
        /// - Parameters:
        ///   - percentage: Current value (0-100)
        ///   - thresholds: Warning and critical percentage thresholds
        /// - Returns: Green for normal, orange for warning, red for critical
        static func progressColor(
            for percentage: Double,
            thresholds: (warning: Double, critical: Double) = (70, 90)
        ) -> Color {
            if percentage < thresholds.warning { return .green }
            if percentage < thresholds.critical { return .orange }
            return .red
        }
    }

    // MARK: - Spacing

    enum Spacing {
        /// Tight spacing for compact layouts
        static let tight: CGFloat = 2

        /// Standard spacing between elements
        static let standard: CGFloat = 4
    }

    // MARK: - Menu Bar

    enum MenuBar {
        /// Standard font for menu bar labels
        static let font: Font = .system(size: 12, weight: .regular).monospacedDigit()

        /// Icon size for menu bar SF Symbols
        static let iconSize: CGFloat = 12

        /// Extra padding for menu bar item width calculation
        static let widthPadding: CGFloat = 8
    }

    // MARK: - Popover

    enum Popover {
        /// Corner radius for popover content
        static let cornerRadius: CGFloat = 8
    }
}

// MARK: - View Extensions

extension View {
    /// Applies menu bar monospaced text styling.
    /// Uses primary label color which adapts to menu bar appearance automatically.
    func menuBarMonospaced() -> some View {
        self.font(DesignSystem.MenuBar.font)
    }
}

