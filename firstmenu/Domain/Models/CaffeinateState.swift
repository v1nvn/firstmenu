//
//  CaffeinateState.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation

/// Represents the current state of the caffeinate (keep-awake) utility.
public enum CaffeinateState: Sendable, Equatable {
    /// System is allowed to sleep normally
    case inactive

    /// System is being kept awake for a specified duration
    case active(until: Date)

    /// System is being kept awake indefinitely
    case indefinite

    public var isActive: Bool {
        switch self {
        case .inactive: return false
        case .active, .indefinite: return true
        }
    }

    public var isIndefinite: Bool {
        if case .indefinite = self { return true }
        return false
    }
}
