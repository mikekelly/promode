# Ideas backlog

Raw, not-yet-spec'd ideas for promode. Run each through promode's own methodology (clarify → plan → TDD/verify) before adopting. Source: HQ assistant practice-scan corpus (`~/code/hq/outputs/assistant-practice-scans/`) + the 2026-06-15 design conversation.

*(Already delivered from that corpus: **durable in-repo working state** — task docs, conditional worktrees, in-repo memory, cross-session retrospective — v2.18.0; **knowledge-authoring load-guarantee framing** — inline/@import/link — v2.18.1. The **Rule-of-Two** autonomy check shipped in `<promode-audit>` (v2.18.0); handoff Active-State-Index buckets + bi-temporal supersession folded into the task-docs skill + `<after-action-review>`.)*

---

## 1. Verify the *process & side-effects*, not just the output
**Leverage: high** (closes the most expensive failure class — "agent said done, but didn't actually do/verify it"). **Effort: M.**
Three converging, well-evidenced mechanisms:
- **Tool-call assertions** — a test/verify step asserts the *expected tool/side-effect actually fired*, not just that output parses (06-15 B1: an agent silently stopped calling its lookup tool and hallucinated, evals stayed green on tone). Absence of the expected call = hard failure.
- **Out-of-band side-effect verification** — for irreversible actions (commit/push, send, delete), confirm by reading the side-effect (git log, sent folder, event), never the model's self-report (06-10 #1).
- **Recovery-from-bad-state evals** — seed a deliberately wrong state and check the agent self-corrects; predicts field usefulness better than first-try success (06-15 A3).
- **"What I did NOT verify" receipt** — agent output carries an explicit unverified-scope/assumptions line so "stopped" ≠ "safe to ship" (06-08 bcherny; 68%-problem-rate stat).
**Artifact:** `verifier` (currently binary PASS/FAIL on running app), `<execution>` checkpoints, `<test-strategy>` / `discovery-to-determinism`.

## 2. LLM-judge / review discipline
**Leverage: high** (Anthropic-proven; two independent sources). **Effort: M.**
- **Rubric-per-dimension** scored in *separate* calls (not one "is this good?").
- **Pairwise comparison** when "better" can't be articulated in advance.
- **Multi-judge majority vote** to tame non-determinism.
- **Consensus-audit** — escalate an extra adversarial reviewer turn when agents agree *too easily* ("suspicion ∝ absence of disagreement", 06-15 B2).
**Artifact:** `code-reviewer`, `promode-audit` (currently parallel assessors, no rubric discipline), `verifier`. Source: 4wk Anthropic judge talk, 06-09 #1.

## 3. Capability-tier rubric + schema-validated subagent returns
**Leverage: high. Effort: M** (brief-cap-sensitive — mind the 10k chunk limit).
- **Primitives-first rubric** for *designing* tools/agents: primitive (bash/file) → custom tool only when primitives fall short (bash can cut tokens 10×) → subagent for parallelism *or* fresh-context review → MCP only for cross-client sharing. promode has a delegation-map (*who*) but no capability-tier rubric (*which tier to reach for*). Source: 4wk Anthropic #3.
- **Schema-validated structured returns** when delegating gather/structured work (the `Workflow`/Agent `schema:` option; Forge 8B 53%→99%). Tighter than prose "verified-vs-assumed". Source: 06-08.
**Artifact:** `<delegation-map>` / `<subagent-scoping>` / `<prompting-subagents>`.

## 4. Skill-authoring discipline
**Leverage: med-high** (cheap, compounding — and downstream of the cross-session retrospective, which *emits* skill proposals). **Effort: M.**
- **Landmines, not docs** — a skill carries project-specific gotchas the model wouldn't know from training, not comprehensive prose (4wk: one bad skill dropped accuracy 97%→77%; 10k→553 lines).
- **Inline exact conventions at point of use** — SkillJuror found progressive disclosure under-performs for precise thresholds/formats; inline them where the agent acts (06-12, benchmarked).
- **Step-level skill post-mortem** — when a skill misfires, localise the *first faulty step*, make a minimal edit, commit as a reviewable diff (06-08; omarsar0 +20pt).
**Artifact:** `developing-skills` / `managing-agent-knowledge`, and how promode authors its own skills/briefs.

## 5. KISS as a constraint-ladder
**Leverage: med-high. Effort: S** (single agent def; benchmarked).
Operationalise KISS into a pre-action elimination ladder for the implementer: *does this need to exist? stdlib? native feature? existing dep? one line?* — before writing code. promode states KISS as a value but has no pre-write check. Source: "Ponytail" 06-12 (293→47 LOC, 16% fewer tokens, 4× faster).
**Artifact:** `implementer` (a pre-action checklist in its definition).
