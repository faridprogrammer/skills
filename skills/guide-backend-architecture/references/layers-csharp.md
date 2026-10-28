# Layers in C# (Layered Monolith)

## Solution Layout

```
src/
  MyApp.Api/               # Presentation
    Controllers/
    Dtos/
    Program.cs
  MyApp.Application/       # Use cases + ports
    Orders/
      CreateOrder.cs       # Command + Handler + Validator
      GetOrder.cs          # Query + Handler
    Common/
      Behaviors/           # ValidationBehavior, TransactionBehavior, LoggingBehavior
      Interfaces/          # IOrderRepository, IUnitOfWork
  MyApp.Domain/            # No project references
    Orders/
      Order.cs
      OrderId.cs
      Money.cs
  MyApp.Infrastructure/    # Implements Application interfaces
    Persistence/
      AppDbContext.cs
      Configurations/
      Repositories/
    Migrations/
```

## DI Wiring (`Program.cs`)

```csharp
builder.Services.AddMediatR(cfg =>
    cfg.RegisterServicesFromAssembly(typeof(CreateOrder).Assembly));
builder.Services.AddScoped(typeof(IPipelineBehavior<,>), typeof(ValidationBehavior<,>));
builder.Services.AddScoped(typeof(IPipelineBehavior<,>), typeof(TransactionBehavior<,>));
builder.Services.AddDbContext<AppDbContext>(o =>
    o.UseNpgsql(builder.Configuration.GetConnectionString("Default")));
builder.Services.AddScoped<IOrderRepository, OrderRepository>();
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
```

## Request Flow Example

```csharp
// Presentation: thin controller
[ApiController]
[Route("api/orders")]
public class OrdersController(IMediator mediator) : ControllerBase
{
    [HttpPost]
    public async Task<ActionResult<OrderDto>> Create(CreateOrderDto dto, CancellationToken ct)
    {
        var result = await mediator.Send(new CreateOrderCommand(dto.CustomerId, dto.Lines), ct);
        return CreatedAtAction(nameof(Get), new { id = result.Id }, result);
    }
}

// Application: command + handler
public record CreateOrderCommand(Guid CustomerId, List<OrderLineInput> Lines) : IRequest<OrderDto>;

public class CreateOrderHandler(IOrderRepository repo, IUnitOfWork uow)
    : IRequestHandler<CreateOrderCommand, OrderDto>
{
    public async Task<OrderDto> Handle(CreateOrderCommand cmd, CancellationToken ct)
    {
        var order = Order.Create(new CustomerId(cmd.CustomerId), cmd.Lines);
        await repo.AddAsync(order, ct);
        await uow.SaveChangesAsync(ct);
        return OrderDto.From(order);
    }
}

// Domain: invariant lives here, knows nothing about EF Core or MediatR
public class Order
{
    public static Order Create(CustomerId customer, IEnumerable<OrderLineInput> lines)
    {
        if (!lines.Any()) throw new DomainException("Order must have at least one line.");
        return new Order(...);
    }
}

// Infrastructure: EF Core stays here
public class OrderRepository(AppDbContext db) : IOrderRepository
{
    public Task AddAsync(Order order, CancellationToken ct)
        => db.Orders.AddAsync(order, ct).AsTask();
}
```

## Layer Rules

1. `Domain` has zero project references.
2. `Application` references `Domain` only.
3. `Api` references `Application` (and `Domain` types for signatures only if needed).
4. `Infrastructure` references `Application` + `Domain`.
5. Never return `IQueryable<T>` from a repository — materialize inside `Infrastructure`.
6. Controllers never touch `DbContext` or repositories directly — always `IMediator.Send`.
