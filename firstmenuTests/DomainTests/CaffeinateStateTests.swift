//
//  CaffeinateStateTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

final class CaffeinateStateTests: XCTestCase {
    func testInactiveState() {
        let state = CaffeinateState.inactive

        XCTAssertFalse(state.isActive)
        XCTAssertFalse(state.isIndefinite)
    }

    func testActiveState() {
        let date = Date().addingTimeInterval(3600)
        let state = CaffeinateState.active(until: date)

        XCTAssertTrue(state.isActive)
        XCTAssertFalse(state.isIndefinite)
    }

    func testIndefiniteState() {
        let state = CaffeinateState.indefinite

        XCTAssertTrue(state.isActive)
        XCTAssertTrue(state.isIndefinite)
    }

    func testActiveStateWithPastDate() {
        let pastDate = Date().addingTimeInterval(-100)
        let state = CaffeinateState.active(until: pastDate)

        XCTAssertTrue(state.isActive)  // State is active even if date passed
        XCTAssertFalse(state.isIndefinite)
    }

    func testEquatable() {
        XCTAssertEqual(CaffeinateState.inactive, .inactive)

        let date = Date()
        let active1 = CaffeinateState.active(until: date)
        let active2 = CaffeinateState.active(until: date)
        XCTAssertEqual(active1, active2)

        XCTAssertEqual(CaffeinateState.indefinite, .indefinite)
    }
}
