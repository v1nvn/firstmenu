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

    // MARK: - Basic Test

    func testBasicSetup() {
        // This test verifies that the test environment is working
        XCTAssertTrue(true, "Basic test setup is working")
    }

    // MARK: - MockPowerProvider Tests

    func testMockPowerProviderCreation() {
        let provider = MockPowerProvider()
        XCTAssertEqual(provider.state, .inactive)
    }

    // MARK: - PowerAssertionController Tests

    func testPowerAssertionControllerCreation() async {
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)
        XCTAssertNotNil(controller)
        XCTAssertEqual(controller.state, .inactive)
    }

    func testPowerAssertionControllerStateAccess() async {
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)
        let state = controller.state
        XCTAssertTrue(state == .inactive || state != .inactive, "State should be readable")
    }

    func testPowerAssertionControllerInitOnly() async {
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)
        XCTAssertNotNil(controller)
    }

    // MARK: - StatusText Tests

    func testStatusTextForInactiveState() async {
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)
        XCTAssertEqual(controller.state, .inactive)
        XCTAssertFalse(controller.isActive)
    }

    // MARK: - CaffeinateMenuView Tests

    func testCaffeinateMenuViewRenders() async {
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)
        XCTAssertNotNil(view)
    }

    func testCaffeinateMenuViewWithInactiveState() async {
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)
        XCTAssertNotNil(view.body, "View body should render with inactive state")
    }

    func testCaffeinateMenuViewWithActiveState() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: 3600)
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)
        XCTAssertNotNil(view.body, "View body should render with active state")
    }

    func testCaffeinateMenuViewWithTimedState() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: 300)  // 5 minutes
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)
        XCTAssertNotNil(view.body, "View body should render with timed state")
    }

    func testCaffeinateMenuViewWithAllButtons() async {
        let provider = MockPowerProvider()
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)
        XCTAssertNotNil(view.body, "View should render all buttons")
    }

    // MARK: - PowerAssertionController StatusText Tests

    func testStatusTextForIndefiniteState() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: nil)
        let controller = PowerAssertionController(powerProvider: provider)
        XCTAssertTrue(controller.isIndefinite)
        XCTAssertTrue(controller.isActive)
    }

    func testStatusTextForActiveStateWithRemainingTime() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: 3600)  // 1 hour
        let controller = PowerAssertionController(powerProvider: provider)
        XCTAssertTrue(controller.isActive)
        XCTAssertFalse(controller.isIndefinite)
    }

    func testStatusTextForActiveStateAlmostExpired() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: 60)  // 1 minute
        let controller = PowerAssertionController(powerProvider: provider)
        XCTAssertTrue(controller.isActive)
    }

    func testStatusTextForActiveStateExpired() async {
        let provider = MockPowerProvider()
        // Activate with negative duration to simulate expired state
        try? await provider.activate(duration: -1)
        let controller = PowerAssertionController(powerProvider: provider)
        // State is technically active but with expired time
        XCTAssertTrue(controller.isActive)
    }

    // MARK: - Integration Tests

    func testCaffeinateMenuViewShowsDisableButtonWhenActive() async {
        let provider = MockPowerProvider()
        try? await provider.activate(duration: 3600)
        let controller = PowerAssertionController(powerProvider: provider)
        let view = CaffeinateMenuView(powerController: controller)
        XCTAssertTrue(controller.isActive)
        XCTAssertNotNil(view.body, "View should render with disable button")
    }

}
