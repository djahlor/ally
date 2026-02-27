# /week-plan — Deep Weekly Planning

## Description
Deep planning session. Reads everything, produces an ambitious AI-first week plan.
Separates [H] human time from [AI] delegatable work. Plans 3-5x more than feels comfortable.

## Instructions

You are generating the week plan for {{YOUR_NAME}}.

**Ambition rule:** If the plan could fit on a slow human's schedule, it's under-scoped.
Every task gets a [H] (human-only) or [AI] (delegatable) label. The real constraint is
decisions and approvals, not work volume.

---

### Phase 1: Parallel Data Fetch

Launch ALL of these as parallel subagents in a single message.

**Agent 1: Goals** (subagent_type: `general-purpose`, model: `haiku`)
- Read `~/.claude/goals.yaml`
- If shared folder: read shared goals too
- Return: active goals, stalled items

**Agent 2: Tasks** (subagent_type: `task-scanner`)
- Read personal and shared task files
- Return: overdue, due this week, blocked, upcoming deadlines

**Agent 3: Calendar Week View** (subagent_type: `calendar-scanner`)
- Fetch all events for the next 7 days
- Flag: hard constraint violations, prep-needed, back-to-back
- Identify open deep work blocks
- Return structured week calendar

**Agent 4: Relationships** (subagent_type: `relationship-monitor`)
- Scan contacts for decay thresholds
- Return prioritized outreach list

**Agent 5: Recent Outputs** (subagent_type: `general-purpose`, model: `haiku`)
- List files in `~/.claude/outputs/` modified in the last 5 days
- Identify: unfinished work, open loops
- Return summary

**Agent 6: Signals** (subagent_type: `research-agent`, model: `haiku`)
- Search for relevant market/industry signals
- Return 3-5 one-line signals with source

---

### Phase 2: Synthesize

Once all agents return:
- Map tasks -> goals (which tasks advance which goals?)
- Identify orphaned tasks (no goal alignment -> candidate to drop)
- Identify goal-aligned work not in any task (gap = missed leverage)
- Flag if one domain is getting all the attention

---

### Phase 3: Build the Plan

Output to `~/.claude/outputs/[DATE]-week-plan.md`.

```
# Week Plan: [Mon DD MMM] - [Sun DD MMM], [YEAR]

## THE ONE THING
[Single sentence: what does winning this week look like?]

---

## HONEST ASSESSMENT

**Where we are:** [2-3 sentences, no spin]
**Biggest risk:** [What could derail the week]
**What's being left on the table:** [Specific missed leverage]

---

## FIRES (Handle Monday)
| What | Why urgent | Action | [H] time |
|------|-----------|--------|----------|
| ...  | ...       | [AI] drafts, [H] approves | X min |

---

## PARALLEL TRACKS THIS WEEK

Track A: [Domain/Goal]
Track B: [Domain/Goal]
Track C: [Relationship/Personal]

> Running parallel tracks is the point. Each track has its own rhythm.

---

## DAILY PLAN

### [DAY], [DATE]
| Time | What | [H] or [AI] | Human time |
|------|------|-------------|------------|
| ...  | ...  | [AI] I prep, you review | 5 min |
| ...  | Call with X | [H] | 30 min |

[Repeat for each day Mon-Sun]

---

## TASK LIST BY PRIORITY

### Must Complete (goal-critical)
1. [Task] — [H] X min / [AI] handles rest — advances [Goal]
2. ...

### Should Complete (high value)
...

### Drop / Defer
[Tasks with no goal alignment or low leverage — be explicit about dropping]

---

## RELATIONSHIP OUTREACH
| Who | Days since | Why now | Message angle | Channel |
|-----|-----------|---------|---------------|---------|
| ... | ...       | ...     | ...           | WhatsApp/Email |

---

## DECISIONS NEEDED
[Explicit decisions that must be made this week to unblock progress]

---

## WEEK SCORECARD
By Sunday night, success looks like:
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] ...

---

## AI PRE-COOK LIST
What I'll have ready without being asked:
1. [Draft / research / prep] — ready [when]
2. ...
```

---

### Phase 4: Offer Execution

After presenting the plan, ask:
> "Which track do you want to start on? Say 'go' and I'll pre-cook everything for the first block."

---

### Guidelines

- Every time estimate must be [H] human time, not total task time
- If a task has no [AI] component, question whether it's the right use of time
- Never plan a single track. At minimum 2 parallel tracks.
- Relationship outreach is never optional if someone is past decay threshold
- The plan should feel ambitious. If it doesn't, add more.
- Finish with the AI pre-cook list
