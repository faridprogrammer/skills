# skills

My personal library of agent skills collected from the internet and various sources.

Each skill lives in `skills/<skill-name>/` as a `SKILL.md` file (plus supporting resources) following the [Agent Skills](https://agentskills.io) format, so it can be loaded by coding agents / AI assistants.

## Skill types

Skill folder names show what kind of skill it is:

| Prefix | Type | When to use |
| ------ | ---- | ----------- |
| `do-` | **Job skill** | Invoke when you want a workflow that runs a task or produces an output (review a branch, triage an issue, run research, scaffold a CLI app). |
| `guide-` | **Reference guide** | Load while you work; the agent applies conventions and checklists (C# style, layering, SOLID, TDD). Usually combined with a job skill or normal coding, not invoked as a standalone session. |

The `name` in each skill's YAML frontmatter matches its folder name.

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

## Job skills (`do-`)

| Skill | What it's for |
| ----- | ------------- |
| `do-code-review` | Review changes since a commit/branch/tag along two axes: Standards and Spec. |
| `do-develop-dotnet-cli-tools` | Develop production-grade C# command-line tools on .NET 8 or newer. |
| `do-diagnosing-bugs` | Diagnosis loop for hard bugs and performance regressions. |
| `do-doubt-driven-development` | Adversarially review non-trivial decisions from fresh context before proceeding. |
| `do-grill-me` | Shortcut entry point that delegates to `do-grilling`. |
| `do-grilling` | Stress-test thinking on a plan, decision, or idea. |
| `do-init-disposable-console-app` | Initialize a disposable C# console app in an empty visible directory with CLI commands, readable logging, configuration, and validation. |
| `do-research` | Tiered open-access research (Quick / Standard / Deep) with academic APIs, docs, web, and OSS; delivers `publish/report.md` reading bundle. |
| `do-triage` | Triage issues and external PRs into agent-ready briefs. |
| `do-ubiquitous-language` | Code-first flat domain glossary from the codebase; sync and drift resolution in markdown. |

## Reference guides (`guide-`)

| Skill | What it's for |
| ----- | ------------- |
| `guide-backend-architecture` | Layered monolith backend in C# (.NET 8+, EF Core, MediatR). |
| `guide-csharp-development` | General C# on .NET 8+: types, nullability, async, exceptions, LINQ, and BCL patterns. |
| `guide-csharp-modern` | C# 14 and .NET 10 language and BCL features for everyday call sites. |
| `guide-csharp-readability` | Naming, layout, control flow, and clarity patterns for readable C#. |
| `guide-frontend-architecture` | React 18 + TypeScript frontend with React Query, minimal dependencies. |
| `guide-oop-fundamentals` | Core OOP: encapsulation, value objects, responsibilities, design patterns. |
| `guide-solid-principles` | SOLID principles, decoupling, dependency direction, and architecture. |
| `guide-tdd` | Test-driven development: red-green-refactor for features and bug fixes. |

## Usage

1. Browse `skills/<skill-name>/SKILL.md` for a skill's instructions.
2. Copy the skill folder you want into your agent's skills directory (e.g. `~/.claude/skills/`, `~/.codex/skills/`, `.agents/skills/`), or point your agent at this repo.
3. For a **job skill**, invoke it as described in its `SKILL.md` frontmatter (or ask the agent to run that workflow).
4. For a **reference guide**, mention the topic while you work, or rely on your agent's skill matching; guides shape how code is written and reviewed rather than starting a fixed pipeline.

Example: "Review this PR" → `do-code-review`. "Build the API handler" → agent may use `guide-backend-architecture` and `guide-csharp-development` alongside normal edits.

## Adding a new skill

1. Choose a prefix: `do-` for a task workflow, `guide-` for reference knowledge.
2. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name` must match the folder, plus `description`).
3. Keep the instructions focused and self-contained; add scripts/resources alongside if needed.
4. Update the job or guide table and **Skill sources** below.

## Skill sources

Where each skill was originally copied from. Skills marked **Original** were authored in this collection. Upstream licenses apply when you redistribute derived skills — check the source repo.

### Job skills

| Skill | Origin |
| ----- | ------ |
| `do-code-review` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/engineering/code-review`) |
| `do-develop-dotnet-cli-tools` | Original (authored in this collection) |
| `do-diagnosing-bugs` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/engineering/diagnosing-bugs`) |
| `do-doubt-driven-development` | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (`skills/doubt-driven-development`) |
| `do-grill-me` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/productivity/grill-me`) |
| `do-grilling` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/productivity/grilling`) |
| `do-init-disposable-console-app` | Original (authored in this collection) |
| `do-research` | [lingzhi227/agent-research-skills](https://github.com/lingzhi227/agent-research-skills) (adapted from `deep-research` and `literature-search`; consolidated in this repo) |
| `do-triage` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/engineering/triage`) |
| `do-ubiquitous-language` | Original (authored in this collection) |

### Reference guides

| Skill | Origin |
| ----- | ------ |
| `guide-backend-architecture` | Original (authored in this collection) |
| `guide-csharp-development` | Original (authored in this collection) |
| `guide-csharp-modern` | Original (authored in this collection) |
| `guide-csharp-readability` | Original (authored in this collection) |
| `guide-frontend-architecture` | Original (authored in this collection) |
| `guide-oop-fundamentals` | Original — split from the earlier `solid` skill in this repo; some `references/` files credit [Academind](https://academind.com) |
| `guide-solid-principles` | Same as `guide-oop-fundamentals` |
| `guide-tdd` | [mattpocock/skills](https://github.com/mattpocock/skills) (`skills/engineering/tdd`) |

Some skills include extra attribution in their folders (for example Academind notes in `clean-code.md`). Check those files when reusing reference material.
