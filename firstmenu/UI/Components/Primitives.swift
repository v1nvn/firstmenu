//
//  Primitives.swift
//  firstmenu
//
//  Reusable primitive components following Apple Human Interface Guidelines for macOS 26.
//  These components provide consistent, native-looking UI across the app.
//

import SwiftUI

// MARK: - List Row

/// A standard list row with hover effect following macOS HIG.
/// Use this for any selectable/interactive row in lists.
struct ListRow<Content: View>: View {
    @State private var isHovering = false
    let action: (() -> Void)?
    @ViewBuilder let content: () -> Content

    init(action: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }

    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    rowContent
                }
                .buttonStyle(.plain)
            } else {
                rowContent
            }
        }
    }

    private var rowContent: some View {
        HStack {
            content()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isHovering ? Color.primary.opacity(0.06) : Color.clear)
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
    }
}

// MARK: - Menu Row

/// A menu-style row with icon, title, and optional trailing content.
/// Follows macOS menu bar popover conventions.
struct MenuRow<Trailing: View>: View {
    let title: String
    let systemImage: String?
    let action: (() -> Void)?
    @ViewBuilder let trailing: () -> Trailing
    @State private var isHovering = false

    init(
        _ title: String,
        systemImage: String? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
        self.trailing = trailing
    }

    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    rowContent
                }
                .buttonStyle(.plain)
            } else {
                rowContent
            }
        }
    }

    private var rowContent: some View {
        HStack(spacing: 8) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
            }
            Text(title)
                .font(.body)
            Spacer()
            trailing()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isHovering ? Color.primary.opacity(0.06) : Color.clear)
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
    }
}

// MARK: - Section Label

/// A section label following macOS HIG typography.
/// Use uppercase for sidebar sections, sentence case for form sections.
struct SectionLabel: View {
    let title: String
    let style: Style

    enum Style {
        case sidebar   // Uppercase, smaller
        case form      // Sentence case, standard
    }

    init(_ title: String, style: Style = .form) {
        self.title = title
        self.style = style
    }

    var body: some View {
        Text(style == .sidebar ? title.uppercased() : title)
            .font(style == .sidebar ? .caption : .subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
    }
}

// MARK: - Count Badge

/// A count badge following macOS HIG.
/// Displays a number in a pill shape.
struct CountBadge: View {
    let count: Int

    var body: some View {
        Text("\(count)")
            .font(.caption.monospacedDigit())
            .foregroundStyle(.secondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.fill.tertiary, in: Capsule())
    }
}

// MARK: - Status Dot

/// A status indicator following macOS conventions.
/// Uses SF Symbols for accessibility.
struct StatusDot: View {
    let isActive: Bool
    let activeColor: Color

    init(isActive: Bool, activeColor: Color = .green) {
        self.isActive = isActive
        self.activeColor = activeColor
    }

    var body: some View {
        Image(systemName: isActive ? "circle.fill" : "circle")
            .font(.system(size: 8))
            .foregroundStyle(isActive ? activeColor : .secondary)
            .accessibilityLabel(isActive ? "Active" : "Inactive")
    }
}

// MARK: - Destructive Button

/// A destructive action button following macOS HIG.
/// Uses the system destructive role for proper styling.
struct DestructiveButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(title, role: .destructive, action: action)
            .buttonStyle(.borderless)
    }
}

// MARK: - Icon Button

/// A small icon button with hover effect.
/// Use for close buttons, action buttons in rows.
struct IconButton: View {
    let systemImage: String
    let action: () -> Void
    let help: String?
    @State private var isHovering = false

    init(_ systemImage: String, help: String? = nil, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.help = help
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.body)
                .foregroundStyle(isHovering ? .primary : .secondary)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .help(help ?? "")
    }
}

// MARK: - Network Speed Label

/// Network speed display using SF Symbols instead of Unicode.
struct NetworkSpeedLabel: View {
    let downloadSpeed: String
    let uploadSpeed: String
    let isActive: Bool

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "arrow.down")
                .font(.caption2)
            Text(downloadSpeed)
            Image(systemName: "arrow.up")
                .font(.caption2)
            Text(uploadSpeed)
        }
        .foregroundStyle(isActive ? .primary : .secondary)
    }
}

// MARK: - Preset Buttons

/// A row of preset duration buttons.
/// Uses native bordered button style.
struct PresetButtons: View {
    let presets: [(label: String, value: String)]
    let selectedValue: String?
    let action: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(presets, id: \.value) { preset in
                Button(preset.label) {
                    action(preset.value)
                }
                .buttonStyle(.bordered)
                .tint(preset.value == selectedValue ? .green : nil)
                .controlSize(.small)
            }
        }
    }
}

// MARK: - Form Section Background

/// Standard background for form sections in popovers.
struct FormSectionBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.fill.quaternary)
    }
}

extension View {
    func formSectionBackground() -> some View {
        modifier(FormSectionBackground())
    }
}

// MARK: - Toggle Row

/// A toggle row for settings with consistent styling.
struct ToggleRow: View {
    let title: String
    let systemImage: String?
    @Binding var isOn: Bool

    init(_ title: String, systemImage: String? = nil, isOn: Binding<Bool>) {
        self.title = title
        self.systemImage = systemImage
        self._isOn = isOn
    }

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: 8) {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                }
                Text(title)
            }
        }
        .toggleStyle(.switch)
        .controlSize(.small)
    }
}

// MARK: - Segmented Picker Row

/// A row with a segmented picker for settings.
struct SegmentedPickerRow<SelectionValue: Hashable>: View {
    let title: String
    let systemImage: String?
    @Binding var selection: SelectionValue
    let options: [(label: String, value: SelectionValue)]

    var body: some View {
        HStack(spacing: 8) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
            }
            Text(title)
            Spacer()
            Picker("", selection: $selection) {
                ForEach(options, id: \.value) { option in
                    Text(option.label).tag(option.value)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .fixedSize()
        }
    }
}
