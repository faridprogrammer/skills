---
name: develop-dotnet-cli-tools
description: Use when creating, extending, debugging, refactoring, validating, or publishing C# command-line tools on .NET 8 or newer.
---

# Develop .NET CLI tools

## Core principle

Build the smallest production-grade CLI that meets the requirements. Preserve an existing tool's architecture. Add hosting and infrastructure only when the tool needs them.

**REQUIRED SUB-SKILLS:** Use `csharp-development` for C# implementation. Use `csharp-readability` when structure or naming changes. Use `backend-architecture` only when the tool already uses or explicitly needs layered application and infrastructure projects.

Do not use this skill for a short-lived utility. Use `init-disposable-console-app` when the user explicitly wants a disposable console application.

## Preflight

1. Inspect the repository, project files, command registration, configuration, documentation, Git status, and uncommitted changes.
2. Confirm that `dotnet` is available. Run `dotnet --list-sdks`.
3. Keep an existing target framework and command-line library unless the user requests a migration.
4. For a new tool, use the requested .NET 8+ framework. If none is requested, select the newest supported framework that the installed SDK can target.
5. Derive names from the requested tool name or current directory. Sanitize invalid names. Ask only when no safe name can be derived.
6. List planned paths before initialization. Detect collisions. Never use `--force`, overwrite files silently, or discard user changes.

## Select the architecture

Use the **simple tier** for one or a few small commands with no shared services:

- One application project.
- `System.CommandLine` for a new tool.
- `Program.cs` as the composition root.
- Focused command classes only when multiple commands need them.
- Direct use of framework APIs.

Use the **hosted tier** when the tool needs shared services, managed configuration or logging, or multiple substantial commands:

- Generic Host, dependency injection, Microsoft configuration, and Microsoft logging.
- Thin command handlers and focused injected services.
- Configuration objects with startup validation.

Do not add Generic Host, DI, configuration, logging, central package management, or extra model layers to a small tool without a concrete need.

For a new tool, create:

```text
<ToolName>.sln
src/<ProjectName>/<ProjectName>.csproj
README.md
```

Do not create a sample command or test project. Do not create or modify tests unless the user explicitly requests tests. Run relevant existing tests.

## Implementation contract

- Preserve the parser and conventions in existing tools. Use `System.CommandLine` by default only for new tools.
- Keep parsing and orchestration in commands. Put substantial business logic in services.
- Use async I/O end to end. Pass `CancellationToken` through every cancellable operation. Ctrl+C must stop cleanly, print one concise diagnostic, and return `130` without a stack trace. Own and release signal handlers at the process boundary.
- Never read stdin automatically. A command must explicitly support piped input and detect redirected input.
- Write command results only to stdout. Write diagnostics, progress, errors, and logs to stderr. Logs must never corrupt CSV, JSON, or other machine-readable results.
- Define input-size limits and a streaming strategy for unbounded files or streams. When using rich-console libraries, bind diagnostics to stderr and disable ANSI output when redirected.
- Define partial-output and partial-write behavior. Buffer results or use atomic file replacement or database transactions when partial results would be invalid.
- Use `0` for success, `1` for unexpected runtime failure, `2` for parsing or input validation failure, and `130` for cancellation. Add domain exit codes only when documented.
- Validate arguments and configuration at boundaries. Show compact errors and usage guidance.
- Catch exceptions at process or command boundaries. Preserve context in logs. Show stack traces only through an explicit option such as `--verbose`.
- For hosted tools, use this effective configuration precedence: command-line options, prefixed environment variables, `appsettings.json`, then defaults. Add user-secrets only for local development when needed.
- Never commit secrets. Prefer environment variables or secure stores. Do not put secrets in command-line arguments, URLs, stdout, or logs.
- Add justified packages without separate approval when repository policy permits it. Select stable versions compatible with the target framework, confirm the package API in use, and keep resolved versions explicit. Do not add an ORM, mapper, mediator, alternate logger, or resilience library without a requirement.
- For network input, define applicable timeouts, response limits, content checks, redirect policy, authentication, and failure mapping. Add retries only for safe operations with an explicit policy.
- Keep tools cross-platform unless the requirement is platform-specific. Use .NET path APIs and avoid shell-specific runtime behavior.
- Default to framework-dependent publishing. Add self-contained, single-file, trimming, Native AOT, or `PackAsTool` only when requested. Verify each selected mode. For installed tools, use a stable documented configuration-file location instead of assuming the working directory.
- Add human or JSON result formats only when required. Result JSON and structured JSON logs are separate concerns.

## Workflow

For a new tool:

1. Complete preflight and select the architecture tier.
2. Create one `.sln` and one application project under `src/`.
3. Add commands and only the infrastructure that their requirements need.
4. Add a concise README.
5. Validate the process contract.

For an existing tool:

1. Trace the current command path and conventions.
2. Make the smallest focused change.
3. Preserve unrelated files, dependencies, output contracts, and uncommitted work.
4. Update documentation for changed user-visible behavior.
5. Validate affected and existing behavior.

## Concrete example

For one command that reads a JSON file and prints a summary, use the simple tier: one project, `System.CommandLine`, `System.Text.Json`, async file I/O, cancellation, and strict stdout/stderr separation. Do not add Generic Host, DI, `appsettings.json`, logging packages, model layers, or a test project unless another requirement needs them.

## Validation

Run the applicable checks and record commands, output, and exit codes:

```text
dotnet restore
dotnet build -c Release
dotnet run --project <project> -- --help
dotnet run --project <project> -- <affected-command> --help
dotnet run --project <project> -- <representative-success>
dotnet run --project <project> -- <known-invalid-input>
```

Also verify stdout and stderr separately. Exercise cancellation when practical. Run existing tests when relevant. Run `dotnet publish` or `dotnet pack` when publishing changed. Do not claim success when a required check did not run; state the limitation.

## README contract

Document installation, usage, root and command help, configuration precedence, environment-variable prefix, output formats, exit codes, cancellation, publishing, and copy-paste examples. Include only sections that apply.

## Common mistakes

| Mistake | Correction |
| --- | --- |
| Applying the hosted tier to every tool | Start with the simple tier and promote only for a concrete need. |
| Replacing an existing parser | Preserve it unless migration is requested. |
| Mixing status text with result output | Keep results on stdout and diagnostics on stderr. |
| Treating JSON logs as JSON results | Define and validate separate contracts. |
| Adding tests despite the request | Add or modify tests only when explicitly requested; run existing tests. |
| Publishing with trimming or AOT by assumption | Enable it only on request and verify compatibility. |
| Hiding failed validation | Report the failed command, output, and exit code. |

Finish with the project path, target framework, architecture tier, changed structure, package additions, validation results, and next command.
