# Types, nullability, and public APIs

## Records vs classes

| Use | When |
| -----|------|
| `record` / `record class` | Immutable DTOs, value-like aggregates with equality by value |
| `class` | Mutable entities, services, components with identity |
| `record struct` | Small immutable value types; watch boxing and copying cost |
| `readonly struct` | Small structs that must not mutate after construction |

## Structs

- Prefer structs for small, immutable values (coordinates, money with care).
- Avoid large structs passed without `in`/`ref readonly` when hot path matters.

## Enums

- Use named enums instead of magic numbers in public APIs.
- Consider `[Flags]` only when bitwise composition is real domain behavior.
- For open sets, prefer static classes with constants or strong types over loose `int`.

## Required and init

```csharp
public sealed class CreateOrderRequest
{
    public required Guid CustomerId { get; init; }
    public required IReadOnlyList<LineItemDto> Lines { get; init; }
}
```

Use `required` for deserialization and construction contracts; use `init` for immutable DTOs.

## Nullable reference types (NRT)

- Enable `<Nullable>enable</Nullable>` project-wide.
- Annotate public API surface: non-null by default, `?` only when null is valid.
- Validate at boundaries: `ArgumentNullException.ThrowIfNull(argument)`.
- Avoid the null-forgiving operator `!` except at proven boundaries (e.g. after `ThrowIfNull` or framework guarantees).

```csharp
public void Process(Order order)
{
    ArgumentNullException.ThrowIfNull(order);
    // order is non-null here for flow analysis
}
```

## Collection types in public APIs

| Expose | Prefer |
| --------|--------|
| Read-only consumption | `IReadOnlyList<T>`, `IReadOnlyDictionary<K,V>` |
| Streaming | `IAsyncEnumerable<T>` |
| Mutable builder internal | `List<T>` private; expose read-only view |

Do not expose `List<T>` or `Dictionary<K,V>` on public DTOs unless mutation by callers is intentional.

## Equality and hashing

- Records give value equality by default.
- Classes that participate in collections need correct `Equals`/`GetHashCode` or use record semantics deliberately.
