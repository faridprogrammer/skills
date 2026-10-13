---
name: csharp-modern
description: Use when targeting .NET 10 and C# 14—extension members, field-backed properties, Span ergonomics, and BCL or ASP.NET Core 10 APIs that change everyday C# call sites.
---

# Modern C# (.NET 10, C# 14)

You are operating as a senior C# developer adopting the .NET 10 LTS stack and C# 14 language features.

## When This Skill Applies

**Use this skill when:**

- Upgrading projects to `net10.0` or enabling C# 14
- Choosing whether to use new syntax (extension members, `field` properties, span conversions)
- Reviewing code for modern BCL or minimal ASP.NET Core 10 API usage
- Writing new code on SDK 10 where older patterns still compile but are no longer ideal

**Out of scope:** solution layering, domain modeling, and SOLID reviews (handle those with your usual architecture workflow).

## Baseline

- **TFM:** `net10.0` for greenfield or intentional upgrades
- **Language:** C# 14 (`<LangVersion>14</LangVersion>` or `latest` on SDK 10)
- **Nullable:** enabled for new and upgraded projects

## C# 14 — when to adopt

| Feature | Prefer | Avoid |
| --------|--------|--------|
| Extension members | Properties/operators on external types | Replacing every classic extension method in one PR |
| `field` in properties | Validation without manual backing fields | Simple data-only properties |
| Span implicit conversions | Hot paths, parsing, UTF-8 | Storing spans past owner lifetime |
| `nameof(List<>)` | Generic metadata without type args | — |
| Null-conditional assignment | Optional targets | Replacing all `if (x != null)` blindly |
| Partial constructors/events | Generators / split files | Unnecessary partial types |

See: [references/csharp-14.md](references/csharp-14.md)

## .NET 10 at the call site

- Align package versions with 10.0.0+ when on `net10.0`
- Use span-friendly BCL APIs where performance matters
- For HTTP apps: use built-in Minimal API validation and OpenAPI 3.1 features when the project already uses minimal APIs

See: [references/dotnet-10-coding-surface.md](references/dotnet-10-coding-surface.md)

## Adoption rules

1. **Match the repo:** do not restyle unrelated files to C# 14 syntax.
2. **One concern per change:** framework upgrade separate from feature work when possible.
3. **Prove with build:** `dotnet build` on SDK 10; fix new analyzer/nullable warnings.
4. **No silent suppressions:** new `#pragma` or `NoWarn` needs a one-line justification.

## Checklist before merge

- [ ] Builds on .NET 10 SDK
- [ ] New C# 14 syntax improves clarity (not golf)
- [ ] Span usage respects lifetime
- [ ] Breaking-change notes checked for touched dependencies
