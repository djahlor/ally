# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [3.1] - 2026-02-25

### Added

- `--dry-run`, `--force`, and `--verbose` flags for install.sh
- Pre-flight checks: OS detection, Claude Code CLI verification
- Existing installation detection with update/reinstall/cancel options
- Automatic backup of existing config on reinstall
- Random tagline banner on install
- `docs/examples.md` — output examples for all commands
- `docs/architecture.md` — system mechanics and data flow
- `SECURITY.md` — security policy and vulnerability reporting
- `CONTRIBUTING.md` — contribution guidelines
- `CODE_OF_CONDUCT.md` — Contributor Covenant 2.1
- `CHANGELOG.md` — this file
- `.github/ISSUE_TEMPLATE/bug_report.md` — bug report template
- `.github/PULL_REQUEST_TEMPLATE.md` — PR checklist

### Changed

- README.md: Added community section with links to all new docs
- `.gitignore`: Added secrets, backup directories, and build artifacts
- `docs/setup-guide.md`: Cross-linked to architecture doc
- `docs/customization.md`: Added "Creating Custom Agents" section

### Fixed

- Install script now handles paths with spaces correctly

## [3.0] - 2026-02-16

### Added

- Modular `@import` architecture: CLAUDE.md imports voice/, systems/ files
- 7 agents: calendar-scanner, task-scanner, inbox-scanner, momentum-analyzer, relationship-monitor, research-agent, email-drafter
- 5 commands: /gm, /triage, /my-tasks, /enrich, /week-plan
- Voice learning loop: triage-stats.yaml + triage-learnings.yaml
- Decision log with revisit-when conditions
- Contact enrichment with tier-based decay thresholds
- Team mode: shared folder integration via Google Drive
- Confidentiality checks for sensitive topics
- Multi-account email routing

### Changed

- Config split from single CLAUDE.md into modular files
- Commands redesigned with parallel agent support

## [1.0] - 2026-01-15

### Added

- Initial release: CLAUDE.md configuration template

[unreleased]: https://github.com/djahlor/ally/compare/v3.1...HEAD
[3.1]: https://github.com/djahlor/ally/compare/v3.0...v3.1
[3.0]: https://github.com/djahlor/ally/compare/v1.0...v3.0
[1.0]: https://github.com/djahlor/ally/releases/tag/v1.0
