# /my-tasks — Task Management

## Description
Track, prioritize, and execute tasks with goal alignment and due date awareness.
Claude doesn't just remind you -- it helps get work done.

## Arguments
- `list` — Show all active tasks, grouped by urgency
- `add "title" --due YYYY-MM-DD --goal "goal-name"` — Add a new task
- `complete <task-id>` — Mark a task as complete
- `execute` — Work on the highest-priority pending task
- `overdue` — Show only overdue and at-risk tasks

## Task Files

- **Personal:** `~/.claude/my-tasks.yaml` (errands, personal items, learning)
- **Company:** If a Team Shared Folder is configured in CLAUDE.md, also read
  `[shared-folder]/tasks/[your-name].yaml` (company work tasks)

## Instructions

### /my-tasks list

Read `~/.claude/my-tasks.yaml` (personal tasks). If a Team Shared Folder
is configured, also read your shared task file. Present both, clearly labeled:

```
TASKS

PERSONAL
  OVERDUE (action required)
  - [task-id] [title] — due [date] ([X days late]) — goal: [goal]

  DUE TODAY
  - [task-id] [title] — goal: [goal]

  APPROACHING (next 7 days)
  - [task-id] [title] — due [date] ([X days]) — goal: [goal]

COMPANY [only if shared folder connected]
  OVERDUE (action required)
  - [task-id] [title] — due [date] ([X days late]) — goal: [goal]

  DUE TODAY
  - [task-id] [title] — goal: [goal]

  APPROACHING (next 7 days)
  - [task-id] [title] — due [date] ([X days]) — goal: [goal]

Summary: [X] personal + [Y] company tasks active, [Z] overdue
```

If there are overdue tasks, flag them prominently and ask:
"Want me to help execute [task], reschedule it, or break it down?"

### /my-tasks add

When adding a task:

1. **Determine destination:** Ask "Is this personal or company work?"
   - Personal -> write to `~/.claude/my-tasks.yaml`, check `~/.claude/goals.yaml`
   - Company -> write to shared task file, check shared `goals.yaml`
   - If no shared folder configured, everything goes to personal
2. Generate a unique task ID (format: `task-XXX`)
3. Ask for any missing required info:
   - Title (required)
   - Due date (required -- always set one, even if approximate)
   - Goal alignment (recommended)
   - Priority (default: 3/normal)
4. Write the task to the correct file
5. Confirm: "Added [personal/company]: [title] — due [date] — aligned to [goal]"

**Goal alignment validation:**
Check the appropriate goals file. If the task doesn't align with any active goal,
flag it: "This task doesn't align with your current goals. Still want to add it?"

### /my-tasks complete

1. Find the task by ID in personal OR shared task file
2. Update status to "complete" in the correct file
3. Add completion date (and `last_modified`/`last_modified_by` for shared tasks)
4. Confirm: "Completed: [title]"
5. If completed before due date: "Nice — finished 3 days early."

### /my-tasks execute

This is where Claude actively helps get work done.

1. Read both task lists, identify the highest-priority actionable task
2. Check the user's calendar to confirm they have time now
3. Present the task and a plan:
   ```
   Ready to work on: [task title]
   Due: [date] | Goal: [goal] | Priority: [priority]

   Here's my plan:
   1. [Step 1]
   2. [Step 2]
   3. [Step 3]

   Shall I proceed?
   ```
4. Execute the work (draft emails, do research, create documents, etc.)
5. Present progress and ask for feedback

### /my-tasks overdue

Quick check for overdue and at-risk tasks across both personal and shared files.

Show:
1. **OVERDUE** — Past due date, not complete
2. **AT RISK** — Due within 48 hours, not started or blocked
3. **APPROACHING** — Due within 7 days

For each, suggest an action: execute, reschedule, delegate, or break down.

### Session-Start Behavior

At the start of any substantive conversation (not just /my-tasks), Claude
should silently check the task list and surface anything critical:

- **OVERDUE tasks:** Always mention these immediately
- **Due today:** Mention if there's time to work on them
- **At risk:** Mention if today's calendar has capacity

This check should be brief (1-2 lines) and not interrupt the user's request.

### Guidelines

- Every task should have a due date. If the user doesn't provide one, suggest one.
- Goal alignment isn't required but is strongly encouraged.
- When executing tasks, be specific about what you're doing and why.
- Don't expand scope. If the task says "draft email," draft the email.
- Celebrate early completions.
- If a task has been sitting with no progress for 5+ days, proactively ask about it.
