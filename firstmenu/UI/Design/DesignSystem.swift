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

        /// Network indicator colors following HIG
        static let download: Color = .green
        static let upload: Color = .blue
    }

    // MARK: - Spacing

    enum Spacing {
        /// Extra tight spacing for menu bar items
        static let extraTight: CGFloat = 2

        /// Tight spacing for compact layouts
        static let tight: CGFloat = 4

        /// Standard spacing between elements
        static let standard: CGFloat = 8

        /// Section padding
        static let section: CGFloat = 12

        /// Large spacing for major sections
        static let large: CGFloat = 16
    }

    // MARK: - Typography

    enum Typography {
        /// Menu bar label font
        static let menuBar: Font = .system(size: 12, weight: .regular).monospacedDigit()

        /// Section header font
        static let sectionHeader: Font = .subheadline.weight(.medium)

        /// Body text in popovers
        static let body: Font = .body

        /// Caption text
        static let caption: Font = .caption

        /// Monospaced digits for stats
        static let stats: Font = .system(.body, design: .monospaced)
    }

    // MARK: - Menu Bar

    enum MenuBar {
        /// Standard font for menu bar labels
        static let font: Font = Typography.menuBar

        /// Icon size for menu bar SF Symbols
        static let iconSize: CGFloat = 12

        /// Extra padding for menu bar item width calculation
        static let widthPadding: CGFloat = 8
    }

    // MARK: - Popover

    enum Popover {
        /// Standard width for compact popovers
        static let compactWidth: CGFloat = 200

        /// Standard width for regular popovers
        static let standardWidth: CGFloat = 220

        /// Standard width for wide popovers
        static let wideWidth: CGFloat = 260

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

    /// Applies standard section header styling.
    func sectionHeaderStyle() -> some View {
        self.font(DesignSystem.Typography.sectionHeader)
            .foregroundStyle(.secondary)
    }

    /// Applies monospaced stats styling.
    func statsStyle() -> some View {
        self.font(DesignSystem.Typography.stats)
    }
}

