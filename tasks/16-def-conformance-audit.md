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
