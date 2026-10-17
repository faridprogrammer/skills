---
name: ubiquitous-language
description: Code-first discovery and maintenance of a flat domain glossary in markdown. Manual invocation only.
disable-model-invocation: true
---

# Ubiquitous Language

Maintain one canonical glossary per repository by mining the codebase, adding missing terms, and resolving drift against existing definitions. Documentation only — no renames in source.

## When This Skill Applies

The user explicitly invoked this skill (or named it in the message). Do not run it automatically from other workflows.

Optional scope: if the user gives a path (e.g. `scope: services/orders/`), limit discovery and evidence to that subtree. Note the scope in the glossary intro when writing.

## Glossary Location (Discover First)

Find **one** existing glossary before creating a new file. Search in this order; use the first match:

1. `docs/ubiquitous-language.md`
2. `docs/glossary.md`
3. Domain vocabulary section in `CONTEXT.md` (or similarly named project context doc at repo root)
4. Any other `**/glossary.md` or `**/ubiquitous-language.md` at repo root level

If nothing exists, create **`docs/ubiquitous-language.md`** using [references/artifact-template.md](references/artifact-template.md).

Never maintain two glossary files. Merge into the discovered canonical path.

## Process

Copy this checklist when applying the skill:

```
Ubiquitous language run:
- [ ] Discover — located or chose glossary path; noted scope if any
- [ ] Mine — gathered evidence from code (see surfaces below)
- [ ] Draft — clustered synonyms; picked canonical terms
- [ ] Reconcile — drift, deprecated, needs-decision
- [ ] Report — inventory + proposed changes (no file write yet)
- [ ] Write — only after user replies apply (or said apply in same message)
```

### 1. Discover

Read the current glossary file if it exists. Parse existing `###` term headings and fields (definition, aliases, evidence, status).

### 2. Mine (code-first)

Gather candidate domain terms from **production** code, prioritizing:

| Surface | Examples |
| -------- | -------- |
| Domain model | entities, value objects, enums, domain services |
| Application layer | commands, queries, handlers (names, not generic suffixes) |
| Public API | routes, request/response DTO names, OpenAPI tags |
| Persistence | EF configurations, table/column names mapped to domain |

**Exclude** unless the user asked for a wide pass:

- Test-only types that do not mirror production vocabulary
- Generated code, vendor packages, build output
- Generic infrastructure words alone (`Repository`, `Handler`, `Controller`, `Service`, `Dto`)

**Inclusion bar (default):** include a term when it appears as a type or stable name in **at least two** evidence locations, or as a **public type name** in a domain/application project. For “wide” bootstrap, the user must say so in the message.

Record evidence as `path` or `path:Symbol` bullets per term.

Infer definitions from XML docs, comments, and usage; prefix inferred one-liners with `(auto)`.

### 3. Draft

Cluster synonyms (e.g. `Purchase` vs `Order`). Pick one **canonical** term per concept for the glossary heading.

### 4. Reconcile

| Situation | Action |
| --------- | ------ |
| Term in code, not in glossary | Add entry with definition `(auto)` and evidence |
| Glossary term, no longer in code | Keep entry; set `Status: deprecated`. Add **Replaced by:** when a clear successor exists; else note `no longer found in code (sync YYYY-MM-DD)` |
| Glossary says X, code dominantly says Y (same concept) | Update canonical heading to Y (or merge aliases) when one name dominates types, API, and persistence |
| Both X and Y used in different layers | Canonical = dominant; list the other under **Aliases** |
| True ambiguity | Set `Status: needs-decision`; do not change canonical term or definition until the user rules in chat |

**Definitions on update:** preserve existing definition text unless it is empty or entirely `(auto)`. Refresh `(auto)` definitions when evidence clearly changed.

Sort all `###` terms **A–Z** (case-insensitive) before write.

### 5. Report (before write)

Post a structured summary:

- **Glossary path** (existing or to be created)
- **Added** — term list
- **Updated** — term list (drift, aliases, evidence, auto-definition refresh)
- **Deprecated** — term list
- **Unresolved** — `needs-decision` items with one-line rationale

End with: **Reply `apply` to write the glossary file.**

If the user already said to apply in the same message, skip waiting and go to Write.

### 6. Write

Update the single canonical markdown file. Use the entry shape in [references/artifact-template.md](references/artifact-template.md). Set intro **Last synced:** to today’s date. No YAML front matter on the glossary file.

## Drift and Authority

Code is evidence. The glossary records the vocabulary the repo actually uses. When drift is resolved, prefer the name that dominates domain types and public contracts. Document aliases instead of hiding alternate names.

## Side Effects

- **Allowed:** edit the glossary markdown only.
- **Not allowed:** rename types, routes, database objects, or UI copy unless the user asks for a separate task.

## Artifact Format

See [references/artifact-template.md](references/artifact-template.md) for the required heading structure and fields.
