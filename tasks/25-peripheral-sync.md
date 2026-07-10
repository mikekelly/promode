# Peripheral sync: README, runbooks, CTO boundary, cross-def references

## Brief
- **Orient** — depends on tasks 19–24 (merged). Read the two decision nodes (`docs/decisions/2026-07-agent-roster-restructure.md`, `2026-07-effort-dispatch-constraint.md`) and the updated register first; they are ground truth. Then: `README.md`, `runbooks/sync-a-shared-principle.md`, `runbooks/add-a-subagent.md`, `plugins/promode/agents/chief-technology-officer.md`, and `grep -rn 'fast-worker\|senior-engineer\|product-design-expert' --include='*.md'` across the repo minus `tasks/`, `DONE.md`, `docs/audits/`, `docs/decisions/` (historical records stay as-is).
- **Specify** —
  1. **README**: agent table → the new roster (7 new/changed rows); tier-economics prose → the config-ladder framing (pre-baked model+effort combos; inherit seats honour the cost ceiling); mention the effort-dispatch constraint in one line linking the decision node.
  2. **Runbook `sync-a-shared-principle.md`**: retire the SE↔CTO-and-FW-calibration narrative — supersede-with-pointer (M3), never delete; document the new byte-identity families (engineer body ×2, worker body ×4, reporting block across engineer+worker+gui-driver+product defs — verify the actual family membership against the committed defs) and point at the checksum script as the deterministic check.
  3. **Runbook `add-a-subagent.md`**: add the frontmatter `effort:` field to the checklist (with the silent-strip warning + decision-node link) and the byte-identity-family question ("does the new def join a checksummed family?").
  4. **CTO def**: narrow its product-call line (crucial *product* calls → CPO; CTO keeps entity/domain model + deep technical trade-offs; both-draft-in-parallel for genuinely-both) and re-point its task-routing references (senior-engineer/fast-worker → engineer rungs / workers as appropriate).
  5. **Cross-def scrub**: fix live references to retired names/semantics in the remaining defs (code-reviewer, debugger, verifier, auditor, constraint-reinforcer, environment-manager, agent-analyzer) and `plugins/promode/docs/*.md` routed docs (d2d routes FW's GUI driving — re-point to gui-driver). Do not rewrite content beyond the re-pointing.
  6. Root `CLAUDE.md`: update only what the roster falsifies (e.g. "eleven agent defs" count in the register preamble is task 24's file; here check CLAUDE.md's own agent enumerations/links). Keep it under its 50-line rule.
- **Why** — a rename that leaves stale references turns every stale mention into a mis-dispatch or a falsehood in loaded orientation (K6 territory).
- **Verified vs assumed** — the grep list above found matches in: README, PROMODE_MAIN_AGENT (task 24's), CTO def, code-reviewer def, lookbook doc, main-agent-delivery doc, register (task 24's), sync runbook, checksum scripts (task 26's). Re-run the grep yourself; files may have moved since.
- **Not / exit** — do NOT touch the brief, the register (task 24), or the checksum scripts (task 26). Historical records (tasks/, DONE.md, audits, decision nodes) stay untouched. Exit: all edits committed; report lists every file touched + every stale reference found and its fix; `grep` for the three old names over live surfaces comes back clean or each remaining hit justified.

## State
- **Open constraints** — blocked on tasks 19–24 merging.

## Outcome
**Done (2026-07-10).** Peripheral surfaces synced to the new roster + effort-dispatch constraint. All edits committed.

**Files touched (10):**
- `README.md` — agent table rebuilt to the new roster (added `chief-product-officer`, `mid-level-engineer`, `senior-product-designer`, worker-family row, `gui-driver`; narrowed CTO to *technical*; removed old `fast-worker`/`product-design-expert` rows); tier prose reframed as a pre-baked model+effort ladder (inherit seats = CTO/CPO/elite-worker honouring the cost ceiling) with a one-line effort-dispatch-constraint note linking the decision node.
- `plugins/promode/agents/chief-technology-officer.md` — frontmatter + `<your-role>`: crucial *product* one-way doors handed to CPO, CTO keeps entity/domain model + deep technical trade-offs, both-draft-in-parallel for genuinely-both; task routing `senior-engineer` vs `fast-worker` → `senior-engineer`/`mid-level-engineer` for code, worker family for non-code.
- `plugins/promode/agents/code-reviewer.md` — implementing agent "(senior-engineer or fast-worker)" → "(senior-engineer or mid-level-engineer)".
- `plugins/promode/agents/auditor.md` — visual-feedback dimension owner `promode:product-design-expert` → `promode:senior-product-designer`.
- `plugins/promode/docs/design-system-lookbook.md` — DESIGN_SYSTEM maintainer + related-agent `product-design-expert` → `senior-product-designer`; lookbook mechanical-assembly `fast-worker` → `mid-level-engineer` (code rides an engineer now).
- `plugins/promode/docs/discovery-to-determinism.md` — scenario-bridge ref `promode:product-design-expert` → `promode:senior-product-designer`.
- `plugins/promode/docs/main-agent-delivery.md` — implementing-agent example `(senior-engineer, fast-worker)` → `(senior-engineer, mid-level-engineer)`.
- `runbooks/sync-a-shared-principle.md` — retired the old SE↔CTO+FW-calibration narrative; documented the new byte-identical families **exactly as `scripts/check-shared-principle-checksums.sh` checks them** (engineer body ×2, worker body ×4, `<reporting>` ×7 [engineers + 4 workers + gui-driver; product/specialist defs deliberately excluded as calibrated], `<behavioural-authority>` ×5, `<test-driven-development>` ×3) and pointed the steps at the checksum script as the deterministic check; kept the pre-restructure shape as a superseded-with-pointer record (M3); fixed the worked-example `implementer.md` split note.
- `runbooks/add-a-subagent.md` — checklist gained the frontmatter `effort:` field (silent-strip warning + both decision-node links) and a "does the new def join a checksummed byte-identical family?" question, plus a Verify line for the checksum script.
- `CLAUDE.md` — line 21 "PDE's def" → "the `senior-product-designer`'s def" (only roster-falsified ref; still 49 lines).

**Stale references found + fixed:** the literal-name grep hit README (4), CTO def (1), code-reviewer (1), auditor (1), design-system-lookbook (3), discovery-to-determinism (1), main-agent-delivery (1), sync-runbook (old family narrative), CLAUDE.md (PDE's def). All re-pointed. No GUI-driving agent name to re-point in d2d itself (that routing lives in the register's DOC row, task 24).

**Final grep clean:** `product-design-expert`/`PDE` and stale `fast-worker` semantics over live surfaces (README, plugins/promode/agents, plugins/promode/docs, runbooks, CLAUDE.md) are clean — all remaining hits are in excluded historical paths (tasks/, docs/decisions/, docs/audits/) or are legitimate current-agent references (`fast-worker` the generic worker, `senior-engineer`). `check-claude-md-imports.sh` and `check-shared-principle-checksums.sh` both green.

**Untouched per brief:** brief, register (task 24), checksum scripts (task 26), historical records.

**Flag for main agent — cross-task inconsistency (not mine to fix):** the register (task 24, `opinion-register.md` lines 248/252) states `mid-level-engineer`'s `<test-driven-development>` is *calibrated* (fewer bullets, no T4/logic-spikes) — but the committed defs + checksum script (task 26) make SE and mid-level-engineer share their **whole body byte-identical**, so mid's TDD is identical to SE's, not calibrated. Per behavioural-authority (verified behaviour > prose) I described the families as the script checks them. The register prose should be reconciled to the committed defs.
