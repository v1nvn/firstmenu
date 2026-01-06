//
//  NSWorkspaceAppLister.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Cocoa

/// Lists and manages running applications using NSWorkspace.
public actor NSWorkspaceAppLister: AppListing {

    private let workspace: NSWorkspace

    public init(workspace: NSWorkspace = .shared) {
        self.workspace = workspace
    }

    public func runningApps() async throws -> [AppProcess] {
        let runningApps = workspace.runningApplications

        return runningApps.compactMap { app -> AppProcess? in
            // Filter for user-facing apps only
            guard app.activationPolicy == .regular,
                  let bundleId = app.bundleIdentifier,
                  !isMenuBarOnly(bundleId) else {
                return nil
            }

            return AppProcess(
                id: bundleId,
                name: app.localizedName ?? "Unknown",
                bundleIdentifier: bundleId,
                pid: app.processIdentifier
            )
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    public func quitApp(bundleIdentifier: String) async throws {
        let runningApps = workspace.runningApplications

        guard let app = runningApps.first(where: { $0.bundleIdentifier == bundleIdentifier }) else {
            throw AppError.notFound
        }

        guard app.terminate() else {
            throw AppError.terminateFailed
        }
    }

    /// Returns true if the app is a menu bar-only app that should be excluded.
    private func isMenuBarOnly(_ bundleId: String) -> Bool {
        // Common menu bar apps to exclude
        let menuBarApps = [
            "com.apple.controlcenter",
            "com.apple.systemuiserver",
            "com.apple.Spotlight"
        ]
        return menuBarApps.contains(bundleId)
    }
}

public enum AppError: Error {
    case notFound
    case terminateFailed
}
