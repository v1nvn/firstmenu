//
//  RAMProviding.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Provides RAM usage statistics.
public protocol RAMProviding: Sendable {
    /// Returns the current RAM usage.
    /// - Returns: A tuple containing used bytes and total bytes.
    /// - Throws: An error if RAM statistics cannot be read.
    func ramUsage() async throws -> (used: Int64, total: Int64)
}
