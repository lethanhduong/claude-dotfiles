---
name: commit-msg
description: Generate a conventional commit message from staged changes. Use when the user asks for a commit message, wants to commit, or says "generate commit message".
argument-hint: [optional: scope or context hint]
allowed-tools: Bash, Read
model: haiku
---

Generate a git commit message for the staged changes.

Steps:
1. Run `git diff --cached` to see what is staged.
2. Run `git log --oneline -5` to understand the project's commit style.
3. Produce a commit message following the project's style. If no clear style, use:
   - Subject: imperative mood, under 72 characters, no period.
   - Body (if needed): explain WHY, not WHAT. Wrap at 72 chars.
4. Output ONLY the commit message — no explanation, no markdown fences.

If nothing is staged, say "Nothing staged. Run `git add <files>` first."
