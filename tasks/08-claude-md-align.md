# CLAUDE.md alignment review + adjustment

## Brief
- **Orient** — root `CLAUDE.md` (49/50-line hard cap — nearly full), the repo as it now stands (v2.31.0: expanded CTO def, authoring-register convention, wiki conventions, sync runbook changes), `plugins/promode/skills/promode-audit/references/agent-knowledge-wiki.md` (authoring conventions), `runbooks/sync-a-shared-principle.md`.
- **Specify** — a revised `CLAUDE.md`, committed in your worktree, with every change justified in the Outcome. Review axes:
  1. **Claim verification** — every checkable statement verified against the repo (script names/counts, file paths, "principles live in **two** places" vs the TDD block's now-three homes, the enumerated check scripts vs what `scripts/check-hooks.sh` actually runs). A statement the repo has moved past is a finding; fix it.
  2. **Coherence with the authoring register** — the new "opinions, not tutorials" paragraph was bolted on; check it sits coherently beside the altitude paragraph ("Placing anything new") and the brief design constraints — merge/reorder if they now overlap or fight.
  3. **Cap headroom** — the file is at 49/50 lines; find genuine cuts (restatement, content that belongs in a linked node, sentences failing the wiki's own no-op test) to restore ≥3 lines of headroom without demoting any load-bearing inline rule to a bare link.
  4. **Forward-compat, don't pre-build** — the maintainer intends a future *opinion register* (human-readable map of promode's opinionatedness, elevated into README, also agent-usable). Don't create it; just avoid restructuring in a way that would fight it, and note in the Outcome where it would naturally hook in.
- **Why** — CLAUDE.md is the guaranteed-loaded root of the knowledge graph; drift here misleads every agent in every session. The maintainer explicitly asked for review + adjustment to properly align.
- **Verified vs assumed** — the 49/50 count and staleness examples above verified by the dispatcher on 2026-07-07; everything else, verify by reading before changing.
- **Not / exit** — do NOT touch the brief, agent defs, skills, or README (other work owns them). Keep CLAUDE.md ≤ 50 lines. Never clobber: this is an edit of the existing file, preserving its structure where it's sound. Exit: committed in your worktree, `./scripts/check-hooks.sh` green, Outcome recorded in **your worktree's tracked copy of this doc** (worktree isolation blocks the shared path).

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — ≤50 lines; load-bearing rules stay inline
- **Established facts** — staleness examples in Brief
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
_(filled by the agent on completion)_
