---
name: ticket-kickoff
description: Start a new ticket/task by creating a structured scratchpad. Use when beginning work on a new feature, bug, or task — especially when given a ticket ID or task description.
argument-hint: [ticket ID or task description]
allowed-tools: Bash, Read, Write
model: sonnet
---

Create a working scratchpad for ticket/task: $ARGUMENTS

Steps:
1. Determine a short slug from the ticket ID or description (e.g., "AUTH-123" or "fix-login-timeout").
2. Create a file at `.claude/active/<slug>.md` in the current project directory (or `~/work/<employer>/.claude/active/<slug>.md` if outside a project).
3. Populate it with this structure:

```markdown
# <Ticket ID / Task Title>

## Goal
<1-2 sentences: what does done look like?>

## Context
<Why this matters; any constraints or deadlines known>

## Approach
<How you plan to tackle it — update as you learn>

## Decisions
<Key choices made and why>

## Progress
- [ ] Step 1
- [ ] Step 2

## Next session
<Where to pick up; blockers>
```

4. Print the file path so the user knows where to find it.
5. Do NOT fill in sections you don't have information for — leave them blank for the user to fill.
