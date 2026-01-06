//
//  CPUProviding.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Provides CPU usage statistics.
public protocol CPUProviding: Sendable {
    /// Returns the current CPU usage as a percentage (0.0 to 100.0).
    /// - Returns: A value between 0.0 and 100.0 representing CPU utilization.
    /// - Throws: An error if CPU statistics cannot be read.
    func cpuPercentage() async throws -> Double
}
