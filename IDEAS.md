# Ideas backlog

Raw, not-yet-spec'd ideas for promode. Before adding or reviving an idea, check the rejected-work log ([docs/decisions/](docs/decisions/2026-07-community-skills-rejections.md)) — match by concept, don't re-suggest.

- Prune ~10 dead local `claude/*` branches + empty `.claude/hooks/` dir (P5)
- Product-framing refinements from the self-assessment ([docs/audits/2026-07-07-product-framing-self-assessment.md](docs/audits/2026-07-07-product-framing-self-assessment.md)): (a) write promode's own `docs/product/PERSONAS.md` (Methodical Principal + Vibe-Coder anti-persona, evidence flagged n=1); (b) README honesty pass — downgrade indicative outcome claims to flagged hypotheses, state who it's not for; (c) run the external A/B (fresh repo, vanilla+good-CLAUDE.md vs full promode) + add a parked register item on the unvalidated core efficacy thesis.
- AAR (this session): two agents misreported completion — auditor stalled (fixed: `auditor.md` foreground-batch callout) and senior-engineer left a partial commit while reporting "done"; both caught only by out-of-band verification. Harden the engineer defs' commit-before-reporting / done-means-cluster discipline (P12/P17) so it doesn't rely on the orchestrator catching slips.
- Brief at capacity: chunk 1 is 9827/10000 chars after O39 — any further `<model-tiers>`/chunk-1 addition forces a split. Decide the brief-budget strategy (split chunk, or tighten existing prose).
- Runtime-verify the new sub-Fable consent check + CTO `model: inherit` in a fresh session (or scratch-install E2E like ✓2) — neither is runtime-verified, only built on the 2026-07-07 probe facts.
