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
| `csharp-development` | General C# on .NET 8+: types, nullability, async, exceptions, LINQ, and BCL patterns. |
| `csharp-modern` | C# 14 and .NET 10 language and BCL features for everyday call sites. |
| `csharp-readability` | Naming, layout, control flow, and clarity patterns for readable C#. |
| `develop-dotnet-cli-tools` | Develop production-grade C# command-line tools on .NET 8 or newer. |
| `doubt-driven-development` | Adversarially review non-trivial decisions from fresh context before proceeding. |
| `backend-architecture` | Layered monolith backend in C# (.NET 8+, EF Core, MediatR). |
| `frontend-architecture` | React 18 + TypeScript frontend with React Query, minimal dependencies. |
| `diagnosing-bugs` | Diagnosis loop for hard bugs and performance regressions. |
| `grill-me` | Relentless interview to sharpen a plan or design. |
| `grilling` | Stress-test thinking on a plan, decision, or idea. |
| `ubiquitous-language` | Code-first flat domain glossary from the codebase; sync and drift resolution in markdown. |
| `research` | Tiered open-access research (Quick / Standard / Deep) with academic APIs, docs, web, and OSS; delivers `publish/report.md` reading bundle. |
| `oop-fundamentals` | Core OOP: encapsulation, value objects, responsibilities, design patterns. |
| `solid-principles` | SOLID principles, decoupling, dependency direction, and architecture. |
| `tdd` | Test-driven development: red-green-refactor for features and bug fixes. |
| `triage` | Triage issues and external PRs into agent-ready briefs. |
| `init-disposable-console-app` | Initialize a disposable C# console app in an empty visible directory with CLI commands, readable logging, configuration, and validation. |

## Usage

1. Browse `skills/<skill-name>/SKILL.md` for a skill's instructions.
2. Copy the skill folder you want into your agent's skills directory (e.g. `~/.claude/skills/`, `~/.codex/skills/`, `.agents/skills/`), or point your agent at this repo.
3. Invoke it as described in its `SKILL.md` frontmatter.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`).
2. Keep the instructions focused and self-contained; add scripts/resources alongside if needed.
3. Update the **Skills** and **Skill sources** tables below.

## Skill sources

Where each skill was originally copied from. Skills marked **Original** were authored in this collection. Upstream licenses apply when you redistribute derived skills — check the source repo.

| Skill | Origin |
| ----- | ------ |
| `code-review` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/engineering/code-review`) |
| `csharp-development` | Original (authored in this collection) |
| `csharp-modern` | Original (authored in this collection) |
| `csharp-readability` | Original (authored in this collection) |
| `develop-dotnet-cli-tools` | Original (authored in this collection) |
| `doubt-driven-development` | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (`skills/doubt-driven-development`) |
| `backend-architecture` | Original (authored in this collection) |
| `frontend-architecture` | Original (authored in this collection) |
| `diagnosing-bugs` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/engineering/diagnosing-bugs`) |
| `grill-me` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/productivity/grill-me`) |
| `grilling` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/productivity/grilling`) |
| `ubiquitous-language` | Original (authored in this collection) |
| `research` | [lingzhi227/agent-research-skills](https://github.com/lingzhi227/agent-research-skills) (adapted from `deep-research` and `literature-search`; consolidated in this repo) |
| `oop-fundamentals` | Original — split from the earlier `solid` skill in this repo; some `references/` files credit [Academind](https://academind.com) |
| `solid-principles` | Same as `oop-fundamentals` |
| `tdd` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/engineering/tdd`) |
| `triage` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/engineering/triage`) |
| `init-disposable-console-app` | Original (authored in this collection) |

Some skills include extra attribution in their folders (for example Academind notes in `clean-code.md`). Check those files when reusing reference material.
