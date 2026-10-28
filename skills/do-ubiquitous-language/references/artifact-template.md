# Ubiquitous language artifact template

Copy this structure when bootstrapping `docs/ubiquitous-language.md` or when adding new sections to an existing glossary. Plain markdown only — no YAML front matter.

```markdown
# Ubiquitous language

Short purpose statement for this repository’s domain vocabulary.

**Last synced:** YYYY-MM-DD

**Scope:** (optional) e.g. whole repo, or `services/orders/` if a scoped run

---

### CanonicalTerm

**Status:** (optional) `deprecated` | `needs-decision`

One short definition. Use `(auto)` at the start when the text was inferred from code.

**Replaced by:** OtherTerm (only when deprecated and successor is clear)

**Aliases:** OtherName, LegacyName

**Evidence:**

- src/Project.Domain/Orders/Order.cs:Order
- src/Project.Api/Controllers/OrdersController.cs
```

## Field rules

| Field | Required | Notes |
| ----- | -------- | ----- |
| `###` heading | yes | Canonical term; sort all terms A–Z |
| Definition paragraph | yes | Immediately under heading (after optional Status lines) |
| **Status** | no | Only `deprecated` or `needs-decision` |
| **Replaced by** | no | With deprecated entries when known |
| **Aliases** | no | Comma-separated or omit if none |
| **Evidence** | yes for new terms; update when drift fixed | Bullet list of `path` or `path:Symbol` |

Omit empty optional sections entirely. Do not use tables inside the glossary unless the repo already used them; prefer the shape above for consistency.
