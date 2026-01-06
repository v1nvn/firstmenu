//
//  AppProcess.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Represents a running application that can be managed.
public struct AppProcess: Sendable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let bundleIdentifier: String?
    public let pid: pid_t

    public init(id: String, name: String, bundleIdentifier: String?, pid: pid_t) {
        self.id = id
        self.name = name
        self.bundleIdentifier = bundleIdentifier
        self.pid = pid
    }
}
