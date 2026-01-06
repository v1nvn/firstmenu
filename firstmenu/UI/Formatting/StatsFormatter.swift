//
//  StatsFormatter.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Formats system statistics for display in the menu bar.
public enum StatsFormatter {
    /// Formats a percentage value with no decimal places.
    public static func formatPercentage(_ value: Double) -> String {
        String(format: "%.0f%%", value)
    }

    /// Formats bytes as a human-readable string (e.g., "8.4 GB").
    public static func formatBytes(_ bytes: Int64) -> String {
        let kb = Double(bytes) / 1024
        let mb = kb / 1024
        let gb = mb / 1024

        if gb >= 1 {
            return String(format: "%.1f GB", gb)
        } else if mb >= 1 {
            return String(format: "%.0f MB", mb)
        } else {
            return String(format: "%.0f KB", kb)
        }
    }

    /// Formats network speed in bytes per second.
    public static func formatNetworkSpeed(_ bps: Int64) -> String {
        let kb = Double(bps) / 1024
        let mb = kb / 1024

        if mb >= 1 {
            return String(format: "%.1f MB/s", mb)
        } else if kb >= 1 {
            return String(format: "%.0f KB/s", kb)
        } else {
            return "0 B/s"
        }
    }

    /// Formats temperature from Celsius.
    public static func formatTemperature(_ celsius: Double) -> String {
        String(format: "%.0f°", celsius)
    }
}
