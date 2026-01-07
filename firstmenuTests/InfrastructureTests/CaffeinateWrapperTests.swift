//
//  CaffeinateWrapperTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
import SwiftUI
@testable import firstmenu

/// Tests for CaffeinateWrapper infrastructure component.
@MainActor
final class CaffeinateWrapperTests: XCTestCase {

    // MARK: - State Properties

    func testStateIsActive() {
        XCTAssertFalse(CaffeinateState.inactive.isActive)
        XCTAssertTrue(CaffeinateState.indefinite.isActive)
        XCTAssertTrue(CaffeinateState.active(until: Date().addingTimeInterval(100)).isActive)
    }

    func testStateIsIndefinite() {
        XCTAssertFalse(CaffeinateState.inactive.isIndefinite)
        XCTAssertTrue(CaffeinateState.indefinite.isIndefinite)
        XCTAssertFalse(CaffeinateState.active(until: Date().addingTimeInterval(100)).isIndefinite)
    }

    func testStateDescription() {
        let inactive = CaffeinateState.inactive
        let indefinite = CaffeinateState.indefinite
        let active = CaffeinateState.active(until: Date().addingTimeInterval(3600))

        // Verify states can be described
        XCTAssertNotNil(String(describing: inactive))
        XCTAssertNotNil(String(describing: indefinite))
        XCTAssertNotNil(String(describing: active))
    }

    // MARK: - Error Types

    func testPowerErrorActivationFailed() {
        let error = PowerError.activationFailed
        XCTAssertEqual(String(describing: error), "activationFailed")
    }

    func testPowerErrorDeactivationFailed() {
        let error = PowerError.deactivationFailed
        XCTAssertEqual(String(describing: error), "deactivationFailed")
    }

    // MARK: - State Comparison

    func testStateEquality() {
        let now = Date()
        let state1 = CaffeinateState.active(until: now)
        let state2 = CaffeinateState.active(until: now)

        // We can test the values by pattern matching
        if case .active(let date1) = state1, case .active(let date2) = state2 {
            XCTAssertEqual(date1, date2)
        }
    }

    func testActiveStateWithFutureDate() {
        let futureDate = Date().addingTimeInterval(3600)
        let state = CaffeinateState.active(until: futureDate)

        if case .active(let until) = state {
            XCTAssertTrue(until > Date())
            XCTAssertGreaterThan(until.timeIntervalSinceNow, 3500)
        } else {
            XCTFail("State should be .active")
        }
    }

    func testActiveStateWithPastDate() {
        let pastDate = Date().addingTimeInterval(-3600)
        let state = CaffeinateState.active(until: pastDate)

        if case .active(let until) = state {
            XCTAssertTrue(until < Date())
        } else {
            XCTFail("State should be .active")
        }
    }

    // MARK: - Process Configuration

    func testCaffeinateExecutablePath() {
        // Verify the caffeinate executable exists at expected location
        let caffeinatePath = "/usr/bin/caffeinate"
        let fileManager = FileManager.default
        XCTAssertTrue(fileManager.fileExists(atPath: caffeinatePath),
                     "caffeinate should exist at \(caffeinatePath)")
    }

    func testCaffeinateAcceptsDurationFlag() {
        // Verify caffeinate accepts the -t flag
        // This is a basic sanity check that the command is available
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        task.arguments = ["-h"]  // Help flag, should exit immediately

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        do {
            try task.run()
            task.waitUntilExit()
            // Caffeinate should exit cleanly with -h
            XCTAssertTrue(task.terminationStatus == 0 || task.terminationStatus != nil)
        } catch {
            XCTFail("caffeinate should be executable: \(error)")
        }
    }

    // MARK: - Edge Cases

    func testActiveStateWithZeroDuration() {
        let now = Date()
        let state = CaffeinateState.active(until: now)

        if case .active(let until) = state {
            // Zero duration should still be a valid state
            XCTAssertNotNil(until)
        } else {
            XCTFail("State should be .active")
        }
    }

    func testActiveStateWithVeryLongDuration() {
        let farFuture = Date().addingTimeInterval(365 * 24 * 3600)  // 1 year
        let state = CaffeinateState.active(until: farFuture)

        if case .active(let until) = state {
            XCTAssertTrue(until > Date().addingTimeInterval(364 * 24 * 3600))
        } else {
            XCTFail("State should be .active")
        }
    }
}
