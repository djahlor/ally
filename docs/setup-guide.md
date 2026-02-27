# Setup Guide

Get Ally running in 15 minutes.

---

## Prerequisites

### 1. Claude Code CLI

Install Claude Code from Anthropic:

```bash
# Install via npm
npm install -g @anthropic-ai/claude-code

# Authenticate
claude auth
```

See [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code) for detailed installation instructions.

### 2. MCP Servers

You need at least Gmail and Google Calendar MCP servers for the core experience. See [mcp-servers.md](mcp-servers.md) for detailed installation instructions for each server.

---

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/djahlor/ally.git
cd ally
```

### Step 2: Run the Installer

```bash
chmod +x install.sh
./install.sh
```

The installer will:
- Ask for your name, role, company, and preferences
- Detect existing installations and offer update/reinstall/cancel
- Optionally connect a Team Shared Folder (Google Drive)
- Create the `~/.claude/` directory structure
- Install modular config files with your information filled in
- Back up your existing config if reinstalling

**Flags:**
```bash
./install.sh --dry-run   # Preview without writing files
./install.sh --force     # Overwrite existing files
./install.sh --verbose   # Detailed output
./install.sh --help      # Show all options
```

### Step 3: Connect MCP Servers

At minimum, connect Gmail and Google Calendar. See [mcp-servers.md](mcp-servers.md) for instructions.

After connecting MCP servers, verify they work:

```bash
claude
# In the Claude Code session:
> Search my email for messages from today
> What's on my calendar today?
```

If both work, your core setup is complete.

### Step 4: Teach It Your Voice

Open `~/.claude/voice/style.md` and replace the placeholder examples with real emails you've sent. This is the single biggest improvement to draft quality.

**What to add:**
1. 3-5 real emails across different contexts (casual, professional, difficult)
2. Your tone description (how you actually write)
3. Your signature(s)

See [customization.md](customization.md) for detailed guidance.

### Step 5: Customize Your System

The installer fills in basic placeholders, but the real power comes from customization. Work through these files:

| File | What to customize | Impact |
|------|------------------|--------|
| `~/.claude/voice/style.md` | Paste real email examples | Highest |
| `~/.claude/systems/triage.md` | Define your Tier 1 people and triggers | High |
| `~/.claude/CLAUDE.md` | Hard constraints, values, personal context | High |
| `~/.claude/systems/mcp-routing.md` | Update as you connect servers | Medium |
| `~/.claude/systems/confidentiality.md` | Sensitive topics for your context | Medium |
| `~/.claude/systems/responsibilities.md` | Energy patterns, scheduling preferences | Medium |

### Step 6: Set Your Goals

Open `~/.claude/goals.yaml` and replace the example objectives with your real ones.

Tips:
- Keep it to 3-5 objectives (fewer is better)
- Each objective should be specific and time-bound
- Include measurable key results
- Set initial progress to 0.0

### Step 7: Try Your First Commands

```bash
claude
```

Then try these commands:

```
/gm                    # Morning briefing
/triage                # Inbox triage
/my-tasks list         # See your tasks
/my-tasks add "Review quarterly metrics" --due 2026-02-15
/enrich stale          # Check relationship health
```

---

## Architecture

Ally uses a modular architecture. Your core config stays lean. Domain-specific config lives in separate files, auto-loaded via `@import`.

```
~/.claude/
├── CLAUDE.md                <- Core config (~130 lines, imports everything below)
├── voice/
│   └── style.md             <- Your writing voice + examples
├── systems/
│   ├── triage.md            <- Inbox triage rules + contact tiers
│   ├── responsibilities.md  <- Always-on behaviors
│   ├── mcp-routing.md       <- MCP servers + routing
│   ├── confidentiality.md   <- Sensitive topic rules
│   └── team-os.md           <- Team shared folder (if configured)
├── commands/                <- Slash commands (/gm, /triage, ...)
├── agents/                  <- Parallel sub-agents
├── contacts/                <- Personal CRM
│   ├── personal/
│   └── business/
├── goals.yaml               <- Your objectives
├── my-tasks.yaml            <- Task tracking
├── decisions.yaml           <- Decision log (append-only)
├── triage-stats.yaml        <- Acceptance rate tracking (auto-updated)
├── triage-learnings.yaml    <- Draft improvement patterns (auto-updated)
├── cache/
├── outputs/
└── logs/
```

Edit any file independently. CLAUDE.md uses `@import` to load them all at session start.

---

## How It Works

### CLAUDE.md + @imports

CLAUDE.md is the entry point. It defines who you are, your core principles, and operating modes. Domain-specific config is split into separate files loaded via `@import`:

- `@voice/style.md` — How you write
- `@systems/triage.md` — How to prioritize your inbox
- `@systems/responsibilities.md` — What Ally always does in the background
- `@systems/mcp-routing.md` — Which tools connect to which services
- `@systems/confidentiality.md` — What topics need extra caution

This keeps each file focused and easy to edit without touching the core config.

### Commands

Commands are markdown files in `~/.claude/commands/` that define multi-step workflows. When you type `/gm`, Claude reads `commands/gm.md` and follows the instructions.

You can:
- Modify existing commands to fit your workflow
- Create new commands for your specific needs
- Share commands with your team

### Contact Files

Each contact gets a markdown file in `~/.claude/contacts/personal/` or `~/.claude/contacts/business/`. These files accumulate context over time: interaction history, personal notes, communication preferences, talking points.

The more you use the system, the richer these files become.

### Decision Log

`decisions.yaml` is an append-only log of key decisions. Ally checks it before re-debating settled questions and flags when a "revisit_when" condition has been met.

### Goals

Goals in `goals.yaml` are active, not passive. Ally references them when:
- Triaging your inbox (does this email advance a goal?)
- Proposing meetings (does this meeting advance a goal?)
- Prioritizing tasks (which task moves the needle most?)
- Challenging your time allocation (are you spending time on what matters?)

### Learning Loop

Every interaction makes the system better:
- **Voice learning** — Edit a draft, the before/after gets logged. Future drafts incorporate the pattern.
- **Acceptance tracking** — Tracks how often drafts go through unchanged, by channel and contact.
- **Decision memory** — Prevents re-debating settled questions.

---

## Automation (Optional)

For users who want Claude to run automatically on a schedule:

### macOS (cron)

```bash
# Edit crontab
crontab -e

