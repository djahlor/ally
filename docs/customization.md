# Customization Guide

Ally is modular by design. Each file controls one domain. Edit any file
independently without touching the rest.

---

## The 80/20 of Customization

If you only do four things, do these:

1. **Add real email examples** to `voice/style.md`
2. **Define your Tier 1 people** in `systems/triage.md`
3. **Set your hard time constraints** in `CLAUDE.md`
4. **Write your actual goals** in `goals.yaml`

These four changes will cover 80% of the improvement. Everything else is refinement.

---

## File-by-File Guide

### voice/style.md — Your Writing Voice

**This is the most impactful file to customize.**

Ally uses this to draft every email, Slack message, and document in your voice.
Bad style instructions = drafts that need heavy editing = no time saved.

**How to get this right:**

1. **Open your Sent Mail folder**
2. **Find 5-10 representative emails** across different contexts:
   - A casual reply to a colleague
   - A professional response to a client or stakeholder
   - A response to criticism or bad news
   - A cold outreach or introduction
   - A scheduling email
3. **Paste them as examples** (anonymize names if needed)
4. **Note your patterns:**
   - How do you start emails? (Name first? "Hey"? Jump right in?)
   - How do you end? ("Best," "Thanks," just your name?)
   - Sentence length? (Short and punchy? Longer and flowing?)
   - Contractions? (I'm/I'd vs I am/I would?)
   - Emoji usage? (Never? Sometimes? Frequently?)
   - Tone shifts? (When are you formal vs casual?)

**Example of a well-documented voice/style.md:**
```markdown
## Tone
Direct but warm. Professional with close colleagues, slightly more formal
with external contacts. Never stiff or corporate-sounding.

## Characteristics
- Short paragraphs (1-3 sentences max)
- Start with the person's name for important messages
- Use "Thanks" not "Thank you"
- Sign off with just first name for internal, full sig for external
- Contractions always (I'm, I'd, we'll, it's)

## Example Emails

Casual internal:
"Hey Sarah — quick update on the roadmap review. Moving the API
launch to March 15 to give the team more buffer. I'll update the
tracker. Let me know if that causes issues on your end. — Chris"

Professional external:
"David, appreciate the detailed proposal. The pricing model works
for us with one adjustment. If that's workable, I'm ready to move
forward. Happy to jump on a call Thursday to finalize. Chris"

Handling criticism:
"Mark, that's fair feedback and I should have caught it sooner.
I'll own the fix. Expect an updated version by EOD Friday. Chris"
```

---

### systems/triage.md — Inbox Rules

**What to customize:**

- **Tier 1 people** — Who gets an immediate response? This varies by role.
- **Tier 1 situations** — What scenarios are always urgent?
- **Contact decay thresholds** — How long before a stale relationship gets flagged?

**Tier 1 examples by role:**

| Role | Tier 1 contacts |
|------|----------------|
| CEO | Board members, co-founders, top 3 customers, partner/family |
| VP Engineering | CTO, direct reports, key architects, partner/family |
| Sales Leader | CEO, top 5 customers, VP Product, partner/family |
| Solo founder | Co-founder, lead investor, top 3 customers, partner/family |

---

### systems/responsibilities.md — Always-On Behaviors

**What to customize:**

- **Task management style** — Aggressive about completion, or gentle reminders?
- **Scheduling preferences** — "Deep work mornings, meetings after lunch, no calls on Friday."
- **Time constraints** — Be specific. "No meetings before 9am. Lunch 12-1pm is protected."
- **Energy patterns** — "Best deep work in the morning (9-12), meetings afternoon."

---

### systems/mcp-routing.md — Server Routing

**What to customize:**

- **Update the Status column** as you connect each MCP server
- **Add email routing rules** if you have multiple accounts
- **Add source routing** so Ally knows where to look for different types of information

---

### systems/confidentiality.md — Sensitive Topics

**What to customize:**

- **Keywords that trigger warnings** — What topics need extra caution in your context?
- **Channel rules** — Which channels are safe for which topics?

**Example keywords by role:**

| Role | Sensitive keywords |
|------|-----------|
| CEO | "fundraising", "acquisition", "board alignment", "termination" |
| VP Engineering | "security incident", "outage", "PII breach", "personnel" |
| Sales Leader | "competitor pricing", "margin", "discount approval" |

---

### CLAUDE.md — Core Config

**What to customize:**

- **Identity section** — Add personal context (family, EA, key relationships)
- **Hard Constraints** — Non-negotiable time boundaries
- **Values** — What's guiding your year?

The rest of CLAUDE.md (principles, operating modes, defaults) usually works well as-is.

---

## Creating Your Own Commands

Commands are markdown files in `~/.claude/commands/`. You can create
any workflow you want.

**Template for a custom command:**

```markdown
# /command-name — One-Line Description

## Description
What this command does and when to use it.

## Arguments
- `arg1` — What it does
- `arg2` — What it does

## Instructions

### Step 1: [Name]
[What Ally should do]

### Step 2: [Name]
[What Ally should do]

### Guidelines
- [Important rules for this command]
```

**Ideas for custom commands:**

| Command | What It Does |
|---------|-------------|
| `/prep <meeting>` | Prepare for a specific meeting with attendee research and talking points |
| `/weekly` | Generate a weekly status update from calendar and completed tasks |
| `/1on1 <person>` | Prepare for a 1:1 with agenda items, recent context, and open items |
| `/board-update` | Draft a board update from goals progress and key metrics |
| `/review <doc>` | Review a document with specific feedback categories |
| `/debrief` | After a meeting, capture decisions, action items, and follow-ups |

---

## Tips for Continuous Improvement

### The Correction Loop

Every time Ally gets something wrong, that's an opportunity to improve the system.

**Pattern:**
1. Ally drafts something that doesn't sound like you
2. You correct it
3. Ask: "How should I update my config to prevent this in the future?"
4. Ally proposes a specific edit (usually to voice/style.md)
5. Make the edit

After 2-3 weeks of corrections, drafts will sound remarkably like you.

### Version Your Config

Since everything is just text files, you can version it with git:

```bash
cd ~/.claude
git init
git add CLAUDE.md voice/ systems/ goals.yaml
git commit -m "Initial Ally setup"
```

This lets you track changes over time and revert if an edit makes things worse.

### Review Quarterly

At the start of each quarter:
1. Update `goals.yaml` with new objectives
2. Review config files for outdated information (team changes, priority shifts)
3. Add any new custom commands you've been wanting
4. Check contact files for accuracy

### Share What Works

If you build a command or customization that works well, consider sharing it
with the community. The best setups are built by combining ideas from many people.

---

## Further Reading

- [Architecture](architecture.md) — How the system works under the hood
- [Examples](examples.md) — Output samples for every command
- [Setup Guide](setup-guide.md) — Full installation walkthrough
- [Contributing](../CONTRIBUTING.md) — How to submit changes
