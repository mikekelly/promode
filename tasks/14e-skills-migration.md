# Migration E — repurpose skill-frontmatter check for agents+commands

## Brief
- **Orient** — the CANONICAL spec is `tasks/13-skills-elimination-design.md` → Outcome → per-skill disposition table + "Delegation plan" (your task letter). Read it in full before acting; it carries the maintainer-ratified dispositions, the five harness-pinned probe facts (⚙), and per-task scope/checkpoints. Owner/mode: promode:fast-worker, parallel with A.
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
_(fast-worker, 2026-07-07 — complete)_

- **Renamed** `scripts/check-skill-frontmatter.sh` → `scripts/check-component-frontmatter.sh` (git mv, per 13 §5 item 5) and `scripts/test-check-skill-frontmatter.sh` → `scripts/test-check-component-frontmatter.sh`; `scripts/check-hooks.sh` runner entry updated — stays CI-wired via `.github/workflows/hook-output-limits.yml` unchanged.
- **New coverage** (dir overrides `AGENTS_DIR`/`COMMANDS_DIR`/`SKILLS_DIR` for the test harness):
  - `agents/*.md` — required non-empty dir; delimited block, flat YAML, non-empty `name`+`description`, `name`==filename, and `model` *where pinned* must be non-empty (no enum check — full model IDs are legal; an allowlist would false-positive on new models).
  - `commands/*.md` — dir optional (task A creates it); when present: block, flat YAML, non-empty `description`; `name` checked against filename only *when present* (commands take their name from the filename — deliberate softening of 13's "name non-empty" for commands so task A's files pass whether or not they carry a `name` key). Dir present but empty = fail.
  - `skills/*/SKILL.md` — legacy invariants kept while the dir exists; **absence is a clean skip**, so the check is green on both this pre-migration worktree and the merged post-deletion tree.
- **TDD**: harness rewritten first (27 fixture cases incl. the absence case), run red (check missing), then implemented green. Full `./scripts/check-hooks.sh` green at exit (pre-migration tree: 9 agents, 0 commands, 7 skills validated).
- **Stale-name sweep**: old script name survives only in historical task docs (allowed set per 13 §5 item 9).
- Committed in worktree; no bump, no push.
