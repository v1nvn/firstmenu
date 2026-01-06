//
//  CaffeinateWrapper.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import Foundation
import Observation

/// Internal class to hold non-observable state.
private final class CaffeinateStateHolder: @unchecked Sendable {
    var caffeinateProcess: Process?
    var timerTask: Task<Void, Never>?
}

/// Controls system sleep using the caffeinate command-line utility.
@MainActor
@Observable
public final class CaffeinateWrapper: PowerAssertionProviding {

    public private(set) var state: CaffeinateState = .inactive

    private let stateHolder = CaffeinateStateHolder()

    public init() {}

    public func activate(duration: TimeInterval? = nil) async throws {
        // Deactivate any existing assertion first
        try await deactivate()

        if let duration = duration {
            let expiryDate = Date().addingTimeInterval(duration)
            state = .active(until: expiryDate)

            // Start timer for auto-deactivation
            stateHolder.timerTask = Task { [weak self] in
                try? await Task.sleep(for: Duration.seconds(duration))
                try? await self?.deactivate()
            }
        } else {
            state = .indefinite
        }

        // Launch caffeinate process
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")

        if let duration = duration {
            // Use -t flag for timed caffeinate
            process.arguments = ["-t", String(UInt32(duration))]
        }
        // For indefinite mode, caffeinate runs without timeout

        do {
            try process.run()
            stateHolder.caffeinateProcess = process

            // Monitor process termination
            Task { [weak self] in
                process.waitUntilExit()
                if let self, self.state.isActive {
                    try? await self.deactivate()
                }
            }
        } catch {
            state = .inactive
            throw PowerError.activationFailed
        }
    }

    public func deactivate() async throws {
        stateHolder.timerTask?.cancel()
        stateHolder.timerTask = nil

        stateHolder.caffeinateProcess?.terminate()
        stateHolder.caffeinateProcess = nil

        state = .inactive
    }

    public func reset(duration: TimeInterval) async throws {
        // If currently active, reactivate with new duration
        if state.isActive {
            try await activate(duration: duration)
        } else {
            try await activate(duration: duration)
        }
    }

    deinit {
        // Clean up on deinit
        stateHolder.caffeinateProcess?.terminate()
        stateHolder.timerTask?.cancel()
    }
}

public enum PowerError: Error {
    case activationFailed
    case deactivationFailed
}
