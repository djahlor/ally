# Examples

What Ally actually produces.

These are real output formats with anonymized data. Every example below is what you see in your terminal after installing Ally and connecting your accounts.

---

## 1. /gm -- Morning Briefing

You open your terminal, type `/gm`, and get this:

```console
Good morning, Alex — Wednesday, 26 Feb 2026

AT A GLANCE
- 4 meetings today (2.5h meeting time, 5.5h deep work)
- 2 tasks due today, 0 overdue
- 14 unread messages (2 Tier 1)

CALENDAR (4 meetings)
 10:00  Product sync with Jordan (30m) [PREP READY]
        Cross-ref: Jordan emailed last night about the API migration timeline
 11:30  Design review: onboarding flow (60m) [NEEDS PREP]
        Cross-ref: Morgan shared Figma link in Slack yesterday
 14:00  1:1 with Pat (30m) [PREP READY]
        Note: Pat mentioned career growth concerns in last 1:1
 16:00  Investor update call (30m) [NEEDS PREP]
        Cross-ref: Monthly metrics email drafted but not sent

PRIORITY STACK
1. Finalize API migration plan — advances "Ship v2 by March 15", ~90 min
2. Review and approve onboarding designs — advances "Reduce churn to <5%", ~30 min
3. Send investor update email — advances "Close seed round", ~15 min (draft ready)

TASKS
 PERSONAL:
   DUE TODAY: Dentist appointment confirmation, Send mom's birthday gift
   OVERDUE: All clear
 COMPANY:
   DUE TODAY: Submit API migration spec to engineering
   OVERDUE: All clear
 BACKGROUND: Competitor analysis 60% complete (auto-running)

INBOX HIGHLIGHTS
 Jordan (Slack DM, 2h ago) — "Need your call on the postgres vs. planetscale
   decision before I spec the migration. Blocking eng."
 Morgan (Email, 8h ago) — "Design partner program: 2 of 3 confirmed. Need
   your OK on the third (Acme Corp). Contract attached."

SIGNALS
 Stripe launched embedded financial accounts — relevant to your payments roadmap
 Y Combinator published updated standard deal terms — relevant if raising this quarter

RELATIONSHIPS
 Casey Martinez — 18 days since contact (Tier 1, threshold: 14 days)
   Suggestion: Quick check-in about their new role at Vercel
 Riley Cooper — 28 days since contact (Tier 2, threshold: 30 days)
   Suggestion: Follow up on the intro they offered to make

GOALS
 "Ship v2 by March 15" — on track, 65% complete, API migration is the critical path
 "Close seed round" — 3 of 5 target investors in active conversation

FOCUS RECOMMENDATION
Based on your calendar and priorities:
1. Before 10:00: Finalize API migration spec (your deepest work block)
2. After product sync: 15 min to approve Morgan's design partner contract
3. Before investor call: Review and send monthly metrics email (draft is ready)

Want me to run a full /triage, prep for a meeting, or work on a task?
```

---

## 2. /triage -- Inbox Triage

You type `/triage` and Ally scans everything:

```console
Scanned: Gmail (8), Slack (4), WhatsApp (2) — 14 items total

TIER 1 — Respond Now

1. Jordan — "Postgres vs PlanetScale decision" (Slack DM, 2h ago)
   Context: Blocking the eng team on migration spec. Needs a yes/no.
   Draft:
   "go with planetscale. the connection pooling alone saves us 2 weeks
   of work and we won't hit the row limits for at least 18 months.
   i'll add the reasoning to the decision log. start the spec today."

2. Morgan — "Design partner: Acme Corp approval" (Gmail, 8h ago)
   Context: 2 of 3 design partners confirmed. Acme Corp is the third.
   Contract attached, standard terms, 90-day commitment.
   Draft:
   "Hey Morgan,

   Looks good. Approved on Acme Corp.

   One thing: make sure the 90-day clock starts from first production,
   not contract signing. We learned that the hard way with the Beacon
   deal.

   Thanks

   Alex"

TIER 2 — Handle Today

3. Pat — "Quick question on Q1 priorities" (Gmail, 1d ago)
   Context: Asking whether to prioritize the analytics dashboard or
   the notification system refactor. Both are on the roadmap.
   Draft:
   "Hey Pat,

   Analytics dashboard. It's the #1 request from design partners and
   directly tied to our churn goal. Notifications can wait until April.

   Let's dig into the scope in our 1:1 today.

   Alex"

TIER 3 — FYI (9 items archived)
  Product Hunt newsletter, 3 GitHub notifications, AWS billing alert,
  2 marketing emails, Figma comment notification, LinkedIn connection request

STATS: 3 items need action, 3 drafts ready | Acceptance rate: 82%
```

Then the approval flow:

```console
> Send 1

Sent. Jordan's Slack DM replied.

> Edit 2: change "Looks good. Approved on Acme Corp." to
  "Approved. Acme Corp is a go."

Got it. Sending edited version to Morgan... Sent.

Learning logged: "Shorter approvals. Skip restating what they already know."

> Skip 3, I'll handle in the 1:1

Skipped. Pat's email marked for follow-up.

Session: 2 sent (1 accepted, 1 edited), 1 skipped
```

