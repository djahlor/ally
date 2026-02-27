# Team Shared Folder

**Location:** `$TEAM_OS_ROOT` (set in `~/.zshrc`, resolves to a shared Google Drive folder)

If `$TEAM_OS_ROOT` is not set or the directory doesn't exist, warn immediately and do not attempt to guess the path.

This folder is synced via Google Drive and shared with your team. It contains shared context that supplements your personal config.

## At Session Start

After reading CLAUDE.md, resolve `$TEAM_OS_ROOT` and load the shared TEAM.md file (it defines the full loading order, on-demand files, and deprioritized files).

## Two-Layer Architecture

You have TWO sets of tasks, goals, and decisions. Always check both.

| Data | Personal (`~/.claude/`) | Shared (Team-OS/) |
|------|------------------------|--------------------------|
| **Tasks** | `my-tasks.yaml` (personal items) | `tasks/{{YOUR_NAME}}.yaml` (company work) |
| **Goals** | `goals.yaml` (personal priorities) | `goals.yaml` (company OKRs) |
| **Decisions** | `decisions.yaml` (personal infra) | `decisions.yaml` (company decisions) |

When running /gm, /my-tasks, or checking goals: include BOTH personal and shared data.
When adding a task: ask whether it's personal or company work, and write to the correct file.
When recording a decision: personal infra goes local, company decisions go shared.

## Inbox System

The inbox enables async communication between team members through the shared folder.

**Reading:** Check `inbox/{{YOUR_NAME}}/new/` for unread messages. After reading, move files to `inbox/{{YOUR_NAME}}/archive/`.

**Sending:** To message a teammate, create a markdown file in `inbox/[their-name]/new/`:
- Filename: `YYYY-MM-DD-HHMM-from-{{YOUR_NAME}}.md`
- Include: From, Date, Re (subject), then message body

## Write Rules

- Always include `last_modified` and `last_modified_by` fields when editing shared files
- All timestamps use ISO 8601 with timezone offset (e.g., `"2026-02-23T14:00:00+01:00"`)
- Follow conventions in TEAM.md and SYNC-RULES.md
- If a session exceeds 30 minutes, re-read shared files before writing
- If you see "Conflict" in any filename, alert the user (Google Drive sync issue)

## Company Context

TEAM.md in the shared folder is the authoritative source for company info, team roster, and roles.
