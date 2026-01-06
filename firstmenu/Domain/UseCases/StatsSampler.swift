//
//  StatsSampler.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation
import Observation

/// Samples system statistics and combines them into a single snapshot.
@MainActor
@Observable
public final class StatsSampler {
    private let cpuProvider: CPUProviding
    private let ramProvider: RAMProviding
    private let storageProvider: StorageProviding
    private let networkProvider: NetworkProviding

    private var storageCache: (used: Int64, total: Int64)?
    private var lastStorageUpdate: Date?
    private let storageCacheInterval: TimeInterval = 5 * 60  // 5 minutes

    public var currentSnapshot: StatsSnapshot?
    public var isSampling: Bool = false

    public init(
        cpuProvider: CPUProviding,
        ramProvider: RAMProviding,
        storageProvider: StorageProviding,
        networkProvider: NetworkProviding
    ) {
        self.cpuProvider = cpuProvider
        self.ramProvider = ramProvider
        self.storageProvider = storageProvider
        self.networkProvider = networkProvider
    }

    /// Samples all system statistics and produces a combined snapshot.
    /// This method handles partial failures gracefully - if any provider fails,
    /// it will use cached values or defaults where available.
    public func sample() async {
        isSampling = true
        defer { isSampling = false }

        // Sample CPU, RAM, and Network every time with error handling
        let cpuValue = await (try? cpuProvider.cpuPercentage()) ?? currentSnapshot?.cpuPercentage ?? 0
        let ramResult = await (try? ramProvider.ramUsage())
        let ramValue: (used: Int64, total: Int64)
        if let ram = ramResult {
            ramValue = ram
        } else if let snapshot = currentSnapshot {
            ramValue = (used: snapshot.ramUsed, total: snapshot.ramTotal)
        } else {
            ramValue = (used: 0, total: 1)
        }
        let networkResult = await (try? networkProvider.networkSpeed())
        let networkValue: (downloadBPS: Int64, uploadBPS: Int64)
        if let network = networkResult {
            networkValue = (downloadBPS: network.downloadBPS, uploadBPS: network.uploadBPS)
        } else if let snapshot = currentSnapshot {
            networkValue = (downloadBPS: snapshot.networkDownloadBPS, uploadBPS: snapshot.networkUploadBPS)
        } else {
            networkValue = (downloadBPS: 0, uploadBPS: 0)
        }

        // Storage is cached with fallback
        let storage = await getStorageUsage()

        currentSnapshot = StatsSnapshot(
            cpuPercentage: cpuValue,
            ramUsed: ramValue.used,
            ramTotal: ramValue.total,
            storageUsed: storage.used,
            storageTotal: storage.total,
            networkDownloadBPS: networkValue.downloadBPS,
            networkUploadBPS: networkValue.uploadBPS
        )
    }

    private func getStorageUsage() async -> (used: Int64, total: Int64) {
        let now = Date()

        if let cached = storageCache,
           let lastUpdate = lastStorageUpdate,
           now.timeIntervalSince(lastUpdate) < storageCacheInterval {
            return cached
        }

        do {
            let storage = try await storageProvider.storageUsage()
            storageCache = storage
            lastStorageUpdate = now
            return storage
        } catch {
            // Return cached value or default on error
            return storageCache ?? (used: 0, total: 1)
        }
    }

    /// Resets the storage cache, forcing a refresh on the next sample.
    public func invalidateStorageCache() {
        storageCache = nil
        lastStorageUpdate = nil
    }
}
