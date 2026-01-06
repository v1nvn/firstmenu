//
//  AppProcessManager.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation
import Observation

/// Manages running applications and provides actions for them.
@MainActor
@Observable
public final class AppProcessManager {
    private let appLister: AppListing

    public var runningApps: [AppProcess] = []
    public var isLoading: Bool = false

    public init(appLister: AppListing) {
        self.appLister = appLister
    }

    /// Refreshes the list of running applications.
    public func refresh() async {
        isLoading = true
        defer { isLoading = false }

        do {
            runningApps = try await appLister.runningApps()
        } catch {
            runningApps = []
        }
    }

    /// Quits the application with the specified bundle identifier.
    public func quitApp(bundleIdentifier: String) async throws {
        try await appLister.quitApp(bundleIdentifier: bundleIdentifier)
        // Refresh the list after quitting
        await refresh()
    }

    /// Quits all user-facing applications.
    public func quitAll() async throws {
        for app in runningApps {
            try await appLister.quitApp(bundleIdentifier: app.bundleIdentifier ?? "")
        }
        runningApps = []
    }

    /// Returns the count of running applications.
    public var appCount: Int {
        runningApps.count
    }
}
