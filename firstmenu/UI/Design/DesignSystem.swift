//
//  DesignSystem.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI

// MARK: - Design System
/// Centralized styling system for consistent UI across the app.
enum DesignSystem {

    // MARK: - Typography

    enum Typography {
        /// Menu bar text - matches macOS system font
        static let menuBarFont = Font.system(size: 12, weight: .regular)
        static let menuBarFontMonospaced = Font.system(size: 12, weight: .regular).monospacedDigit()

        /// Popover headings
        static let headingFont = Font.system(size: 13, weight: .semibold)

        /// Popover body text
        static let bodyFont = Font.system(size: 12, weight: .medium).monospacedDigit()

        /// Popover secondary text
        static let secondaryFont = Font.system(size: 11, weight: .regular)

        /// Popover tertiary text
        static let tertiaryFont = Font.system(size: 10, weight: .regular)
    }

    // MARK: - Colors

    enum Colors {
        /// Menu bar text color
        static let menuBarText: Color = .white

        /// Menu bar text when inactive/dimmed
        static let menuBarTextDimmed: Color = .white.opacity(0.5)

        /// Progress bar colors based on percentage
        static func progressColor(for percentage: Double, thresholds: (warning: Double, critical: Double) = (70, 90)) -> Color {
            if percentage < thresholds.warning { return .green }
            if percentage < thresholds.critical { return .orange }
            return .red
        }
    }

    // MARK: - Spacing

    enum Spacing {
        /// Tight spacing for compact layouts
        static let tight: CGFloat = 2

        /// Default spacing between elements
        static let standard: CGFloat = 4

        /// Comfortable spacing for sections
        static let comfortable: CGFloat = 8

        /// Loose spacing for larger gaps
        static let loose: CGFloat = 12
    }

    // MARK: - Menu Bar

    enum MenuBar {
        /// Minimum width for any menu bar item (prevents cropping)
        static let minWidth: CGFloat = 24

        /// Extra padding added to calculated content width
        static let widthPadding: CGFloat = 8

        /// Height of menu bar items
        static let height: CGFloat = 22

        /// Icon size for menu bar symbols
        static let iconSize: CGFloat = 12
    }

    // MARK: - Popover

    enum Popover {
        /// Corner radius for popover content
        static let cornerRadius: CGFloat = 6

        /// Padding around popover content
        static let contentPadding: CGFloat = 8

        /// Background material
        static let backgroundMaterial: Material = .ultraThin

        /// Standard widths
        enum Width {
            static let compact: CGFloat = 160
            static let standard: CGFloat = 180
            static let wide: CGFloat = 200
            static let extraWide: CGFloat = 220
        }

        /// Standard heights
        enum Height {
            static let compact: CGFloat = 60
            static let standard: CGFloat = 70
            static let tall: CGFloat = 80
        }
    }

    // MARK: - Layout

    enum Layout {
        /// Standard corner radius
        static let cornerRadius: CGFloat = 4

        /// Border width (if used)
        static let borderWidth: CGFloat = 0.5
    }
}

// MARK: - View Extensions

extension View {
    /// Applies menu bar text styling.
    func menuBarText() -> some View {
        self
            .font(DesignSystem.Typography.menuBarFont)
            .foregroundStyle(DesignSystem.Colors.menuBarText)
    }

    /// Applies menu bar monospaced text styling.
    func menuBarMonospaced() -> some View {
        self
            .font(DesignSystem.Typography.menuBarFontMonospaced)
            .foregroundStyle(DesignSystem.Colors.menuBarText)
    }

    /// Applies popover heading styling.
    func popoverHeading() -> some View {
        self
            .font(DesignSystem.Typography.headingFont)
            .foregroundStyle(.primary)
    }

    /// Applies popover body styling.
    func popoverBody() -> some View {
        self
            .font(DesignSystem.Typography.bodyFont)
            .foregroundStyle(.primary)
    }

    /// Applies popover secondary styling.
    func popoverSecondary() -> some View {
        self
            .font(DesignSystem.Typography.secondaryFont)
            .foregroundStyle(.secondary)
    }

    /// Applies popover tertiary styling.
    func popoverTertiary() -> some View {
        self
            .font(DesignSystem.Typography.tertiaryFont)
            .foregroundStyle(.tertiary)
    }
}

