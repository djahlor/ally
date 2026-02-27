# Ally

Your AI that actually knows you.

Ally is a personal AI system built on [Claude Code](https://docs.anthropic.com/en/docs/claude-code). It connects to your email, calendar, Slack, and messaging, learns your voice, tracks your relationships, and keeps you focused on what you said matters most.

One install. Modular. Gets better the more you use it.

---

## What It Does

**Communicate** — Triage your inbox across every channel. Get draft responses in your voice. Every correction teaches it something new.

**Prepare** — Morning briefings, meeting prep, market signals. Walk into every meeting with full context, without doing the prep yourself.

**Remember** — Contact files that build themselves. Staleness alerts when important relationships go quiet. You never forget to follow up.

**Focus** — Your goals are the filter. Every triage decision, meeting recommendation, and task priority runs through what you said matters. Ally pushes back when your time drifts.

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/djahlor/ally.git
cd ally

# 2. Install (interactive setup, ~2 minutes)
chmod +x install.sh
./install.sh

# 3. Try it
claude
# Then type: /gm
```

You'll need [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed, plus Gmail and Google Calendar MCP servers at minimum.

---

## Architecture

Modular by design. Your core config stays lean. Domain-specific config lives in separate files, auto-loaded via `@import`.

```
~/.claude/
├── CLAUDE.md                <- Core config (~130 lines)
├── voice/
│   └── style.md             <- Your writing voice + examples
├── systems/
│   ├── triage.md            <- Inbox triage rules
│   ├── responsibilities.md  <- Always-on behaviors
│   ├── mcp-routing.md       <- MCP servers + routing
│   ├── confidentiality.md   <- Sensitive topic rules
│   └── team-os.md           <- Team shared folder (optional)
├── commands/
│   ├── gm.md                <- Morning briefing
│   ├── triage.md            <- Inbox triage
│   ├── my-tasks.md          <- Task management
│   ├── enrich.md            <- Contact enrichment
│   └── week-plan.md         <- Weekly planning
├── agents/                  <- Parallel sub-agents
├── contacts/                <- Personal CRM
├── goals.yaml               <- Your objectives
├── my-tasks.yaml            <- Task tracking
└── decisions.yaml           <- Decision log
```

Edit any file independently. Add new modules without touching the core.

---

## Commands

| Command | What it does |
|---------|-------------|
| `/gm` | Morning briefing. 7 agents run in parallel: calendar, tasks, inbox, momentum, relationships, research, podcasts. |
| `/triage` | Scan all connected channels. Classify by urgency. Draft responses in your voice. Learn from every edit. |
| `/my-tasks` | Tasks with execution, not just tracking. Ally drafts the email, does the research, preps the document. |
| `/enrich` | Scan channels for relationship updates. Flag stale contacts. Suggest touchpoints. |
| `/week-plan` | Deep weekly planning. Goals, tasks, calendar, relationships, market signals. |

---

## How It Learns

Every interaction makes the system better:

- **Voice learning** — Edit a draft, the before/after gets logged. Future drafts incorporate the pattern.
- **Acceptance tracking** — Tracks how often drafts go through unchanged, by channel and contact.
- **Decision memory** — Prevents re-debating settled questions. Flags when conditions change.
- **Relationship context** — Every interaction enriches contact files automatically.

The longer you use it, the better it gets.

---

## Customization

The #1 quality lever is `voice/style.md`. Paste 3-5 real emails you've sent. The examples matter more than any description you could write.

After that:
1. Set goals in `goals.yaml`
2. Define your Tier 1 people in `systems/triage.md`
3. Connect MCP servers in `systems/mcp-routing.md`
4. Add contacts to `contacts/`

---

## MCP Servers

More servers = more capability. Start with the essentials, add over time.

| Server | Required? | What It Enables |
|--------|-----------|-----------------|
| Gmail | **Yes** | Email triage, drafting, sending |
| Google Calendar | **Yes** | Scheduling, availability, meeting prep |
| Slack | Recommended | Slack triage, channel monitoring |
| WhatsApp (Beeper) | Optional | WhatsApp message triage |
| Granola | Optional | Meeting notes context |
| Notion | Optional | Docs, knowledge base |
| Exa | Optional | Web search, research |

---

## Team Mode

If your team shares a Google Drive folder, the installer can connect it:

- Shared goals, tasks, and decisions
- Async inbox between teammates
- Two-layer architecture: personal + company tasks
- Write-protected governance

Enter your shared folder path during `./install.sh`.

---

## Philosophy

1. **Push, don't just serve.** Ally challenges priorities, says "no" to low-leverage work, and keeps you honest.
2. **Clarity over comprehensiveness.** Fewer priorities. Explicit tradeoffs. Fast decisions.
3. **Systems compound.** Every correction makes it smarter. Every interaction enriches context.
4. **Ship, don't polish.** Drafts should be send-ready. Bias toward closing loops.
5. **Files over databases.** Markdown and YAML. Readable, portable, no lock-in. Your data stays yours.

---

## Community

- [Contributing Guide](CONTRIBUTING.md) — How to submit changes
- [Code of Conduct](CODE_OF_CONDUCT.md) — Be decent
- [Security Policy](SECURITY.md) — Reporting vulnerabilities
- [Changelog](CHANGELOG.md) — What's new
- [Architecture](docs/architecture.md) — How it works under the hood
- [Setup Guide](docs/setup-guide.md) — Full installation walkthrough
- [Customization](docs/customization.md) — Make it yours
- [Examples](docs/examples.md) — Output samples for every command

**Found a bug?** [Open an issue](https://github.com/djahlor/ally/issues/new/choose).

---

Built by [Djahlor Andrews](https://linkedin.com/in/djahlor).

MIT License. See [LICENSE](LICENSE) for details.
