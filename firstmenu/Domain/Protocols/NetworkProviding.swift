//
//  NetworkProviding.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Provides network speed statistics.
public protocol NetworkProviding: Sendable {
    /// Returns the current network speed in bytes per second.
    /// - Returns: A tuple containing download BPS and upload BPS.
    /// - Throws: An error if network statistics cannot be read.
    func networkSpeed() async throws -> (downloadBPS: Int64, uploadBPS: Int64)
}
