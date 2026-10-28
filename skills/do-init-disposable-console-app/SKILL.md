---
name: do-init-disposable-console-app
description: Initialize a disposable C# console application in an empty visible directory with System.CommandLine, hosting, configuration, readable logging, help, and validation.
---

# Initialize a disposable console app

Use this skill only when the user explicitly asks to initialize a disposable C# console application. The generated application is intended for short-lived work and should stay small, inspectable, and easy to delete.

The skill runs in the current directory. Do not create a child directory and do not mutate the directory until all preflight checks pass.

## Interface

Support these skill options when the user supplies them:

```text
--framework <TFM>
--name <ProjectName>
--non-interactive
--skip-validation
--help
```

In interactive use, ask only for a framework or project name that cannot be derived safely. In noninteractive use, derive the project name from the current directory and choose the newest supported installed target framework unless an option overrides it. These options belong to the skill invocation; the generated application's `--help` and `--log-format` options belong to the generated app.

## Preflight

1. Confirm that `dotnet` is available. Use the current environment's shell and file tools; no PowerShell-specific generator is required.
2. Run `dotnet --list-sdks`. Support .NET 8 and newer. Select the highest installed SDK that can target a supported TFM. Reject an explicit framework that is unsupported or unavailable.
3. Inspect the current directory. Ignore hidden files and folders, including `.git` and editor metadata. If any visible entry exists, stop and list those entries. Do not run `dotnet new`. Preserve all hidden entries. Never use `--force`; if `dotnet new` would overwrite a hidden entry, stop and report the collision before changing it.
4. Derive the project name from the current folder name unless `--name` is supplied. Sanitize it to a valid C# identifier/project name: remove invalid characters, preserve word boundaries where possible, prefix a leading digit, and fail with a `--name` instruction if no valid name remains.
5. Read stable package versions, supported framework policy, option names, and exit codes from `config.json` in this skill directory.

## Generation

Run `dotnet new console --name <ProjectName> --framework <TFM>` in the current directory only after the empty-directory check passes. The resulting project must contain one SDK-style `.csproj` and no solution file.

Use direct file-creation tool calls to generate the small set of source files. Do not create a generator script or a large template set. Keep `Program.cs` as the composition root and use one class per command with explicit registration.

The generated project must include:

- `System.CommandLine` with the pinned version from `config.json`.
- Microsoft hosting, configuration, and logging packages with versions matching the selected target framework according to `config.json`.
- Generic host and dependency injection.
- `appsettings.json` loaded through standard .NET configuration.
- Configuration precedence: command-line options, environment variables, `appsettings.json`, then built-in defaults. Wire these sources in that order so higher-priority values override lower-priority values.
- A project-name-derived uppercase environment-variable prefix and standard .NET `__` mapping for nested settings.
- A shared stdin abstraction that commands may opt into; never read stdin automatically.
- Cancellation and Ctrl+C handling with a concise message and cancellation exit code, without a stack trace.
- Global exception handling that logs a concise error and returns the runtime-failure exit code.
- Explicit command registration and async command handlers accepting `CancellationToken`. Use `System.CommandLine` options and positional arguments where commands need parameters.
- Root and command-specific `--help` output, compact validation errors, and usage hints.
- `--log-format compact|json`, defaulting to `compact`. Resolve it from the command line, environment variable, `appsettings.json`, then default; JSON changes logs only.
- Compact logs containing UTC timestamp, three-letter level, short category/source, and message. Keep scopes and event IDs hidden unless useful.
- `appsettings.json` containing logging defaults, category overrides, and a small application section.
- A `datetime` command that writes to standard output (never through `ILogger`) and prints both UTC and machine-local ISO 8601 timestamps with offsets. The command has no options.
- Centralized exit codes: `0` success, `1` unhandled runtime failure, `2` invalid input, and `130` cancellation.

Keep the baseline free of Serilog. Add it only in a future variant that explicitly requests file logging, rolling files, or richer sinks.

## Validation

Unless `--skip-validation` is supplied, run and report each check:

```text
dotnet build
dotnet run -- --help
dotnet run -- datetime --help
dotnet run -- datetime
dotnet run -- <known-invalid-input>
```

The invalid-input check must return exit code `2`; wire `System.CommandLine` parse/validation errors to that code instead of relying on a library default. The successful command must return `0`. Leave generated files in place when validation fails and report the failed command and its output.

## README

Generate a README with copy-paste PowerShell and Bash-compatible commands covering:

- Build and run.
- Root and command help.
- The `datetime` command.
- `compact` and `json` log formats.
- Configuration precedence and environment-variable naming.
- Exit codes.
- Adding a command class, registering it explicitly in `Program.cs`, and injecting a shared service.
- Deleting the disposable project when the work is complete.

Finish by reporting the project path, selected framework, generated structure, validation results, and next commands.
