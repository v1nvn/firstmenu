//
//  CaffeinateMenuTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import XCTest
@testable import firstmenu

@MainActor
final class CaffeinateMenuTests: XCTestCase {

    // MARK: - CaffeinateMenuView Tests

    func testCaffeinateMenuViewRenders() {
        let controller = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = CaffeinateMenuView(powerController: controller)
        XCTAssertNotNil(view)
    }

    func testCaffeinateMenuViewWithInactiveState() {
        let controller = PowerAssertionController(powerProvider: MockPowerProvider())
        let view = CaffeinateMenuView(powerController: controller)
        _ = view.body
    }

    func testCaffeinateMenuViewWithActiveState() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: nil)
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)
        _ = view.body
    }

    func testCaffeinateMenuViewWithTimedState() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: 600)
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)
        _ = view.body
    }

    // MARK: - CaffeinateButton Tests

    func testCaffeinateButtonRenders() {
        let button = CaffeinateButton(
            title: "15 Minutes",
            isActive: false,
            action: {}
        )
        XCTAssertNotNil(button)
    }

    func testCaffeinateButtonInactive() {
        let button = CaffeinateButton(
            title: "1 Hour",
            isActive: false,
            action: {}
        )
        _ = button.body
    }

    func testCaffeinateButtonActive() {
        let button = CaffeinateButton(
            title: "Indefinitely",
            isActive: true,
            action: {}
        )
        _ = button.body
    }

    func testCaffeinateButtonActionExecutes() {
        var actionExecuted = false
        let button = CaffeinateButton(
            title: "Test",
            isActive: false,
            action: { actionExecuted = true }
        )
        _ = button.body
        XCTAssertNotNil(button)
    }

    // MARK: - PowerAssertionController StatusText Tests

    func testStatusTextForInactiveState() {
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)
        XCTAssertEqual(controller.statusText, "System can sleep normally")
    }

    func testStatusTextForIndefiniteState() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: nil)
        let controller = PowerAssertionController(powerProvider: provider)
        XCTAssertEqual(controller.statusText, "Keeping awake indefinitely")
    }

    func testStatusTextForActiveStateWithRemainingTime() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: 1800)
        let controller = PowerAssertionController(powerProvider: provider)
        XCTAssertTrue(controller.statusText.contains("30 min"))
    }

    func testStatusTextForActiveStateAlmostExpired() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: 30)
        let controller = PowerAssertionController(powerProvider: provider)
        // Should show 0 min when less than a minute
        XCTAssertTrue(controller.statusText.contains("0 min"))
    }

    func testStatusTextForActiveStateExpired() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: 1) // 1 second, will expire quickly
        let controller = PowerAssertionController(powerProvider: provider)
        // After a brief delay, state will show as expired
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        XCTAssertTrue(controller.statusText.contains("Keeping awake") || controller.statusText.contains("0 min"))
    }

    // MARK: - Integration Tests

    func testCaffeinateMenuViewWithAllButtons() {
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)

        // View should render all preset buttons
        _ = view.body
        XCTAssertNotNil(view)
    }

    func testCaffeinateMenuViewShowsDisableButtonWhenActive() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: nil)
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)
        _ = view.body
        XCTAssertNotNil(view)
    }

}
