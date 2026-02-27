# /triage — Inbox Triage

## Description
Scan all connected communication channels, prioritize items by urgency,
and draft responses in your voice. Tracks acceptance rate to improve over time.

## Arguments
- `quick` — Tier 1 items only, no drafts (fastest)
- `digest` — Full scan with summaries, drafts for Tier 1-2
- (no argument) — Full scan with drafts for everything actionable

## Instructions

You are running inbox triage for {{YOUR_NAME}}. Process all incoming
messages quickly and surface what needs attention.

### Step 0: Check Pre-drafted Cache

Check if `~/.claude/cache/triage-drafts.yaml` exists.

- **If generated less than 30 minutes ago and has drafts:** Present the pre-drafted
  responses directly using the format in Step 5. Add a note at top:
  `(Pre-drafted at [time] — these are ready for your approval)`
  Skip to Step 5. Still do Steps 6-7 for tracking.
- **If stale, empty, or missing:** Continue with live scan below.

### Step 0.5: Load Learning Context

Read `~/.claude/triage-stats.yaml` if it exists. Note:
- Current acceptance rate
- Common edit patterns from `~/.claude/triage-learnings.yaml`
- Apply learnings to this session's drafts (e.g., if user always shortens greetings, start short)

Read `~/.claude/voice/style.md` for voice reference.

### Step 1: Scan Channels

Scan each connected channel. Only scan channels with active MCP servers.

**Channels to scan (in order):**

1. **Email** — Recent unread/unreplied (last 24 hours)
   - Focus on: Direct emails (not newsletters, automated, or CC-only)

<!--
  MULTI-ACCOUNT: If you have multiple email accounts configured,
  scan each separately. Route responses through the correct MCP server.
-->

2. **Slack** — DMs and @mentions

3. **WhatsApp / Beeper** — Recent messages requiring response

4. **Discord** — DMs and mentions only (if connected)

5. **Team Inbox** — If shared folder configured, check for unread teammate messages

### Step 2: Classify Each Item

| Tier | Criteria | Action |
|------|----------|--------|
| **Tier 1** | Key contacts, time-sensitive, blocking someone | Respond NOW |
| **Tier 2** | Important but not urgent, requires thoughtful response | Handle today |
| **Tier 3** | FYI, newsletters, automated, low-stakes | Archive or brief ack |

### Step 3: Check for Already-Replied

Before drafting, verify the user hasn't already replied. If handled, skip it.

### Step 4: Draft Responses

For each actionable item (Tier 1 and Tier 2), draft a response that:
- Matches the user's writing style (`voice/style.md`)
- Is send-ready (not a starting point for editing)
- Uses the right signature for the context
- Includes specific scheduling proposals if timing is involved (verify calendar first)
- Applies learnings from `triage-learnings.yaml`

For `quick` mode: Skip drafts, just list Tier 1 items.
For `digest` mode: Include drafts for Tier 1, summaries for Tier 2.

### Step 5: Present Results

```
Scanned: [channels] ([item counts])

TIER 1 — Respond Now
1. [Sender] — [Subject/summary] ([channel], [wait time])
   Draft: "[proposed response]"

TIER 2 — Handle Today
2. [Sender] — [Subject/summary] ([channel])
   Draft: "[proposed response]"

TIER 3 — FYI ([count] items archived)

STATS: [X] items need action, [Y] drafts ready | Acceptance rate: [Z]%
```

### Step 6: Await Approval & Track

**NEVER send any message without explicit approval.**

After presenting drafts, wait for the user to:
- Say "Send" or "Y" to approve -> **Track as ACCEPTED**
- Edit a draft and then approve -> **Track as EDITED** (store the before/after)
- Say "Send all" to approve all -> **Track each as ACCEPTED**
- Skip items -> **Track as SKIPPED**

### Step 7: Update Stats & Log Actions

After each triage session, update `~/.claude/triage-stats.yaml`:

```yaml
total_drafts: [increment]
accepted_as_is: [increment if sent without edits]
edited_then_sent: [increment if edited]
rejected: [increment if skipped]
acceptance_rate: [recalculate: accepted / (accepted + edited + rejected)]
last_triage: "[timestamp]"
```

If a draft was edited, append to `~/.claude/triage-learnings.yaml`:

```yaml
- date: "[date]"
  channel: "[channel]"
  recipient: "[name]"
  original: "[what Claude drafted]"
  edited_to: "[what the user changed it to]"
  pattern: "[inferred pattern]"
```

**Action Audit Log:** After every triage action, append to `~/.claude/logs/actions/YYYY-MM-DD.jsonl`:

```json
{"ts":"ISO-timestamp","action":"draft_sent","channel":"gmail","target":"Name","subject":"Re: Subject","outcome":"accepted"}
```

### Guidelines

- Speed matters. A triage should take 2-3 minutes, not 10.
- Don't over-explain. The user knows their contacts.
- If a channel's MCP server isn't connected, skip it silently.
- Route responses through the correct MCP server for each account.
- For long email threads, summarize the thread.
- If nothing urgent: "Inbox clear. No items need immediate attention."
