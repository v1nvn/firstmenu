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

    // MARK: - Edge Cases

    func testZeroDuration() async throws {
        try await controller.keepAwake(for: 0)

        // With zero duration, the state should still be active (immediately expires)
        // but the implementation treats it as active
        XCTAssertTrue(controller.isActive)

        if case .active(let until) = controller.state {
            let timeRemaining = until.timeIntervalSinceNow
            XCTAssertLessThanOrEqual(timeRemaining, 1.0, "Zero duration should expire immediately")
        } else {
            XCTFail("State should be .active")
        }
    }

    func testVeryShortDuration() async throws {
        try await controller.keepAwake(for: 0.001)  // 1 millisecond

        XCTAssertTrue(controller.isActive)
    }

    func testVeryLongDuration() async throws {
        let oneYear: TimeInterval = 365 * 24 * 60 * 60
        try await controller.keepAwake(for: oneYear)

        XCTAssertTrue(controller.isActive)

        if case .active(let until) = controller.state {
            let timeRemaining = until.timeIntervalSinceNow
            XCTAssertGreaterThan(timeRemaining, oneYear - 10, "Should have most of the year remaining")
        }
    }

    func testMultipleActivations() async throws {
        // First activation
        try await controller.keepAwake(for: 300)
        var firstUntil: Date?
        if case .active(let until) = controller.state {
            firstUntil = until
        }

        // Second activation should replace first
        try await controller.keepAwake(for: 600)

        var secondUntil: Date?
        if case .active(let until) = controller.state {
            secondUntil = until
        }

        XCTAssertNotNil(firstUntil)
        XCTAssertNotNil(secondUntil)
        XCTAssertNotEqual(firstUntil, secondUntil, "Second activation should have new expiration time")
    }

    func testToggleBetweenActiveAndInactive() async throws {
        // Start inactive
        XCTAssertFalse(controller.isActive)

        // Activate
        try await controller.keepAwake(for: 60)
        XCTAssertTrue(controller.isActive)

        // Deactivate
        try await controller.allowSleep()
        XCTAssertFalse(controller.isActive)

        // Activate again
        try await controller.keepAwake(for: 60)
        XCTAssertTrue(controller.isActive)

        // Deactivate again
        try await controller.allowSleep()
        XCTAssertFalse(controller.isActive)
    }

    func testToggleBetweenActiveAndIndefinite() async throws {
        // Start with timed activation
        try await controller.keepAwake(for: 300)
        XCTAssertTrue(controller.isActive)
        XCTAssertFalse(controller.isIndefinite)

        // Switch to indefinite
        try await controller.keepAwakeIndefinitely()
        XCTAssertTrue(controller.isActive)
        XCTAssertTrue(controller.isIndefinite)

        // Switch back to timed
        try await controller.keepAwake(for: 300)
        XCTAssertTrue(controller.isActive)
        XCTAssertFalse(controller.isIndefinite)
    }

    func testAllowSleepWhenAlreadyInactive() async throws {
        // Should be able to call allowSleep when already inactive without error
        XCTAssertFalse(controller.isActive)

        try await controller.allowSleep()

        // Should still be inactive
        XCTAssertFalse(controller.isActive)
        XCTAssertEqual(controller.state, .inactive)
    }

    func testResetWhenInactive() async throws {
        // Reset should work even when not currently active
        XCTAssertFalse(controller.isActive)

        try await controller.resetTimer(duration: 300)

        // Should now be active
        XCTAssertTrue(controller.isActive)
    }

    func testConcurrentKeepAwakeCalls() async throws {
        // Launch multiple concurrent keepAwake calls
        async let activation1 = try? controller.keepAwake(for: 300)
        async let activation2 = try? controller.keepAwakeIndefinitely()
        async let activation3 = try? controller.keepAwake(for: 600)

        // Wait for all to complete
        await (activation1, activation2, activation3)

        // Last one should win (indefinite)
        XCTAssertTrue(controller.isIndefinite)
    }

    func testStateProviderDelegation() async throws {
        // Verify that controller properly delegates to provider
        XCTAssertEqual(controller.state, powerProvider.state)

        try await controller.keepAwakeIndefinitely()

        XCTAssertEqual(controller.state, powerProvider.state)
        XCTAssertEqual(controller.state, .indefinite)

        try await controller.allowSleep()

        XCTAssertEqual(controller.state, powerProvider.state)
        XCTAssertEqual(controller.state, .inactive)
    }

    func testNegativeDuration() async throws {
        // Negative duration should be treated by the implementation
        // The mock provider will handle it, setting a date in the past
        try await controller.keepAwake(for: -60)

        // State should still be active (even though technically expired)
        XCTAssertTrue(controller.isActive)
    }

    func testFractionalSecondDuration() async throws {
        try await controller.keepAwake(for: 0.5)

        XCTAssertTrue(controller.isActive)

        if case .active(let until) = controller.state {
            let timeRemaining = until.timeIntervalSinceNow
            XCTAssertGreaterThan(timeRemaining, 0, "Should have positive time remaining")
            XCTAssertLessThanOrEqual(timeRemaining, 1.0, "Should be less than 1 second")
        }
    }

    func testMultipleRapidResets() async throws {
        try await controller.keepAwake(for: 300)

        // Perform multiple rapid resets
        for i in 1..<10 {
            try await controller.resetTimer(duration: TimeInterval(i * 60))
        }

        XCTAssertTrue(controller.isActive)

        if case .active(let until) = controller.state {
            let timeRemaining = until.timeIntervalSinceNow
            XCTAssertGreaterThan(timeRemaining, 500)  // Last reset was 540 seconds
            XCTAssertLessThanOrEqual(timeRemaining, 600)
        }
    }

    func testIsActiveWithDifferentStates() async throws {
        // Inactive
        XCTAssertFalse(controller.isActive)

        // Active with duration
        try await controller.keepAwake(for: 60)
        XCTAssertTrue(controller.isActive)

        // Indefinite
        try await controller.keepAwakeIndefinitely()
        XCTAssertTrue(controller.isActive)

        // Back to inactive
        try await controller.allowSleep()
        XCTAssertFalse(controller.isActive)
    }

    func testIsIndefiniteWithDifferentStates() async throws {
        // Inactive
        XCTAssertFalse(controller.isIndefinite)

        // Active with duration
        try await controller.keepAwake(for: 60)
        XCTAssertFalse(controller.isIndefinite)

        // Indefinite
        try await controller.keepAwakeIndefinitely()
        XCTAssertTrue(controller.isIndefinite)

        // Back to inactive
        try await controller.allowSleep()
        XCTAssertFalse(controller.isIndefinite)
    }

    func testMultipleControllersWithSameProvider() async throws {
        let controller2 = PowerAssertionController(powerProvider: powerProvider)

        // Activate first controller
        try await controller.keepAwake(for: 300)

        // Second controller should see same state
        XCTAssertEqual(controller2.state, controller.state)
        XCTAssertTrue(controller2.isActive)

        // Activate second controller
        try await controller2.keepAwakeIndefinitely()

        // First controller should see updated state
        XCTAssertEqual(controller.state, controller2.state)
        XCTAssertTrue(controller.isIndefinite)
    }

    func testProviderStateTransitions() async throws {
        // Verify state transitions through all phases
        XCTAssertEqual(powerProvider.state, .inactive)

        try await controller.keepAwake(for: 100)
        // Use isActive to check for active state since we can't match the exact Date
        XCTAssertTrue(powerProvider.state.isActive)
        if case .active = powerProvider.state {
            // State is active
            XCTAssertTrue(true)
        } else {
            XCTFail("State should be active")
        }

        try await controller.keepAwakeIndefinitely()
        XCTAssertEqual(powerProvider.state, .indefinite)
        XCTAssertTrue(powerProvider.state.isIndefinite)

        try await controller.allowSleep()
        XCTAssertEqual(powerProvider.state, .inactive)
        XCTAssertFalse(powerProvider.state.isActive)
    }

    func testResetWithoutPriorActivation() async throws {
        // Reset should work even without a prior activation
        XCTAssertFalse(controller.isActive)

        try await controller.resetTimer(duration: 120)

        XCTAssertTrue(controller.isActive)

        if case .active(let until) = controller.state {
            let timeRemaining = until.timeIntervalSinceNow
            XCTAssertGreaterThan(timeRemaining, 110)
        }
    }

    func testStateEquality() {
        // Test CaffeinateState equality
        let inactive1 = CaffeinateState.inactive
        let inactive2 = CaffeinateState.inactive
        XCTAssertEqual(inactive1, inactive2)

        let now = Date()
        let active1 = CaffeinateState.active(until: now)
        let active2 = CaffeinateState.active(until: now)
        XCTAssertEqual(active1, active2)

        let indefinite1 = CaffeinateState.indefinite
        let indefinite2 = CaffeinateState.indefinite
        XCTAssertEqual(indefinite1, indefinite2)

        XCTAssertNotEqual(inactive1, active1)
        XCTAssertNotEqual(inactive1, indefinite1)
        XCTAssertNotEqual(active1, indefinite1)
    }
}
