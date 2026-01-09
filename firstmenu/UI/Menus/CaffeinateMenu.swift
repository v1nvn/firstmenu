//
//  CaffeinateMenu.swift
//  firstmenu
//
//  Keep-awake menu using reusable primitives and HIG styling
//

import SwiftUI

/// Menu view for caffeinate (keep-awake) controls.
struct CaffeinateMenuView: View {
    @Bindable var powerController: PowerAssertionController

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Status indicator using SF Symbol
            HStack(spacing: DesignSystem.Spacing.tight) {
                StatusDot(isActive: powerController.isActive)
                Text(powerController.statusText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, DesignSystem.Spacing.section)
            .padding(.top, DesignSystem.Spacing.standard)
            .padding(.bottom, DesignSystem.Spacing.tight)

            // Presets
            VStack(spacing: 0) {
                CaffeinateMenuButton(
                    title: "15 Minutes",
                    isActive: false,
                    action: {
                        Task { try? await powerController.keepAwake(for: 15 * 60) }
                    }
                )

                CaffeinateMenuButton(
                    title: "1 Hour",
                    isActive: false,
                    action: {
                        Task { try? await powerController.keepAwake(for: 60 * 60) }
                    }
                )

                CaffeinateMenuButton(
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
                        .padding(.vertical, DesignSystem.Spacing.tight)

                    Button("Disable Keep Awake", role: .destructive) {
                        Task { try? await powerController.allowSleep() }
                    }
                    .buttonStyle(.borderless)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, DesignSystem.Spacing.section)
                    .padding(.vertical, DesignSystem.Spacing.tight)
                }
            }
        }
    }
}

/// A button row for caffeinate presets.
private struct CaffeinateMenuButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                Spacer()
                if isActive {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                        .font(.body)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, DesignSystem.Spacing.section)
        .padding(.vertical, DesignSystem.Spacing.tight + 2)
        .background(isHovering ? Color.primary.opacity(0.06) : Color.clear)
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
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
