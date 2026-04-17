---
description: Git workflow conventions — global, no path filter
---

- Commit message: imperative mood, subject line under 72 characters, no period at end.
- Always create a NEW commit rather than amending, unless the user explicitly requests `--amend`.
- Never `--force` push to `main` or `master`. Warn the user if they request it.
- Never skip hooks (`--no-verify`) unless the user explicitly asks.
- Stage specific files by name; avoid `git add -A` or `git add .` which can include secrets.
- When a pre-commit hook fails, fix the underlying issue and create a new commit — do not use `--no-verify` to bypass.
