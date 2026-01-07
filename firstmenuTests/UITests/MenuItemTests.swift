//
//  MenuItemTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI
import XCTest
@testable import firstmenu

/// Tests for MenuItem components.
final class MenuItemTests: XCTestCase {

    // MARK: - SizePreferenceKey

    func testSizePreferenceKeyDefaultValue() {
        XCTAssertEqual(SizePreferenceKey.defaultValue, .zero)
    }

    func testSizePreferenceKeyReduce() {
        var size = CGSize(width: 100, height: 50)

        // Reduce with next value
        SizePreferenceKey.reduce(value: &size) { CGSize(width: 200, height: 100) }

        // The reduce implementation replaces with nextValue()
        XCTAssertEqual(size, CGSize(width: 200, height: 100))
    }

    func testSizePreferenceKeyReduceWithZero() {
        var size = CGSize(width: 100, height: 50)

        // Reduce with zero value
        SizePreferenceKey.reduce(value: &size) { .zero }

        XCTAssertEqual(size, .zero)
    }

    func testSizePreferenceKeyReduceWithNegativeSize() {
        var size = CGSize(width: 100, height: 50)

        // Reduce with negative dimensions (edge case)
        SizePreferenceKey.reduce(value: &size) { CGSize(width: -10, height: -20) }

        XCTAssertEqual(size, CGSize(width: -10, height: -20))
    }

    func testSizePreferenceKeyReduceChained() {
        var size = CGSize.zero

        // Chain multiple reduces
        SizePreferenceKey.reduce(value: &size) { CGSize(width: 50, height: 25) }
        XCTAssertEqual(size, CGSize(width: 50, height: 25))

        SizePreferenceKey.reduce(value: &size) { CGSize(width: 150, height: 75) }
        XCTAssertEqual(size, CGSize(width: 150, height: 75))

        SizePreferenceKey.reduce(value: &size) { CGSize(width: 200, height: 100) }
        XCTAssertEqual(size, CGSize(width: 200, height: 100))
    }
}
