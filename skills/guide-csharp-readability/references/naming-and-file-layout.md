# Naming and file layout

Follow [C# coding conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions) and [Framework design guidelines](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/) naming.

## Casing

| Element | Style | Example |
| --------|--------|---------|
| Namespace | PascalCase | `Acme.Orders` |
| Type, method, property | PascalCase | `OrderService`, `GetTotal` |
| Interface | `I` + PascalCase | `IOrderRepository` |
| Parameter, local | camelCase | `customerId` |
| Private field | `_camelCase` | `_logger` |
| Constant | PascalCase | `MaxRetries` |
| Type parameter | `T` + noun | `TEntity` |

## Naming rules

- Use **domain language** (`PlaceOrder`), not vague names (`ProcessData`, `HandleStuff`).
- Async methods end with **`Async`**.
- Boolean members read as questions: `IsActive`, `HasItems`, `CanRetry`.
- Do not use Hungarian notation (`strName`, `iCount`).
- One concept, one name: do not mix `Customer`, `Client`, and `User` for the same thing.

## Searchability

Names should be unique enough to grep. Avoid single-letter identifiers except loop indices and well-known math.

## File layout

- **File-scoped namespace** at top of file:

```csharp
namespace Acme.Orders.Application;

public sealed class CreateOrderHandler { }
```

- **One primary public type per file**; file name matches type name (`CreateOrderHandler.cs`).
- **Member order** (typical):
  1. Constants
  2. Static fields
  3. Instance fields
  4. Constructors
  5. Public properties and methods
  6. Private helpers

## Usings

- Remove unused usings.
- Prefer project `GlobalUsings.cs` for common namespaces (`System`, `Microsoft.Extensions.Logging`).
- Do not hide domain imports behind excessive globals.

## Regions

Avoid `#region` except in generated code or rare very large files. Prefer smaller types instead.
