# Worker family: shared thin generic body × four model+effort configs

## Brief
- **Orient** — `plugins/promode/agents/fast-worker.md` (being rewritten in place — read it first; its `<reporting>` block is the byte-shared family to copy verbatim; its engineer prose is being CUT, see inventory below). `plugins/promode/agents/senior-engineer.md` for shared wording of evidence/stay-on-task bullets. Register: `plugins/promode/docs/opinion-register.md`.
- **Specify** — author ONE thin generic worker body used by four def files, **bodies byte-identical below frontmatter** (checksum guard lands in task 26):
  - `elite-worker.md` (new): `model: inherit`, NO effort field (inherits session). Description: generic executor at the orchestrator's own tier — hardest non-code execution, judge/synthesis-grade grunt.
  - `high-level-worker.md` (new): `model: opus`, `effort: high`.
  - `fast-worker.md` (rewrite in place, history preserved): `model: sonnet`, `effort: medium`.
  - `cheap-worker.md` (new): `model: haiku`, NO effort field (Haiku has no effort control).
  - Body sections (thin — this family exists to pre-bake model+effort configs for *generic non-code* dispatch; the methodology payload is deliberately small):
    1. `<reporting>` — copy the existing block **verbatim, byte-identical** with the engineer defs (P13/P14; matters most at cheap tiers, where a sloppy report costs the main agent the most).
    2. Role — generic executor: research grunt, gathering, formatting non-source artifacts, file operations, running existing scripts, doc assembly. Config (model + effort) comes from frontmatter; the def carries conduct, not capability claims. Task-doc Outcome discipline (record before reporting, own-worktree copy when isolated).
    3. **Code-lane rule (load-bearing — this seals TDD):** *"If the task turns out to require changing production code, stop and report for re-dispatch to an engineer — code changes ride TDD, which lives in the engineer definitions, not here. A worker writing production code is the hole through which the methodology drains."* Keep the why inline (M3).
    4. Principles-lite — evidence-over-assumptions (P1) and stay-on-task/flag-don't-fix (P10), same wording as the engineer defs' bullets.
    5. Escalation — ambiguous requirements, ~3 failed approaches, out-of-scope needs, missing credentials (O37 family wording).
    6. Commit produced artifacts before reporting (P12, calibrated: artifacts, not code).
    7. Knowledge: report-for-capture — surface capture-worthy discoveries in the report for the main agent to dispatch; workers do not write the graph themselves (the VER/AA calibration, applied here).
  - **Cut-prose inventory (O16 — required in your report):** the current fast-worker body carries these rules; show each surviving in a named home: TDD block + constraint-ladder + behavioural-authority + file-organization + traceability + backwards-compat → engineer shared body (task 20, verify against its committed result or state the dependency); `<gui-driving>`/T17 → `gui-driver.md` (task 22 — a parallel task; state it as the named destination, don't verify); bounce-up lane rule → engineer body's pin-relative lane rule; agent-knowledge capture → replaced by report-for-capture here (deliberate calibration — say so).
- **Why** — per-dispatch effort doesn't exist (task 19's node), so generic model+effort combos must be pre-baked as defs. Named rungs make tier recommendations structural (M0) — a delegation-map row the orchestrator can't fail to see, vs dispatch advice it can forget. The listing tax of four entries is bought deliberately.
- **Verified vs assumed** — `model: inherit` is a valid frontmatter value (probed, register ⚙). Haiku-no-effort and effort-field semantics: task 19's node. Assumed: the four-section body is enough conduct for Haiku (M1: weaker pin normally earns MORE operational detail — if a section feels underspecified for Haiku, add operational detail rather than opinion, and flag it).
- **Not / exit** — do NOT create gui-driver.md (task 22), touch engineer defs, brief, register, README, or scripts. Exit: four files committed, bodies byte-identical (state the check you ran), inventory in report + Outcome.

## State
- **Established facts** — frontmatter values ratified and exact; elite-worker must NEVER be `model: fable` (breaks non-Fable consumers; cost-ceiling reasoning lives in task 19's node).
- **Open constraints** — worktree-isolated: Outcome goes in YOUR worktree's copy of this doc.

## Outcome
Done. Authored ONE thin generic worker body shared byte-identical across four def files (verified: all four bodies below frontmatter share shasum `a636eb56…`; `<reporting>` block diffs clean against `senior-engineer.md`):

- `elite-worker.md` (new) — `model: inherit`, no effort field.
- `high-level-worker.md` (new) — `model: opus`, `effort: high`.
- `fast-worker.md` (rewritten in place, history preserved) — `model: sonnet`, `effort: medium`.
- `cheap-worker.md` (new) — `model: haiku`, no effort field.

Body sections (thin, per brief): `<reporting>` (verbatim family), `<your-role>` (generic non-code executor; config-from-frontmatter, conduct-not-capability; task-doc Outcome + own-worktree discipline), `<code-lane>` (load-bearing TDD seal, why inline), `<principles>` (P1 + P10 verbatim engineer wording), `<escalation>` (O37 family, code-free), `<committing>` (P12 calibrated to artifacts), `<knowledge>` (report-for-capture, VER/AA calibration).

**Cut-prose inventory (O16)** — every rule the old fast-worker body carried, shown surviving:
- TDD block + constraint-ladder + behavioural-authority + file-organization + traceability (P9) + backwards-compat → **engineer shared body** (task 20: `senior-engineer.md` / `mid-level-engineer.md`). Task 20 not yet merged in this worktree; verified all these blocks are present verbatim in the current committed `senior-engineer.md`. State the dependency: they live there, not here — a worker never writes production code (`<code-lane>`), so it never needs them.
- `<gui-driving>` / T17 selector discipline → **`gui-driver.md`** (task 22, parallel — named destination, not verified; `gui-driver.md` does not yet exist in this worktree).
- bounce-up lane rule ("stop and report for re-dispatch to senior-engineer") → the engineer body's pin-relative lane rule (task 20 §3); the worker keeps only the *code-lane* stop-and-report (any production code → engineer), not the design-judgement bounce, since a worker does no code at all.
- agent-knowledge capture section → **deliberately calibrated** to report-for-capture `<knowledge>` here (workers surface findings, main agent dispatches capture — the VER/AA calibration, K1/K2 report-only rows). Not a silent drop: intentional per brief §7.

**Not verified / assumptions:** did not run any hooks/CI or lint the frontmatter against a live harness; `effort:` field validity taken from task 19's node (not re-probed). Task 20 and task 22 destinations named per brief, not verified (parallel tasks). Assumed the four-section body is sufficient conduct for Haiku (M1 flag: no section felt underspecified enough to warrant added operational detail — the payload is deliberately thin and capability-neutral).
