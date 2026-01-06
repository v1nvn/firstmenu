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
    public func sample() async throws {
        isSampling = true
        defer { isSampling = false }

        // Sample CPU, RAM, and Network every time
        async let cpu = cpuProvider.cpuPercentage()
        async let ram = ramProvider.ramUsage()
        async let network = networkProvider.networkSpeed()

        // Storage is cached
        let storage = await getStorageUsage()

        let (cpuValue, ramValue, networkValue) = await (try cpu, try ram, try network)

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
