# /gm — Morning Briefing

## Description
Start your day with a structured briefing: calendar, tasks, urgent messages,
news signals, relationship health, goal momentum, and focus recommendations.

## Instructions

You are running the morning briefing for {{YOUR_NAME}}. Follow these steps.

### Phase 0: Cache Check

Check if `~/.claude/cache/morning-briefing.md` exists.

- **If generated TODAY and less than 2 hours old:** Display it with a note:
  `(Pre-fetched at [time] — say "refresh" for live data)`. Skip to Phase 3.
- **If stale or missing:** Continue below.

### Phase 0.5: Get Current Time

Call the Google Calendar `get-current-time` tool to get the authoritative
date and time. Never guess the day of week.

### Phase 1: Data Fetch

Collect data from all connected sources. **If agents are installed** (`~/.claude/agents/`),
launch them in parallel using the Task tool for speed. **If no agents**, run these steps
sequentially — the briefing works either way.

**1. Calendar**
If agent exists, use subagent_type: `calendar-scanner`. Otherwise do directly:
- Fetch today's events and tomorrow morning (until 14:00)
- For each event: time, duration, title, attendees
- Flag: before {{EARLIEST_MEETING_TIME}}, back-to-back, no agenda
- Check contacts for attendee context

**2. Tasks**
If agent exists, use subagent_type: `task-scanner`. Otherwise do directly:
- Read `~/.claude/my-tasks.yaml` (personal)
- If shared folder configured: read shared task file too
- Return: due today, overdue, next 3 days

**3. Inbox Scan**
If agent exists, use subagent_type: `inbox-scanner`. Otherwise do directly:
- Scan each connected email account (last 12 hours, flag Tier 1 senders)
- Scan Slack DMs (focus on key contacts)
- If shared folder: check team inbox for unread messages
- Don't do full triage. Just surface what's critical.

**4. Goals**
If agent exists, use subagent_type: `momentum-analyzer`. Otherwise do directly:
- Read `~/.claude/goals.yaml`
- If shared folder: read shared goals too
- Flag stalled goals and biggest gap

**5. Relationships** (skip if no contacts exist yet)
If agent exists, use subagent_type: `relationship-monitor`. Otherwise do directly:
- Scan `~/.claude/contacts/` for decay thresholds
- Tier 1: flag at 10+ days, Tier 2: 25+ days, Tier 3: 50+ days

**6. Signals** (skip if no web search tool connected)
- Find 2-3 relevant signals for your industry
- One-line summaries only

### Phase 2: Synthesize

Once all agents return, cross-reference the data:
- Link meeting attendees to emails they sent
- Link tasks to meetings they relate to
- Link goals to calendar alignment
- Build the priority stack based on goal alignment

### Phase 3: Present the Briefing

Format:

```
Good morning, {{YOUR_NAME}} — [Day], [Date]

AT A GLANCE
- [n] meetings today ([n]h meeting time, [n]h deep work)
- [n] tasks due today, [n] overdue
- [n] unread messages ([n] Tier 1)

CALENDAR ([count] meetings)
 [time]  [title] ([duration]) [PREP READY / NEEDS PREP]
         [cross-ref: attendee emailed about X / last met on Y]
 ...

PRIORITY STACK
1. [Top priority] — advances [goal], ~[time]
2. [Second priority] — [reason]
3. [Third priority] — [reason]

TASKS
 PERSONAL:
   DUE TODAY: [list or "Clear"]
   OVERDUE: [list or "All clear"]
 COMPANY: [only if shared folder connected]
   DUE TODAY: [list or "Clear"]
   OVERDUE: [list or "All clear"]
 BACKGROUND: [tasks with progress]

TEAM INBOX [only if shared folder connected]
 [Messages from teammates, or "No messages"]

INBOX HIGHLIGHTS
 [Tier 1 items from email, Slack, WhatsApp — or "No urgent items"]

SIGNALS
 [Signal 1] — [one-line context]
 [Signal 2] — [one-line context]

RELATIONSHIPS
 [Name] — [n] days since contact — [suggested action]

GOALS
 [Brief status on top 1-2 goals]

FOCUS RECOMMENDATION
Based on your calendar and priorities:
1. [Top priority]
2. [Second priority]
3. [Third priority, if time allows]
```

### Guidelines

- The whole briefing should be scannable. Lead with the most important information.
- If there are no urgent items, say so.
- The priority stack should reflect goal alignment.
- If today's calendar is misaligned with goals, say so explicitly.
- End with: "Want me to run a full /triage, prep for a meeting, or work on a task?"
