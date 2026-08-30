# Catalog data

This folder is the research source of truth. The Rails app will import these files later. Agents update JSON here. Agents do not write the database.

This catalog is informational. It is not medical advice. It is not legal advice. It is not a shop.

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
4. Add at least one `sources[]` row with `url` and `accessed_at`. Compound `summary` and `research_uses` need a regulator or literature source. A vendor URL is not enough.
5. Set `last_reviewed_at` to the day you opened those URLs (`YYYY-MM-DD`).
6. Label any amount or frequency notes as commonly reported research protocols. Do not write them as instructions.
7. Do not put a price on a compound file.

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

## Rules that fail `bin/rails catalog:check`

- Invalid JSON
- Missing `last_reviewed_at`
- Empty `sources`
- Deleted required keys
- Rumour records on the public index without a curator note
- Compound summary sources that are only vendor, encyclopedia, review, or news (need `regulator` or `primary_literature`)
- A present research use whose sources are only vendor or encyclopedia

Touch `last_reviewed_at` only when you opened the cited URL in that session.

## First drop (from the scout, 2026-08-25)

Providers (seen live): `reschem`, `biopeptics`, `tetratide-labs`, `the-clinic`, `comp-pharm`, `alphahuman`, `neuroactive`, `primeself`.

Starter compounds (cited 2026-08-26): `bpc-157`, `tb-500`, `semax`, `selank`, `ghk-cu`, `noopept`.

Products: only after the matching compound file exists, and only where a live page shows a form.

## Changelog

- 2026-08-30: Merge check rejects vendor-only and encyclopedia-only compound summaries.
- 2026-08-26: Six starter compound files with literature, SAHPRA, and WADA citations.
- 2026-08-25: Schema, templates, and first eight provider files. No compound research yet.
