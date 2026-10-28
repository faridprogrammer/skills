# API Conventions

## REST Shape

- Resources are nouns: `POST /api/orders`, `GET /api/orders/{id}`, `GET /api/orders?customerId=...`.
- Commands: `POST` (create), `PUT` (full replace), `PATCH` (partial), `DELETE` (remove).
- Queries: `GET` with paging (`page`, `pageSize`, default `pageSize=20`, max `100`).
- Status codes: `201` create (+ `Location`), `200` read/update, `204` delete, `400` validation, `404` missing, `409` conflict, `500` unexpected.

## DTOs vs Domain Models

- DTOs live in `Api/Dtos/` (request/response shapes). Domain models live in `Domain/`.
- Map at the boundary: controller maps DTO → command; handler maps domain → result DTO.
- Never return entities from controllers.

```csharp
public record CreateOrderDto(Guid CustomerId, List<OrderLineInputDto> Lines);
public record OrderDto(Guid Id, decimal Total, string Currency);
```

## Validation (MediatR Pipeline)

```csharp
public class ValidationBehavior<TRequest, TResponse>(IEnumerable<IValidator<TRequest>> validators)
    : IPipelineBehavior<TRequest, TResponse>
{
    public async Task<TResponse> Handle(TRequest req, RequestHandlerDelegate<TResponse> next, CancellationToken ct)
    {
        var failures = (await Task.WhenAll(validators.Select(v => v.ValidateAsync(req, ct))))
            .SelectMany(r => r.Errors).Where(e => e != null).ToList();
        if (failures.Count > 0) throw new ValidationException(failures);
        return await next();
    }
}
```

- One `AbstractValidator<T>` per command/query that needs it.
- Validation failures → `400` with a ProblemDetails body listing field errors.

## Errors (ProblemDetails)

```csharp
app.UseExceptionHandler(); // map exceptions:
 // ValidationException → 400, NotFoundException → 404,
 // DomainException → 422, anything else → 500 (no stack traces to clients)
```

- Domain violations throw `DomainException` (→ `422`); missing resources throw `NotFoundException` (→ `404`).
- Log `500`s with correlation IDs; return only the correlation ID to the client.

## Auth

- JWT bearer by default; `[Authorize]` on controllers, `[AllowAnonymous]` only for public endpoints.
- User/tenant ID flows as a claim → mapped into commands in the controller, never read from headers in handlers.
