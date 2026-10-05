# Data Access with EF Core

## DbContext (Infrastructure Only)

```csharp
public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Order> Orders => Set<Order>();

    protected override void OnModelCreating(ModelBuilder b)
    {
        b.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
    }
}
```

- Registered as **scoped** in DI.
- Entity configurations via `IEntityTypeConfiguration<T>` in `Persistence/Configurations/`.
- Value objects mapped with `OwnsOne` / `HasConversion` — conversion details never leak to `Domain`.

## Repository + Unit of Work

```csharp
// Port defined in Application
public interface IOrderRepository
{
    Task AddAsync(Order order, CancellationToken ct);
    Task<Order?> GetByIdAsync(OrderId id, CancellationToken ct);
}

public interface IUnitOfWork
{
    Task SaveChangesAsync(CancellationToken ct);
}
```

- One transaction per command handler: use a MediatR `TransactionBehavior<TRequest, TResponse>` that wraps `Handle` in an execution strategy + transaction, or call `IUnitOfWork.SaveChangesAsync` once at the end of the handler.
- Queries: read-only, `AsNoTracking()`, project to DTOs.

## Migrations and Seeding

```powershell
dotnet ef migrations add AddOrders --project src/MyApp.Infrastructure --startup-project src/MyApp.Api
dotnet ef database update --project src/MyApp.Infrastructure --startup-project src/MyApp.Api
```

- Every schema change ships with a migration in the same change.
- Seed data via explicit `DbContext` seeders run at startup or via a dedicated migration — never in domain constructors.

## Rules

1. No `DbSet`/`DbContext` outside `Infrastructure`.
2. No lazy loading — use explicit `Include` or projections.
3. No raw SQL unless justified; isolate it in a repository method with a comment explaining why LINQ was insufficient.
4. Optimistic concurrency with row-version tokens on aggregates that need it.
