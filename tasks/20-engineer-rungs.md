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
(filled by the agent on completion)
