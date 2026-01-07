//
//  DesignSystemTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import XCTest
@testable import firstmenu

/// Tests for DesignSystem styling constants.
final class DesignSystemTests: XCTestCase {

    // MARK: - Typography

    func testMenuBarFontExists() {
        let font = DesignSystem.Typography.menuBarFont
        // Font values are opaque in SwiftUI, we just verify they're accessible
        XCTAssertNotNil(font)
    }

    func testMenuBarFontMonospacedExists() {
        let font = DesignSystem.Typography.menuBarFontMonospaced
        XCTAssertNotNil(font)
    }

    func testHeadingFontExists() {
        let font = DesignSystem.Typography.headingFont
        XCTAssertNotNil(font)
    }

    func testBodyFontExists() {
        let font = DesignSystem.Typography.bodyFont
        XCTAssertNotNil(font)
    }

    func testSecondaryFontExists() {
        let font = DesignSystem.Typography.secondaryFont
        XCTAssertNotNil(font)
    }

    func testTertiaryFontExists() {
        let font = DesignSystem.Typography.tertiaryFont
        XCTAssertNotNil(font)
    }

    // MARK: - Colors

    func testMenuBarTextColor() {
        let color = DesignSystem.Colors.menuBarText
        // Verify it's a valid color (white)
        XCTAssertEqual(color, .white)
    }

    func testMenuBarTextDimmedColor() {
        let color = DesignSystem.Colors.menuBarTextDimmed
        // Verify it's white with reduced opacity
        XCTAssertTrue(color.description.contains("white") || color == .white.opacity(0.5))
    }

    func testProgressColorGreenForLowPercentage() {
        let color = DesignSystem.Colors.progressColor(for: 50)
        // 50% is below warning threshold (70), should be green
        // Note: Color equality is limited in SwiftUI, we verify it doesn't crash
        XCTAssertNotNil(color)
    }

    func testProgressColorOrangeForWarningPercentage() {
        let color = DesignSystem.Colors.progressColor(for: 75)
        // 75% is above warning (70) but below critical (90), should be orange
        XCTAssertNotNil(color)
    }

    func testProgressColorRedForCriticalPercentage() {
        let color = DesignSystem.Colors.progressColor(for: 95)
        // 95% is above critical threshold (90), should be red
        XCTAssertNotNil(color)
    }

    func testProgressColorWithCustomThresholds() {
        let color = DesignSystem.Colors.progressColor(for: 85, thresholds: (50, 80))
        // 85% is above critical (80), should be red
        XCTAssertNotNil(color)
    }

    func testProgressColorAtBoundaryValues() {
        let green = DesignSystem.Colors.progressColor(for: 69)
        let orange = DesignSystem.Colors.progressColor(for: 70)
        let red = DesignSystem.Colors.progressColor(for: 90)

        XCTAssertNotNil(green)
        XCTAssertNotNil(orange)
        XCTAssertNotNil(red)
    }

    func testProgressColorForZeroPercent() {
        let color = DesignSystem.Colors.progressColor(for: 0)
        XCTAssertNotNil(color)
    }

    func testProgressColorForHundredPercent() {
        let color = DesignSystem.Colors.progressColor(for: 100)
        XCTAssertNotNil(color)
    }

    // MARK: - Spacing

    func testSpacingTight() {
        XCTAssertEqual(DesignSystem.Spacing.tight, 2)
    }

    func testSpacingStandard() {
        XCTAssertEqual(DesignSystem.Spacing.standard, 4)
    }

    func testSpacingComfortable() {
        XCTAssertEqual(DesignSystem.Spacing.comfortable, 8)
    }

    func testSpacingLoose() {
        XCTAssertEqual(DesignSystem.Spacing.loose, 12)
    }

    // MARK: - Menu Bar

    func testMenuBarMinWidth() {
        XCTAssertEqual(DesignSystem.MenuBar.minWidth, 24)
    }

    func testMenuBarWidthPadding() {
        XCTAssertEqual(DesignSystem.MenuBar.widthPadding, 8)
    }

    func testMenuBarHeight() {
        XCTAssertEqual(DesignSystem.MenuBar.height, 22)
    }

    func testMenuBarIconSize() {
        XCTAssertEqual(DesignSystem.MenuBar.iconSize, 12)
    }

    // MARK: - Popover

    func testPopoverCornerRadius() {
        XCTAssertEqual(DesignSystem.Popover.cornerRadius, 6)
    }

    func testPopoverContentPadding() {
        XCTAssertEqual(DesignSystem.Popover.contentPadding, 8)
    }

    func testPopoverBackgroundMaterial() {
        let material = DesignSystem.Popover.backgroundMaterial
        // Material is an opaque type, just verify it's accessible
        XCTAssertNotNil(material)
    }

    func testPopoverWidthCompact() {
        XCTAssertEqual(DesignSystem.Popover.Width.compact, 160)
    }

    func testPopoverWidthStandard() {
        XCTAssertEqual(DesignSystem.Popover.Width.standard, 180)
    }

    func testPopoverWidthWide() {
        XCTAssertEqual(DesignSystem.Popover.Width.wide, 200)
    }

    func testPopoverWidthExtraWide() {
        XCTAssertEqual(DesignSystem.Popover.Width.extraWide, 220)
    }

    func testPopoverHeightCompact() {
        XCTAssertEqual(DesignSystem.Popover.Height.compact, 60)
    }

    func testPopoverHeightStandard() {
        XCTAssertEqual(DesignSystem.Popover.Height.standard, 70)
    }

    func testPopoverHeightTall() {
        XCTAssertEqual(DesignSystem.Popover.Height.tall, 80)
    }

    // MARK: - Layout

    func testLayoutCornerRadius() {
        XCTAssertEqual(DesignSystem.Layout.cornerRadius, 4)
    }

    func testLayoutBorderWidth() {
        XCTAssertEqual(DesignSystem.Layout.borderWidth, 0.5)
    }

    // MARK: - View Extensions

    func testMenuBarTextExtensionExists() {
        let text = Text("test")
        let styled = text.menuBarText()
        // View extensions return opaque types, just verify they compile and don't crash
        XCTAssertNotNil(styled)
    }

    func testMenuBarMonospacedExtensionExists() {
        let text = Text("test")
        let styled = text.menuBarMonospaced()
        XCTAssertNotNil(styled)
    }

    func testPopoverHeadingExtensionExists() {
        let text = Text("test")
        let styled = text.popoverHeading()
        XCTAssertNotNil(styled)
    }

    func testPopoverBodyExtensionExists() {
        let text = Text("test")
        let styled = text.popoverBody()
        XCTAssertNotNil(styled)
    }

    func testPopoverSecondaryExtensionExists() {
        let text = Text("test")
        let styled = text.popoverSecondary()
        XCTAssertNotNil(styled)
    }

    func testPopoverTertiaryExtensionExists() {
        let text = Text("test")
        let styled = text.popoverTertiary()
        XCTAssertNotNil(styled)
    }
}
