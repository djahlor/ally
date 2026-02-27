# Contributing to Ally

Thanks for wanting to contribute. Ally is a Claude Code configuration template, not a framework. Contributions should keep it simple and useful.

## What We Accept

- New commands and agents
- Documentation improvements
- Install script fixes and improvements
- MCP server setup guides
- Bug fixes

## What We Don't Accept

- **Changes to core CLAUDE.md principles.** These are the user's to customize, not ours to dictate.
- **Vendor lock-in as defaults.** Don't require a specific paid MCP server or service.
- **Personal configuration.** The template uses `{{PLACEHOLDER}}` format for a reason. Keep it generic.

## How to Contribute

**Small changes** (typos, doc fixes): Fork and open a PR directly.

**New features** (commands, agents): Open an issue first to discuss the idea. Once aligned, fork, create a branch, and submit a PR.

All PRs should:
- Have a clear description of what changed and why
- Pass `./install.sh --dry-run` without errors
- Not introduce leaked placeholder values in installed output

## Conventions

- Placeholders use `{{PLACEHOLDER_NAME}}` format. `install.sh` replaces them at install time.
- Agent files use YAML frontmatter: `name`, `description`, `model`, `maxTurns`.
- Command files follow this structure: Description, Arguments (optional), Instructions (with phases/steps), Guidelines.
- File naming: lowercase, hyphens (e.g., `week-plan.md`, `inbox-scanner.md`).

## Testing

```bash
./install.sh --dry-run
```

This verifies the installer runs without errors. After running, check that no `{{PLACEHOLDER}}` values leak into the installed files.

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

Short version: be respectful, assume good intent, keep feedback constructive.
