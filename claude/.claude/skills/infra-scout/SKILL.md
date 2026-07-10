---
name: infra-scout
description: Find where to host or run a project — the right provider/service for each infra need, favoring free tiers. Use whenever the user is about to deploy, ship, or launch an app/web/API/bot/side-project and needs to pick where it lives, or asks "where do I host this", "what's a free way to run X", "cheapest way to deploy", "free database/storage/CDN/email/cron/queue", or "what free tier covers this". Sources the live free-for.dev catalog so limits stay current instead of going stale.
argument-hint: [what you're building, or a category like "postgres" / "static site" / "email"]
allowed-tools: Read, WebFetch
model: sonnet
---

## What this does

Turns "I built X, where do I put it?" into a short, current shortlist of providers per
infra need — with the actual free-tier limits and the catch for each — then a pick.

The catalog is **[free-for.dev](https://free-for.dev/)** (source:
`github.com/ripienaar/free-for-dev`, `README.md`). It changes weekly, so **fetch it
live** — never answer free-tier limits from memory; they go stale and get people billed.

## Steps

1. **Pin down the needs.** From the request, list the infra pieces the project actually
   requires. Don't guess more than the app needs (a static site needs hosting + maybe a
   form endpoint — not a Postgres cluster). Common buckets:

   | Need | free-for.dev section to look at |
   |------|--------------------------------|
   | Run a frontend / static site | Web Hosting, Static/JAMstack |
   | Run a backend / API / container | PaaS, IaaS, Serverless / FaaS |
   | Database | Databases (Postgres, MySQL, Mongo, Redis) |
   | File / object storage | Storage and Media Processing |
   | CDN / edge | CDN |
   | Auth / users | Identity / Authentication |
   | Send email | Email / Transactional email |
   | Background jobs / cron / queue | Cron / Background, Message queues |
   | Domain / DNS | DNS, Domains |
   | CI/CD, secrets, monitoring, logs, errors | the correspondingly-named sections |
   | LLM / AI inference | look under APIs / AI, or say if not covered |

   If the request is vague ("host my app"), ask one or two sharp questions: *is it a
   static site or does it run server code? does it need a database? roughly how much
   traffic?* — then proceed. Don't stall.

2. **Fetch the live catalog** with WebFetch on `https://free-for.dev/` (or the raw
   README `https://raw.githubusercontent.com/ripienaar/free-for-dev/master/README.md`
   if the site is unreachable). In the WebFetch prompt, name the specific sections and
   the need — e.g. *"list providers under PaaS and Databases with their free-tier
   limits for hosting a small Node API with a Postgres database."* This keeps the
   response scoped instead of dumping the whole (very long) page.

3. **Shortlist, don't dump.** For each need, give the **2–4 strongest** options, not the
   full list. Each option gets: provider, the free-tier limit that matters, and the
   **catch** (sleeps after inactivity, cold starts, egress fees, card required, row cap,
   sunset risk). The catch is why this skill exists — a free tier with a trap is worse
   than a cheap paid tier the user chose knowingly.

4. **Recommend a stack.** Close with one concrete pairing that covers all the needs
   together (e.g. *"Cloudflare Pages for the frontend + a Railway/Fly service for the
   API + Neon for Postgres"*), and one line on when to reach for the paid tier or a
   different provider. Note lock-in if the pick is hard to leave.

## Output shape

```
## <project> — where to host

**Needs:** <compute type> · <db?> · <storage?> · <other>

### <Need 1, e.g. API hosting>
- **<Provider>** — <free limit>. Catch: <the gotcha>.
- **<Provider>** — <free limit>. Catch: <the gotcha>.

### <Need 2, e.g. Postgres>
- ...

## Recommended stack
<one concrete pairing> — <one line on why, and the upgrade trigger>.
```

## Notes

- Free-for.dev skews toward developer infra. If a need isn't covered there (e.g. a niche
  managed service), say so plainly and fall back to general knowledge — don't force a bad
  fit from the list.
- Always surface **card-required** vs. **truly free** — for a throwaway or a student
  project that distinction is the whole decision.
- ponytail: no scripts, no cached provider DB. The value is the live fetch + the "catch"
  column; a local copy would just rot.
