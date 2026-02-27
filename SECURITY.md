# Security Policy

Ally connects to services that contain your most sensitive data: email, calendar, messages, files. This document explains what it touches, what safeguards exist, and how to report issues.

## What Ally Touches

| Service | Access Level | Risk |
|---------|-------------|------|
| Gmail | Read/send email | High (message content, attachments) |
| Google Calendar | Read/write events | Medium (schedule data) |
| Slack | Read/send messages | Medium (team communication) |
| WhatsApp (Beeper) | Read/send messages | Medium (personal messages) |
| Google Drive | Read/write files | Medium (document access) |
| Notion | Read/write pages | Low (knowledge base) |
| Web Search (Exa) | Read-only | Low (public data) |

## Built-in Safeguards

- **Message-sending guardrail.** Ally never sends any message without explicit "Send" or "Y" approval. No exceptions.
- **Confidentiality checks.** Warns before drafting sensitive topics (fundraising, legal, personnel) on public channels. Suggests private alternatives.
- **No credential storage.** Ally is config files only. OAuth tokens live in MCP server directories, not in Ally's file tree.
- **Local-only data.** Contact files, triage learnings, stats, and logs stay on your machine in `~/.claude/`. Nothing is uploaded unless you push it.
- **Audit logging.** Every triage action is logged to `~/.claude/logs/actions/` with timestamp, action type, and outcome.

## Reporting Vulnerabilities

Use [GitHub Private Vulnerability Reporting](../../security/advisories/new) to submit security issues. Do not use email or public issues.

Include in your report:
- Description of the vulnerability
- Steps to reproduce
- Potential impact (what data could be exposed, what actions could be triggered)

We aim to acknowledge reports within 72 hours.

## Scope of Reports

**In scope:**
- Token leakage through config files or logs
- Prompt injection via contact files, email content, or other ingested data
- Information disclosure between accounts (e.g., work context leaking into personal drafts)
- Vulnerabilities in `install.sh` or other scripts
- Unsafe defaults in template files

**Out of scope:**
- MCP server bugs (report to the MCP server maintainer)
- Claude Code vulnerabilities (report to [Anthropic](https://anthropic.com))
- Social engineering that requires physical access to the machine

## Best Practices for Users

- Never commit `~/.claude/` to a public repository. It contains contacts, goals, and system config.
- Review `.gitignore` before pushing any fork or derivative.
- Rotate OAuth credentials periodically, especially after revoking access to a device.
- Only install MCP servers from trusted, reviewed sources.
- Use `./install.sh --dry-run` before running updates to preview changes.
