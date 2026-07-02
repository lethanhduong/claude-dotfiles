---
name: erp-explorer
description: Explore Profisee (MDM, REST/OData) and CluedIn (MDM/data catalog, GraphQL) — list entities/models, inspect schema, sample records, read-only. Use when asked to explore master data, Profisee, or CluedIn.
allowed-tools: Bash(curl -s:*), Bash(curl -sS:*)
---

Requires environment variables set by the user beforehand — never invent
values for these:

- Profisee: `PROFISEE_BASE_URL`, `PROFISEE_TOKEN` (or `PROFISEE_API_KEY`)
- CluedIn: `CLUEDIN_BASE_URL`, `CLUEDIN_ACCESS_TOKEN`

If any are missing, stop and ask the user to set them rather than guessing at
a base URL or trying unauthenticated requests.

## Profisee (REST, OData)

- `GET {PROFISEE_BASE_URL}/<metadata path>` with `Authorization: Bearer
  $PROFISEE_TOKEN` — lists entities (tables) and attributes (columns) of the
  master data models. Exact metadata path depends on the instance/version —
  check the instance's own API docs or Swagger page if available.
- List/sample records with OData query params: `$top` (cap the page size),
  `$filter`, `$select`. Always set `$top` — never fetch an unbounded result set.
- GET only. Profisee's write operations are POST/PUT/PATCH/DELETE — never use
  those verbs in this skill under any circumstance.

## CluedIn (GraphQL)

- `POST {CLUEDIN_BASE_URL}/graphql` with `Authorization: Bearer
  $CLUEDIN_ACCESS_TOKEN`. GraphQL reads go over POST too, so the HTTP method
  doesn't tell you if a call is safe — the operation keyword in the body does.
- Only ever send `query { ... }` operations. Never send `mutation { ... }`.
- Start with introspection to see what's available:
  `{ __schema { types { name } } }`
- Then query entities by ID, full-text search, or property value per CluedIn's
  GraphQL docs. Prefer search/read-shaped fields; avoid anything named like a
  command (`merge`, `delete`, `apply`, `action`).

## Important caveat

Command-pattern safety checks (allowed-tools, hooks) can't reliably tell a
GraphQL query from a mutation inside a POST body, and can't catch every REST
write shape. For these two systems specifically, the real safety boundary is
a **read-only service account or API token issued at the source** — ask the
Profisee/CluedIn admin for one rather than relying only on this skill's
instructions.

## Output

Per system: what models/entities exist, their attributes, and a few sampled
records (redact anything that looks like PII/secrets in the summary rather
than the raw data itself).
