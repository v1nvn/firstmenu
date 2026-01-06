Below is a comprehensive, opinionated master plan for firstmenu, aligned with everything we discussed:
✔ fully native
✔ Liquid Glass
✔ menu-bar only
✔ ultra–low footprint
✔ strict TDD
✔ CLI-first dev loop
✔ future-proof but not bloated

This is written as a living architecture document you can actually follow.

⸻

firstmenu — Master Plan

A first-class macOS menu bar system companion

⸻

1. Vision & Non-Goals

Vision

firstmenu is a single, glassy, always-trustworthy entry point to:
	•	System health
	•	Connectivity
	•	Contextual actions

It should feel like something Apple forgot to ship.

Explicit Non-Goals
	•	❌ No Dock icon
	•	❌ No background daemon
	•	❌ No Electron / WebKit
	•	❌ No permissions prompts unless unavoidable
	•	❌ No “dashboard” window
	•	❌ No configuration bloat

⸻

2. High-Level Feature Set (Final)

Menu Bar Display (single line, compact)
	•	CPU (percentage)
	•	RAM (used / total or used only)
	•	Storage (used / total, system volume)
	•	Weather (icon + temp)
	•	Internet speed (↓ / ↑)

Menu Actions (on click)
	•	Running Applications
	•	List of currently running apps
	•	Per-app quit
	•	Quit All (user apps only)
	•	Caffeinate Utility
	•	Toggle “Keep Awake”
	•	Presets:
	•	15 min
	•	1 hour
	•	Indefinite
	•	Status reflected in menu bar icon

⸻

3. Architectural Principles (Non-Negotiable)
	1.	UI is dumb
	2.	Domain logic is pure
	3.	System access is isolated
	4.	Everything testable first
	5.	CLI is a first-class citizen

⸻

4. Project Structure

firstmenu/
├── App/
│   └── FirstMenuApp.swift
│
├── UI/
│   ├── MenuBar/
│   │   ├── MenuBarLabelView.swift
│   │   └── MenuBarWindowView.swift
│   ├── Menus/
│   │   ├── AppListMenu.swift
│   │   ├── CaffeinateMenu.swift
│   │   └── SettingsMenu.swift
│   └── Formatting/
│       └── StatsFormatter.swift
│
├── Domain/
│   ├── Models/
│   │   ├── StatsSnapshot.swift
│   │   ├── WeatherSnapshot.swift
│   │   └── AppProcess.swift
│   │
│   ├── Protocols/
│   │   ├── CPUProviding.swift
│   │   ├── RAMProviding.swift
│   │   ├── StorageProviding.swift
│   │   ├── NetworkProviding.swift
│   │   ├── WeatherProviding.swift
│   │   ├── AppListing.swift
│   │   └── PowerAssertionProviding.swift
│   │
│   └── UseCases/
│       ├── StatsSampler.swift
│       ├── WeatherSampler.swift
│       ├── AppProcessManager.swift
│       └── PowerAssertionController.swift
│
├── Infrastructure/
│   ├── CPU/
│   │   └── MachCPUReader.swift
│   ├── RAM/
│   │   └── MachRAMReader.swift
│   ├── Storage/
│   │   └── FileSystemStorageReader.swift
│   ├── Network/
│   │   └── InterfaceNetworkReader.swift
│   ├── Weather/
│   │   └── OpenMeteoWeatherClient.swift
│   ├── Apps/
│   │   └── NSWorkspaceAppLister.swift
│   └── Power/
│       └── CaffeinateWrapper.swift
│
├── Tests/
│   ├── DomainTests/
│   ├── InfrastructureTests/
│   └── IntegrationTests/
│
├── Makefile
└── README.md


⸻

5. Data Flow (Critical)

Kernel / System APIs
        ↓
Infrastructure Readers (isolated, thin)
        ↓
Domain Use Cases (pure, testable)
        ↓
StatsSnapshot / View Models
        ↓
SwiftUI Menu Bar Views

No shortcuts. Ever.

