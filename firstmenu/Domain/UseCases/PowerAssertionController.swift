//
//  PowerAssertionController.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation
import Observation

/// Controls power assertions for keeping the system awake.
@Observable
public final class PowerAssertionController {
    private let powerProvider: any PowerAssertionProviding

    // Directly store the state
    public private(set) var state: CaffeinateState

    public init(powerProvider: any PowerAssertionProviding) {
        self.powerProvider = powerProvider
        self.state = powerProvider.state
    }

    /// Activates keep-awake mode for the specified duration.
    public func keepAwake(for duration: TimeInterval) async throws {
        try await powerProvider.activate(duration: duration)
        state = powerProvider.state
    }

    /// Activates keep-awake mode indefinitely.
    public func keepAwakeIndefinitely() async throws {
        try await powerProvider.activate(duration: nil)
        state = powerProvider.state
    }

    /// Deactivates keep-awake mode.
    public func allowSleep() async throws {
        try await powerProvider.deactivate()
        state = powerProvider.state
    }

    /// Resets the keep-awake timer with a new duration.
    public func resetTimer(duration: TimeInterval) async throws {
        try await powerProvider.reset(duration: duration)
        state = powerProvider.state
    }

    /// Refreshes the state from the provider.
    public func refreshState() {
        state = powerProvider.state
    }

    /// Returns true if the system is currently being kept awake.
    public var isActive: Bool {
        state.isActive
    }

    /// Returns true if the system is being kept awake indefinitely.
    public var isIndefinite: Bool {
        state.isIndefinite
    }
}
