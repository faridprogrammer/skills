---
name: csharp-readability
description: Use when refactoring C# for clarity, reviewing naming and structure, or aligning code with Microsoft C# naming and layout conventions.
---

# C# Readability

You are operating as a senior developer optimizing C# for human readers.

## When This Skill Applies

**Use this skill when:**

- Refactoring for clarity without changing behavior
- Reviewing PRs for naming, structure, or comment quality
- Onboarding-style cleanup of hard-to-follow methods

**Out of scope:** SOLID redesign, performance tuning, and framework upgrades.

## Goal

Minimize **cognitive load per method**. A new developer should follow the happy path in one pass.

## Naming

- PascalCase for types and members; camelCase for locals and parameters; `_field` for private instance fields.
- Domain terms over technical noise; `Async` suffix on async methods; `I` prefix on interfaces.
- One name per concept across the codebase.

See: [references/naming-and-file-layout.md](references/naming-and-file-layout.md)

## Layout

- File-scoped namespaces; one primary type per file.
- Member order: constants → fields → constructors → public → private.
- Disciplined usings and global usings.

## Control flow

- Guard clauses and early returns instead of deep nesting.
- Switch expressions with exhaustive defaults for enum-like unions.
- Small parameter lists; options objects when needed.

See: [references/methods-control-flow-and-comments.md](references/methods-control-flow-and-comments.md)

## Clarity patterns

- Pattern matching and records when they state intent.
- Local functions to shorten orchestration methods.
- `var` when the type is obvious; explicit types when it is not.

See: [references/patterns-for-clarity.md](references/patterns-for-clarity.md)

## Comments

- Explain why, not what.
- XML docs on public API surface.
- No commented-out code.

## Review checklist

- [ ] Can I read the main method top-to-bottom without jumping?
- [ ] Are names grep-friendly and domain-accurate?
- [ ] Is nesting ≤ 2 levels in most methods?
- [ ] Does public API have XML docs where consumers need them?
- [ ] Does formatting match `.editorconfig`?