⸻

6. Menu Bar UI Design

Label Format (example)

CPU 12% • RAM 9.4G • SSD 62% • ☀︎ 28° • ↓ 32 ↑ 8

Styling Rules
	•	monospacedDigit()
	•	SF Symbols only
	•	.ultraThinMaterial
	•	No custom colors
	•	Opacity hierarchy instead of separators

Update Strategy
	•	TimelineView(.periodic(by: 1s))
	•	Weather: 10–15 min cache
	•	Storage: 5 min refresh
	•	Apps list: on click only

⸻

7. Feature-by-Feature Technical Plan

7.1 CPU
	•	API: host_processor_info
	•	Unit: normalized (0.0–1.0)
	•	Test:
	•	value bounds
	•	multi-core normalization

⸻

7.2 RAM
	•	API: host_statistics64
	•	Metric: used memory (wired + active)
	•	Test:
	•	value < total memory
	•	non-negative

⸻

7.3 Storage
	•	API: FileManager.attributesOfFileSystem
	•	Target: system volume only
	•	Test:
	•	total > used
	•	stable across calls

⸻

7.4 Internet Speed
	•	API: getifaddrs + if_data
	•	Strategy: delta between samples
	•	Test:
	•	deterministic deltas
	•	interface filtering (en0, en1)

⸻

7.5 Weather
	•	Provider: Open-Meteo (no API key)
	•	Data: current temp + condition code
	•	Caching: disk-backed, TTL-based
	•	Test:
	•	decoding
	•	cache hit/miss
	•	fallback on failure

⸻

7.6 Running Applications Menu
	•	API: NSWorkspace.shared.runningApplications
	•	Filter:
	•	user-facing apps only
	•	exclude menu bar apps
	•	Actions:
	•	quit app
	•	quit all (with confirmation)
	•	Test:
	•	filtering logic
	•	quit command generation (mocked)

⸻

7.7 Caffeinate Wrapper
	•	API: Process → /usr/bin/caffeinate
	•	Modes:
	•	timed
	•	indefinite
	•	State:
	•	tracked internally
	•	reflected in icon
	•	Test:
	•	command generation
	•	lifecycle handling
	•	idempotency

⸻

8. Testing Strategy (TDD First)

Test Layers

Layer	Scope
Domain	100% coverage
Infrastructure	bounds + sanity
Integration	minimal
UI	manual only

CLI Execution
	•	make pulse → all tests
	•	make probe → domain only
	•	make delta → single test file
	•	entr / watch mode for TDD

⸻

9. Makefile Philosophy

The Makefile is:
	•	The primary dev interface
	•	Human-readable
	•	Intent-driven

Example semantics:

make pulse     # full test suite
make probe     # fast TDD loop
make watch     # auto-run on save
make clean     # derived data cleanup


⸻

10. Permissions & Privacy

Capability	Needed
App Sandbox	✅
Network (Outgoing)	✅
Location	❌ (IP-based weather)
Accessibility	❌
Full Disk	❌

No scary dialogs.

⸻

11. Performance Targets

Metric	Target
RAM	< 20 MB
CPU	< 0.3% idle
Wakeups	≤ 1/sec
Binary	< 10 MB


⸻

12. Release Strategy (Later)
	•	macOS only
	•	Paid, low-cost utility
	•	No subscription
	•	No telemetry
	•	No login

⸻

13. Build Order (Recommended)
	1.	StatsSampler (CPU/RAM/Net)
	2.	Storage reader
	3.	Weather sampler
	4.	Menu bar formatting
	5.	App list + quit all
	6.	Caffeinate wrapper
	7.	Visual polish
	8.	Packaging

⸻

14. Final Note

This plan is:
	•	Small enough to finish
	•	Clean enough to maintain
	•	Serious enough to ship

If you want, next we can:
	•	Lock exact Makefile targets
	•	Start CPU TDD implementation
	•	Design menu bar text layout precisely
	•	Or tackle caffeinate wrapper first

Just say the word.
