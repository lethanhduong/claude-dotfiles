---
description: Model routing rules — global, no path filter
---

- **Haiku**: explore, grep, summarize, background agents, mechanical edits.
- **Sonnet**: default for feature work, tests, reviews, debugging known bugs.
- **Opus**: security audits, cross-cutting refactors, race-condition debugging, novel query optimization, novel architecture decisions.
- **opusplan**: plan with Opus, execute with Sonnet — use when the change spans more than 3 files or requires architectural judgment.
- Always set `model:` explicitly on every subagent definition. Never leave it unset (bug: defaults to Sonnet even when main session runs Opus).
