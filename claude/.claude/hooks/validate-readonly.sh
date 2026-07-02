#!/bin/bash
# PreToolUse hook for the `sys-explorer` subagent (and any skill it loads).
# Best-effort backstop that blocks obviously-mutating Bash and MCP calls.
# This is defense-in-depth, not a substitute for read-only credentials at
# the source (see erp-explorer/SKILL.md for why that matters for
# Profisee/CluedIn specifically).

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# --- Bash commands: gcloud / bq / gsutil / curl ---
if [ "$TOOL_NAME" = "Bash" ] && [ -n "$COMMAND" ]; then
  if echo "$COMMAND" | grep -qE '\b(gcloud|bq|gsutil|bqetl)\b'; then
    if echo "$COMMAND" | grep -iE '\b(create|delete|update|patch|remove|set-iam-policy|add-iam-policy-binding|remove-iam-policy-binding|insert|rm|cp|mv|mb|rb|load|cancel|undelete)\b' > /dev/null; then
      echo "Blocked: sys-explorer is read-only. Mutating gcloud/bq/gsutil command: $COMMAND" >&2
      exit 2
    fi
    if echo "$COMMAND" | grep -iE '\b(INSERT|UPDATE|DELETE|MERGE|DROP|ALTER|TRUNCATE|CREATE)\b' > /dev/null; then
      echo "Blocked: sys-explorer is read-only. Looks like BigQuery DML/DDL: $COMMAND" >&2
      exit 2
    fi
  fi

  if echo "$COMMAND" | grep -qE '\bcurl\b'; then
    # Block explicit write HTTP verbs (covers Profisee REST writes).
    # Exception: POST to testIamPermissions is a read-shaped probe (gcp-explorer).
    if echo "$COMMAND" | grep -iE -- '-X\s*(POST|PUT|PATCH|DELETE)|--request\s*(POST|PUT|PATCH|DELETE)' > /dev/null; then
      if ! echo "$COMMAND" | grep -qE 'testIamPermissions|/graphql'; then
        echo "Blocked: sys-explorer is read-only. curl uses a write HTTP verb: $COMMAND" >&2
        exit 2
      fi
    fi
    # Heuristic for GraphQL (e.g. CluedIn): reads use POST too, so check the
    # operation keyword in the body instead of the HTTP verb.
    if echo "$COMMAND" | grep -iE '\bmutation\b' > /dev/null; then
      echo "Blocked: sys-explorer is read-only. GraphQL 'mutation' keyword found: $COMMAND" >&2
      exit 2
    fi
  fi
fi

# --- MCP tool calls: block anything shaped like a write, from any server ---
if echo "$TOOL_NAME" | grep -qi '^mcp__'; then
  if echo "$TOOL_NAME" | grep -iE '(create|update|delete|move|duplicate|insert|remove|archive|write|send|edit|upload|set-|set_|add-|add_)' > /dev/null; then
    echo "Blocked: sys-explorer is read-only. $TOOL_NAME looks like a write operation." >&2
    exit 2
  fi
fi

exit 0
