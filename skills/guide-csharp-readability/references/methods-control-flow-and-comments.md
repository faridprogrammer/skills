# Methods, control flow, and comments

## Method size and abstraction

- One level of abstraction per method: orchestration calls named helpers; helpers do not mix HTTP, SQL, and domain rules.
- If a method needs a scroll to understand, extract private methods with intention-revealing names.
- Aim for a single **happy path** visible at the top; edge cases branch off.

## Guard clauses

```csharp
public OrderDto Map(Order order)
{
    ArgumentNullException.ThrowIfNull(order);

    if (!order.IsActive)
    {
        throw new InvalidOperationException("Cannot map inactive order.");
    }

    return new OrderDto(order.Id, order.Total);
}
```

Prefer early returns over deep nesting.

```csharp
// Hard to read
if (user is not null)
{
    if (user.IsActive)
    {
        if (user.HasPermission(Permission.Edit))
        {
            Edit(user);
        }
    }
}

// Clearer
if (user is null || !user.IsActive || !user.HasPermission(Permission.Edit))
{
    return;
}

Edit(user);
```

## Switch expressions

Use switch expressions for mapping discriminated values. Use exhaustive handling with a `never` check in the default arm for unions:

```csharp
public static string Describe(OrderStatus status) => status switch
{
    OrderStatus.Pending => "Pending",
    OrderStatus.Shipped => "Shipped",
    OrderStatus.Cancelled => "Cancelled",
    _ => throw new ArgumentOutOfRangeException(nameof(status), status, null),
};
```

## Parameters

- Few parameters (ideally ≤ 4). Use an options or command object when the list grows.
- Avoid `bool` parameters that change behavior unless the name is obvious (`saveAsDraft: true`).
- Prefer enums or small value types over multiple booleans.

## Comments and documentation

- Comments explain **why**, not **what** the code already says.
- Public API: XML documentation on types and members consumers call.

```csharp
/// <summary>Places an order and reserves inventory.</summary>
/// <param name="command">Must include at least one line item.</param>
public Task<OrderId> PlaceAsync(PlaceOrderCommand command, CancellationToken cancellationToken);
```

- No commented-out code in source control; delete or restore from history.
- TODO comments need an owner or issue reference.

## Formatting

- Match existing project style (`.editorconfig`).
- Braces on all control blocks in team style that requires them.
- One statement per line; avoid dense one-liners that hide logic.
