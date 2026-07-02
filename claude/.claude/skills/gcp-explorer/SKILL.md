---
name: gcp-explorer
description: Explore a logged-in GCP account's identity, IAM roles, and enabled APIs for a project. Use when asked to check GCP permissions, what a user/service account can access, or to "explore this GCP project" (not BigQuery data itself — see bq-explorer for that).
allowed-tools: Bash(gcloud auth list), Bash(gcloud config list), Bash(gcloud config get-value:*), Bash(gcloud projects list:*), Bash(gcloud projects describe:*), Bash(gcloud projects get-iam-policy:*), Bash(gcloud iam roles list:*), Bash(gcloud iam roles describe:*), Bash(gcloud services list:*), Bash(gcloud auth print-access-token), Bash(curl -s -X POST https://cloudresourcemanager.googleapis.com/*)
---

## Steps

1. **Identity**: `gcloud auth list`, `gcloud config list`
2. **Project**: `gcloud config get-value project`, `gcloud projects describe <project>`
   (or `gcloud projects list` if scope is unclear)
3. **IAM**: `gcloud projects get-iam-policy <project> --format=json` — filter the
   bindings down to the active account's email/service-account, don't dump the
   whole policy. Use `gcloud iam roles describe <role>` for any role name that
   isn't self-explanatory.
4. **IAM fallback — testIamPermissions**: low-privilege accounts usually can't
   read the IAM policy at all (`getIamPolicy` itself needs a permission). Probe
   what the identity actually holds instead:
   ```
   curl -s -X POST "https://cloudresourcemanager.googleapis.com/v1/projects/<project>:testIamPermissions" \
     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: application/json" \
     -d '{"permissions":["resourcemanager.projects.get","resourcemanager.projects.getIamPolicy","bigquery.datasets.get","bigquery.jobs.create","bigquery.tables.list","storage.buckets.list","storage.objects.list"]}'
   ```
   The response lists only the permissions the caller holds. Adjust the probe
   list to what's relevant (BigQuery, Storage, Pub/Sub, ...).
5. **Enabled APIs**: `gcloud services list --enabled` — note anything relevant
   to data work (BigQuery, Storage, Dataflow, Pub/Sub).

## Known failure mode: stale quota_project

If *every* command fails with `USER_PROJECT_DENIED` / "does not have required
permission to use project X", check `gcloud config list` for a
`billing/quota_project` pointing at a project this account can't access — the
request dies on the quota header before the real permission check. Fixing it is
a config change (out of read-only scope): report it and give the user the fix,
`gcloud config unset billing/quota_project`.

## Rules

- Read-only: never `create`, `delete`, `update`, `set-iam-policy`,
  `add-iam-policy-binding`, or similar.
- Don't guess project IDs or emails — read them from `gcloud config` /
  `gcloud auth list` first.
- If a command fails on permission, record it as a finding ("this identity
  lacks access to X") instead of retrying with different flags.

## Output

Identity + project(s), IAM roles/permissions held in plain language (not just
role IDs), and enabled APIs relevant to data work. Flag broad roles like
`roles/owner` or `roles/editor` explicitly.
