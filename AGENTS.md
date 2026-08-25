# AGENTS.md — how to work here

Read this before touching code or catalog files. `CLAUDE.md` just points here.

## What this is

A South Africa research catalog for peptides, nootropics, and local providers. JSON in `data/` is the source of truth. A Rails 8.1 app will present it. Public name is TBD.

Product truth lives in `docs/`: [PRD.md](docs/PRD.md) (F-1 to F-23), [EPICS.md](docs/EPICS.md) (EP-01 to EP-09), [ROADMAP.md](docs/ROADMAP.md), [scout-inventory.md](docs/research/scout-inventory.md). The human board is [STATUS.md](STATUS.md). **If code and docs drift, update the docs in the same commit.**

## Hard rules

1. **Informational catalog only.** Do not give medical advice, legal advice, or a protocol. Label amounts as commonly reported research protocols. Do not present a research storefront as a licensed medicine.
2. **JSON is the research source of truth.** Agents update `data/*.json`. Agents do not write PostgreSQL. Invalid JSON, missing `last_reviewed_at`, or empty `sources` must not merge.
3. **Cite, do not invent.** Compound summaries need a regulator or literature source. Open the URL in the session. Vendor pages may support product facts only.
4. **Never features.** No checkout, order buttons, live stock theatre, clinic booking, personal dosing, injection guides, AI protocol generators, a full drug-interaction engine, user efficacy reviews, paid ranking, hosted COA PDFs as proof, or a traffic-light "legal to buy".
5. **Secrets never rendered, logged, or committed.** `config/master.key` stays gitignored.
6. **Input integrity (speech-to-text).** High-blast actions (ignore, delete, force-push, private/public, secrets, production, path-wide destroy) need a second signal: exact path, typed confirm, or an explicit restate. If a noun is not a known path, branch, or board term, and the action is high-blast, ask. Never invent **public**. If visibility is unset, stop and ask.
7. **Shared labels.** Chat may only use IDs on STATUS.md, the PRD, EPICS, ROADMAP, or GitHub issues. Do not invent `C1` or "track A". Write a new ID on the board before using it in chat.

## Git workflow

- **Phase 1 to Phase 3: commit to `main`** in small atomic commits. This is a solo catalog. Flip to branch + PR when a second contributor appears, or at Phase 4 (stacks), whichever comes first.
- Commit subjects: imperative, plain ("Add BPC-157 compound record"). Reference a story as `(#23)` once issues exist. Close with `Closes #23` when the commit completes it.
- Never commit a failing suite. `bin/ci` green before push of app code. JSON-only commits must still be valid JSON.

## Review gate — before opening a PR (hard stop)

Do not run `gh pr create` until `/dt-ship-pre-pr-gate` has finished on the **exact PR-head SHA**: `/ce-code-review` → `/ie-review` → `/cubic-loop` (local). Fix findings between steps. Any commit after the gate voids it. Re-run before create.

After the PR is open: wait for remote CI and review bots; re-run the three lenses on the PR; reply on every thread (`**Grok:**` first) with the fix and SHA, or why not, or a GitHub issue number if deferred. Never resolve a thread before the reply exists. Never merge unless the human asks.

Milestone end also gets a deeper pass: `dte-deep-reviewer`, `dte-test-auditor`, and `/security-review` if the work touches auth, scraping, or secrets.

## Tool and skill playbook

**Discovery, in this order:**
1. Augment `codebase-retrieval` first for "how / where does X work".
2. Grep or glob for every call of a known name.
3. LSP or IDE tools for definition and references.

**Catalog research:** Firecrawl or web fetch for public pages. Quote facts. Record `accessed_at`. Do not scrape Examine.com. Do not bulk-download PMC.

**Runtime check:** Chrome DevTools MCP against the running app. Verify every UI story before the review gate.

**Building UI:** `/ui-design` plus `frontend-design`. Hotwire skills (`turbo-frames-patterns`, `turbo-streams-patterns`, `stimulus-patterns`, `turbo-morphing`) before hand-rolling. Tailwind via `tailwind-coder`.

**Building backend:** `layered-rails` for placement. `solid-queue-coder` / `solid-cache-coder` for jobs and cache. `minitest-coder` and `rails-testing` for tests. `dte-pwa` when Phase 3 turns the PWA on.

**Planning:** `/ce-plan` then `/ce-work`. Security: `/security-review` or `dte-security-sweep`.

## Testing policy

- **Minitest** for models, jobs, controllers, integration. Fixtures over factories.
- **Playwright** in `e2e/` for every user-facing flow from the first catalog screens. `npx playwright test`.
- **Stable DOM ids are mandatory:**
  - Every interactive or assertable element gets a semantic kebab-case `id`.
  - Repeated elements: `data-testid` for the kind plus a unique `id` per instance.
  - Playwright selectors use ids and test-ids only. Never CSS structure or text.
  - Renaming an id is a breaking change. Update specs in the same commit.
- Non-trivial logic ships with its test in the same commit.

## Conventions

- Ruby 3.4.9 / Rails 8.1. PostgreSQL only. RuboCop as generated (`bin/rubocop`).
- Views: semantic HTML + Tailwind. English strings stay out of Ruby.
- Issue and PR bodies open with plain-language **What / Why / How**. No code symbols in that block.
- Devcontainer is a contributor tool. Local Postgres uses the socket unless `DB_HOST` is set.
