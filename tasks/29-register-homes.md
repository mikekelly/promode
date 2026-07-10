# Register homes sync for the brief-concision pass (chained on task 28)

## Brief
- **Orient** — task 28's Outcome in `tasks/28-brief-concision.md` (where each R-clause landed) + the edited `plugins/promode/PROMODE_MAIN_AGENT.md`. Target: `plugins/promode/docs/opinion-register.md`.
- **Specify** — four ratified register edits:
  1. **A3** — its B home is now real (task 28's R1 clause). Update the homes cell to cite the actual section it landed in (B§role or B§execution); the `v` marker only if the wording is genuinely sentence-shared with CTO's — otherwise mark `c` (receiver-side calibration). Same for the CPO home if A3 doesn't already cite it (CPO's contract mirrors CTO's recommendation+rejected shape — task 23).
  2. **P14** — homes cell gains the brief home task 28 created (B§execution, receiver side: the main agent demands the assumptions line).
  3. **T16** — homes cell reflects the restored B§test-strategy clause.
  4. **New item `task-doc-hygiene`** (maintainer-ratified 2026-07-10) — the `<task-docs>` anti-drift doctrine currently serving no register item: open-loop-only (carry live task + last outcome, prior state recoverable from git), decisions-as-constraints-not-prose, and durability (a doc that may sit in Ready describes behavioural contracts/interfaces, not file paths — paths rot). One row in the Orchestration table (next O-number), statement + homes (B§task-docs), with the why.
  - If task 28's dedupes changed which section carries O19/O20/O24's brief-side text, adjust those homes cells to match reality (statement text unchanged).
- **Why** — the register is only trustworthy if its homes columns match the corpus (the A3 `v` marker was provably false — that class of rot is what this fixes); the anti-drift bullets are real house doctrine and the traceability rule demands they trace to an item or be cut — the maintainer chose: item.
- **Verified vs assumed** — verify each claimed home by actually grepping the edited brief; do not take task 28's report on faith for the homes cells you write (P1).
- **Not / exit** — do NOT edit the brief, defs, README, runbooks. Exit: register committed, every touched homes cell grep-verified against the brief, `scripts/check-claude-md-imports.sh` green.

## State
- **Open constraints** — blocked on task 28.

## Outcome
Four ratified register edits applied to `plugins/promode/docs/opinion-register.md`; `scripts/check-claude-md-imports.sh` green (and full `scripts/check-hooks.sh` green). Every touched homes cell was grep-verified against the edited brief before writing (P1) — did not rely on task 28's report.

**Grep-verified brief homes (locations, not memory):**
- R1 (A3 clause) — line 144, inside `<execution>` (tags at 143/147) → **B§execution**.
- R2 (P14 clause) — line 144, inside `<execution>` → **B§execution**.
- R3 (T16 clause) — line 150, inside `<test-strategy>` (tags at 149/151) → **B§test-strategy**.

**Edits:**
1. **A3** `recommendation-plus-strongest-rejected` (row): `CTO; B v` → `CTO; CPO v; B§execution c`.
   - The old `B v` was provably false (no B home existed pre-task-28). The new B home is task 28's R1 clause, which is *receiver-side* ("a C-suite draft arrives as recommendation + rejected — ratify against the rejected"), distinct from the producer-side statement → marked **`c`**.
   - Added **CPO `v`**: CPO's def (line 14) carries "Present a recommendation with the strongest rejected alternatives — not a survey." **byte-identical** to CTO's (line 14) — a verbatim producer pair. R1 also names both C-suite seats explicitly.
2. **P14** `assumptions-note-in-reports` (row): leading `B;` → `B§execution c;` (rest of cell unchanged). The plain `B` was aspirational (grep-absent pre-task-28); R2 made it real at §execution, receiver-side (the main agent applies the same skepticism to a report lacking the line) → **`c`**. Confirmed §execution/line-144 is the *only* P14 home in the brief (other "assumptions" hits are P1 evidence-over-assumptions L36, O15 verified-vs-assumed L100, PD4 user-need-claims L126 — not P14).
3. **T16** `seam-changes-are-architectural` (row): `SE; CTO; B` → `SE; CTO; B§test-strategy`. Located the previously-aspirational `B` to the restored §test-strategy clause. Left unmarked (not `v`): it is the fullest expression of a *convergent* stance — SE's def (L61) is calibrated ("surface it for the main agent... rather than deciding unilaterally"), CTO carries the seam-placement doctrine; no home shares B's exact three-party sentence, so `v` (which asserts a shared-wording family) would be misleading. SE/CTO left unmarked as before (out of this task's scope and defensibly convergent-unmarked).
4. **New `O46 task-doc-hygiene`** — inserted as the last Orchestration-table row (the table already ran to O45 `effort-pinned-per-def`; the CLAUDE.md snapshot showing O43-last was stale, so the "next O-number" is **O46**, not O44). Statement covers the `<task-docs>` anti-drift doctrine (open-loop-only, decisions-as-constraints, durability/contracts-not-paths) with the why baked in (M3: "the payoff is a doc a fresh session or the cross-session retrospective can act on without re-derivation"). Home: **B§task-docs**.

**O19/O20/O24 — verified, no adjustment needed:**
- **O19** `B§planning+§task-docs`: C1a cut §planning's Outcome-before-reporting + card-movement text, but those survive in the §task-docs Lifecycle (already a cited home); §planning still carries "persist one doc per task + card in Ready". Both sections remain legitimate homes.
- **O20** `B§project-tracking`: canonical home untouched; C1c *reduced* the §task-docs status duplicate, which was never a cited O20 home — the reduction reinforces §project-tracking as the single home.
- **O24** `B§planning`: §planning Fog discipline kept (gained the folded unique sentence); the deleted §task-docs Fog of war was never a cited home. Home unchanged.

**Not verified / assumptions:** I did not re-mark SE/CTO on the T16 row (out of scope; they were unmarked before). No register-slug or O-number-sequence CI check exists, so O46's placement/uniqueness is verified only by reading, not a script. Did not touch the brief, defs, README, or runbooks.