The learning log entry created from the edit:

```console
triage-learnings.yaml updated:
  - date: "2026-02-26"
    channel: "gmail"
    recipient: "Morgan"
    original: "Looks good. Approved on Acme Corp."
    edited_to: "Approved. Acme Corp is a go."
    pattern: "Shorter approvals. Don't restate the ask. Get to the decision."
```

---

## 3. Learning Loop Progression

This is where the system compounds. Same situation, three weeks apart.

**Week 1 draft** (before Ally learns your voice):

```console
Draft:
"Dear Morgan,

Thank you so much for sending over the design partner proposal for
Acme Corp. I've had a chance to review the contract and everything
looks great on our end.

I'm happy to confirm that we'd like to move forward with bringing
Acme Corp on board as our third design partner. This is an exciting
milestone for the program!

One thing I wanted to flag — it might be worth ensuring that the
90-day commitment period begins from the date of first production
rather than the contract signing date, as we've found this to be
a better approach based on our previous experience.

Please let me know if you have any questions or if there's anything
else you need from me to get this finalized.

Best regards,
Alex Chen
Head of Product
Acme Inc."
```

**Week 3 draft** (after corrections are logged):

```console
Draft:
"Approved. Acme Corp is a go.

One thing: make sure the 90-day clock starts from first production,
not contract signing. We learned that the hard way with Beacon.

Thanks

Alex"

Sent without edits.
```

What happened between week 1 and week 3:

- 47 drafts processed across email, Slack, and WhatsApp
- 19 corrections logged with before/after patterns
- Key patterns learned: skip pleasantries, lead with the decision, use "Thanks" not "Thank you", sign off with just first name, never open with "Dear", contractions everywhere, no exclamation marks
- Acceptance rate: 40% (week 1) to 85% (week 3)
- Average draft length dropped from 127 words to 34 words

---

## 4. /enrich stale -- Relationship Health

You type `/enrich stale` and get:

```console
RELATIONSHIP HEALTH CHECK

NEEDS ATTENTION (overdue)
  Casey Martinez (Tier 1) — Last contact: 18 days ago (Slack DM)
    Context: Started new role as VP Eng at Vercel in January.
             You discussed a potential integration partnership.
    Suggestion: "Congrats follow-up. Ask how the first month is going.
                 Mention the integration idea casually."

  Sam Okafor (Tier 2) — Last contact: 38 days ago (email)
    Context: Introduced you to two angel investors in December.
             One of those intros led to an active conversation.
    Suggestion: "Thank-you update. Let them know the intro is progressing.
                 People like knowing their intros led somewhere."

APPROACHING (within 5 days of threshold)
  Riley Cooper (Tier 2) — Last contact: 28 days ago (WhatsApp)
    Context: Offered to intro you to their Head of Partnerships at Figma.
    Suggestion: "Follow up on the Figma intro offer. Keep it short."

HEALTHY
  12 contacts are within their cadence

Want me to draft any of these touchpoint messages?
```

---

## 5. /week-plan (excerpt)

You type `/week-plan` and the full plan generates. Here is the top section:

```console
# Week Plan: Mon 23 Feb - Sun 01 Mar, 2026

## THE ONE THING
Ship the API migration spec and get eng building by Wednesday.
Everything else this week is noise if that doesn't happen.

## HONEST ASSESSMENT
Where we are: v2 is 65% complete but the critical path runs through
the migration, and eng has been blocked for 3 days waiting on a spec.
Design partners are locked in but will start asking hard questions in
2 weeks if they don't see progress. The seed round conversations are
warm but will cool fast without a product update to share.

Biggest risk: Getting pulled into investor prep and losing the deep
work block needed for the migration spec.

What's being left on the table: Casey Martinez intro to Vercel
partnerships is going stale. That could open a distribution channel
worth more than any single investor meeting.

## PARALLEL TRACKS THIS WEEK

Track A: Product (v2 migration)
  [AI] Draft full migration spec from Jordan's notes — Mon AM
  [H] Review and approve spec — Mon, 30 min
  [AI] Prep design review materials from Morgan's Figma — Tue
  [H] Design review meeting — Wed 11:30, 60 min

Track B: Fundraise
  [AI] Draft monthly investor update with latest metrics — Mon
  [H] Review and send update — Mon, 15 min
  [H] Investor call — Wed 16:00, 30 min
  [AI] Follow-up notes and next steps after call — Wed evening

Track C: Relationships
  [AI] Draft Casey Martinez check-in message — Mon
  [H] Review and send — Mon, 2 min
  [AI] Draft Sam Okafor thank-you update — Tue
  [H] Review and send — Tue, 2 min

## AI PRE-COOK LIST
What I'll have ready without being asked:
1. API migration spec first draft — ready Monday 9:00 AM
2. Investor update email with February metrics — ready Monday 10:00 AM
3. Casey Martinez touchpoint message — ready Monday 9:00 AM
4. Design review prep doc with annotated Figma screenshots — ready Tuesday PM
```
