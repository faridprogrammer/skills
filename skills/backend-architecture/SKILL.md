---
name: backend-architecture
description: Use when building or reviewing a layered monolith backend in C# on .NET 8+. Covers Presentation, Application (MediatR), Domain, and Infrastructure (EF Core) layers, dependency direction, and API conventions.
---

# Backend Architecture: Layered Monolith in C# (.NET 8+, EF Core, MediatR)

You are operating as a senior backend engineer building a layered monolith: a single deployable ASP.NET Core application with strict layer boundaries.

## When This Skill Applies

**Use this skill when:**
- Starting a new backend or adding a feature to the monolith
- Structuring projects, layers, or MediatR handlers
- Adding EF Core persistence (entities, repositories, migrations)
- Defining API endpoints, DTOs, validation, or error responses
- Reviewing layering violations or coupling to infrastructure

## Stack (Locked)

- **.NET 8+**, ASP.NET Core Web API
- **Entity Framework Core** for all persistence
- **MediatR** as the mandatory request pipeline (controllers send `IRequest`s; all business logic lives in handlers)
- Validation via a MediatR pipeline behavior (e.g. FluentValidation)

## Layer Map

```
Presentation (Api) → Application → Domain ← Infrastructure
                         ↑                          ↑
                   defines interfaces         implements interfaces
```

| Layer (project) | Contains | Must NOT contain |
|-----------------|----------|------------------|
| **Presentation** (`*.Api`) | Controllers / endpoints, DTOs, auth, ProblemDetails mapping | Business logic, `DbContext`, SQL |
| **Application** (`*.Application`) | MediatR commands/queries + `IRequestHandler`s, use-case orchestration, ports (repository interfaces), pipeline behaviors | EF Core, `DbContext`, HTTP concerns |
| **Domain** (`*.Domain`) | Entities, value objects, domain services, invariants | References to other layers, EF Core, MediatR |
| **Infrastructure** (`*.Infrastructure`) | EF Core `DbContext`, configurations, repositories, migrations, external clients | Business decisions |

## The Dependency Rule

Dependencies point **inward** toward the domain:

- `Api` references `Application` (sends requests via `IMediator`).
- `Application` references `Domain` only (depends on repository **interfaces**).
- `Infrastructure` references `Application` (implements the interfaces) + `Domain`.
- `Domain` references **nothing**.
- `DbContext` never leaves `Infrastructure`; return domain objects or DTOs, never `IQueryable` across layers.

See: [references/layers-csharp.md](references/layers-csharp.md)

## Request Flow (Mandatory)

```
Controller → IMediator.Send(command/query) → Handler → Repository interface → EF Core repository
```

- Controllers are thin: map HTTP → command/query, send via MediatR, map result → HTTP response.
- One transaction per command handler (pipeline behavior or Unit of Work). Queries are read-only.
- DTOs at the boundary; domain models inside. Never expose entities directly.

See: [references/api-conventions.md](references/api-conventions.md), [references/data-access.md](references/data-access.md)

## Data Access Rules (EF Core)

- `DbContext` is scoped, lives only in `Infrastructure`.
- Repositories implement `Application` interfaces; no `DbSet` outside repositories.
- Schema changes via migrations; seed data via explicit seeders.
- No raw SQL unless justified and isolated in a repository.

See: [references/data-access.md](references/data-access.md)

## Checklists

**Before coding:** What is the use case (command or query)? What DTOs? What domain invariants? New migration needed?

**While coding:** Controller thin? Logic in handler, not controller? Depending on interfaces? Domain free of EF Core/MediatR imports?

**After coding:** `dotnet build` passes? Migrations added? Errors returned as ProblemDetails? No `DbContext` outside Infrastructure?
