//
//  AppProcessTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

final class AppProcessTests: XCTestCase {
    func testAppProcessInitialization() {
        let app = AppProcess(
            id: "com.example.app",
            name: "TestApp",
            bundleIdentifier: "com.example.app",
            pid: 1234
        )

        XCTAssertEqual(app.id, "com.example.app")
        XCTAssertEqual(app.name, "TestApp")
        XCTAssertEqual(app.bundleIdentifier, "com.example.app")
        XCTAssertEqual(app.pid, 1234)
    }

    func testAppProcessWithNilBundleIdentifier() {
        let app = AppProcess(
            id: "local-process",
            name: "LocalProcess",
            bundleIdentifier: nil,
            pid: 5678
        )

        XCTAssertNil(app.bundleIdentifier)
        XCTAssertEqual(app.name, "LocalProcess")
    }

    func testIdentifiable() {
        let app1 = AppProcess(
            id: "unique-id",
            name: "App",
            bundleIdentifier: "com.app",
            pid: 100
        )

        let app2 = AppProcess(
            id: "unique-id",
            name: "DifferentName",
            bundleIdentifier: "com.different",
            pid: 200
        )

        XCTAssertEqual(app1.id, app2.id)
    }

    func testEquatable() {
        let app1 = AppProcess(
            id: "com.test.app",
            name: "TestApp",
            bundleIdentifier: "com.test.app",
            pid: 1000
        )

        let app2 = AppProcess(
            id: "com.test.app",
            name: "TestApp",
            bundleIdentifier: "com.test.app",
            pid: 1000
        )

        XCTAssertEqual(app1, app2)
    }
}
