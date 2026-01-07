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

    // MARK: - Edge Cases

    func testAppProcessWithEmptyStrings() {
        let app = AppProcess(
            id: "",
            name: "",
            bundleIdentifier: "",
            pid: 0
        )

        XCTAssertEqual(app.id, "")
        XCTAssertEqual(app.name, "")
        XCTAssertEqual(app.bundleIdentifier, "")
        XCTAssertEqual(app.pid, 0)
    }

    func testAppProcessWithNegativePID() {
        let app = AppProcess(
            id: "test",
            name: "Test",
            bundleIdentifier: "com.test",
            pid: -1 as pid_t
        )

        XCTAssertEqual(app.pid, -1)
    }

    func testAppProcessWithZeroPID() {
        let app = AppProcess(
            id: "test",
            name: "Test",
            bundleIdentifier: "com.test",
            pid: 0 as pid_t
        )

        XCTAssertEqual(app.pid, 0)
    }

    func testAppProcessWithMaximumPID() {
        let app = AppProcess(
            id: "test",
            name: "Test",
            bundleIdentifier: "com.test",
            pid: Int32.max
        )

        XCTAssertEqual(app.pid, Int32.max)
    }

    func testAppProcessWithSpecialCharactersInName() {
        let app = AppProcess(
            id: "test",
            name: "Test/App & Tool®",
            bundleIdentifier: "com.test",
            pid: 100
        )

        XCTAssertEqual(app.name, "Test/App & Tool®")
    }

    func testAppProcessWithEmojiInName() {
        let app = AppProcess(
            id: "test",
            name: "Test App 🔥🚀",
            bundleIdentifier: "com.test",
            pid: 100
        )

        XCTAssertEqual(app.name, "Test App 🔥🚀")
    }

    func testAppProcessWithVeryLongName() {
        let longName = String(repeating: "A", count: 1000)
        let app = AppProcess(
            id: "test",
            name: longName,
            bundleIdentifier: "com.test",
            pid: 100
        )

        XCTAssertEqual(app.name, longName)
    }

    func testAppProcessWithVeryLongBundleIdentifier() {
        let longBundleId = String(repeating: "a.", count: 100) + "app"
        let app = AppProcess(
            id: longBundleId,
            name: "Test",
            bundleIdentifier: longBundleId,
            pid: 100
        )

        XCTAssertEqual(app.bundleIdentifier, longBundleId)
    }

    func testAppProcessWithNilBundleIdentifierInEquatable() {
        let app1 = AppProcess(
            id: "1",
            name: "App",
            bundleIdentifier: nil,
            pid: 100
        )

        let app2 = AppProcess(
            id: "1",
            name: "App",
            bundleIdentifier: nil,
            pid: 100
        )

        XCTAssertEqual(app1, app2)
    }

    func testAppProcessNotEqualWithDifferentIDs() {
        let app1 = AppProcess(
            id: "com.app1",
            name: "SameName",
            bundleIdentifier: "com.app1",
            pid: 100
        )

        let app2 = AppProcess(
            id: "com.app2",
            name: "SameName",
            bundleIdentifier: "com.app2",
            pid: 100
        )

        XCTAssertNotEqual(app1, app2)
    }

    func testAppProcessNotEqualWithDifferentNames() {
        let app1 = AppProcess(
            id: "same-id",
            name: "App1",
            bundleIdentifier: "com.app",
            pid: 100
        )

        let app2 = AppProcess(
            id: "same-id",
            name: "App2",
            bundleIdentifier: "com.app",
            pid: 100
        )

        XCTAssertNotEqual(app1, app2)
    }

    func testAppProcessNotEqualWithDifferentPIDs() {
        let app1 = AppProcess(
            id: "com.app",
            name: "App",
            bundleIdentifier: "com.app",
            pid: 100
        )

        let app2 = AppProcess(
            id: "com.app",
            name: "App",
            bundleIdentifier: "com.app",
            pid: 200
        )

        // ID is same, so they should be equal even with different PIDs
        XCTAssertEqual(app1, app2)
    }

    func testAppProcessWithWhitespaceInName() {
        let app = AppProcess(
            id: "test",
            name: "   App Name   ",
            bundleIdentifier: "com.test",
            pid: 100
        )

        XCTAssertEqual(app.name, "   App Name   ")
    }

    func testAppProcessWithNewlinesInName() {
        let app = AppProcess(
            id: "test",
            name: "App\nName\nWith\nNewlines",
            bundleIdentifier: "com.test",
            pid: 100
        )

        XCTAssertEqual(app.name, "App\nName\nWith\nNewlines")
    }

    func testMultipleAppProcessesWithDifferentIDs() {
        let apps = [
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 100 as pid_t),
            AppProcess(id: "2", name: "App2", bundleIdentifier: "com.app2", pid: 200 as pid_t),
            AppProcess(id: "3", name: "App3", bundleIdentifier: "com.app3", pid: 300)
        ]

        XCTAssertEqual(apps.count, 3)
        XCTAssertEqual(apps[0].id, "1")
        XCTAssertEqual(apps[1].id, "2")
        XCTAssertEqual(apps[2].id, "3")
    }

    func testAppProcessCanBeSorted() {
        let apps = [
            AppProcess(id: "3", name: "Zulu", bundleIdentifier: "com.z", pid: 300),
            AppProcess(id: "1", name: "Alpha", bundleIdentifier: "com.a", pid: 100 as pid_t),
            AppProcess(id: "2", name: "Bravo", bundleIdentifier: "com.b", pid: 200 as pid_t)
        ]

        let sorted = apps.sorted { $0.id < $1.id }

        XCTAssertEqual(sorted[0].id, "1")
        XCTAssertEqual(sorted[1].id, "2")
        XCTAssertEqual(sorted[2].id, "3")
    }

    func testAppProcessCanBeSortedByName() {
        let apps = [
            AppProcess(id: "1", name: "Zulu", bundleIdentifier: "com.z", pid: 300),
            AppProcess(id: "2", name: "Alpha", bundleIdentifier: "com.a", pid: 100 as pid_t),
            AppProcess(id: "3", name: "Bravo", bundleIdentifier: "com.b", pid: 200 as pid_t)
        ]

        let sorted = apps.sorted { $0.name < $1.name }

        XCTAssertEqual(sorted[0].name, "Alpha")
        XCTAssertEqual(sorted[1].name, "Bravo")
        XCTAssertEqual(sorted[2].name, "Zulu")
    }

    func testAppProcessIdentifiableID() {
        let app = AppProcess(
            id: "com.unique.id",
            name: "App",
            bundleIdentifier: "com.bundle",
            pid: 100
        )

        XCTAssertEqual(app.id, "com.unique.id")
    }

    func testAppProcessWithDotsInID() {
        let app = AppProcess(
            id: "com.company.app.subcomponent",
            name: "App",
            bundleIdentifier: "com.company.app",
            pid: 100
        )

        XCTAssertEqual(app.id, "com.company.app.subcomponent")
    }

    func testAppProcessWithHyphensAndUnderscores() {
        let app = AppProcess(
            id: "com.my-app_test",
            name: "My App_Test",
            bundleIdentifier: "com.my-app_test",
            pid: 100
        )

        XCTAssertEqual(app.id, "com.my-app_test")
        XCTAssertEqual(app.name, "My App_Test")
    }

    func testAppProcessNilVsEmptyBundleIdentifier() {
        let app1 = AppProcess(
            id: "1",
            name: "App",
            bundleIdentifier: nil,
            pid: 100
        )

        let app2 = AppProcess(
            id: "2",
            name: "App",
            bundleIdentifier: "",
            pid: 100
        )

        XCTAssertNotEqual(app1, app2, "nil and empty bundle identifiers should create different apps")
    }

    func testAppProcessWithUnicodeCharacters() {
        let app = AppProcess(
            id: "com.example.日本語",
            name: "アプリケーション",
            bundleIdentifier: "com.example.日本語",
            pid: 100
        )

        XCTAssertEqual(app.name, "アプリケーション")
        XCTAssertEqual(app.bundleIdentifier, "com.example.日本語")
    }
}
