//
//  MachRAMReader.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Reads RAM statistics using Mach kernel APIs.
public actor MachRAMReader: RAMProviding {

    public init() {}

    public func ramUsage() async throws -> (used: Int64, total: Int64) {
        var stats = vm_statistics64()
        var count: mach_msg_type_number_t = UInt32(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)

        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else {
            throw RAMError.readFailed
        }

        // Get page size
        var pageSize: vm_size_t = 0
        let hostPageSizeResult = host_page_size(mach_host_self(), &pageSize)
        guard hostPageSizeResult == KERN_SUCCESS else {
            throw RAMError.readFailed
        }

        // Calculate memory usage
        // Wired + Active are considered "used" memory
        let wiredPages = Int64(stats.wire_count)
        let activePages = Int64(stats.active_count)
        let compressorPages = Int64(stats.compressor_page_count)
        let usedPages = wiredPages + activePages + compressorPages

        let totalMemory = ProcessInfo.processInfo.physicalMemory
        let usedMemory = usedPages * Int64(pageSize)

        return (used: usedMemory, total: Int64(totalMemory))
    }
}

public enum RAMError: Error {
    case readFailed
}
