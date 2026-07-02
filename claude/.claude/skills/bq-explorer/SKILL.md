---
name: bq-explorer
description: Explore BigQuery read-only — datasets, tables, schemas, sizes, AND sample data to understand it two ways: as a senior Data Analyst (what the data means for the business) and as a senior Data Engineer (how the data flows, freshness, quality, lineage). Cost- and performance-aware. Use when asked what data exists in BigQuery, to profile/sample a dataset, or to "explore BigQuery".
allowed-tools: Bash(bq ls:*), Bash(bq show:*), Bash(bq head:*), Bash(bq query:*)
---

Read-only exploration. You inspect and sample data to build understanding — you
never change it. Two lenses, run whichever the user needs (or both):

- **DA lens (business):** what does this data mean? entities, key metrics,
  dimensions, value distributions, date coverage.
- **DE lens (pipeline):** how does the data flow? freshness, row growth,
  partitioning, keys/dupes/nulls, source → staging → mart lineage.

## Step 1 — Inventory (metadata, free)

1. `bq ls --project_id=<p> --format=json` → datasets. Pipe through `python3 -c`
   to print just IDs (raw prettyjson floods context on big projects):
   ```
   bq ls --project_id=<p> --format=json | python3 -c "
   import json,sys; d=json.load(sys.stdin)
   print(len(d)); [print(x['datasetReference']['datasetId']) for x in d]"
   ```
2. `bq ls --project_id=<p> --format=json <dataset>` → tables (print `type` too:
   TABLE / VIEW / EXTERNAL).
3. `bq show --format=prettyjson <dataset>.<table>` → schema, row count, size,
   partitioning/clustering, description. **Free** — read this before any query.
4. Inventory many tables in one query (dry-run first):
   ```
   SELECT table_id, row_count, size_bytes,
          TIMESTAMP_MILLIS(last_modified_time) AS last_modified
   FROM `<p>.<dataset>.__TABLES__` ORDER BY size_bytes DESC
   ```

## Step 2 — Sample rows to understand the data

Get a feel for real values, not just column names.

- **Preview is FREE — prefer it:** `bq head -n 20 <dataset>.<table>` reads rows
  directly, **scans 0 bytes, costs nothing**. Use this as the default sampler
  instead of `SELECT * LIMIT`.
- **`SELECT ... LIMIT n` still scans the whole table** for the selected columns
  (LIMIT caps rows *returned*, not bytes *read*). So when you must query:
  - `SELECT` only the columns you need — never `SELECT *` on a wide table.
  - Add a **partition filter** (e.g. `WHERE _PARTITIONDATE >= ...` or the
    partition column) to prune bytes — this is the biggest cost lever.
  - For a spread-out sample use `TABLESAMPLE SYSTEM (1 PERCENT)` rather than a
    full scan.

## Step 3a — DA lens (business meaning)

Cheap profiling queries (always dry-run first, filter a partition if possible):

- **Distinct / cardinality:** `APPROX_COUNT_DISTINCT(col)` — is it a key, a
  category, or free text? (APPROX is far cheaper than exact `COUNT(DISTINCT)`.)
- **Top values of a dimension:**
  `SELECT col, COUNT(*) c FROM t GROUP BY col ORDER BY c DESC LIMIT 20`
- **Date coverage / grain:** `SELECT MIN(dt), MAX(dt), COUNT(*) FROM t` — what
  period does this cover, one row per what?
- **A headline metric:** sum/avg of the obvious measure by the obvious dimension
  (revenue by month, orders by store) to confirm the table means what its name
  says.

Report in business terms: "this is one row per <grain>, covering <dates>, key
metric <X>, main dimensions <...>".

## Step 3b — DE lens (data flow & quality)

- **Freshness:** `MAX(updated_at / ingested_at / _PARTITIONTIME)` vs now — is the
  pipeline current or stale? Cross-check `last_modified` from `__TABLES__`.
- **Key integrity / dupes:**
  `SELECT id, COUNT(*) c FROM t GROUP BY id HAVING c > 1 LIMIT 10`
- **Null rate on important columns:**
  `SELECT COUNTIF(col IS NULL)/COUNT(*) FROM t` (filter a partition).
- **Lineage by convention:** read naming — `*_staging` / `*_raw` / `*_external`
  → source & landing; `*_datamart` / `*_report` / views → curated/serving.
  `bq show` on a VIEW reveals its SQL → the upstream tables it reads (free).
- **Shape:** partition column, clustering, EXTERNAL source URI (`bq show` shows
  the GCS/Sheets/etc. backing an external table).

Report as a flow: source → staging → mart, plus freshness and any quality flags
(dupes, high null rate, stale partition).

## Performance & cost discipline (mandatory)

- **Always `bq query --dry_run --use_legacy_sql=false '<sql>'` first** — it
  prints bytes-to-be-scanned with $0 cost. Report the estimate; if it's large
  (say > a few GB), reconsider or tighten the filter before running for real.
- **Cap the bill** on any real query as a seatbelt:
  `bq query --use_legacy_sql=false --maximum_bytes_billed=1000000000 '<sql>'`
  (1 GB) — the query is rejected rather than scanning more.
- Prefer `bq head` (free) and `bq show` (free) over queries wherever they answer
  the question.
- One `INFORMATION_SCHEMA` / `__TABLES__` query beats N per-table calls.

## Read-only rules (hard)

- **No DML** (`INSERT`/`UPDATE`/`DELETE`/`MERGE`/`TRUNCATE`), **no DDL**
  (`CREATE`/`ALTER`/`DROP`), **no** `bq mk` / `bq rm` / `bq load` / `bq cp` /
  `bq insert`. Exploration only touches metadata and reads rows.
- Never write query results back to a destination table (`--destination_table`,
  `CREATE TABLE AS`) — return samples inline instead.
- If a read fails on permission, record it as a finding ("no access to X"), do
  not retry with write-shaped workarounds.

## Output

1. **Inventory:** dataset → table list with row counts / sizes.
2. **DA view** (if asked): grain, date coverage, key metrics, main dimensions,
   a few sampled rows.
3. **DE view** (if asked): source→staging→mart flow, freshness, partitioning,
   quality flags (dupes / nulls / stale).
4. **Cost note:** bytes scanned / estimated for the queries you ran.
Flag anything sensitive (PII columns, credentials-looking data) separately.
