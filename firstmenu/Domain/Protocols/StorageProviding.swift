//
//  StorageProviding.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Provides storage usage statistics for the system volume.
public protocol StorageProviding: Sendable {
    /// Returns the current storage usage.
    /// - Returns: A tuple containing used bytes and total bytes.
    /// - Throws: An error if storage statistics cannot be read.
    func storageUsage() async throws -> (used: Int64, total: Int64)
}
