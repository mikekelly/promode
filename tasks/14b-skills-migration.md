# Migration B — consuming-def rewires (conditional doc reads, skill-name sweeps)

## Brief
- **Orient** — the CANONICAL spec is `tasks/13-skills-elimination-design.md` → Outcome → per-skill disposition table + "Delegation plan" (your task letter). Read it in full before acting; it carries the maintainer-ratified dispositions, the five harness-pinned probe facts (⚙), and per-task scope/checkpoints. Owner/mode: resume 14a's agent.
- **Specify** — execute exactly your lettered task from the plan; deliverable, exclusions, and exit condition as stated there.
- **Why** — ratified opinion (2026-07-07): promode avoids voluntary-invocation skills; capabilities move to the four non-voluntary surfaces (dedicated agent / def prompting / def-directed doc read / commands), preserving JIT economics.
- **Verified vs assumed** — probe facts P1–P5 verified live 2.1.201 (see 13); re-verify file locations by reading before editing.
- **Not / exit** — stay inside your letter's scope (other letters own adjacent files); `./scripts/check-hooks.sh` green at your exit (except where your letter says the checkpoint owns it); commit; Outcome recorded in this doc (worktree agents: your tracked copy — it merges); no bump (final task bumps), no push.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — per 13's plan
- **Established facts** — ratification 2026-07-07; probes P1–P5
- **Pending goals / next step** — execute per 13

## Outcome
_(senior-engineer, 2026-07-07 — resumed from 14a; executed at HEAD after A/E/inspect-fix merged; committed on this branch, no bump, no push)_

**Done — consuming-def rewires to the new surfaces (per 13's disposition table):**
- **`senior-engineer.md`** (`<operator-seam>`, "Keep the UI a thin shell") — UI-state-graph-harness build now `first read ${CLAUDE_PLUGIN_ROOT}/docs/discovery-to-determinism.md`; the selector-based/mechanics-live-there wording kept.
- **`verifier.md`** (step 3) — d2d skill mention → `first read ${CLAUDE_PLUGIN_ROOT}/docs/discovery-to-determinism.md (and its ui-state-graph-edt.md)`. Left untouched: the two `/verify` mentions (harness *built-in* skill, explicitly "not shipped by promode") in the description, step 2, and escalation.
- **`fast-worker.md`** (`<gui-driving>`) — d2d skill mention → conditional read of the doc "when the brief calls for a map/graph/recognizer"; **T17 selector rule mirrored inline** per plan ("selector-based actions, never hardcoded coordinates (coordinates drift; stable selectors/identifiers don't); validate each step against the live tree") so FW keeps its always-loaded selector discipline without the doc read for simple driving.
- **`product-design-expert.md`** (4 sites: lines 116, 118, 139, 175) — three `design-system-lookbook` skill invokes → read `${CLAUDE_PLUGIN_ROOT}/docs/design-system-lookbook.md`; the `discovery-to-determinism` scenario-bridge mention → read `${CLAUDE_PLUGIN_ROOT}/docs/discovery-to-determinism.md (<scenario-vs-seam>)`.
- **`environment-manager.md`** — not a doc-read consumer (references the *loop/principle*, not mechanics); the bare hyphenated skill-name "discovery-to-determinism loop" neutralised to "discovery⇄determinism loop" so it no longer reads as a skill reference.

**Verbatim-block discipline (re-verified per sync runbook):** none of the edited sections is a checksummed home. Confirmed post-edit that both invariant families still match byte-for-byte:
- `<test-driven-development>` (SE ≡ CTO): `8562ef13…0b1296` (both).
- `<behavioural-authority>` (SE/FW/CTO/CR/DBG): `19604f77…a7182` (all five).
The recovering-subagents mechanics fold into agent-analyzer already landed in task A; not re-touched.

**Swept clean:** full `grep -i` across all `plugins/promode/agents/*.md` for the seven old skill names / `a skill` / `the skill` / `skills/` returns only the new `${CLAUDE_PLUGIN_ROOT}/docs/…` conditional reads plus the two allowed harness-skill mentions (`/verify` built-in, `frontend-design`/`managing-agent-knowledge` referenced by name as harness skills, not ours). CTO/CR/DBG carry no moved-skill references. All three doc-read target paths exist.

`./scripts/check-hooks.sh` green (exit 0).

**Not touched (owned by parallel/later letters):** brief + `hooks.json` (C); root `CLAUDE.md` / README / register (D). No new stale references introduced for them.
