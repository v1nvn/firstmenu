//
//  PowerAssertionProviding.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation
import Observation

/// Controls power assertions to prevent system sleep.
public protocol PowerAssertionProviding: Observable, Sendable {
    /// The current caffeinate state.
    var state: CaffeinateState { get }

    /// Activates caffeinate mode, preventing system sleep.
    /// - Parameter duration: Optional duration in seconds. If nil, prevents sleep indefinitely.
    /// - Throws: An error if the assertion cannot be created.
    func activate(duration: TimeInterval?) async throws

    /// Deactivates caffeinate mode, allowing normal sleep behavior.
    /// - Throws: An error if the assertion cannot be released.
    func deactivate() async throws

    /// Resets the caffeinate timer with a new duration.
    /// - Parameter duration: The new duration in seconds.
    /// - Throws: An error if the timer cannot be reset.
    func reset(duration: TimeInterval) async throws
}
