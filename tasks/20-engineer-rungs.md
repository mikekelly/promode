# Engineer rungs: shared body for senior-engineer + mid-level-engineer

## Brief
- **Orient** — `plugins/promode/agents/senior-engineer.md` (the superset body) and `plugins/promode/agents/fast-worker.md` (source of the conditional-TDD framing and the bounce-up lane wording). Register vocabulary: `plugins/promode/docs/opinion-register.md` (auto-imported; cite slugs when judging what a clause serves). Authoring convention: opinions-not-tutorials (M1), rationale-travels (M3).
- **Specify** — produce ONE shared engineer body used by two def files whose **bodies are byte-identical below the frontmatter** (a checksum guard is added in task 26 — make identity exact):
  - `senior-engineer.md` (edit in place): frontmatter `name: senior-engineer`, `model: opus`, `effort: high`, description updated (it's the dispatch-routing surface: deep-reasoning rung, TDD, commits before reporting).
  - `mid-level-engineer.md` (new): `name: mid-level-engineer`, `model: sonnet`, `effort: medium`, description (mechanical/well-specified engineering rung, TDD, commits before reporting).
  - Body = current senior-engineer body with these four changes, everything else preserved verbatim (T4 evidence-tracing bullet, logic-spikes exception, decision-node sentence, operator-seam incl. gherkin/d2d conditional reads, constraint-ladder, traceability, `<behavioural-authority>` — that block is **byte-identical across five existing homes (RB-checked); do not touch a character of it**):
    1. **Rung-neutral role**: the role section must read correctly on either pin. Seniority is read from the own-model preamble signal ("You are powered by the model named …"); if the signal is absent, behave as the senior rung (degrade toward more judgement, never fabricate a model).
    2. **Conditional TDD framing** (from fast-worker): TDD binds *when the task changes code*; non-code mechanical work still ends with a concrete check that the intended effect happened. The full TDD block itself is unchanged.
    3. **Pin-relative lane rule** (replaces SE's "mechanical work belongs to fast-worker" aside and FW's "bounce to senior-engineer" — draft to refine): *"Know your rung. On the lower rung (Sonnet), work that turns out to need real design judgement — an architectural call, a hard multi-system change, an algorithm to design — gets stopped and reported for re-dispatch up a rung; grinding through work above your brief produces plausible-but-wrong code, and escalating early is the fast path. On the higher rung (Opus), absorb trivial work rather than bouncing it back."* Keep the why in place (M3).
    4. **Remove nothing else and add nothing else.** There is no `<gui-driving>` section in this body — GUI driving moves to the new `gui-driver` def (task 22), not here.
- **Why** — per-dispatch effort doesn't exist (task 19's node); rungs are pre-baked model+effort configs over one methodology. One body means one home to sync; the pin-relative lane rule is O38 expressed once instead of forked.
- **Verified vs assumed** — the own-model preamble signal is a probed ⚙ fact (register, O39). The frontmatter `effort:` field is docs-confirmed + binary-verified (2.1.202). Assumed: Sonnet 5 handles the full senior body well (O34 reasoning — ratified; if while authoring you find a clause that clearly only makes sense on one rung, flag it in your report rather than forking the body).
- **Not / exit** — do NOT touch fast-worker.md (task 21 owns its rewrite), the brief, the register, README, or scripts. Exit: both files committed, bodies byte-identical (verify with `diff <(sed '1,/^---$/d;0,/^---$/d' a) …` or equivalent — state the check you ran), report includes the M1 flag list if any.

## State
- **Established facts** — frontmatter values are ratified and exact. `effort:` is the correct field name.
- **Open constraints** — worktree-isolated task: record the Outcome in YOUR worktree's copy of this doc; it lands on merge. Commit before reporting.

## Outcome
**Done (2026-07-10).** One shared engineer body now lives in two def files with byte-identical bodies below the frontmatter.

- `plugins/promode/agents/senior-engineer.md` (edited in place): frontmatter unchanged except `description` gained "rung" framing and `effort: high` added. `name: senior-engineer`, `model: opus` unchanged.
- `plugins/promode/agents/mid-level-engineer.md` (new): `name: mid-level-engineer`, `model: sonnet`, `effort: medium`, description = mechanical/well-specified rung, TDD-when-code-changes, commits before reporting.

**Four changes applied to the shared body (only the `<your-role>` section changed; everything else verbatim from the prior SE body):**
1. **Rung-neutral role** — opening line no longer says "You are the senior engineer"; it reads the rung from the own-model preamble ("You are powered by the model named …"), Opus = senior rung / Sonnet = lower rung, and defaults to the senior rung (more judgement, never fabricate a model) when the signal is absent.
2. **Conditional TDD framing** — "You implement code via TDD" → "When the task changes code, you implement via TDD …" plus the closing clause "Non-code mechanical work still ends with a concrete check that the intended effect happened." Housed in the role; the `<test-driven-development>` block itself is byte-for-byte the prior SE block (kept whole, per the brief — so the T4 evidence bullet and logic-spikes exception survive verbatim, unlike FW's calibrated block).
3. **Pin-relative lane rule** — replaced SE's "(Mechanical work … belongs to `fast-worker`; …)" aside with the "Know your rung" paragraph: escalate-up on the lower rung (why: plausible-but-wrong code / escalate-early is the fast path), absorb-down on the higher rung (added a matching why per M3: the re-dispatch costs more than the trivial work).
4. **Nothing else added/removed.** No `<gui-driving>` section (belongs to task 22's `gui-driver`). `<behavioural-authority>` (5-home byte-identical block), constraint-ladder, operator-seam (gherkin/d2d conditional reads), `<escalation>`, `<agent-knowledge>` (incl. the K3 decision-node sentence) all preserved verbatim.

**Verification run:** `diff <(sed '1,/^---$/d;0,/^---$/d' senior-engineer.md) <(sed '1,/^---$/d;0,/^---$/d' mid-level-engineer.md)` → empty (bodies byte-identical). The `effort` field name is taken as ratified/exact per this doc's State.

**M1 flag list:** none — no clause was found that only makes sense on one rung. The role's rung-detection makes the pin-relative bits ("On the lower rung … / On the higher rung …") read correctly on either pin.

**Not verified / assumptions:** did not run any harness/loader to confirm Claude Code parses the `effort:` frontmatter field (taken as ratified per the brief). Did not confirm Sonnet 5 handles the full senior TDD body well at runtime (O34 reasoning, ratified). Refined the change-3 draft's absorb-down clause by adding an explicit why (M3) — a wording refinement within the "draft to refine" latitude, not a scope change.
