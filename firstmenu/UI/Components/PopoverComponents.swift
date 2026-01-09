//
//  PopoverComponents.swift
//  firstmenu
//
//  Reusable primitive components for menu bar popovers
//

import SwiftUI

// MARK: - Popover Container

/// Standard container for all menu bar popover content.
/// Provides consistent width, background material, and structure.
struct PopoverContainer<Content: View>: View {
    let width: CGFloat
    @ViewBuilder let content: () -> Content

    init(width: CGFloat = DesignSystem.Popover.standardWidth, @ViewBuilder content: @escaping () -> Content) {
        self.width = width
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
            Divider()
            PopoverFooter()
        }
        .frame(width: width)
        .background(.regularMaterial)
    }
}

// MARK: - Popover Header

/// Standard header for popover content with icon and title.
struct PopoverHeader: View {
    let title: String
    let systemImage: String
    let value: String?
    let valueColor: Color?

    init(
        _ title: String,
        systemImage: String,
        value: String? = nil,
        valueColor: Color? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.value = value
        self.valueColor = valueColor
    }

    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
                .font(.headline)
            Spacer()
            if let value = value {
                Text(value)
                    .statsStyle()
                    .foregroundStyle(valueColor ?? .primary)
            }
        }
    }
}

// MARK: - Stat Gauge Row

/// A row displaying a label with a linear gauge indicator.
struct StatGaugeRow: View {
    let value: Double
    let total: Double
    let tintColor: Color

    init(value: Double, total: Double = 100, tintColor: Color = .accentColor) {
        self.value = value
        self.total = total
        self.tintColor = tintColor
    }

    var body: some View {
        Gauge(value: value, in: 0...total) {
            EmptyView()
        }
        .gaugeStyle(.linearCapacity)
        .tint(tintColor)
    }
}

// MARK: - Info Row

/// A simple labeled content row with consistent styling.
struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        LabeledContent(label, value: value)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}

// MARK: - Section Header

/// A small section header for grouping related content.
struct PopoverSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .sectionHeaderStyle()
    }
}

// MARK: - Status Indicator

/// A status indicator using SF Symbols following macOS HIG.
struct StatusIndicator: View {
    let isActive: Bool
    let activeColor: Color

    init(isActive: Bool, activeColor: Color = .green) {
        self.isActive = isActive
        self.activeColor = activeColor
    }

    var body: some View {
        if isActive {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(activeColor)
                .font(.subheadline)
                .accessibilityLabel("Active")
        }
    }
}

// MARK: - Preset Button Group

/// A horizontal group of preset buttons.
struct PresetButtonGroup: View {
    let presets: [String]
    let selectedPreset: String?
    let action: (String) -> Void

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.standard) {
            ForEach(presets, id: \.self) { preset in
                Button(preset) {
                    action(preset)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(preset == selectedPreset ? .green : nil)
            }
        }
    }
}

// MARK: - Popover Content Section

/// A padded content section for popovers.
struct PopoverSection<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    init(spacing: CGFloat = DesignSystem.Spacing.standard, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content()
        }
        .padding()
    }
}

// MARK: - Empty State View

/// A view shown when there's no content to display.
struct PopoverEmptyState: View {
    let title: String
    let systemImage: String
    let description: String?

    init(_ title: String, systemImage: String, description: String? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
    }

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            if let description = description {
                Text(description)
            }
        }
        .frame(height: 80)
    }
}
