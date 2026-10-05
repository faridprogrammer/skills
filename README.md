# skills

My personal library of agent skills collected from the internet and various sources.

Each skill lives in `skills/<skill-name>/` as a `SKILL.md` file (plus supporting resources) following the [Agent Skills](https://agentskills.io) format, so it can be loaded by coding agents / AI assistants.

## Skills

| Skill | What it's for |
| ----- | ------------- |
| `code-review` | Review changes since a commit/branch/tag along two axes: Standards and Spec. |
| `codebase-design` | Shared vocabulary for designing deep modules and testable interfaces. |
| `deep-research` | Systematic academic literature reviews in 6 phases with structured notes and final report. |
| `diagnosing-bugs` | Diagnosis loop for hard bugs and performance regressions. |
| `grill-me` | Relentless interview to sharpen a plan or design. |
| `grill-with-docs` | Relentless interview that also produces ADRs and a glossary. |
| `grilling` | Stress-test thinking on a plan, decision, or idea. |
| `implement` | Implement a piece of work based on a spec or set of tickets. |
| `implement-spec` | Implement a specification in code. |
| `literature-search` | Search academic literature via Semantic Scholar, arXiv, and OpenAlex APIs. |
| `research` | Investigate a question against primary sources and capture findings as Markdown. |
| `solid` | Write senior-quality code via SOLID principles, TDD, and clean code practices. |
| `tdd` | Test-driven development: red-green-refactor for features and bug fixes. |
| `teach` | Teach a new skill or concept within the workspace. |
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
