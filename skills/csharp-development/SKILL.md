---
name: csharp-development
description: Use when writing or reviewing C# on .NET 8+—types, nullability, async, exceptions, IDisposable, LINQ, records, enums, DI usage, and common BCL patterns.
---

# C# Development (.NET 8+)

You are operating as a senior C# developer focused on idiomatic, correct .NET code.

## When This Skill Applies

**Use this skill when:**

- Implementing or reviewing C# features, services, or libraries
- Fixing bugs in application or infrastructure code
- Choosing types, async patterns, or error handling

**Out of scope:** solution layering, MediatR/EF structure, and SOLID architecture (handle those in separate reviews).

## Type system

- **Records** for immutable DTOs; **classes** for mutable services and entities.
- **Structs** only when small and immutable; watch copy cost.
- **Enums** instead of magic numbers in public APIs.
- **`required`** and **`init`** for construction contracts on DTOs.

See: [references/types-nullability-and-apis.md](references/types-nullability-and-apis.md)

## Nullability

- Keep nullable reference types enabled.
- Annotate public APIs; validate with `ArgumentNullException.ThrowIfNull`.
- Minimize `!`; use it only where flow analysis or framework contracts guarantee non-null.

## Async

- Async end-to-end; pass `CancellationToken`.
- No `.Result` / `.Wait()` on tasks.
- `await using` for `IAsyncDisposable`.

See: [references/async-and-cancellation.md](references/async-and-cancellation.md)

## Exceptions and validation

- Exceptions for exceptional cases; validate at boundaries.
- Rethrow with `throw;` to keep stack traces.
- HTTP APIs return ProblemDetails for errors, not raw exception details.

See: [references/exceptions-and-validation.md](references/exceptions-and-validation.md)

## Resources

```csharp
await using var stream = File.OpenRead(path);
```

- `using` / `await using` for all disposable resources.
- Prefer `IAsyncDisposable` when cleanup is async.

## LINQ and collections

- Prefer clarity over clever LINQ.
- Know when queries materialize.
- Expose `IReadOnlyList<T>` when callers need a stable snapshot.

See: [references/linq-collections-and-performance.md](references/linq-collections-and-performance.md)

## Dependency injection (code level)

- Constructor injection only; no service locator in business code.
- Depend on abstractions at boundaries (`IOrderRepository`, not concrete types).
- Register lifetimes correctly: singleton vs scoped vs transient.

## Checklists

**Before coding:** Types and nullability for public surface? Async API with cancellation? Validation at boundary?

**After coding:** `dotnet build` clean? No new nullable or analyzer warnings? Disposables wrapped? No sync-over-async?
