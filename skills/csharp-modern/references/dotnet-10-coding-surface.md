# .NET 10 coding surface

.NET 10 is LTS (support through November 2028). Target `net10.0` for new apps that adopt C# 14.

Overview: [What's new in .NET 10](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-10/overview).

## SDK and project defaults

```xml
<PropertyGroup>
  <TargetFramework>net10.0</TargetFramework>
  <LangVersion>14</LangVersion>
  <Nullable>enable</Nullable>
  <ImplicitUsings>enable</ImplicitUsings>
</PropertyGroup>
```

Build and test on the .NET 10 SDK before merging framework bumps.

## Runtime and libraries (how you write C#)

- **Performance:** JIT and GC improvements favor hot paths that use spans, UTF-8 APIs, and less allocation. Prefer existing BCL span-based overloads when they exist.
- **Post-quantum cryptography:** new ML-DSA / ML-KEM APIs for security-sensitive code; use official `System.Security.Cryptography` types rather than custom crypto.
- **Networking:** `WebSocketStream` and TLS 1.3 on macOS affect how you structure async I/O code; keep `CancellationToken` on all network calls.

## Validation

Validation APIs moved toward `Microsoft.Extensions.Validation` for some scenarios. When upgrading packages, align validation package versions with ASP.NET Core 10 and check release notes for namespace moves.

## ASP.NET Core 10 (call-site only)

These affect C# you write at the HTTP boundary without prescribing app structure:

| Area | What changed |
| ------|--------------|
| Minimal APIs | Built-in validation support for parameters and bodies |
| OpenAPI | OpenAPI 3.1, YAML documents, XML doc comments flow into OpenAPI |
| Identity | Passkey (WebAuthn) support in templates |
| Blazor | `[PersistentState]` for declarative prerender state; improved diagnostics |

Use `TypedResults` and attribute-based OpenAPI metadata where the template already does.

## Adoption checklist

- [ ] Solution builds on SDK 10 with zero new warning suppressions (or each suppression documented).
- [ ] Package references for `Microsoft.AspNetCore.*`, `Microsoft.EntityFrameworkCore.*`, and `Microsoft.Extensions.*` are 10.0.0+ when on `net10.0`.
- [ ] New language features used only where they improve clarity, not for novelty.
- [ ] Breaking changes from [Breaking changes in .NET 10](https://learn.microsoft.com/en-us/dotnet/core/compatibility/10.0) reviewed for your dependencies.
