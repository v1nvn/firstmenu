//
//  AppProcessManagerTests.swift
//  firstmenuTests
//
//  Created by Vineet Kumar on 06/01/26.
//

import XCTest
@testable import firstmenu

@MainActor
final class AppProcessManagerTests: XCTestCase {
    func testRefreshLoadsApps() async throws {
        let appLister = MockAppLister()
        let expectedApps = [
            AppProcess(id: "com.apple.Safari", name: "Safari", bundleIdentifier: "com.apple.Safari", pid: 1001),
            AppProcess(id: "com.apple.finder", name: "Finder", bundleIdentifier: "com.apple.finder", pid: 1002),
        ]
        await appLister.setApps(expectedApps)

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 2)
        XCTAssertEqual(manager.runningApps[0].name, "Safari")
        XCTAssertEqual(manager.runningApps[1].name, "Finder")
    }

    func testRefreshHandlesErrors() async throws {
        let appLister = MockAppLister()
        await appLister.setShouldThrow(true)

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 0)
        XCTAssertFalse(manager.isLoading)
    }

    func testAppCount() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1),
            AppProcess(id: "2", name: "App2", bundleIdentifier: "com.app2", pid: 2),
            AppProcess(id: "3", name: "App3", bundleIdentifier: "com.app3", pid: 3),
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.appCount, 3)
    }

    func testQuitAppRemovesFromList() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "com.test.app1", name: "App1", bundleIdentifier: "com.test.app1", pid: 1),
            AppProcess(id: "com.test.app2", name: "App2", bundleIdentifier: "com.test.app2", pid: 2),
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 2)

        try await manager.quitApp(bundleIdentifier: "com.test.app1")

        XCTAssertEqual(manager.runningApps.count, 1)
        XCTAssertEqual(manager.runningApps.first?.bundleIdentifier, "com.test.app2")

        let quitCallCount = await appLister.quitCallCount()
        XCTAssertEqual(quitCallCount.count, 1)
        XCTAssertEqual(quitCallCount.first, "com.test.app1")
    }

    func testQuitAll() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1),
            AppProcess(id: "2", name: "App2", bundleIdentifier: "com.app2", pid: 2),
            AppProcess(id: "3", name: "App3", bundleIdentifier: "com.app3", pid: 3),
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 3)

        try await manager.quitAll()

        XCTAssertEqual(manager.runningApps.count, 0)

        let quitCallCount = await appLister.quitCallCount()
        XCTAssertEqual(quitCallCount.count, 3)
    }

    func testQuitAllHandlesPartialFailure() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1),
            AppProcess(id: "2", name: "App2", bundleIdentifier: "com.app2", pid: 2),
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        // Simulate partial failure - second call throws
        await appLister.setShouldThrow(true)

        // Should throw because one of the quit operations fails
        do {
            try await manager.quitAll()
            XCTFail("Should have thrown an error")
        } catch {
            // Expected - at least one quit failed
        }
    }
}
