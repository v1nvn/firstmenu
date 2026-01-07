# ADR 002: Actor Isolation for Infrastructure Providers

## Status
Accepted

## Context
FirstMenu's infrastructure providers access system resources concurrently:
- CPU and RAM readers are called every second
- Network reader calculates deltas between readings
- Multiple menu bar items may read simultaneously

Swift Concurrency requires data races to be eliminated at compile time.

## Decision
All infrastructure providers are implemented as Swift `actor`s:

```swift
public actor MachCPUReader: CPUProviding {
    public func cpuPercentage() async throws -> Double { ... }
}

public actor MachRAMReader: RAMProviding {
    public func ramUsage() async throws -> (used: Int64, total: Int64) { ... }
}
```

## Rationale
1. **Thread Safety**: Actors ensure serialized access to mutable state
2. **Compiler Support**: Swift compiler enforces actor isolation
3. **No Locks**: No manual mutex/synchronization needed
4. **Async/Await**: Natural fit for Swift Concurrency

## Trade-offs
**Positive**:
- Compile-time guarantee of no data races
- Clean async/await syntax
- Automatic serialization of access

**Negative**:
- All methods become async (minor overhead)
- Cannot share mutable state without actors
- Testing requires async/await

## Implementation Notes
- Mock providers also use actors for consistent testing
- UI layer (`@MainActor`) coordinates async calls from providers
- Use cases (`@MainActor` classes) bridge actors and UI

## Alternatives Considered
1. **Mutex/Locks**: Manual synchronization
   - Rejected: Error-prone, not Swift-idiomatic

2. **SerialDispatchQueue**: GCD queues
   - Rejected: No compile-time safety

3. **Immutable State + Copy-on-Write**: Value semantics
   - Rejected: Not feasible for system state that changes externally
