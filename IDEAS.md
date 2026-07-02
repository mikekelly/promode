# Ideas backlog

Raw, not-yet-spec'd ideas for promode.

- **Harmonise reporting contracts** — the "not verified / assumptions" reporting note exists only in the engineers + verifier; a reviewer's APPROVED and a debugger's root-cause claim carry the same overconfidence risk. Likewise task-doc write-back is required of engineers/debugger/verifier but not the reviewer. (From the 2026-07-02 prompting review; awaiting maintainer sign-off.)
- **State the knowledge-writer asymmetry** — some agents write to the knowledge graph (engineers, debugger, environment-manager, product-design-expert), others only report findings (verifier, code-reviewer, agent-analyzer). The rationale (writers = agents that commit) is nowhere written down, so it reads as accident. One sentence where it's decided. (Same review.)

*(The full 2026-06-15 practice-scan backlog has been delivered: **durable in-repo working state** — task docs, conditional worktrees, in-repo memory, cross-session retrospective — v2.18.0; **Rule-of-Two** autonomy check — v2.18.0; **knowledge-authoring load-guarantee framing** — inline/@import/link — v2.18.1; **verify process & side-effects** + **KISS constraint-ladder** — v2.19.0; **LLM-judge discipline**, **capability-tier rubric + schema-validated returns**, **skill-authoring discipline** — v2.20.0; **code-reviewer distrusts the change's own narration** (SEVRA-BENCH: verify the diff, not the PR/commit/comment framing) — v2.21.0. Source corpus: `~/code/hq/outputs/assistant-practice-scans/`.)*
