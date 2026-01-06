//
//  MenuBarWindowView.swift
//  firstmenu
//
//  Created by Vineet Kumar on 06/01/26.
//

import SwiftUI

/// The popover menu bar window view.
struct MenuBarWindowView: View {
    @Bindable var appManager: AppProcessManager
    @Bindable var powerController: PowerAssertionController

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Apps Section
            SectionHeader(title: "Running Apps", count: appManager.appCount)

            if appManager.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else if appManager.runningApps.isEmpty {
                Text("No running apps")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .padding()
            } else {
                ForEach(appManager.runningApps) { app in
                    AppRowView(app: app, onQuit: {
                        Task { try? await appManager.quitApp(bundleIdentifier: app.bundleIdentifier ?? "") }
                    })
                }

                Divider()

                Button("Quit All Apps") {
                    Task { try? await appManager.quitAll() }
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }

            Divider()

            // Caffeinate Section
            SectionHeader(title: "Keep Awake")

            CaffeinateMenuView(powerController: powerController)

            Divider()

            // Footer
            HStack {
                Text("firstmenu")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.borderless)
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 280)
    }
}

struct SectionHeader: View {
    let title: String
    var count: Int?

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            Spacer()
            if let count = count {
                Text("\(count)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

struct AppRowView: View {
    let app: AppProcess
    let onQuit: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "app.dashed")
                .foregroundStyle(.secondary)
            Text(app.name)
                .font(.body)
            Spacer()
            Button(action: onQuit) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
            .help("Quit \(app.name)")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Quit", role: .destructive) {
                onQuit()
            }
        }
    }
}

#Preview {
    MenuBarWindowView(
        appManager: AppProcessManager(appLister: NSWorkspaceAppLister()),
        powerController: PowerAssertionController(powerProvider: CaffeinateWrapper())
    )
}
