# ADR 001: Clean Architecture with Three Layers

## Status
Accepted

## Context
FirstMenu is a macOS menu bar application that monitors system resources and displays them in a compact UI. The application needs to:
- Access low-level system APIs (Mach kernel, file system, network)
- Display UI using SwiftUI
- Be testable without requiring system permissions
- Handle failures gracefully

## Decision
We adopt a three-layer Clean Architecture:

### Domain Layer
- **Models**: `StatsSnapshot`, `WeatherSnapshot`, `AppProcess`, `CaffeinateState`
- **Protocols**: `CPUProviding`, `RAMProviding`, `StorageProviding`, `NetworkProviding`, `WeatherProviding`, `AppListing`, `PowerAssertionProviding`
- **Use Cases**: `StatsSampler`, `WeatherSampler`, `AppProcessManager`, `PowerAssertionController`

**Responsibilities**: Core business logic and domain models. No dependencies on external frameworks or system APIs.

### Infrastructure Layer
- **Readers**: `MachCPUReader`, `MachRAMReader`, `FileSystemStorageReader`, `InterfaceNetworkReader`
- **Clients**: `OpenMeteoWeatherClient`
- **Wrappers**: `NSWorkspaceAppLister`, `CaffeinateWrapper`
- **Formatters**: `StatsFormatter`

**Responsibilities**: External system integration, data persistence, API calls. Implements protocols defined in Domain layer.

### UI Layer
- **Views**: `MenuBarLabelView`, `MenuBarWindowView`, `CPUPopoverView`, etc.
- **Components**: `MenuItem`, `DesignSystem`, `CaffeinateMenu`, `SettingsMenu`
- **State**: `MenuBarState` (singleton)

**Responsibilities**: Display and user interaction. Depends on Domain layer for business logic.

## Consequences
**Positive**:
- Domain layer is 100% testable without system dependencies
- Infrastructure can be swapped (e.g., different weather API)
- UI is decoupled from system access
- Clear separation of concerns

**Negative**:
- More files and indirection than a simple monolithic app
- Some boilerplate for protocol definitions
- Singleton state (`MenuBarState`) requires careful management

## Alternatives Considered
1. **Monolithic approach**: All code in UI layer
   - Rejected: Not testable, hard to maintain

2. **MVVM**: Model-View-ViewModel
   - Rejected: Overkill for a menu bar app, ViewModels would be thin wrappers

3. **VIPER**: View-Interactor-Presenter-Entity-Router
   - Rejected: Too complex for the scope of this application

## References
- Clean Architecture by Robert C. Martin
- The Clean Architecture by Uncle Bob
