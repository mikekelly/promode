# Migration A — create auditor + reinforce agents, commands/, docs/ moves, delete skills/

## Brief
- **Orient** — the CANONICAL spec is `tasks/13-skills-elimination-design.md` → Outcome → per-skill disposition table + "Delegation plan" (your task letter). Read it in full before acting; it carries the maintainer-ratified dispositions, the five harness-pinned probe facts (⚙), and per-task scope/checkpoints. Owner/mode: promode:senior-engineer.
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
_(senior-engineer, 2026-07-07 — executed; committed on this branch, no bump, no push)_

**Done, per 13's task A (all via `git mv`, history preserved):**
- **`agents/auditor.md`** (opus) — from promode-audit SKILL.md, restructured as an agent def: house-style `<reporting>` + `<your-role>`; synthesis/prioritisation stays with the auditor, main agent ratifies (O2 pattern); fan-out is **foreground parallel batch** with the P2 why inline (background children's notifications bubble to the root session, observed 2.1.201) and the **no-Agent-tool fallback** ("report dimensions + rubrics back for the main agent to fan out"); write-action recommendation renamed to dispatch `promode:constraint-reinforcer`; doc pointers now `${CLAUDE_PLUGIN_ROOT}/docs/{agent-knowledge-wiki,discovery-to-determinism}.md` (P5); skill-quality lens re-scoped to the *target repo's* skills.
- **`agents/constraint-reinforcer.md`** (opus) — from reinforce-design-constraints SKILL.md, near-verbatim; `<reporting>` added; wiki refs → `${CLAUDE_PLUGIN_ROOT}/docs/agent-knowledge-wiki.md`; `<related>` now cites `promode:auditor`.
- **`commands/handoff.md`** — near-verbatim, same name (`/promode:handoff` unchanged); "task-docs skill" mention neutralised to plain task-docs wording (content moves to brief chunk 4 in task C).
- **`commands/promode-audit.md`** — thin shim keeping the slash form: dispatch `promode:auditor`, ratify its prioritisation, deliver, offer capture. Body phrased as flow instructions per 13's P4 injection-shaped note.
- **`docs/` moves** — 3 audit references (`agent-knowledge-wiki.md`, `main-agent-delivery.md`, `managing-promode-retirement.md`) + d2d body (`discovery-to-determinism.md`) + its 2 refs (`ui-state-graph-edt.md`, `operator-seam-and-agent-tools.md`) + lookbook body (`design-system-lookbook.md`) + its ref (`live-reload-server.md`), all flat in `plugins/promode/docs/` beside the register. Skill frontmatter → H1 + one-line "routed mechanics doc" cold-open; every internal `references/`//`../SKILL.md` link rewritten to same-dir; retirement doc's self-referential location note updated.
- **Inspector** — `plugins/promode/scripts/inspect-agent.sh` + `test-fixtures/sample-transcript.jsonl`; smoke-tested at the new path (tip/step/full modes all render — same assertions as check-inspect-agent.sh).
- **agent-analyzer fold** — recovering-subagents mechanics inlined into `<mechanics>` (inspector usage via `${CLAUDE_PLUGIN_ROOT}/scripts/inspect-agent.sh`, tip-first backtracking, bulk jq extractions + JSONL format gotchas); description updated (also covers recovery dispatches).
- **`plugins/promode/skills/` deleted** (task-docs + recovering-subagents SKILL.mds removed with it; task-docs content is in git history for task C).
- **Inbound links for moved files updated repo-wide**: root `CLAUDE.md` (3 path refs), `RUNBOOKS.md`, register header (W home key now full path), `docs/decisions/2026-07-community-skills-rejections.md`. Verified: no unresolvable relative md links in touched files (the 3 remaining "broken" hits are illustrative examples in the wiki/inline-format code fences).

**Expected failures left for the parallel scripts task (per brief: scripts/ untouched):**
1. `check-skill-frontmatter.sh` — "no SKILL.md files found" (task E repurposes it over agents/+commands/; note: commands carry `name`+`description` frontmatter to satisfy the repurposed check).
2. `check-inspect-agent.sh` — stale paths at lines 10–11; needs `plugins/promode/scripts/inspect-agent.sh` and `plugins/promode/scripts/test-fixtures/sample-transcript.jsonl`. **Divergence from 13**: 13's task A owned this fix; the dispatch brief assigned scripts/ to the parallel task, so it's flagged here instead.
All other checks green (output limits, gating, chunk registration ×3, version banner, imports, JSON, inspector smoke run manually).

**Left for other letters (verified still-stale on exit):** root `CLAUDE.md` line "skills (just-in-time knowledge) in `plugins/promode/skills/`" + altitude/What-is-Promode wording (D); README Skills section (D); register skill rows/Components (D); wiki "Authoring skills" reframe (D); plugin.json `skills` keyword (D); def rewires SE/VER/FW/PDE/EM conditional doc-reads (B); brief + hooks.json (C).
