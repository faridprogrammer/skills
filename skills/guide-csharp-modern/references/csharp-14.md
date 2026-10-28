# C# 14 language features

C# 14 ships with .NET 10. Set `<LangVersion>14</LangVersion>` or `latest` with the .NET 10 SDK.

Official overview: [What's new in C# 14](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-14).

## Extension members

Extension members extend the older extension-method model with properties, operators, and static members on the extended type.

```csharp
public static class PointExtensions
{
    extension(Point p)
    {
        public double Magnitude => Math.Sqrt(p.X * p.X + p.Y * p.Y);
    }

    extension(Point)
    {
        public static Point Origin => new(0, 0);
    }
}
```

**Use when:** you extend a type you do not own and want properties or static helpers that read like instance/type members.

**Skip when:** a wrapper type or adapter in your domain is clearer, or the extension would hide important behavior.

**Migration:** keep existing `static` extension methods until you have a reason to move; new APIs can use extension blocks.

## Field-backed properties (`field`)

Use the contextual keyword `field` in custom accessors instead of a manual backing field.

```csharp
public string Name
{
    get => field;
    set => field = value?.Trim() ?? string.Empty;
}
```

**Use when:** you need validation or normalization beyond an auto-property.

**Skip when:** an auto-property is enough.

## Span and ReadOnlySpan conversions

C# 14 adds implicit conversions among arrays, `Span<T>`, and `ReadOnlySpan<T>` so call sites need less casting.

**Use when:** you call span-based BCL APIs on arrays or slices.

**Rules:** respect span lifetime; do not store a span that points into a stack buffer or short-lived array after the owner goes out of scope.

## `nameof` with unbound generics

```csharp
var name = nameof(List<>); // "List"
```

**Use when:** reflection, logging, or generic type names without a type argument.

## Null-conditional assignment

```csharp
target?.Property = value;
list?[index] = item;
```

**Use when:** assigning only if the left side is non-null, without an extra `if`.

## Partial constructors and events

Instance constructors and events can be `partial`, like methods and properties in C# 13.

**Use when:** source generators or large types split implementation across files.

## Lambda parameter modifiers

Lambdas can use `ref`, `in`, or `out` on parameters without explicit types.

```csharp
Func<int, int> twice = (ref int x) => { x *= 2; return x; };
```

**Use when:** you pass low-level delegates that need by-reference semantics.

## User-defined compound assignment

Types can define `+=`, `-=`, and related compound operators where it improves API ergonomics (uncommon in application code; more common in domain types with custom algebra).

## File-based apps preprocessor directives

C# 14 adds preprocessor support for single-file / file-based app scenarios. Use only when you adopt that project style.

## C# 11–13 (still common in mixed codebases)

Not C# 14, but often seen alongside upgrades:

| Feature | Typical use |
| --------|------------- |
| Collection expressions `[..items]` | literals and spreads |
| Primary constructors on classes | concise DI ctor |
| `required` members | DTOs and options |
| `static abstract` interface members | generic math-style APIs |
| `ref readonly` parameters | large struct passing |

Prefer C# 14 features in new code on .NET 10 when they reduce noise; do not mass-refactor older syntax without a task.
