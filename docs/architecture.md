# Architecture

How the pieces connect.

---

## 1. Data Flow

```
Session Start
    |
    v
CLAUDE.md --@import--> voice/style.md
                        systems/triage.md
                        systems/responsibilities.md
                        systems/mcp-routing.md
                        systems/confidentiality.md
    |
    v
Command (e.g. /gm)
    |
    v
Agents (parallel) --> MCP Servers --> External Services
    |                                  (Gmail, Calendar, Slack, ...)
    v
Cache files
    |
    v
Synthesized output
    |
    v
Learning files (triage-stats, triage-learnings, decisions)
```

Claude Code loads `CLAUDE.md` at session start. The `@import` directives pull in domain config files, giving the model your full context in a single pass. When you run a command, it reads its instruction file from `commands/`, launches agents if available, queries MCP servers for live data, writes intermediate results to cache, and synthesizes everything into a final output. User corrections feed back into learning files that improve future sessions.

---

## 2. Agent Orchestration

The `/gm` command launches up to 7 agents in parallel using the Task tool. Each agent is a markdown file with YAML frontmatter (name, description, model, maxTurns) and focused instructions. Each writes its output to a dedicated cache file.

```
/gm
|-- calendar-scanner    --> cache/gm-calendar.md
|-- task-scanner        --> cache/gm-tasks.md
|-- inbox-scanner       --> cache/gm-inbox.md
|-- momentum-analyzer   --> cache/gm-momentum.md
|-- relationship-monitor --> cache/gm-relationships.md
|-- research-agent      --> cache/gm-signals.md
|-- email-drafter       --> cache/triage-drafts.yaml
         |
         v
    /gm reads all cache files --> morning briefing
```

**How it works:**

1. `/gm` checks for a fresh cached briefing (less than 2 hours old). If found, it displays the cache and skips data fetch.
2. If stale or missing, it checks whether agent files exist in `~/.claude/agents/`.
3. If agents exist, it launches them in parallel via the Task tool. Each agent gets its own MCP server access and writes structured output to its cache file.
4. If agents don't exist, `/gm` runs the same steps sequentially in a single thread. The briefing works either way. Agents are a speed optimization, not a requirement.
5. Once all cache files are populated, `/gm` cross-references the data: linking meeting attendees to emails they sent, tasks to meetings they relate to, goals to calendar alignment.
6. It presents the synthesized briefing.

**Agent anatomy** (frontmatter example):

```yaml
---
name: inbox-scanner
description: Scans email inboxes, Slack DMs, and pending triage drafts.
model: sonnet
maxTurns: 15
---
```

The `model` field lets you run cheaper agents on Sonnet while the orchestrating command runs on whatever model the user selected. `maxTurns` caps how many tool calls the agent can make, preventing runaway loops.

---

## 3. Learning Loop

Three files create a feedback loop that makes the system better over time.

**triage-stats.yaml** tracks acceptance rates:

```yaml
total_drafts: 147
accepted_as_is: 89
edited_then_sent: 41
rejected: 17
by_channel:
  email: { total: 98, accepted: 64 }
  slack: { total: 49, accepted: 25 }
```

**triage-learnings.yaml** captures before/after patterns from user edits:

```yaml
- date: 2026-02-20
  channel: email
  before: "Thank you for reaching out. I'd be happy to discuss this further."
  after: "Thanks for this. Happy to chat."
  pattern: "User prefers 'Thanks' over 'Thank you', shorter openings, casual tone"
```

**decisions.yaml** logs settled questions so they don't get re-debated:

```yaml
- decision: Use Calendly for external scheduling
  date: 2026-01-15
  why: Reduces back-and-forth by 80%
  alternatives: [manual scheduling, Cal.com]
  revisit_when: "Calendly raises pricing or we exceed 50 bookings/month"
```

**Concrete example of the loop in action:**

1. Ally drafts: "Thank you for reaching out. I'd be happy to discuss this at your convenience."
2. User edits to: "Thanks for this. Happy to chat."
3. The before/after gets appended to `triage-learnings.yaml` with the inferred pattern: shorter openings, casual tone, "Thanks" not "Thank you".
4. Next draft already incorporates the pattern. No explicit instruction needed.

The stats file is updated automatically after each draft approval. The learnings file is updated automatically after each user edit. Neither requires permission.

---

## 4. Cache Lifecycle

Agents write to cache. Commands read from cache. TTL determines when data goes stale.

| Agent | Writes | Read by | TTL |
|-------|--------|---------|-----|
| calendar-scanner | `cache/gm-calendar.md` | `/gm`, `/week-plan` | 2 hours |
| task-scanner | `cache/gm-tasks.md` | `/gm`, `/week-plan` | 2 hours |
| inbox-scanner | `cache/gm-inbox.md`, `cache/triage-drafts.yaml` | `/gm`, `/triage` | 30 minutes |
| momentum-analyzer | `cache/gm-momentum.md` | `/gm` | 2 hours |
| relationship-monitor | `cache/gm-relationships.md` | `/gm`, `/enrich` | 2 hours |
| research-agent | `cache/gm-signals.md` | `/gm`, `/week-plan` | 2 hours |

Inbox cache has a shorter TTL because email state changes frequently. Calendar and task data is more stable. When a command finds fresh cache, it skips the data fetch entirely and uses the cached data, making repeat runs near-instant.

Cache files are plain markdown or YAML. They're human-readable and can be inspected directly if something looks wrong.

---

## 5. File Conventions

| Category | Format | Examples |
|----------|--------|---------|
| Config | Markdown | `CLAUDE.md`, `voice/style.md`, `systems/*.md` |
| Data | YAML | `goals.yaml`, `my-tasks.yaml`, `decisions.yaml`, `triage-stats.yaml` |
| Agents | Markdown + YAML frontmatter | `agents/inbox-scanner.md` (frontmatter: name, description, model, maxTurns) |
| Commands | Markdown with sections | `commands/gm.md` (sections: Description, Arguments, Instructions, Guidelines) |
| Cache | Markdown or YAML | `cache/gm-calendar.md`, `cache/triage-drafts.yaml` |
| Logs | JSONL | `logs/actions/YYYY-MM-DD.jsonl` (one JSON object per line) |

**Placeholders:** Template files use `{{PLACEHOLDER_NAME}}` format. The installer (`install.sh`) replaces these with user-provided values during setup. Examples: `{{YOUR_NAME}}`, `{{WORK_EMAIL}}`, `{{TIMEZONE}}`, `{{TIER_1_PEOPLE}}`.

**Why plain files:** Markdown and YAML are readable without tooling, diffable with git, portable across machines, and have zero lock-in. Your entire AI config is a directory of text files you own.
