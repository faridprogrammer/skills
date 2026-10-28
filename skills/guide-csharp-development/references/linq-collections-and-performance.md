# LINQ, collections, and performance

## Readability first

- Prefer named intermediate variables over long LINQ chains when debugging matters.
- Method syntax and query syntax are equivalent; stay consistent within a file.

```csharp
// Clear
var active = orders.Where(o => o.IsActive).ToList();

// Obscure — avoid unless team style allows
var x = orders.Where(o => o.Lines.Sum(l => l.Qty * l.Price) > threshold);
```

## Materialization

| API | Effect |
| -----|--------|
| `ToList`, `ToArray` | Executes query; allocates |
| `First`, `Single` | Executes; throws if empty/wrong count |
| `Any`, `Count` | May enumerate entire sequence |

Know whether you enumerate once or many times. Multiple enumerations on `IEnumerable` from EF or network are costly.

## EF Core note

Do not compose unbounded `IQueryable` in memory. Project in the database with `Select` and execute once.

## Allocations

- Prefer `TryGetValue` on dictionaries over double lookup.
- Use `CollectionsMarshal` or span APIs only in measured hot paths.
- `string.Create` and `Span<char>` for heavy string building.

## Sequences vs lists

- Return `IReadOnlyList<T>` when count and indexing matter to callers.
- Return `IEnumerable<T>` only when lazy streaming is intentional and documented.

## Ordering and stability

- Specify `OrderBy` when order matters for tests or UX.
- `Distinct` needs meaningful equality; use `DistinctBy` (.NET 6+) for projections.

## Anti-patterns

| Pattern | Issue |
| --------|-------|
| `.ToList().ForEach` | Use `foreach` |
| LINQ in tight loops on large data | Hoist or use indexes |
| `Count() > 0` | Prefer `Any()` |
