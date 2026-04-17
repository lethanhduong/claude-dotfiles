---
name: explain
description: Explain a piece of code — what it does, why it exists, and any non-obvious behavior. Use when the user highlights code or asks "what does this do", "explain this", "walk me through this".
argument-hint: [file:line_range or paste code]
allowed-tools: Read, Grep, Glob
model: sonnet
---

Explain the code at $ARGUMENTS (file path, line range, or pasted snippet).

Steps:
1. Read the code. If a file path is given, read that file (or the specified range).
2. Trace any non-obvious dependencies — read callers or callees only if essential to understanding.
3. Write a clear explanation:
   - **What it does**: one paragraph, plain language.
   - **Why it exists** (if inferable from context, naming, or comments): one sentence.
   - **Non-obvious behavior**: edge cases, side effects, performance implications, or gotchas. Skip this section if there are none.
4. Keep the explanation short enough to read in 30 seconds. No padding.
