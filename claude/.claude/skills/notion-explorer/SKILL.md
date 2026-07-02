---
name: notion-explorer
description: Explore a Notion workspace read-only — map teamspaces, pages, and databases with their schemas, and sample records. Use when asked what exists in Notion, to find where something lives, or to "explore the Notion workspace".
allowed-tools: mcp__claude_ai_Notion__notion-search, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-get-comments, mcp__claude_ai_Notion__notion-get-users, mcp__claude_ai_Notion__notion-get-teams, mcp__claude_ai_Notion__notion-query-data-sources, mcp__claude_ai_Notion__notion-query-database-view, mcp__claude_ai_Notion__notion-query-meeting-notes
---

Uses the Notion MCP server (`mcp__claude_ai_Notion__*`). If those tools aren't
available or return auth errors, stop and tell the user to authenticate the
Notion connector first — don't fall back to the raw Notion REST API with
guessed tokens.

## Steps

1. **Teams/users**: `notion-get-teams` (and `notion-get-users` if who-has-access
   matters) — the workspace's top-level structure.
2. **Broad search**: `notion-search` with the topic keywords (or a `""`-style
   broad query per teamspace) — find top-level pages and databases.
3. **Fetch key pages**: `notion-fetch` on the hubs/indexes found — map the page
   tree one or two levels deep, don't crawl everything.
4. **Databases**: for each relevant database, fetch it to get the property
   schema (columns + types), then sample a handful of rows via
   `notion-query-data-sources` / `notion-query-database-view`. Always cap page
   size / result count — never pull a full database.

## Rules

- Read-only: never call `notion-create-*`, `notion-update-*`, `notion-move-*`,
  `notion-duplicate-*`, or comment-creation tools (the sys-explorer hook also
  blocks these by name pattern).
- Prefer search over exhaustive crawling; stop when the map answers the
  question.

## Output

A workspace map: teamspaces → key pages → databases (with property schemas and
a rough row-count feel), plus where the asked-about content lives. Flag
anything sensitive-looking (credentials pages, HR/PII databases) separately at
the top.
