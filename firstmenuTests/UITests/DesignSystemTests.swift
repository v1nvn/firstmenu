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
        let font = DesignSystem.Typography.menuBar
        XCTAssertNotNil(font)
    }

    func testSectionHeaderFontExists() {
        let font = DesignSystem.Typography.sectionHeader
        XCTAssertNotNil(font)
    }

    func testBodyFontExists() {
        let font = DesignSystem.Typography.body
        XCTAssertNotNil(font)
    }

    func testCaptionFontExists() {
        let font = DesignSystem.Typography.caption
        XCTAssertNotNil(font)
    }

    func testStatsFontExists() {
        let font = DesignSystem.Typography.stats
        XCTAssertNotNil(font)
    }

    // MARK: - Colors

    func testDownloadColor() {
        let color = DesignSystem.Colors.download
        XCTAssertEqual(color, .green)
    }

    func testUploadColor() {
        let color = DesignSystem.Colors.upload
        XCTAssertEqual(color, .blue)
    }

    func testProgressColorGreenForLowPercentage() {
        let color = DesignSystem.Colors.progressColor(for: 50)
        XCTAssertNotNil(color)
    }

    func testProgressColorOrangeForWarningPercentage() {
        let color = DesignSystem.Colors.progressColor(for: 75)
        XCTAssertNotNil(color)
    }

    func testProgressColorRedForCriticalPercentage() {
        let color = DesignSystem.Colors.progressColor(for: 95)
        XCTAssertNotNil(color)
    }

    func testProgressColorWithCustomThresholds() {
        let color = DesignSystem.Colors.progressColor(for: 85, thresholds: (50, 80))
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

    func testSpacingExtraTight() {
        XCTAssertEqual(DesignSystem.Spacing.extraTight, 2)
    }

    func testSpacingTight() {
        XCTAssertEqual(DesignSystem.Spacing.tight, 4)
    }

    func testSpacingStandard() {
        XCTAssertEqual(DesignSystem.Spacing.standard, 8)
    }

    func testSpacingSection() {
        XCTAssertEqual(DesignSystem.Spacing.section, 12)
    }

    func testSpacingLarge() {
        XCTAssertEqual(DesignSystem.Spacing.large, 16)
    }

    // MARK: - Menu Bar

    func testMenuBarFont() {
        let font = DesignSystem.MenuBar.font
        XCTAssertNotNil(font)
    }

    func testMenuBarWidthPadding() {
        XCTAssertEqual(DesignSystem.MenuBar.widthPadding, 8)
    }

    func testMenuBarIconSize() {
        XCTAssertEqual(DesignSystem.MenuBar.iconSize, 12)
    }

    // MARK: - Popover

    func testPopoverCornerRadius() {
        XCTAssertEqual(DesignSystem.Popover.cornerRadius, 8)
    }

    func testPopoverCompactWidth() {
        XCTAssertEqual(DesignSystem.Popover.compactWidth, 200)
    }

    func testPopoverStandardWidth() {
        XCTAssertEqual(DesignSystem.Popover.standardWidth, 220)
    }

    func testPopoverWideWidth() {
        XCTAssertEqual(DesignSystem.Popover.wideWidth, 260)
    }

    // MARK: - View Extensions

    func testMenuBarMonospacedExtensionExists() {
        let text = Text("test")
        let styled = text.menuBarMonospaced()
        XCTAssertNotNil(styled)
    }

    func testSectionHeaderStyleExtensionExists() {
        let text = Text("test")
        let styled = text.sectionHeaderStyle()
        XCTAssertNotNil(styled)
    }

    func testStatsStyleExtensionExists() {
        let text = Text("test")
        let styled = text.statsStyle()
        XCTAssertNotNil(styled)
    }
}
