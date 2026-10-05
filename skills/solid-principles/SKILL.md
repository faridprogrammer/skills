---
name: solid-principles
description: Use when refactoring, reviewing architecture, or decoupling code. Applies SOLID principles rigorously, enforces dependency direction toward the domain, and designs vertical slices with horizontal layers.
---

# SOLID Principles: Architecture and Decoupling

You are operating as a senior software engineer focused on SOLID design and software architecture.

## When This Skill Applies

**Use this skill when:**
- Refactoring or reviewing code quality and coupling
- Planning or designing architecture (features, layers, modules)
- Applying SOLID principles or dependency inversion
- Decoupling infrastructure from domain logic
- Debugging issues caused by tangled dependencies

This skill covers refactoring, SOLID principles, and architecture. It does not cover core OOP modeling (value objects, encapsulation, patterns).

## Core Philosophy

> "Enable developers to discover, understand, add, change, remove, test, debug, deploy, and monitor features efficiently."

Optimize for change: new features by **adding** code, not editing tested code.

## 1. Apply SOLID Principles Rigorously

| Principle | Question to Ask |
|-----------|-----------------|
| **S**RP - Single Responsibility | "Does this have ONE reason to change?" |
| **O**CP - Open/Closed | "Can I extend without modifying?" |
| **L**SP - Liskov Substitution | "Can subtypes replace base types safely?" |
| **I**SP - Interface Segregation | "Are clients forced to depend on unused methods?" |
| **D**IP - Dependency Inversion | "Do high-level modules depend on abstractions?" |

Red flags: classes described with "and", `if/else` chains for types, `throw new Error("Not implemented")` (fat interface), `new ConcreteClass()` in business logic.

See: [references/solid-principles.md](references/solid-principles.md)

## 2. Architect for Change

**Vertical slicing:** organize by feature, not technical layer (`users/`, `orders/` — not `controllers/`, `services/`).

**Horizontal decoupling:** Presentation → Application → Domain ← Infrastructure. Dependencies point **inward** toward the domain; domain knows nothing about infrastructure.

**The Dependency Rule:** domain defines interfaces (ports); infrastructure implements them (adapters). Inject abstractions, never instantiate concretions in business logic.

See: [references/architecture.md](references/architecture.md)

## 3. Manage Complexity Ruthlessly

**Essential complexity** = inherent to the domain. **Accidental complexity** = introduced by our solutions.

Detect via change amplification, cognitive load, and surprises. Fight with **YAGNI, KISS, DRY** (Rule of Three).

See: [references/complexity.md](references/complexity.md)

## 4. The Four Elements of Simple Design (XP)

In priority order:
1. **Runs all the tests**
2. **Expresses intent**
3. **No duplication** (Rule of Three)
4. **Minimal** — fewest classes/methods possible

## 5. Code Smell Detection

| Smell | Solution |
|-------|----------|
| Long Method / Large Class | Extract methods/classes, single responsibility |
| Long Parameter List | Introduce parameter object |
| Divergent Change / Shotgun Surgery | Split classes / move related code together |
| Switch Statements | Replace with polymorphism |
| Speculative Generality | YAGNI — remove unused abstractions |

See: [references/code-smells.md](references/code-smells.md)

## 6. Tests

Default loop is **Red-Green-Refactor**; design happens during refactoring. Most tests at the domain/unit level; integration at boundaries; E2E for critical paths only. See: [references/tdd.md](references/tdd.md), [references/testing.md](references/testing.md)

Clean, expressive code remains mandatory — see [references/clean-code.md](references/clean-code.md).

## Checklists

**Before coding:** What are the acceptance criteria? What test first? What is the simplest slice? What boundaries/interfaces does this need?

**While coding:** Single responsibility? Depending on abstractions? Extending without modifying? Dependencies pointing inward?

**After coding:** All tests pass? Any circular dependencies? Domain free of infrastructure imports? Any dead code?
