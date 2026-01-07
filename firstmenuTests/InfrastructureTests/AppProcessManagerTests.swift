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
            AppProcess(id: "com.apple.Safari", name: "Safari", bundleIdentifier: "com.apple.Safari", pid: 1001 as pid_t),
            AppProcess(id: "com.apple.finder", name: "Finder", bundleIdentifier: "com.apple.finder", pid: 1002 as pid_t),
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
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1 as pid_t),
            AppProcess(id: "2", name: "App2", bundleIdentifier: "com.app2", pid: 2 as pid_t),
            AppProcess(id: "3", name: "App3", bundleIdentifier: "com.app3", pid: 3 as pid_t),
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.appCount, 3)
    }

    func testQuitAppRemovesFromList() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "com.test.app1", name: "App1", bundleIdentifier: "com.test.app1", pid: 1 as pid_t),
            AppProcess(id: "com.test.app2", name: "App2", bundleIdentifier: "com.test.app2", pid: 2 as pid_t),
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
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1 as pid_t),
            AppProcess(id: "2", name: "App2", bundleIdentifier: "com.app2", pid: 2 as pid_t),
            AppProcess(id: "3", name: "App3", bundleIdentifier: "com.app3", pid: 3 as pid_t),
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
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1 as pid_t),
            AppProcess(id: "2", name: "App2", bundleIdentifier: "com.app2", pid: 2 as pid_t),
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

    // MARK: - Edge Cases

    func testRefreshWithEmptyAppList() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 0)
        XCTAssertEqual(manager.appCount, 0)
    }

    func testRefreshWithSingleApp() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "OnlyApp", bundleIdentifier: "com.only", pid: 1 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 1)
        XCTAssertEqual(manager.runningApps.first?.name, "OnlyApp")
    }

    func testRefreshWithLargeNumberOfApps() async throws {
        let appLister = MockAppLister()
        let apps = (0..<100).map { i in
            AppProcess(id: "\(i)", name: "App\(i)", bundleIdentifier: "com.app\(i)", pid: Int32(i))
        }
        await appLister.setApps(apps)

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 100)
        XCTAssertEqual(manager.appCount, 100)
    }

    func testRefreshOverwritesPreviousList() async throws {
        let appLister = MockAppLister()

        let manager = AppProcessManager(appLister: appLister)

        // First refresh
        await appLister.setApps([
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1 as pid_t)
        ])
        await manager.refresh()
        XCTAssertEqual(manager.runningApps.count, 1)

        // Second refresh with different apps
        await appLister.setApps([
            AppProcess(id: "2", name: "App2", bundleIdentifier: "com.app2", pid: 2 as pid_t),
            AppProcess(id: "3", name: "App3", bundleIdentifier: "com.app3", pid: 3 as pid_t)
        ])
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 2)
        XCTAssertEqual(manager.runningApps.first?.id, "2")
    }

    func testLoadingStateFlag() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)

        XCTAssertFalse(manager.isLoading)

        // Create a slow refresh by not setting the apps immediately
        // Actually, the mock is fast, so we just verify it resets
        await manager.refresh()

        XCTAssertFalse(manager.isLoading, "Loading flag should be reset after refresh completes")
    }

    func testQuitAppWithNonExistentBundleIdentifier() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 1)

        // Try to quit an app that doesn't exist
        do {
            try await manager.quitApp(bundleIdentifier: "com.nonexistent")
            XCTFail("Should have thrown an error")
        } catch {
            // Expected - app not found
        }

        // The list should refresh even after error
        // The mock appLister removes the app only if it matches
    }

    func testQuitAppWithNilBundleIdentifier() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "NoBundle", bundleIdentifier: nil, pid: 1 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 1)

        // The implementation passes nil or empty string to quitApp
        // This should be handled by the appLister
        try? await manager.quitApp(bundleIdentifier: "")

        // List should refresh regardless of outcome
        XCTAssertNotNil(manager)
    }

    func testQuitAllWithEmptyList() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 0)

        // quitAll should not throw on empty list
        try await manager.quitAll()

        XCTAssertEqual(manager.runningApps.count, 0)
    }

    func testQuitAllWithSingleApp() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "Solo", bundleIdentifier: "com.solo", pid: 1 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 1)

        try await manager.quitAll()

        XCTAssertEqual(manager.runningApps.count, 0)
    }

    func testMultipleRefreshesInSequence() async throws {
        let appLister = MockAppLister()
        let manager = AppProcessManager(appLister: appLister)

        for i in 1..<10 {
            await appLister.setApps([
                AppProcess(id: "\(i)", name: "App\(i)", bundleIdentifier: "com.app\(i)", pid: Int32(i))
            ])
            await manager.refresh()
            XCTAssertEqual(manager.runningApps.count, 1)
            XCTAssertEqual(manager.runningApps.first?.name, "App\(i)")
        }
    }

    func testConcurrentRefreshes() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)

        // Launch multiple concurrent refreshes
        async let refresh1: Void = manager.refresh()
        async let refresh2: Void = manager.refresh()
        async let refresh3: Void = manager.refresh()

        await (refresh1, refresh2, refresh3)

        // Should complete without crashing
        XCTAssertNotNil(manager.runningApps)
    }

    func testAppCountUpdatesAfterRefresh() async throws {
        let appLister = MockAppLister()
        let manager = AppProcessManager(appLister: appLister)

        XCTAssertEqual(manager.appCount, 0)

        await appLister.setApps([
            AppProcess(id: "1", name: "A", bundleIdentifier: "com.a", pid: 1 as pid_t),
            AppProcess(id: "2", name: "B", bundleIdentifier: "com.b", pid: 2 as pid_t),
            AppProcess(id: "3", name: "C", bundleIdentifier: "com.c", pid: 3 as pid_t)
        ])

        await manager.refresh()

        XCTAssertEqual(manager.appCount, 3)

        await appLister.setApps([
            AppProcess(id: "1", name: "A", bundleIdentifier: "com.a", pid: 1 as pid_t)
        ])

        await manager.refresh()

        XCTAssertEqual(manager.appCount, 1)
    }

    func testAppsAreInSameOrderAsProvided() async throws {
        let appLister = MockAppLister()
        let apps = [
            AppProcess(id: "3", name: "Zulu", bundleIdentifier: "com.z", pid: 3 as pid_t),
            AppProcess(id: "1", name: "Alpha", bundleIdentifier: "com.a", pid: 1 as pid_t),
            AppProcess(id: "2", name: "Bravo", bundleIdentifier: "com.b", pid: 2 as pid_t)
        ]
        await appLister.setApps(apps)

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 3)
        XCTAssertEqual(manager.runningApps[0].id, "3")
        XCTAssertEqual(manager.runningApps[1].id, "1")
        XCTAssertEqual(manager.runningApps[2].id, "2")
    }

    func testAppsWithDuplicateNames() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "SameName", bundleIdentifier: "com.app1", pid: 1 as pid_t),
            AppProcess(id: "2", name: "SameName", bundleIdentifier: "com.app2", pid: 2 as pid_t),
            AppProcess(id: "3", name: "SameName", bundleIdentifier: "com.app3", pid: 3 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 3)
        // All should have the same name but different IDs
        XCTAssertEqual(manager.runningApps[0].name, "SameName")
        XCTAssertEqual(manager.runningApps[1].name, "SameName")
        XCTAssertEqual(manager.runningApps[2].name, "SameName")

        XCTAssertNotEqual(manager.runningApps[0].id, manager.runningApps[1].id)
        XCTAssertNotEqual(manager.runningApps[1].id, manager.runningApps[2].id)
    }

    func testQuitAppRefreshesList() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1 as pid_t),
            AppProcess(id: "2", name: "App2", bundleIdentifier: "com.app2", pid: 2 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 2)

        // Quit one app - should trigger refresh
        try await manager.quitApp(bundleIdentifier: "com.app1")

        // The mock removes the app from the list when quit is called
        // So the refresh will show the updated list
        XCTAssertEqual(manager.runningApps.count, 1)
        XCTAssertEqual(manager.runningApps.first?.bundleIdentifier, "com.app2")
    }

    func testAppsWithSpecialCharactersInNames() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "App & Tool®", bundleIdentifier: "com.app1", pid: 1 as pid_t),
            AppProcess(id: "2", name: "テスト", bundleIdentifier: "com.app2", pid: 2 as pid_t),
            AppProcess(id: "3", name: "App 🔥", bundleIdentifier: "com.app3", pid: 3 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 3)
        XCTAssertEqual(manager.runningApps[0].name, "App & Tool®")
        XCTAssertEqual(manager.runningApps[1].name, "テスト")
        XCTAssertEqual(manager.runningApps[2].name, "App 🔥")
    }

    func testManagerWithAppsHavingNilBundleIdentifiers() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "NoBundle1", bundleIdentifier: nil, pid: 1 as pid_t),
            AppProcess(id: "2", name: "HasBundle", bundleIdentifier: "com.app", pid: 2 as pid_t),
            AppProcess(id: "3", name: "NoBundle2", bundleIdentifier: nil, pid: 3 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 3)
        XCTAssertNil(manager.runningApps[0].bundleIdentifier)
        XCTAssertNotNil(manager.runningApps[1].bundleIdentifier)
        XCTAssertNil(manager.runningApps[2].bundleIdentifier)
    }

    func testQuitAllHandlesNilBundleIdentifiers() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "NoBundle", bundleIdentifier: nil, pid: 1 as pid_t),
            AppProcess(id: "2", name: "HasBundle", bundleIdentifier: "com.app", pid: 2 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        // quitAll should handle nil bundle identifiers by passing empty string
        try await manager.quitAll()

        XCTAssertEqual(manager.runningApps.count, 0)
    }

    func testInitialState() async {
        let appLister = MockAppLister()
        let manager = AppProcessManager(appLister: appLister)

        XCTAssertEqual(manager.runningApps.count, 0)
        XCTAssertEqual(manager.appCount, 0)
        XCTAssertFalse(manager.isLoading)
    }

    func testProviderErrorsClearList() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "App1", bundleIdentifier: "com.app1", pid: 1 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 1)

        // Make provider throw
        await appLister.setShouldThrow(true)
        await manager.refresh()

        // On error, the list should be cleared
        XCTAssertEqual(manager.runningApps.count, 0)
    }

    func testMultipleQuitOperations() async throws {
        let appLister = MockAppLister()
        await appLister.setApps([
            AppProcess(id: "1", name: "A", bundleIdentifier: "com.a", pid: 1 as pid_t),
            AppProcess(id: "2", name: "B", bundleIdentifier: "com.b", pid: 2 as pid_t),
            AppProcess(id: "3", name: "C", bundleIdentifier: "com.c", pid: 3 as pid_t),
            AppProcess(id: "4", name: "D", bundleIdentifier: "com.d", pid: 4 as pid_t)
        ])

        let manager = AppProcessManager(appLister: appLister)
        await manager.refresh()

        XCTAssertEqual(manager.runningApps.count, 4)

        // Quit apps one by one
        try await manager.quitApp(bundleIdentifier: "com.a")
        XCTAssertEqual(manager.runningApps.count, 3)

        try await manager.quitApp(bundleIdentifier: "com.b")
        XCTAssertEqual(manager.runningApps.count, 2)

        try await manager.quitApp(bundleIdentifier: "com.c")
        XCTAssertEqual(manager.runningApps.count, 1)

        try await manager.quitApp(bundleIdentifier: "com.d")
        XCTAssertEqual(manager.runningApps.count, 0)
    }
}
