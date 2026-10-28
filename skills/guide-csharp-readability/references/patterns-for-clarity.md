# Patterns for clarity

Use language features when they **reduce** cognitive load, not when they shorten line count.

## Pattern matching

```csharp
if (message is OrderPlaced placed)
{
    await HandleOrderPlacedAsync(placed, cancellationToken);
    return;
}

if (message is PaymentFailed failed)
{
    await HandlePaymentFailedAsync(failed, cancellationToken);
    return;
}
```

Prefer `is` patterns over `as` + null check when you need the typed value.

## Property patterns and records

Records make DTOs readable:

```csharp
public sealed record OrderLineDto(Guid ProductId, int Quantity, decimal UnitPrice);

public decimal LineTotal => Quantity * UnitPrice;
```

Deconstruct only when names at the call site stay clear:

```csharp
var (productId, quantity, _) = line; // poor if `_` hides meaning
```

## Local functions

Use local functions to keep the outer method's story short:

```csharp
public async Task<Result> ImportAsync(Stream csv, CancellationToken cancellationToken)
{
    async Task<Row?> ReadRowAsync()
    {
        // parse one row
    }

    while (await ReadRowAsync() is { } row)
    {
        // process
    }
}
```

## `var` usage

- Use `var` when the type is obvious from the right-hand side.
- Use explicit types when the type is not obvious or matters for readability (`IEnumerable<Order>` vs `List<Order>`).

```csharp
var orders = await _repository.ListAsync(cancellationToken); // clear
Order first = orders[0]; // explicit when indexing changes meaning
```

## Null handling

Prefer pattern checks over nested null tests:

```csharp
if (response?.Data is { Count: > 0 } data)
{
    Process(data);
}
```

## LINQ for readability

Use LINQ when the operation is standard (`Where`, `Select`, `OrderBy`). Switch to `foreach` when side effects or multi-step logic make LINQ obscure.

## What to avoid

| Golf | Prefer |
| ------|--------|
| Nested ternaries | `if` or switch expression |
| Long fluent chains | Intermediate variables |
| Clever bitwise tricks | Named methods unless performance-critical and documented |
