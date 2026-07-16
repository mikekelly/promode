# Register sync: MK section + Components + decision node

## Brief
- **Orient** — `plugins/promode/docs/opinion-register.md` (house style: section tables, home keys, markers incl. ⚙/v/c/e, Components section). The committed outcomes + flagged duplications of tasks 31 and 32. Precedent: `tasks/24-brief-register-sync.md`. Decision-node exemplar: `docs/decisions/2026-07-agent-roster-restructure.md`.
- **Specify** — three deliverables in the register + one node:
  1. **New `## Marketing` section (MK items)** — ratified items only, house format (slug + statement + homes); tier-3 time-pinned empirical claims marked ⚙-analogue with verified-as-of dates and listed in the Harness-pinned-style currency block (or a parallel "market-pinned" block if cleaner — your call, state why). Record the M2/M3 duplications tasks 31/32 flagged.
  2. **Home-key + row updates** — add CMO (and senior-marketer) home keys to the preamble; update PD9 (carved routing), PD5 (marketing layer now owned), PD6 (fourth guise home), O2/O13/O39 (CMO joins the C-suite inherit seats — incl. the informed-tier-consent trigger list), and any row the carve touched.
  3. **Components entries** — AG-cmo, AG-senior-marketer (why-it-exists + coordination, citing not duplicating), DOC rows for each new routed doc.
  4. **Decision node `docs/decisions/2026-07-marketing-lane.md`** — decided: full lane (CMO inherit + senior-marketer opus/high), CPO carve (positioning/growth/channel → CMO; joint-growth both-draft-unprimed rule), docs/marketing/ ownership, three-tier mined-doctrine treatment, MIT provenance from coreyhaines31/marketingskills. Rejected + why: execution-rung-only (no seat); CMO-as-comms-only (too thin for inherit tokens); wholesale 47-skill import (M5 + opinions-not-tutorials — ~35/47 model-derivable or perishable); a sonnet marketing rung (generic workers cover it). Ratified 2026-07-15.
- **Why** — the register is the single evolvable home (M0); defs shipped in 31/32 are drift until their clauses trace to register items and the carve's row homes are consistent.
- **Verified vs assumed** — assumed the ratified-candidates doc and the two def outcomes are consistent; a mismatch (a def clause serving no ratified item, or a ratified item with no home) is a finding to surface in the report, not silently reconcile.
- **Not / exit** — do NOT edit the brief, README, defs, or hooks. Exit: register + node committed + Outcome.
- **Opportunistic (from task 37):** sync O4's literal register statement — it still reads "Always `run_in_background: true`" but the harness now backgrounds by default and the brief (post-37) says "never pass `run_in_background: false`"; update O4's wording to match (semantics unchanged — currently equivalent-but-stale, not drift).

## State
- **Established facts** — chained on tasks 31 AND 32 (needs their flagged duplications and final doc set).

## Outcome
**Done (2026-07-16).** Register + decision node committed. Invariant suite green (check-claude-md-imports, check-component-frontmatter — 19 agents, check-hooks).

