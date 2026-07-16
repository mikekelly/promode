# Auditor: marketing-traceability (knit) dimension

## Brief
- **Orient** — `plugins/promode/agents/auditor.md` (dimension structure, fan-out mechanics, light-check routing, R8 slug-tagging). Register state from task 33 (PD5/PD6/MK rows). The CMO/senior-marketer defs (what the owning agents uphold in-flight — the audit dimension mirrors it, per O36's design).
- **Specify** — extend the auditor with a **marketing-traceability assessor dimension** checking the knit across the PD5 hierarchy:
  - every `docs/marketing/` doc cites the goal it serves and the `docs/product/PERSONAS.md` persona it targets (citations, not forked copies — K5);
  - no cross-layer contradictions: positioning in marketing docs vs product docs; personas targeted vs personas established; features the marketing strategy leans on vs features actually defined;
  - **orphans in both directions are findings** (V5): a marketing doc serving no live goal (stale strategy / goal proliferation), and a goal or shipped feature with no marketing representation;
  - PD6 fourth guise: campaign/positioning claims retro-fitted to goals they never served;
  - findings tag register slugs (R8); the light-check route holds — a targeted knit check goes to the owning agent (CMO or senior-marketer), not a fan-out.
  Also update the affected register row homes (AUD gains the relevant MK/PD5 homes) — this task owns that one register touch since it's the enforcement (`e`) marker.
- **Why** — ratified 2026-07-15: the audit couldn't flag a broken knit at a layer with no docs and no owner; now that the lane owns the layer, the corpus-wide check completes the loop (owning agents uphold in-flight, auditor verifies corpus-wide).
- **Verified vs assumed** — assumed the auditor's dimension list is extensible without restructuring its fan-out; if adding a dimension forces a broader auditor redesign, stop and report (O37) rather than reshape.
- **Not / exit** — do NOT edit the brief, README, CMO/senior-marketer defs, or other register rows. Exit: auditor def + register-home touch committed + Outcome.

## State
- **Established facts** — chained on task 33; can run in parallel with task 34 (disjoint files).

## Outcome
**Done — 2026-07-16.** Added the **Marketing traceability (knit)** dimension to `plugins/promode/agents/auditor.md`:
- New `<dimensions>` table row (conditional, suggested assessor `promode:senior-marketer`), placed after the Design row (both conditional).
- New `<marketing-traceability>` detail block (after `<design-system-visual-loop>`), mirroring `<framing-traceability>`, with five checks: (1) strategy nodes cite (never fork) goal + persona — `K5`; (2) no cross-layer contradictions (positioning / personas-targeted-vs-established / features-leaned-on-vs-defined); (3) orphans both directions are findings — `V5` (downward = stale strategy/goal proliferation, upward = goal/shipped feature with no GTM); (4) no post-hoc campaign justification — `PD6` fourth guise; (5) platform-pinned doctrine currency-checked — `mk-platform-doctrine-time-pinned` (dated sections aged past their re-verify trigger = findings). Closes with the light-check route (targeted knit spot-check → CMO for strategy layer / senior-marketer for execution, not a fan-out) and R8 slug-tagging (already carried by the assessor brief).

Register-home touches (AUD `e` enforcement marker) in `opinion-register.md`: **PD5** (audits the marketing-layer knit corpus-wide), **PD6** (checks the fourth guise corpus-wide), **`mk-platform-doctrine-time-pinned`** (currency-audit).

Invariant checks green: `scripts/check-hooks.sh` (full suite) + `scripts/check-component-frontmatter.sh` (21 components valid). No auditor restructure was needed — the dimension list was extensible as assumed; fan-out mechanics untouched.

**Decisions-as-constraints for later agents:** the dimension is a *reusable lens* (three cadences), not a full-sweep-only step — its light-check owner is CMO (strategy) / senior-marketer (execution). The AUD `e` homes on PD5/PD6/mk-platform-doctrine are the enforcement record; do not add a rival knit slug — this dimension enforces existing items.
