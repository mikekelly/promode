# Migration C — brief surgery + chunk 4 + hooks.json registration

## Brief
- **Orient** — the CANONICAL spec is `tasks/13-skills-elimination-design.md` → Outcome → per-skill disposition table + "Delegation plan" (your task letter). Read it in full before acting; it carries the maintainer-ratified dispositions, the five harness-pinned probe facts (⚙), and per-task scope/checkpoints. Owner/mode: single owner, worktree.
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
_(senior-engineer, 2026-07-07 — worktree copy; merges to canonical)_

**Done.** Brief surgery + chunk 4 + full 4-chunk registration; `./scripts/check-hooks.sh` fully green (verified red-first: marker added before registration made `check-hook-chunk-registration.sh` fail demanding 1..4, then registration turned it green).

- **Chunk 1–3 swaps** (per 13 §4): `<background-delegation>` recovery → dispatch `promode:agent-analyzer`; `<delegation-map>` +2 rows (`promode:auditor`, `promode:constraint-reinforcer`); `<agent-knowledge>` graph-health line now routes buried-constraint repair to `promode:constraint-reinforcer`; `<feature-knowledge-base>` + `<project-tracking>` + `<planning>` skill pointers → `<test-strategy>`/`<task-docs>` cross-refs; `<test-strategy>` d2d mechanics → `plugins/promode/docs/discovery-to-determinism.md` via def-routing (SE build / VER run), visual loop routes to PDE only (lookbook skill name dropped); `<promode-audit>` → dispatch `promode:auditor` + `/promode:promode-audit` mention (light-check text unchanged); `<after-action-review>` "skill" wording → brief/agent-def/routed-doc. Header comment updated to state the no-skills stance.
- **Chunk 4** (new, 4689 chars delivered): `<task-docs>` — full mechanics recovered from git (`c0abcb9~1:plugins/promode/skills/task-docs/SKILL.md`): template, single-source-of-status, fog, durability, anti-drift, lifecycle incl. worktree-Outcome nuance; sub-headings flattened to bold leads, "you" = main agent, handoff cross-ref updated. Plus `<handoff>` — the proactive trigger promoted into the brief: about-to-`/clear` / context pressure → run `/promode:handoff`.
- **Rebalance decision:** the two delegation-map rows overflowed chunk 1's ~160-char headroom, so the first CHUNK marker moved above `<prompting-subagents>` (whole self-contained section shifted into chunk 2). Delivered sizes now 8974/8420/9142/4689 — chunk 1 regained ~1k headroom.
- **hooks.json**: chunk 4 registered in all four matchers (startup/resume/clear/compact), chunks 1..4 each.
- **Follow-up for D:** the brief's header comment cites `docs/decisions/2026-07-skills-elimination` — that node is task D's deliverable and doesn't exist yet (comment-only, stripped before delivery, so nothing user-visible depends on it).
- Not verified here (✓1 owns it): live scratch-session delivery of 4 chunks; checks simulate delivery via the hook script.
