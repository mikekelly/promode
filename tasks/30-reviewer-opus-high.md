# Move code-reviewer to Opus / high effort

## Brief
- **Orient** — `plugins/promode/agents/code-reviewer.md` (currently `model: sonnet`, no `effort:`, description says "Defaults to Sonnet for standard review; pass model: opus for complex architectural review"). The tier's other homes: `plugins/promode/PROMODE_MAIN_AGENT.md` `<model-tiers>` + `<delegation-map>`, `plugins/promode/docs/opinion-register.md` (O13 row + AG-code-reviewer row), README agents table (`code-reviewer` row, currently the only execution row with no tier annotation).
- **Specify** — one deliverable: the reviewer runs opus/high everywhere the tier is recorded, consistently.
  1. Def frontmatter: `model: opus` + `effort: high`. Description rewritten to state the pin; mirror the debugger's inverse lever: "pass `model: sonnet` for simple mechanical diffs".
  2. Brief `<model-tiers>`: add `code-reviewer` to the **opus / high** bullet (it is on no bullet today). `<delegation-map>`: annotate the code-review line `(opus/high)`.
  3. Register: O13 statement's opus/high enumeration gains `code-reviewer`; AG-code-reviewer "why" column gains the tier + its why (below), citing O13.
  4. README agents table: append "(Opus / high effort)" to the code-reviewer row, matching the table's style.
  5. Supersession record (M3, never silently delete a stance): append a dated amendment to `docs/decisions/2026-07-agent-roster-restructure.md` — code-reviewer sonnet→opus/high (2026-07-16, owner call), old default-sonnet + upgrade-lever stance superseded; the lever inverts (downgrade to sonnet per-dispatch).
- **Why** (travels with the rule in each home — M3): review is a judgement seat, not mechanical execution — its APPROVED/REWORK verdict gates merges and it's the enforcement home for the seam/tier/tracer/crystallise checks; a misjudged approval costs far more than the sonnet→opus delta, and the old "remember to pass model: opus when it's architectural" made the upgrade a forgettable dispatch decision, exactly what the pre-baked ladder exists to avoid (O13/M0).
- **Verified vs assumed** — verified: all five homes above located by grep; the checksum guard (`scripts/check-shared-principle-checksums.sh`) covers body blocks only, frontmatter/description changes don't touch it. Assumed: no other home records the reviewer's tier (grep for `code-reviewer` near model/tier terms came back clean elsewhere).
- **Not / exit** — do NOT touch the def's body blocks (`<behavioural-authority>` is checksum-guarded across 5 defs), the debugger's own model advice, or any other rung's tier. Exit: all edits in, `scripts/check-hooks.sh` and `scripts/check-shared-principle-checksums.sh` green (the brief edit must keep every chunk < 10k), changes committed.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — brief hook-output 10k cap per chunk; body-block checksums must not change
- **Established facts** — homes enumerated above; owner ratified the tier change 2026-07-16
- **Pending goals / next step** — execute the sync

## Outcome

All five homes synced, `code-reviewer` now runs opus/high everywhere the tier is recorded:

1. `plugins/promode/agents/code-reviewer.md` — frontmatter `model: opus` + `effort: high`; description rewritten to state the pin with the inverted lever ("pass `model: sonnet` for simple mechanical diffs").
2. `plugins/promode/PROMODE_MAIN_AGENT.md` — `<delegation-map>` code-review line annotated `(opus/high)`; `<model-tiers>` opus/high bullet gains `code-reviewer`.
3. `plugins/promode/docs/opinion-register.md` — O13 statement's opus/high enumeration gains `code-reviewer`; AG-code-reviewer row's "why" column gains the tier + its why, citing O13.
4. `README.md` — code-reviewer agents-table row appends "(Opus / high effort)", matching the table's style.
5. `docs/decisions/2026-07-agent-roster-restructure.md` — appended a dated "Amendment (2026-07-16, owner call)" section recording the sonnet→opus/high supersession, the old default-sonnet + upgrade-lever stance, and the inverted lever, without deleting the original node text (M3).

Did NOT touch: the def's body blocks (checksum-guarded `<behavioural-authority>` family — code-reviewer stayed in the family, unchanged content), the debugger's own model advice, or any other rung's tier.

**Checks:** `scripts/check-hooks.sh` — green (all sub-checks incl. hook-output-limits, chunk-registration, agent-gating, and `check-shared-principle-checksums.sh` as its last step). `scripts/check-shared-principle-checksums.sh` run standalone — also green (`<behavioural-authority>` still byte-identical across the 5 homes including code-reviewer.md).

**Not verified / assumptions:** relied on the brief's grep sweep (task doc's "Verified vs assumed") that no other home records the reviewer's tier — did not re-grep beyond the five homes named in the brief plus the roster-restructure decision doc.
