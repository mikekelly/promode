Produced by promode:product-design-expert, 2026-07-07, as a report-only spike turning promode's own PD1/PD4/PD6 lens on itself; captured verbatim so it survives session deletion.

---
# Promode, judged by its own PD1/PD4/PD6 standards — verdict: REFINE

## 1. Reconstructed persona
Promode never writes its own persona down (a finding in itself — PD3 demands every product name its documented persona; promode has none for *itself*).

**Persona — "The Methodical Principal" (Mike):** a senior/principal engineer or technical founder who already *has* a formed, opinionated methodology (TDD-as-religion, tests-as-spec, evidence-over-assumptions, discovery-hardens-into-determinism) developed over a career, not discovered via Claude Code; works solo or leads a small team; runs Claude Code heavily enough to feel context-rot, agents-doing-work-inline, and session-to-session methodology drift. Jobs: stop re-litigating taste every session; make the agent enforce *my* discipline without policing; keep frontier spend down while getting frontier-quality judgement; own/evolve the methodology as a versioned artifact. Comfort signals baked in: willing to *read every prompt*, maintain a register-governed fork, fluent in Gherkin/operator-seams/knowledge-graphs; finds a 400-line opinion register reassuring, not intimidating.
**Evidence grade: n=1, self-authored.** The persona is the maintainer; every choice maps onto one person's stated preferences ("the mikekelly fork"). No cited signal that anyone else holds this exact bundle. By promode's own PD3, a persona-of-one presented without the "evidence: assumed" flag it demands of others.
**Anti-persona — "The Vibe-Coder / Explorer":** uses Claude Code to explore an unfamiliar problem, prototype fast, or work where TDD is genuinely awkward (notebooks, one-off scripts, research spikes, design-first UI); has no methodology and doesn't want to adopt someone else's whole one; will never read the prompts or maintain a fork; experiences "TDD non-negotiable" + "delegate everything" as friction. Promode is correctly not for them — and never says so out loud.

## 2. Load-bearing user-need assumptions (graded)
| # | Assumption | Evidenced? | Grade | Notes |
|---|---|---|---|---|
| A1 | Context rot degrades long agent sessions | Partially — community-observed, plausibly self-observed | C+ | Real directionally; magnitude and "delegation is the best remedy" asserted, not measured. Harness-dependent. |
| A2 | Developers want an opinionated methodology enforced on them | No signal beyond maintainer | D | Core adoption premise; plausible for the persona, unknown otherwise. Most devs resist imposed process; README's own "methodology is taste" undercuts enforce-on-everyone. |
| A3 | The fork-per-user model will actually be adopted | No | D− | The big one (§4). Maintaining a multi-home, checksum-guarded, register-governed fork is real ongoing labour; zero evidence anyone but the author pays it. |
| A4 | Orchestrate-don't-implement beats a good CLAUDE.md | No head-to-head | D | Central efficiency claim, never A/B'd. O32 describes exactly the test never run on the whole thesis. |
| A5 | The Fable-economics split saves money at equal/better quality | No measurement | D | Plausible logic; "cheaper AND higher quality" is two-sided; delegation has its own token cost. Net savings unproven. |
| A6 | Voluntary skills are bad enough to eliminate entirely | Partially — reasoned decision node | C | Mechanism sound; leap from "sometimes misfires" to "ban entirely" is a taste-call; commands keep the same description-tax machinery, so purity isn't total. |
| A7 | TDD-non-negotiable is the right cross-project default | No | D | Defensible for backend/logic; asserted universally; treated as axiom, not hypothesis. |
| A8 | Reading/owning the prompts is a user value | No | D | A benefit for the persona; a cost most never pay. |
**Pattern:** mechanism claims grade C; every user-need/outcome claim grades D (assumed, uncited). Exactly the failure mode PD4 exists to catch — about promode's own foundations.

## 3. Post-hoc-justification findings (PD6) — citations
Two of PD6's three guises present; no fabricated citations (credit: it omits data rather than inventing it).
- **Stretched goal / benefit-as-fact:** README line 3 ("grow high quality codebases fast whilst keeping costs down") — accomplished-fact framing, all three of high-quality/fast/costs-down unmeasured. README line 43 ("the main context stays small… the methodology survives the session") — three asserted outcomes, no control. README line 7 / How-it-works — the whole Fable-economics pitch is a hypothesis stated in the indicative.
- **Flattered persona:** README line 9 ("you can read every prompt it ships") — framed as a benefit; mostly a cost nobody outside the persona pays. The "Fork it" section assumes the reader shares the maintainer's appetite for methodology-as-craft.
- **Self-referential validation loop (the key one):** promode's only project is promode. The audit, this analysis, the register, the AARs all exercise the methodology on the methodology. Impressive internal coherence substituting for external validation is the textbook post-hoc structure. Confirmed against the docs.
- **Genuine credit:** high mechanism-level honesty — flags ⚙ harness-pins, records rejected alternatives, keeps a decision log, doesn't fabricate. The gap is specifically at the product/user-need layer.

## 4. Single biggest unvalidated assumption + cheap validation path
**A3/A4 fused:** "orchestrate-don't-implement, delivered as an enforced opinionated methodology, produces materially better and/or cheaper outcomes than a competent hand-written CLAUDE.md — and enough people want that to adopt/fork it." It is promode's domain model: every structural choice descends from it, so if it's wrong the whole edifice is elaborate machinery for a marginal gain, and unwinding it means unwinding everything (the A1/PD4 "propagates into the architecture" warning turned on promode itself).
**Cheap path (days):** (1) pick 3–4 real non-trivial tasks in a *fresh external repo* promode has never touched; (2) A/B — Arm A = vanilla Claude Code + a good hand-written CLAUDE.md + a couple skills, Arm B = full promode, same tasks/budget, blind-graded; (3) measure token/credit spend (cost claim), a quality rubric graded by a fresh unprimed reviewer via R4 pairwise comparison (quality claim), wall-clock/iterations; (4) this is O32 turned outward — the framework prescribes A/B-testing doubtful sections and has never pointed it at the thesis. If B doesn't beat A by a margin justifying the complexity + fork-maintenance tax, simplify toward the CLAUDE.md-plus-a-few-agents core.

## Verdict: REFINE
By its own PD1/PD4/PD6 standards promode has NOT earned its stated outcome claims — but it's closer to compliant than a cynic would guess, and the fix is honest framing, not demolition.
- **Passes its own bar:** high mechanism-level honesty; flags harness-pins; records rejected alternatives; keeps a decision log; doesn't fabricate; transparent that it's an n=1 personal fork. PD6's fabricated-citation guise is absent.
- **Fails its own bar:** applies PD3/PD4 ruthlessly to the projects it builds and exempts itself; no PERSONAS.md for its own user; states better/faster/cheaper in the indicative with zero cited signal; rests its whole architecture on a domain-model-grade assumption (orchestrate-beats-good-CLAUDE.md, and forks-happen) never tested against a single external project. Judged as it judges others, a wall of grade-D user-need claims — a red flag, not an approval.
**Refinement (cheap, register-native):** (1) write promode's own `docs/product/PERSONAS.md` — name "The Methodical Principal," flag evidence as assumed (n=1, maintainer), add the "Vibe-Coder/Explorer" anti-persona; (2) downgrade the README's indicative outcome claims to flagged hypotheses and say who it's *not* for; (3) run the §4 A/B once externally, and until then carry a top-level parked register item: "Core efficacy thesis: unvalidated against external project outcomes (n=1, self-referential)."
