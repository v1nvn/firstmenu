//
//  PowerAssertionController.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation
import Observation

/// Controls power assertions for keeping the system awake.
@MainActor
@Observable
public final class PowerAssertionController {
    private let powerProvider: any PowerAssertionProviding

    public var state: CaffeinateState {
        powerProvider.state
    }

    public init(powerProvider: any PowerAssertionProviding) {
        self.powerProvider = powerProvider
    }

    /// Activates keep-awake mode for the specified duration.
    public func keepAwake(for duration: TimeInterval) async throws {
        try await powerProvider.activate(duration: duration)
    }

    /// Activates keep-awake mode indefinitely.
    public func keepAwakeIndefinitely() async throws {
        try await powerProvider.activate(duration: nil)
    }

    /// Deactivates keep-awake mode.
    public func allowSleep() async throws {
        try await powerProvider.deactivate()
    }

    /// Resets the keep-awake timer with a new duration.
    public func resetTimer(duration: TimeInterval) async throws {
        try await powerProvider.reset(duration: duration)
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
