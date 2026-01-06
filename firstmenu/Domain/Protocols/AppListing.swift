//
//  AppListing.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Provides a list of running applications.
public protocol AppListing: Sendable {
    /// Returns a list of currently running user-facing applications.
    /// - Returns: An array of `AppProcess` representing running apps.
    /// - Throws: An error if the app list cannot be retrieved.
    func runningApps() async throws -> [AppProcess]

    /// Terminates the application with the specified bundle identifier.
    /// - Parameter bundleIdentifier: The bundle identifier of the app to quit.
    /// - Throws: An error if the app cannot be quit.
    func quitApp(bundleIdentifier: String) async throws
}
