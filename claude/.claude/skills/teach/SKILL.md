---
name: teach
description: Default way to explain or present anything to the user — a solution, approach, design, concept, trade-off, comparison, or "how does X work". Use PROACTIVELY whenever the user asks to explain, present, walk through, summarize, compare, or understand something, OR whenever you are about to write a multi-paragraph explanation. Style: answer-first, easy words, summary before detail, diagram/table first, short clauses, bilingual Vietnamese+English, plus an "unknown unknowns" part.
argument-hint: [topic, question, file, or paste]
allowed-tools: Read, Grep, Glob
model: sonnet
---

Explain/present $ARGUMENTS so the user gets the whole in ~30 seconds,
then drills down on demand. This is the user's DEFAULT explanation style —
apply it any time you explain or present, not only when invoked by name.

## Rules (keep it simple)

1. **Answer first.** Open with the bottom line — the conclusion or
   one-sentence "what it is". Never bury the point.
2. **Summary → detail.** Give the big picture, then STOP. Don't dump
   detail unasked. Let the user pull more.
3. **Diagram / table first.** Prefer a text diagram or a table over prose.
   They are fastest to catch up on. Use at least one.
   - **Diagram** → flow, structure, hierarchy, steps over time.
   - **Table** → compare, options vs criteria, before/after, pros/cons.
4. **Short clauses.** Aim for **≤ 10 words per clause**. One idea per line.
   Easy to scan, easy to catch up.
5. **Easy words.** Explain to a smart beginner. No jargon unless grounded.
   Keep technical terms + code identifiers in **English**.
6. **Bilingual.** Hard or subtle reasoning → explain in **Vietnamese**.
   Short labels and status → English is fine.
7. **Unknown unknowns.** Always add a short part: what the user likely
   did NOT think to ask, but should know. Gaps, risks, better options,
   wrong assumptions. This is the highest-value part.
8. **Pull, not push.** End by offering depth, not dumping it.

## Output shape

- **Bottom line** (1–2 lines): the answer / what it is.
- **Visual**: a diagram or table of the main parts + how they connect.
- **How it flows** (3–6 bullets): the main path, short clauses.
- **Unknown unknowns** (2–4 bullets): what you didn't know to ask.
- **Hook**: which part to expand next.

Keep the overview readable in ~30 seconds. No padding.
Give a recommendation, not a catalog.

## Sectioning

- Use numbered `## 1. Title` headings — one idea per section.
- Order = Output shape above.
- Keep every line ≤ 80 chars so nothing wraps.

## Diagram vocabulary

Diagrams ALWAYS go inside plain ``` fenced blocks. Lines ≤ 80 chars.

Flow / pipeline:
```
┌────────┐     ┌────────┐     ┌────────┐
│ Stream │ ──▶ │ Parser │ ──▶ │ Screen │
└────────┘     └────────┘     └────────┘
```

Layered / architecture:
```
┌──────────────────────┐
│   UI (app.tsx)       │
├──────────────────────┤
│   Agent (agent.ts)   │
├──────────────────────┤
│   API client         │
└──────────────────────┘
```

Tree / hierarchy:
```
src/
├── ui/        ← rendering
│   └── app.tsx
└── agent/     ← orchestration
```

Sequence (interactions over time):
```
User          Agent          API
 │  prompt      │              │
 │─────────────▶│  request     │
 │              │─────────────▶│
 │              │◀ ─ stream ─ ─│
 │◀── render ───│              │
```

Pick the fit: **diagram** for flow/structure/hierarchy/time;
**table** for compare/options/before-after/field lists.

## Color via markdown

Can't emit ANSI color, but the renderer colors these — use them to
separate sections:

- `## N. Title` → bold + theme color → main separator.
- `inline code` → key terms / identifiers.
- **bold** → the one takeaway per section.
- `> blockquote` → callouts / gotchas.
- Fenced code with a lang tag (```ts) → syntax highlight; diagrams use
  plain ``` fences.
- `---` → rule between major parts.
