//
//  MenuItem.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import AppKit
import SwiftUI

/// A reusable component that manages a single status item with its popover.
@MainActor
class MenuItem: NSObject {
    let statusItem: NSStatusItem
    var popover: NSPopover?

    init(title: String) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        super.init()

        if let button = statusItem.button {
            button.title = title
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    func updateTitle(_ title: String) {
        statusItem.button?.title = title
    }

    func updateView<Content: View>(_ view: Content) {
        // Wrap view in fixed-width container to prevent layout issues
        let measuredView = view
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: SizePreferenceKey.self,
                        value: geometry.size
                    )
                }
            )

        let renderer = ImageRenderer(content: measuredView)
        renderer.scale = 2.0  // Retina

        if let nsImage = renderer.nsImage {
            statusItem.button?.image = nsImage
            statusItem.button?.title = ""

            // Calculate width with padding to prevent cropping
            // The image size includes the scale factor, so we divide by 2
            // Then add padding to ensure no cropping
            let contentWidth = nsImage.size.width / renderer.scale
            statusItem.length = ceil(contentWidth + DesignSystem.MenuBar.widthPadding)
        }
    }

    func setPopover<Content: View>(
        content: Content,
        contentSize: NSSize = NSSize(width: 200, height: 150)
    ) {
        if popover == nil {
            popover = NSPopover()
            popover?.behavior = .transient

            // Create a visual effect view for the native frosted glass background
            let effectView = NSVisualEffectView()
            effectView.material = .popover
            effectView.state = .active
            effectView.wantsLayer = true
            effectView.layer?.cornerRadius = DesignSystem.Popover.cornerRadius
            popover?.contentViewController = NSViewController()
            popover?.contentViewController?.view = effectView
        }

        // Create a hosting controller with the SwiftUI content
        let hostingController = NSHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        // Add the hosting view to the effect view
        if let effectView = popover?.contentViewController?.view as? NSVisualEffectView {
            effectView.addSubview(hostingController.view)

            // Set up constraints
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: effectView.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: effectView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: effectView.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: effectView.bottomAnchor)
            ])
        }
    }

    @objc private func togglePopover() {
        guard let statusButton = statusItem.button else { return }

        if let popover = popover, popover.isShown {
            closePopover()
        } else {
            showPopover(from: statusButton)
        }
    }

    private func showPopover(from button: NSButton) {
        popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func closePopover() {
        popover?.performClose(nil)
    }

    deinit {
        NSStatusBar.system.removeStatusItem(statusItem)
    }
}

/// Preference key for measuring view size.
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
