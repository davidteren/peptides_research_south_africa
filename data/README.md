# Catalog data

This folder is the research source of truth. Agents update JSON here. Agents do not write the database.

This catalog is informational. It is not medical advice. It is not legal advice. It is not a shop.

A new agent should be able to add or refresh a record from this file. The merge check is the only gate.

## Layout

| Path | What it holds |
| --- | --- |
| `schema/` | JSON Schema for each record type |
| `_templates/` | Copy these. Keep every key. |
| `compounds/` | One file per compound (`bpc-157.json`) |
| `providers/` | One file per provider (`reschem.json`) |
| `products/` | One file per listing (`reschem-bpc-157-pen.json`) |
| `stacks/` | Empty until the stack checker ships. Schema exists now. |

## How to add a compound

1. Copy `_templates/compound.json`.
2. Set a new kebab `id`. Do not reuse a retired id.
3. Fill required fields. Use `null` or `[]` rather than deleting keys.
4. Add at least one `sources[]` row with `url` and `accessed_at`. See Citation rules.
5. Set `last_reviewed_at` to the day you opened those URLs (`YYYY-MM-DD`).
6. Label any amount or frequency notes as commonly reported research protocols. Do not write them as instructions.
7. Do not put a price on a compound file.
8. Fill a row on the [grade-review checklist](../docs/research/grade-review.md). A human can block a grade raise.
9. Run `bin/rails catalog:check`. Do not merge if it fails.

## How to add a provider

1. Confirm the site is live. If it is 404, set `"status": "down"` or do not add it.
2. Record only facts on the page: name, URL, city, forms, script step, currency.
3. Set `kind` from what the site is (research storefront, compounding pharmacy, clinic, oral retailer). Type is a classification, not a recommendation.
4. Quote marketing. Do not rewrite it as efficacy.

## How to add a product

1. The `compound_id` and `provider_id` files must already exist.
2. Use a live product URL. Quote the shop title verbatim.
3. If the price is login-gated, set `price_zar` to `null` and `price_visible_without_login` to `false`.
4. A non-null price needs `price_checked_on`.
5. `coa_stated` means the provider states a certificate. Do not host PDFs. Do not score purity.

## Citation rules

- A compound `summary` needs at least one `regulator` or `primary_literature` source. Vendor, encyclopedia, review, or news alone fails the check.
- A present research use needs `regulator`, `primary_literature`, or `review`. Vendor or encyclopedia alone fails.
- Wikipedia and other encyclopedia pages are jump-offs only. Add a primary source before publish.
- Vendor URLs support product facts only (title, form, price, COA claim). They do not support a compound summary.
- Amounts are commonly reported research protocols. They are never instructions.

## Open the URL. Do not guess.

1. Open every cited URL in the session that sets `accessed_at` or `last_reviewed_at`.
2. Quote what the page says. Do not invent a title, date, or finding.
3. Touch `last_reviewed_at` only when you opened the cited URL in that session.
4. If the page is gone, say so. Do not keep a dead URL as if it were live.

## First-drop order

The 2026-08-25 scout added providers first, then compounds, then products only where a live page showed a form. That history stays.

Ongoing rule: a compound file must exist before its product file. Do not add a listing for a compound that is not in `compounds/`.

## Bans

These are hard no. Grep this heading.

- No live scrape farm in the app or in this folder.
- No bulk PMC download.
- No Examine.com scrape. Examine.com remains a link-out only.

Do not add a crawler, a shop poller, or a paper-mirror job.

## Gate

The merge check is `bin/rails catalog:check`. Invalid JSON, missing `last_reviewed_at`, empty `sources`, or a vendor-only summary must not merge.

`config/ci.rb` runs the same command as the step named `Catalog: JSON merge check`. GitHub Actions runs `bin/rails test`, which includes the live catalog validator tests. Do not invent a second checker.

## Rules that fail `bin/rails catalog:check`

- Invalid JSON
- Missing `last_reviewed_at`
- Empty `sources`
- Deleted required keys
- Rumour records on the public index without a curator note
- Compound summary sources that are only vendor, encyclopedia, review, or news (need `regulator` or `primary_literature`)
- A present research use whose sources are only vendor or encyclopedia

## First drop (from the scout, 2026-08-25)

Providers (seen live): `reschem`, `biopeptics`, `tetratide-labs`, `the-clinic`, `comp-pharm`, `alphahuman`, `neuroactive`, `primeself`.

Starter compounds (cited 2026-08-26): `bpc-157`, `tb-500`, `semax`, `selank`, `ghk-cu`, `noopept`.

Products: only after the matching compound file exists, and only where a live page shows a form.

## Changelog

- 2026-08-30: Operator loop: citation rules, bans, live merge check, and grade-review checklist.
- 2026-08-30: Merge check rejects vendor-only and encyclopedia-only compound summaries.
- 2026-08-26: Six starter compound files with literature, SAHPRA, and WADA citations.
- 2026-08-25: Schema, templates, and first eight provider files. No compound research yet.
