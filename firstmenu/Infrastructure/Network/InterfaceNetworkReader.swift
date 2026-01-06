//
//  InterfaceNetworkReader.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Reads network statistics from system interfaces.
public actor InterfaceNetworkReader: NetworkProviding {

    private var previousSnapshot: NetworkSnapshot?
    private var previousTimestamp: Date?

    private struct NetworkSnapshot {
        let inputBytes: UInt64
        let outputBytes: UInt64
    }

    public init() {}

    public func networkSpeed() async throws -> (downloadBPS: Int64, uploadBPS: Int64) {
        let snapshot = try getCurrentSnapshot()
        let now = Date()

        guard let previous = previousSnapshot,
              let previousTime = previousTimestamp else {
            // First reading - store for next time
            previousSnapshot = snapshot
            previousTimestamp = now
            return (downloadBPS: 0, uploadBPS: 0)
        }

        let timeInterval = now.timeIntervalSince(previousTime)
        guard timeInterval > 0 else {
            return (downloadBPS: 0, uploadBPS: 0)
        }

        // Calculate bytes transferred
        let downloadDelta: UInt64
        let uploadDelta: UInt64

        if snapshot.inputBytes >= previous.inputBytes {
            downloadDelta = snapshot.inputBytes - previous.inputBytes
        } else {
            // Counter wrapped
            downloadDelta = 0
        }

        if snapshot.outputBytes >= previous.outputBytes {
            uploadDelta = snapshot.outputBytes - previous.outputBytes
        } else {
            // Counter wrapped
            uploadDelta = 0
        }

        // Calculate bytes per second
        let downloadBPS = Int64(Double(downloadDelta) / timeInterval)
        let uploadBPS = Int64(Double(uploadDelta) / timeInterval)

        // Store for next time
        previousSnapshot = snapshot
        previousTimestamp = now

        return (downloadBPS: downloadBPS, uploadBPS: uploadBPS)
    }

    private func getCurrentSnapshot() throws -> NetworkSnapshot {
        var ifa: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifa) == 0 else {
            throw NetworkError.readFailed
        }

        defer {
            freeifaddrs(ifa)
        }

        var inputBytes: UInt64 = 0
        var outputBytes: UInt64 = 0

        var current = ifa
        while let ifaddr = current {
            let addr = ifaddr.pointee.ifa_addr.pointee

            if addr.sa_family == UInt8(AF_LINK) {
                let name = String(cString: ifaddr.pointee.ifa_name)

                // Only count active network interfaces (en0, en1, etc.)
                if name.hasPrefix("en") || name.hasPrefix("bridge") {
                    if let ifaData = ifaddr.pointee.ifa_data {
                        let data = ifaData.assumingMemoryBound(to: if_data.self)
                        inputBytes += UInt64(data.pointee.ifi_ibytes)
                        outputBytes += UInt64(data.pointee.ifi_obytes)
                    }
                }
            }

            current = ifaddr.pointee.ifa_next
        }

        return NetworkSnapshot(inputBytes: inputBytes, outputBytes: outputBytes)
    }
}

public enum NetworkError: Error {
    case readFailed
}
