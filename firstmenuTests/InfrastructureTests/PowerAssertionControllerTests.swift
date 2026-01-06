//
//  PowerAssertionControllerTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

@MainActor
final class PowerAssertionControllerTests: XCTestCase {
    var powerProvider: MockPowerProvider!
    var controller: PowerAssertionController!

    override func setUp() async throws {
        try await super.setUp()
        powerProvider = MockPowerProvider()
        controller = PowerAssertionController(powerProvider: powerProvider)
    }

    func testInitialStateIsInactive() {
        XCTAssertEqual(controller.state, .inactive)
        XCTAssertFalse(controller.isActive)
        XCTAssertFalse(controller.isIndefinite)
    }

    func testKeepAwakeForDuration() async throws {
        try await controller.keepAwake(for: 3600)  // 1 hour

        XCTAssertTrue(controller.isActive)
        XCTAssertFalse(controller.isIndefinite)

        if case .active(let until) = controller.state {
            let timeRemaining = until.timeIntervalSinceNow
            XCTAssertGreaterThan(timeRemaining, 3500)  // At least 58+ minutes remaining
            XCTAssertLessThanOrEqual(timeRemaining, 3600)
        } else {
            XCTFail("State should be .active")
        }
    }

    func testKeepAwakeIndefinitely() async throws {
        try await controller.keepAwakeIndefinitely()

        XCTAssertTrue(controller.isActive)
        XCTAssertTrue(controller.isIndefinite)
        XCTAssertEqual(controller.state, .indefinite)
    }

    func testAllowSleep() async throws {
        try await controller.keepAwakeIndefinitely()
        XCTAssertTrue(controller.isActive)

        try await controller.allowSleep()

        XCTAssertFalse(controller.isActive)
        XCTAssertEqual(controller.state, .inactive)
    }

    func testResetTimer() async throws {
        try await controller.keepAwake(for: 300)  // 5 minutes
        XCTAssertTrue(controller.isActive)

        try await controller.resetTimer(duration: 600)  // Reset to 10 minutes

        XCTAssertTrue(controller.isActive)

        if case .active(let until) = controller.state {
            let timeRemaining = until.timeIntervalSinceNow
            XCTAssertGreaterThan(timeRemaining, 590)  // At least 9+ minutes remaining
        } else {
            XCTFail("State should be .active")
        }
    }

    func testActivationReplacesPreviousState() async throws {
        try await controller.keepAwake(for: 3600)
        XCTAssertTrue(controller.isActive)

        try await controller.keepAwakeIndefinitely()

        XCTAssertTrue(controller.isIndefinite)
    }

    func testActivationError() async throws {
        await powerProvider.setShouldThrow(true)

        do {
            try await controller.keepAwake(for: 60)
            XCTFail("Should have thrown an error")
        } catch {
            // Expected
            XCTAssertFalse(controller.isActive)
        }
    }

    func testDeactivationError() async throws {
        try await controller.keepAwakeIndefinitely()
        XCTAssertTrue(controller.isActive)

        await powerProvider.setShouldThrow(true)

        do {
            try await controller.allowSleep()
            XCTFail("Should have thrown an error")
        } catch {
            // Expected
            // State should still be active since deactivation failed
            XCTAssertTrue(controller.isActive)
        }
    }

    func testStateChangesAreObservable() async throws {
        // Verify initial state
        XCTAssertEqual(controller.state, .inactive)

        // Trigger state change
        try await controller.keepAwakeIndefinitely()

        // Verify state changed
        XCTAssertEqual(controller.state, .indefinite)
        XCTAssertTrue(controller.isActive)
    }
}
