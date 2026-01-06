//
//  MachCPUReader.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Reads CPU statistics using Mach kernel APIs.
public actor MachCPUReader: CPUProviding {

    private var previousCpuInfo: host_cpu_load_info?
    private var previousTimestamp: UInt64 = 0

    public init() {}

    public func cpuPercentage() async throws -> Double {
        var numCpuInfo = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size)
        var cpuInfo = host_cpu_load_info()

        let result: kern_return_t = withUnsafeMutablePointer(to: &cpuInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(numCpuInfo)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &numCpuInfo)
            }
        }

        guard result == KERN_SUCCESS else {
            throw CPUError.readFailed
        }

        let currentTimestamp = mach_absolute_time()

        // Calculate deltas from previous reading
        let userDiff: UInt32
        let systemDiff: UInt32
        let idleDiff: UInt32
        let niceDiff: UInt32

        if let previous = previousCpuInfo {
            userDiff = cpuInfo.cpu_ticks.0 &- previous.cpu_ticks.0
            systemDiff = cpuInfo.cpu_ticks.1 &- previous.cpu_ticks.1
            idleDiff = cpuInfo.cpu_ticks.2 &- previous.cpu_ticks.2
            niceDiff = cpuInfo.cpu_ticks.3 &- previous.cpu_ticks.3
        } else {
            // First reading - use absolute values
            userDiff = cpuInfo.cpu_ticks.0
            systemDiff = cpuInfo.cpu_ticks.1
            idleDiff = cpuInfo.cpu_ticks.2
            niceDiff = cpuInfo.cpu_ticks.3
        }

        // Store current reading for next time
        previousCpuInfo = cpuInfo
        previousTimestamp = currentTimestamp

        let totalTicks = userDiff + systemDiff + idleDiff + niceDiff
        guard totalTicks > 0 else {
            return 0.0
        }

        let usedTicks = userDiff + systemDiff + niceDiff
        let percentage = Double(usedTicks) / Double(totalTicks) * 100.0

        return min(max(percentage, 0.0), 100.0)
    }
}

public enum CPUError: Error {
    case readFailed
}
