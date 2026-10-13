# Exceptions and validation

## Philosophy

- Use exceptions for **exceptional** failures, not normal control flow.
- Validate early at system boundaries (HTTP, message bus, CLI).
- Preserve context when rethrowing: `throw;` not `throw ex;`.

## Argument validation

```csharp
public void Transfer(decimal amount, Account from, Account to)
{
    ArgumentNullException.ThrowIfNull(from);
    ArgumentNullException.ThrowIfNull(to);
    ArgumentOutOfRangeException.ThrowIfNegative(amount);
}
```

Prefer `ArgumentNullException.ThrowIfNull` and `ArgumentOutOfRangeException.ThrowIf*` over manual `if` throws for common cases.

## Domain vs infrastructure

| Layer | Throw |
| -------|-------|
| Domain | Domain-specific exceptions or `Result` types when the team uses them |
| Application | Translate domain failures to application outcomes |
| HTTP API | Map to status codes and **ProblemDetails** for errors |

```csharp
// API boundary — problem details, not raw exception messages to clients
return Results.Problem(
    title: "Order not found",
    statusCode: StatusCodes.Status404NotFound);
```

Do not leak stack traces or internal exception types in production responses.

## Catch blocks

- Catch specific types when you can handle or translate them.
- Avoid empty `catch` except when intentionally swallowing with logging.
- Log unexpected exceptions with structured logging; include correlation IDs when available.

## IDisposable and errors

If construction fails after acquiring a resource, use `try`/`finally` or `using` so disposal still runs.

## Validation libraries

FluentValidation or data annotations are fine at boundaries; keep domain rules in domain code when they encode business invariants.
