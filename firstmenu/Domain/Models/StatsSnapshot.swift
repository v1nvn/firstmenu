//
//  StatsSnapshot.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// A snapshot of system resource statistics at a point in time.
public struct StatsSnapshot: Sendable, Equatable {
    /// CPU usage as a percentage (0.0 to 100.0)
    public let cpuPercentage: Double

    /// RAM usage in bytes
    public let ramUsed: Int64

    /// Total RAM in bytes
    public let ramTotal: Int64

    /// Storage used in bytes
    public let storageUsed: Int64

    /// Total storage in bytes
    public let storageTotal: Int64

    /// Network download speed in bytes per second
    public let networkDownloadBPS: Int64

    /// Network upload speed in bytes per second
    public let networkUploadBPS: Int64

    public init(
        cpuPercentage: Double,
        ramUsed: Int64,
        ramTotal: Int64,
        storageUsed: Int64,
        storageTotal: Int64,
        networkDownloadBPS: Int64,
        networkUploadBPS: Int64
    ) {
        self.cpuPercentage = cpuPercentage
        self.ramUsed = ramUsed
        self.ramTotal = ramTotal
        self.storageUsed = storageUsed
        self.storageTotal = storageTotal
        self.networkDownloadBPS = networkDownloadBPS
        self.networkUploadBPS = networkUploadBPS
    }

    /// RAM usage as a percentage (0.0 to 100.0)
    public var ramPercentage: Double {
        guard ramTotal > 0 else { return 0 }
        return (Double(ramUsed) / Double(ramTotal)) * 100.0
    }

    /// Storage usage as a percentage (0.0 to 100.0)
    public var storagePercentage: Double {
        guard storageTotal > 0 else { return 0 }
        return (Double(storageUsed) / Double(storageTotal)) * 100.0
    }
}
