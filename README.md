# skills

My personal library of agent skills collected from the internet and various sources.

Each skill lives in `skills/<skill-name>/` as a `SKILL.md` file (plus supporting resources) following the [Agent Skills](https://agentskills.io) format, so it can be loaded by coding agents / AI assistants.

## Install

Installs all skills to `~/.agents/skills/` (`%USERPROFILE%\.agents\skills` on Windows). The destination is cleaned first, then replaced with the contents of `skills/`.

Windows (PowerShell):

```powershell
./install.ps1
```

macOS / Linux:

```bash
./install.sh
# or: bash install.sh
```

Dry run (preview without changing anything):

```powershell
./install.ps1 -DryRun
./install.sh --dry-run
```

## Skills

| Skill | What it's for |
| ----- | ------------- |
| `code-review` | Review changes since a commit/branch/tag along two axes: Standards and Spec. |
| `doubt-driven-development` | Adversarially review non-trivial decisions from fresh context before proceeding. |
| `backend-architecture` | Layered monolith backend in C# (.NET 8+, EF Core, MediatR). |
| `frontend-architecture` | React 18 + TypeScript frontend with React Query, minimal dependencies. |
| `deep-research` | Systematic academic literature reviews in 6 phases with structured notes and final report. |
| `diagnosing-bugs` | Diagnosis loop for hard bugs and performance regressions. |
| `grill-me` | Relentless interview to sharpen a plan or design. |
| `grill-with-docs` | Relentless interview that also produces ADRs and a glossary. |
| `grilling` | Stress-test thinking on a plan, decision, or idea. |
| `implement` | Implement a piece of work based on a spec or set of tickets. |
| `implement-spec` | Implement a specification in code. |
| `literature-search` | Search academic literature via Semantic Scholar, arXiv, and OpenAlex APIs. |
| `research` | Investigate a question against primary sources and capture findings as Markdown. |
| `oop-fundamentals` | Core OOP: encapsulation, value objects, responsibilities, design patterns. |
| `solid-principles` | SOLID principles, decoupling, dependency direction, and architecture. |
| `tdd` | Test-driven development: red-green-refactor for features and bug fixes. |
| `triage` | Triage issues and external PRs into agent-ready briefs. |

## Usage

1. Browse `skills/<skill-name>/SKILL.md` for a skill's instructions.
2. Copy the skill folder you want into your agent's skills directory (e.g. `~/.claude/skills/`, `~/.codex/skills/`, `.agents/skills/`), or point your agent at this repo.
3. Invoke it as described in its `SKILL.md` frontmatter.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`).
2. Keep the instructions focused and self-contained; add scripts/resources alongside if needed.
3. Update the table above.

## Sources

Collected from various public sources across the internet. Individual skills may carry their own attribution or license notes — check the skill folder when reusing.
