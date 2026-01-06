//
//  CaffeinateMenu.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI

/// Menu view for caffeinate (keep-awake) controls.
struct CaffeinateMenuView: View {
    @Bindable var powerController: PowerAssertionController

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Status indicator
            HStack {
                Circle()
                    .fill(powerController.isActive ? .green : .secondary)
                    .frame(width: 8, height: 8)
                Text(powerController.statusText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 4)

            // Presets
            VStack(spacing: 0) {
                CaffeinateButton(
                    title: "15 Minutes",
                    isActive: false,
                    action: {
                        Task { try? await powerController.keepAwake(for: 15 * 60) }
                    }
                )

                CaffeinateButton(
                    title: "1 Hour",
                    isActive: false,
                    action: {
                        Task { try? await powerController.keepAwake(for: 60 * 60) }
                    }
                )

                CaffeinateButton(
                    title: "Indefinitely",
                    isActive: powerController.isIndefinite,
                    action: {
                        Task {
                            if powerController.isIndefinite {
                                try? await powerController.allowSleep()
                            } else {
                                try? await powerController.keepAwakeIndefinitely()
                            }
                        }
                    }
                )

                if powerController.isActive {
                    Divider()
                        .padding(.vertical, 4)

                    Button("Disable Keep Awake") {
                        Task { try? await powerController.allowSleep() }
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                }
            }
        }
    }
}

struct CaffeinateButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                Spacer()
                if isActive {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                }
            }
        }
        .buttonStyle(.borderless)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

extension PowerAssertionController {
    var statusText: String {
        switch state {
        case .inactive:
            return "System can sleep normally"
        case .active(let until):
            let remaining = until.timeIntervalSinceNow
            if remaining > 0 {
                let minutes = Int(remaining / 60)
                return "Keeping awake for \(minutes) min"
            } else {
                return "Keeping awake"
            }
        case .indefinite:
            return "Keeping awake indefinitely"
        }
    }
}

#Preview {
    CaffeinateMenuView(
        powerController: PowerAssertionController(powerProvider: CaffeinateWrapper())
    )
    .padding()
}