# Add morning briefing at 7am
0 7 * * * cd ~ && claude --command "/gm" >> ~/.claude/logs/gm.log 2>&1

# Add midday triage at noon
0 12 * * * cd ~ && claude --command "/triage digest" >> ~/.claude/logs/triage.log 2>&1
```

### Manual (Recommended for Getting Started)

Most users start by manually running commands and add automation later:

```
/gm              # Run when you start your day
/triage          # Run when you want to clear your inbox
/my-tasks list   # Run when you're planning your day
```

---

## Troubleshooting

### "MCP server not connected"

Make sure the MCP server is installed and configured. See [mcp-servers.md](mcp-servers.md).

### "Permission denied" on install.sh

```bash
chmod +x install.sh
```

### Drafts don't sound like me

This is the most common issue. Fix it by:
1. Adding more examples to `~/.claude/voice/style.md`
2. Pasting 5-10 real emails you've sent
3. Being specific about tone, sentence length, greetings, sign-offs

### Tasks aren't being tracked

Make sure `~/.claude/my-tasks.yaml` exists and is writable. The installer should have created it.

---

## Getting Help

- **Customization guide:** [customization.md](customization.md)
- **Architecture:** [architecture.md](architecture.md)
- **Examples:** [examples.md](examples.md)
- **MCP server setup:** [mcp-servers.md](mcp-servers.md)
- **Security policy:** [../SECURITY.md](../SECURITY.md)
- **Claude Code docs:** [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code)

---

## What's Next

Once you're comfortable with the basics:

1. **Create contact files** for your 10-20 most important relationships
2. **Build custom commands** for workflows specific to your role
3. **Set up automation** to run triage and briefings on schedule
4. **Iterate on your config** — every correction is a chance to improve the system
