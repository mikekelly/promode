# Def↔register conformance audit (forward pass)

## Brief
- **Orient** — the register (`plugins/promode/docs/opinion-register.md`, auto-imported into every agent session here), all 11 defs in `plugins/promode/agents/`, `runbooks/sync-a-shared-principle.md`.
- **Specify** — first dedicated FORWARD verification of the register-traceability constraint over the agent defs: (a) per def, every clause maps to the register slug(s) it serves, or is flagged ORPHAN; (b) statements contradicting the register or a sibling def flagged; (c) each def's existence justified against its Components row (does the def actually do what the row claims?). Method: 11 parallel per-def checkers (register arrives via @-import) → main-agent synthesis. Verdict per def + a consolidated orphan/conflict list.
- **Why** — the register was derived FROM the defs (backward); "every clause serves an item" (forward) has only been checked on the migration's new defs. Maintainer asked for the affirmative answer; this pass earns it.
- **Not / exit** — read-only for checkers (report, change nothing); fixes ratified + dispatched separately. Outcome: synthesis recorded here.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — checkers read-only
- **Established facts** — 09 backward pass clean at its snapshot; migration review clean on new defs
- **Pending goals / next step** — fan out 11 checkers, synthesise

## Outcome
**Synthesis (2026-07-07, all 11 checkers reported).** Verdicts: 3 CONFORMANT (SE, FW, DBG), 8 CONFORMANT-WITH-FINDINGS, 0 NONCONFORMANT.

**Answers to the maintainer's three questions:**
1. **Cohesive together — YES.** Zero contradictions across all 11 defs; both byte-identical families re-verified independently by multiple checkers (TDD SE≡CTO; behavioural-authority ×5 incl. why-line); every documented calibration checked out as documented; the one apparent T3 tension is a register-wording overstatement, not def drift.
2. **Every statement justified — YES, with 4 orphan clusters, all "grow the register" not "cut the clause":** (a) CR's baseline review-quality fragments (security gate, naming, edge/error/perf); (b) AUD's setup-check cluster (copy-install leftovers + recommended settings); (c) AUD's slug-tagged-findings stance (self-referentially untraced); (d) CRF's managing-agent-knowledge deferral pointer. Everything else maps, most defs completely.
3. **Subagents themselves justified — YES.** All 11 Components rows delivered by their defs (existence-as-opinion holds); row wording gaps only (AG-cto "re-dispatches" overstates escalate-for-re-dispatch; AG-se coordination omits gherkin/spike duties; AG-auditor omits the setup check).

**Def defects (3):** EM `<escalation>` silently drops O37's ~3-attempts bound (undocumented divergence); CR carries no failing-test-first evidence check despite P2/O26 claiming CR enforcement; AA's K7 home claim is thinly fulfilled.
**Register precision fixes:** T3 statement vs v-family content; E1 enumeration vs def envelope; T19's unrecorded "when asked" gate; AN2 statement scope; DOC-d2d row should name ui-state-graph-edt.md; homes columns systematically omit CRF (K1, K5, K2/K3, M2, P1, O37-calibrated) and AUD (O6, O35, K2, P14); K5 omits PDE.
**Harness flag:** CRF asserts subtree-@import "guarantees" load — probed only for ROOT CLAUDE.md (2.1.201); mark ⚙ assumed-unprobed or probe.
**Checker-methodology finding (evidence over testimony):** 3/11 checkers reported a stray `</output>` tag in their def — out-of-band grep proves none exist; they mistook their own Read-tool wrapper for file content (one even "verified" it). The auditor/CR checkers explicitly caught the trap. Worth a gotcha line in AA's format-gotchas (the wrapper is not file content).
**Watch-only (no action):** DBG risk-assessment block least-anchored; T5 w:DBG rationale spread thin; K2-CTO thin home.

**Fix batch applied (2026-07-07, ratified; one commit, v2.38.0).** Every site re-verified by reading before editing.
- **Def edits:** EM `<escalation>` gains the O37 family bound ("you've tried ~3 approaches without a healthy environment", calibrated); CR must-pass gains the failing-test-first evidence check (test-first order in the diff OR RED→GREEN evidence in the report/task doc; absence → REWORK; readable-judgement shaped — CR still doesn't run suites), making P2/O26's "enforced by CR" true; AA `<your-role>` gains the calibrated K7 orient clause (graph + brief-named task docs before analysing).
- **Register growth:** new M6 `hook-only-install-hygiene` (CM, AUD, README migration note); new R7 `review-quality-baseline` (CR); new R8 `findings-cite-register-slugs` (AUD); CRF's managing-agent-knowledge deferral folded into K1 as a statement tail (no new row).
- **Homes bookkeeping:** CRF added to K1, K5, K2, K3, M2, P1, O37 (all c, with calibration notes where the shape differs — O37 = ask-before-enshrining, M2 = plain-link rule); AUD added to O6, O35, K2, P14 (c, with what it checks); PDE added to K5.
- **Row wording:** AG-cto "re-dispatches" → "escalates routine implementation for re-dispatch down"; AG-se coordination gains gherkin-authoring (T22) + logic-spike (O29/T11) duties; AG-auditor gains the inline pre-flight setup check (M6, O6, O35); T3 statement trimmed to the v-family bullet (seam tail noted as living in B/SE text); E1 notes the def envelope carries the fuller enumeration; T19 records the when-asked gate; AN2 grows the assess-dimensions clause; DOC-d2d names `ui-state-graph-edt.md` as part of the entry.
- **Harness honesty:** CRF `<the-tension>` @import guarantee marked verified-for-root / assumed-for-subtree (2.1.201); register's ⚙ section gains an **Assumed-unprobed** entry for subtree-`CLAUDE.md` @import transclusion.
- **Gotcha capture:** AA format-gotchas gains the Read-tool `<output>`-wrapper line (wrapper ≠ file content; verify structural claims out-of-band) — absence of stray tags re-confirmed by grep during this batch.
- **Checksums re-verified post-edit:** TDD block SE≡CTO identical; `<behavioural-authority>` byte-identical ×5 (awk/shasum per sync-runbook). `./scripts/check-hooks.sh` fully green.
- **Left as-is (flag for a future pass):** O38's statement still says "CTO re-dispatches routine implementation" — same overstatement the AG-cto row had, but not in the ratified batch; CTO's own def correctly frames it as stop-and-report.
