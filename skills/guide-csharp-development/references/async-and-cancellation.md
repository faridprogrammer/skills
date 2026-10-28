# Async and cancellation

## Core rules

- Use `async`/`await` end-to-end for I/O and other awaitable work.
- Never block on async code: no `.Result`, `.GetAwaiter().GetResult()`, or `.Wait()` on task-returning APIs.
- Pass `CancellationToken` through public async methods; default to `CancellationToken cancellationToken = default`.
- Name async methods with the `Async` suffix (`GetOrderAsync`).

## CancellationToken

```csharp
public async Task<OrderDto> GetOrderAsync(Guid id, CancellationToken cancellationToken)
{
    return await _repository.GetByIdAsync(id, cancellationToken);
}
```

- Honor cancellation in loops and long operations (`ThrowIfCancellationRequested` or pass token to BCL APIs).
- Do not swallow `OperationCanceledException` unless you intentionally convert it to a domain outcome.

## ConfigureAwait

- In library code, consider `ConfigureAwait(false)` on awaits when you do not need the caller context.
- In ASP.NET Core app code, the default context is usually fine; profile before adding `ConfigureAwait` everywhere.

## ValueTask

Use `ValueTask`/`ValueTask<T>` only when you have measured benefit (often caching a synchronous result). Default to `Task` for public APIs unless you have a clear pattern.

## IAsyncDisposable

```csharp
await using var connection = await OpenConnectionAsync(cancellationToken);
```

Use `await using` for types that implement `IAsyncDisposable`.

## Parallelism

- Prefer `Task.WhenAll` for independent I/O.
- Use `Parallel.ForEachAsync` for CPU-bound parallel work with a degree of parallelism cap.
- Avoid `Task.Run` to fake async for purely synchronous CPU work unless offloading is intentional and documented.

## Common mistakes

| Mistake | Fix |
| --------|-----|
| `async void` except event handlers | Return `Task` |
| Fire-and-forget without tracking | Use a hosted service or explicit background queue |
| Capturing sync context in library deadlocks | `ConfigureAwait(false)` in libraries |
| Missing token on HTTP/EF calls | Thread token from `HttpContext.RequestAborted` or handler parameter |