### `plugins/promode/docs/opinion-register.md`
- **New `## Marketing` section** — 83 `mk-` rows (id | statement | homes), one per ratified register-worthy item, ordered by source domain. Preamble states the lane shape, `mk-` prefix, MIT provenance + unverified-claims status, the 5 kin-as-extensions, the subsumed payloads (no per-payload row), and the OKF non-ratification. Placed after Architecture, before Environment (the CTO/CPO/CMO C-suite-domain cluster: Product design → Architecture → Marketing).
- **New `⌛` "market-pinned" marker** (distinct from `⚙` harness-pinned) — defined in the Markers line + a new **`## Market-pinned (⌛)`** currency block (parallel to Harness-pinned), because the re-verify *trigger* differs (live platform/upstream, not a Claude Code release). Lists every ⌛ item + its trigger, the verified-as-of=2026-07-15-is-mining-not-checking caveat, and the tier-3-durables-that-aren't-⌛ (`mk-net-cash-over-roas`, `mk-retarget-different-offers`, `mk-forecasts-are-guesses`).
- **Home-key preamble** — added CMO, SM agent keys + the ten `mkt-*` doc keys; bumped "seventeen agent defs" → "nineteen".
- **Row/statement updates:** M0 (+CMO home, subsumes `mk-agentic-stack-thesis`), O2 (+CMO seat + joint-growth rule), **O4 (opportunistic sync — "Always run_in_background:true" → "never pass run_in_background:false"**, matches brief post-37), O11 (+`mk-two-tier-loop-actions` extension), O13 (CMO into inherit seats + frontmatter list), O14 (`mk-value-is-the-disagreement` kin cross-ref), O39 (CMO into the informed-tier-consent trigger), K7 (+CMO/SM orient, `mk-marketing-context-file` resolves here), K8 (statement widened to `docs/marketing/`), PD3 (+`mk-persona-proxy-ladder` extension), PD5 (+CMO owns the marketing layer), PD6 (+fourth guise + CMO), PD9 (positioning/growth carved CPO→CMO), R4 (+`mk-expert-panel-scoring` extension).
- **Components:** AG-cmo + AG-senior-marketer rows (why-it-exists + coordination, citing register slugs not duplicating); one **DOC-marketing** row enumerating all ten `marketing-*.md` docs (chose one grouped lane row over ten — mirrors DOC-d2d's multi-file precedent; each doc noted as an individual fork-decision point).
- **Documented calibrations:** new "Marketing lane" bullet recording the genuine both-homes duplications (5 dual-homed MK items decision↑/mechanics↓, the platform-doctrine stance, PD6 fourth guise, the three-pair joint-draft rule, `mk-offer-is-the-thing` as PD1 kin) — never collapse.

### `docs/decisions/2026-07-marketing-lane.md` (new)
Decided (full lane, CPO carve incl. joint-growth both-draft-unprimed, `docs/marketing/` ownership, three-tier mined-doctrine treatment, Decision A link-upstream, Decision B organic-before-paid) + rejected-with-why (execution-only, CMO-as-comms-only, wholesale 47-skill import, sonnet rung, vendoring payloads, OKF→IDEAS.md). MIT provenance, all quant unverified.

### Findings surfaced (P1/O37 — mismatches NOT silently reconciled)
1. **`mk-value-is-the-disagreement` scope of ratification point 2.** Task 32 flagged it as an O14/R4 *extension* (like the 5 kin), but the ratification block's point 2 enumerates **exactly five** kin-as-extensions and this slug is not among them (nor in task 30's "merge candidates" list). It carries genuine substance and is carried in `marketing-council.md` as a distinct item. **Resolved as its own MK row, noted as O14/R4 kin** (honouring the ratification's literal five-item enumeration over task 32's broader read). Cheap to reclassify to a pure extension if the maintainer intended it — flagging rather than silently folding.
2. **`⌛` vs `⚙` marker.** The task left the marker choice to me; I introduced a *new* glyph rather than overloading `⚙`, because bucketing market-pinned items under "re-verify on Claude Code change" would misdirect both harness audits and platform-currency checks. Stated in the Markers line + Market-pinned block.
3. **DOC granularity.** Chose one grouped DOC-marketing row (10 docs enumerated in-cell) over ten rows — consistent with DOC-d2d, keeps Components scannable, preserves per-doc fork-decision note. A maintainer wanting ten discrete DOC rows (strict existence-as-opinion) can split it.

### Not verified / assumptions
- Did **not** re-derive the ratified list from the 92 candidates independently — took the ratification block + tasks 31/32 Outcomes as the source of truth (as the brief directed). Verified each row's homes against the actually-shipped CMO/SM defs and confirmed all ten `marketing-*.md` docs exist; did **not** open each doc to confirm every item's in-doc presence (trusted task 32's item→home inventory, which I cross-checked against the def's `<specialism-docs>` list).
- Every quantitative MK claim is the source repo's, carried unverified (⌛ status) — not checked by me.
- Did not touch the brief, README, defs, or hooks (per Not/exit). The O4 sync was register-only wording; the brief's own O4 text was already updated in task 37.
