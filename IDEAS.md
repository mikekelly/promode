# Ideas backlog

Raw, not-yet-spec'd ideas for promode. Run each through promode's own methodology (clarify → plan → TDD/verify) before adopting. Source: HQ assistant practice-scan corpus (`~/code/hq/outputs/assistant-practice-scans/`) + the 2026-06-15 design conversation.

*(Already delivered from that corpus: **durable in-repo working state** — task docs, conditional worktrees, in-repo memory, cross-session retrospective — v2.18.0; **knowledge-authoring load-guarantee framing** — inline/@import/link — v2.18.1; **verify process & side-effects** — tool-call/side-effect assertions, out-of-band irreversible-action checks, recovery-from-bad-state, "not verified" receipts — v2.19.0; **KISS constraint-ladder** in the implementer — v2.19.0. The **Rule-of-Two** autonomy check shipped in `<promode-audit>` (v2.18.0); handoff Active-State-Index buckets + bi-temporal supersession folded into the task-docs skill + `<after-action-review>`.)*

---

## 1. LLM-judge / review discipline
**Leverage: high** (Anthropic-proven; two independent sources). **Effort: M.**
- **Rubric-per-dimension** scored in *separate* calls (not one "is this good?").
- **Pairwise comparison** when "better" can't be articulated in advance.
- **Multi-judge majority vote** to tame non-determinism.
- **Consensus-audit** — escalate an extra adversarial reviewer turn when agents agree *too easily* ("suspicion ∝ absence of disagreement", 06-15 B2).
**Artifact:** `code-reviewer`, `promode-audit` (currently parallel assessors, no rubric discipline), `verifier`. Source: 4wk Anthropic judge talk, 06-09 #1.

## 2. Capability-tier rubric + schema-validated subagent returns
**Leverage: high. Effort: M** (brief-cap-sensitive — mind the 10k chunk limit).
- **Primitives-first rubric** for *designing* tools/agents: primitive (bash/file) → custom tool only when primitives fall short (bash can cut tokens 10×) → subagent for parallelism *or* fresh-context review → MCP only for cross-client sharing. promode has a delegation-map (*who*) but no capability-tier rubric (*which tier to reach for*). Source: 4wk Anthropic #3.
- **Schema-validated structured returns** when delegating gather/structured work (the `Workflow`/Agent `schema:` option; Forge 8B 53%→99%). Tighter than prose "verified-vs-assumed". Source: 06-08.
**Artifact:** `<delegation-map>` / `<subagent-scoping>` / `<prompting-subagents>`.

## 3. Skill-authoring discipline
**Leverage: med-high** (cheap, compounding — and downstream of the cross-session retrospective, which *emits* skill proposals). **Effort: M.**
- **Landmines, not docs** — a skill carries project-specific gotchas the model wouldn't know from training, not comprehensive prose (4wk: one bad skill dropped accuracy 97%→77%; 10k→553 lines).
- **Inline exact conventions at point of use** — SkillJuror found progressive disclosure under-performs for precise thresholds/formats; inline them where the agent acts (06-12, benchmarked).
- **Step-level skill post-mortem** — when a skill misfires, localise the *first faulty step*, make a minimal edit, commit as a reviewable diff (06-08; omarsar0 +20pt).
**Artifact:** `developing-skills` / `managing-agent-knowledge`, and how promode authors its own skills/briefs.
