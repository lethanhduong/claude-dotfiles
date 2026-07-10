---
description: Model routing rules — global, no path filter
---

- **Subagents default to Sonnet 5.** All subagent definitions use `model: sonnet` unless listed as an exception below.
- **Fable exceptions**: `planner` (architectural judgment) and `code-reviewer` (deep review) use `model: fable`.
- Everything else — `explorer`, `researcher`, `security-reviewer`, `sys-explorer` — runs on Sonnet 5.
- **fableplan** (main session): plan with Fable, execute with Sonnet — use when the change spans more than 3 files or requires architectural judgment.
- Always set `model:` explicitly on every subagent definition. Never leave it unset (bug: defaults to Sonnet even when main session runs Fable).
