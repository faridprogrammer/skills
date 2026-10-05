---
name: oop-fundamentals
description: Use when writing object-oriented code, modeling domain objects, or reviewing OOP design. Covers encapsulation, value objects vs entities, Tell Don't Ask, composition over inheritance, responsibility-driven design, and design patterns.
---

# OOP Fundamentals: Core Object-Oriented Design

You are operating as a senior software engineer focused on core object-oriented craftsmanship.

## When This Skill Applies

**Use this skill when:**
- Writing or modeling classes and domain objects
- Designing value objects, entities, and aggregates
- Reviewing encapsulation and object responsibilities
- Applying design patterns
- Writing clean, human-readable object-oriented code

This skill covers core OOP modeling. It does not cover SOLID principles, decoupling, or architecture.

## Core Philosophy

> "Objects are defined by their responsibilities, not their data."

Objects should **hide data and expose behavior**. The goal: code that is easy to **discover, understand, change, test, and debug**.

## 1. Model the Domain with Objects

**Finding objects:** nouns in requirements → candidate objects; verbs → candidate behaviors; domain concepts → value objects.

**For every class ask:**
1. "What pattern is this?" (Entity, Service, Repository, Factory, Information Holder, Coordinator, etc.)
2. "Is it doing too much?"

See: [references/object-design.md](references/object-design.md)

## 2. Encapsulation, Value Objects, and Entities

- **ALWAYS wrap primitives in domain objects** — IDs, emails, money amounts, etc.
- **Value objects** (`Money`, `Email`, `Address`): immutable, no identity, compared by value.
- **Entities** (`User`, `Order`): have identity, compared by ID, mutate only via methods.
- **Aggregates:** one aggregate root is the entry point; external code never reaches inside directly.
- Hide internals (private fields), expose behavior — never expose mutable state.

```typescript
// BAD: raw primitives, exposed state
// function createOrder(userId: string, email: string)

// GOOD: domain types
function createOrder(userId: UserId, email: Email)
```

## 3. Behavioral Principles

- **Tell, Don't Ask** — command objects to do work; don't interrogate them and do it yourself.
- **Composition over inheritance** — prefer pluggable policies/strategies over subclasses (inheritance only for true "is-a").
- **Law of Demeter** — only talk to immediate friends; one dot per line (`order.getShippingCity()`, not `order.getCustomer().getAddress().getCity()`).
- **Design by Contract** — define preconditions, postconditions, and invariants for each method.
- **Polymorphism** — replace type-checking conditionals with types.

See: [references/object-design.md](references/object-design.md)

## 4. Write Clean, Human-Readable Code

**Naming (priority order):** Consistency > Understandability > Specificity > Brevity > Searchability. Avoid vague names (`data`, `info`, `manager`).

**Functions:** few parameters (3+ → parameter object), small and single-purpose, one abstraction level per function, no unexpected side effects.

**Control structures:** prefer positive checks, guard clauses and early returns over `else`, no deep nesting, embrace real errors over synthetic codes.

See: [references/clean-code.md](references/clean-code.md)

## 5. Design Patterns Awareness

**Creational:** Singleton, Factory, Builder, Prototype.
**Structural:** Adapter, Decorator, Proxy, Composite.
**Behavioral:** Strategy, Observer, Template Method, Command.

**Warning:** Let patterns emerge from refactoring — don't force them upfront. Match the pattern to a problem you actually have.

See: [references/design-patterns.md](references/design-patterns.md)

## 6. Tests and Complexity

- **TDD (Red-Green-Refactor)** is the default loop; design happens during refactoring. See: [references/tdd.md](references/tdd.md), [references/testing.md](references/testing.md)
- Fight complexity with **YAGNI, KISS, DRY** (Rule of Three — wait for 3 duplications). See: [references/complexity.md](references/complexity.md)
- Watch for smells: Primitive Obsession, Feature Envy, Data Clumps, God Object. See: [references/code-smells.md](references/code-smells.md)

## Checklists

**Before coding:** Do I understand the requirement? What test first? What is the simplest object model? Am I solving a real problem?

**While coding:** Does this class have one clear responsibility? Is state encapsulated? Can I name this more clearly? Composition instead of inheritance?

**After coding:** Do tests pass? Any dead code? Would a junior understand this in 6 months?
