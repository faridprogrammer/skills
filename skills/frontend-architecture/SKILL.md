---
name: frontend-architecture
description: Use when building or reviewing a React 18 + TypeScript frontend with React Query. Covers feature folders, UI/application/domain/infrastructure layers, data fetching, and a minimal dependency budget.
---

# Frontend Architecture: React 18 + TypeScript + React Query

You are operating as a senior frontend engineer building a single-page application with React 18, TypeScript (strict), and Vite.

## When This Skill Applies

**Use this skill when:**
- Starting a new frontend or adding a feature
- Structuring features, folders, or data-fetching code
- Adding React Query queries/mutations or API clients
- Defining TypeScript domain types, DTOs, or mappers
- Reviewing layering violations (e.g. `fetch` in components)

## Stack (Locked)

- **React 18+**, **TypeScript (strict)**, **Vite**
- **React Query (`@tanstack/react-query`)** — the only server-state solution
- **React Router** for routing
- UI state: built-in `useState`/`useReducer`/context only

## Dependency Budget (Keep Small)

Allowed by default:

- `react`, `react-dom`, `react-router`
- `@tanstack/react-query`
- `typescript`, `vite`, plus dev tooling (linter, formatter, test runner, testing library)

Not allowed by default (hand-roll or use stdlib):

- State: no Zustand/Redux/MobX — context + hooks suffice
- HTTP: no axios — thin `fetch` wrapper (see below)
- Forms: controlled inputs + small helpers, no Formik/React Hook Form unless a form is genuinely complex
- Dates, utils: `Intl`, native `Date`, and small local helpers — no date-fns/lodash unless justified in a comment

Any exception must be justified in code review: what stdlib/React Query solution failed and why.

## Layer Map

```
components/pages → hooks/services → domain ← infrastructure/api
   (JSX only)      (orchestration)   (pure TS)   (fetch + mappers)
```

| Layer (folder) | Contains | Must NOT contain |
|----------------|----------|------------------|
| **Presentation** (`components/`, `pages/`) | JSX, UI state, event handlers calling hooks | `fetch`, query keys, DTO shapes |
| **Application** (`hooks/`, `services/`) | Custom hooks, React Query `useQuery`/`useMutation` wrappers, orchestration | JSX, raw `fetch` |
| **Domain** (`types/`, `model/`) | TS types, value objects, pure validation/business functions | Imports from other layers, `fetch`, React Query |
| **Infrastructure** (`api/`) | `fetch` wrapper, endpoint functions, DTO→domain mappers, storage, token handling | JSX, React Query hooks |

Dependencies point **inward** toward `domain`: `domain` imports nothing from the feature.

See: [references/feature-structure-react.md](references/feature-structure-react.md)

## Data-Flow Rules

1. Components never call `fetch` — they call custom hooks.
2. Hooks never call `fetch` directly — they call `api/` functions via React Query.
3. Server state lives only in React Query caches (keyed per feature: `['orders', id]`).
4. DTOs are mapped to domain types at the `api/` boundary; components only see domain types.
5. Mutations invalidate their queries (`queryClient.invalidateQueries`) — no manual cache patching except optimistic updates with rollback.

See: [references/data-fetching.md](references/data-fetching.md)

## Checklists

**Before coding:** Which feature folder? Query or mutation? What domain types? Which query keys to invalidate?

**While coding:** `fetch` only in `api/`? Components JSX-only? Domain free of React/fetch imports? No new third-party dep without justification?

**After coding:** `tsc --noEmit` passes? Loading/error/empty states handled? Queries invalidated after mutations? No unused dependencies added?
