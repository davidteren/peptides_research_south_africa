# Intent Engineering: validate later-epic plans

- **Skill:** ie-validate-plan
- **Context:** plan
- **Date:** 2026-08-30
- **Docs:** `docs/plans/2026-08-30-00{6-9}-*.md`
- **Lenses:** predictability, convention, simplicity, experience (plus security on 009)
- **Config source:** defaults (no `.intense/` in this repo)

Blocking gaps from the first pass were applied in the plan files.

## Verdict

Ready to implement after review edits.

| Plan | Epic / issues | Verdict |
| --- | --- | --- |
| 006 PWA and device saves | EP-06 `#56` `#65` `#67` `#69` `#71` `#73` `#75` | Ready |
| 007 Stack checker | EP-08 Phase 4 `#60` `#66` `#68` `#70` `#72` `#74` | Ready |
| 008 Arithmetic helper | F-20 `#76` `#77` | Ready |
| 009 Accounts and native | EP-09 `#50` `#52` `#53` `#54` `#55` `#57` | Ready |

## Applied review edits

**006**

- Service worker caches Turbo Drive HTML GETs, not only navigations.
- Propshaft: runtime-cache digested CSS/JS. Do not precache undigested asset paths.
- `/saved` paints from localStorage slugs with no fetch. Route string pinned.
- Worker registration lives in `application.js` (no extra importmap pin).
- Uncached offline URLs may fail.

**007**

- "Fails the checker" means invalid ids or fewer than two members. WADA and class overlap still publish with warnings.
- Route note rule is one injectable vs none, not a pharmacology clash.
- Checker is `GET /stacks/check`, not POST create.
- Empty `data/stacks/` is valid.

**008**

- Error state `#arithmetic-error`. Never render 0 for bad input.
- `#arithmetic-formula` on the page.
- Nav-only entry. No compound-show link.
- U1 may land early. Do not merge the page before `/stacks/check`.

**009**

- Magic link expires in 15 minutes. Invalid token has `#login-token-invalid`.
- Rate-limit POST /login.
- Create user on successful click, not on the request.
- Signed-in save routes and server-truth `aria-pressed`.
- Merge accept and decline ids.

## Residual (not blocking)

- Playwright still depends on plan 001 scaffold.
- Native wrapper (U4 of 009) stays skipped until plan 006 is on `main`.
- Production mail provider is an operations choice.
- `#72` publish wording is an explicit product mapping in R4. Change it only if the curator wants class-overlap to block JSON.

## Coverage

ce-doc-review personas: coherence, feasibility, product, design, scope-guardian. Security on 009. Architecture lens skipped (plan mode). Stack-checker review agent hung after research; that plan was reviewed in-session against EPICS, schema, and `lib/catalog.rb`.
