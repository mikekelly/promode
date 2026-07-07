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

**Done 2026-07-07.** Root `CLAUDE.md` revised: 49 → 46 lines (4 lines headroom), `./scripts/check-hooks.sh` green, no version bump, nothing else touched. Every referenced path/claim was re-verified against the repo before/after editing (hooks files, brief `<delegation-map>`, README table, wiki + delivery references, `docs/decisions/`, `RUNBOOKS.md` and all four runbooks exist and match).

### Changes, each justified

1. **Agents bullet (claim fix).** "research, implementation, review, debugging, testing, QA, environment, product design" → "hard-to-reverse design, implementation, review, debugging, verification/QA, environment management, product design, and after-action analysis". There is no promode research subagent — the brief's `<delegation-map>` routes codebase/web research to built-in `Explore`/`general-purpose`; meanwhile `chief-technology-officer` (design) and `agent-analyzer` (after-action analysis) were absent from the list. New list matches `plugins/promode/agents/` (9 defs).
2. **`check-hooks.sh` bullet (claim fix).** The old text said the runner "runs the size, gating, and chunk-registration checks" — it actually runs seven (`check-json-valid`, `check-skill-frontmatter`, the three hook checks, `check-version-in-context`, `check-inspect-agent`). Rewrote as "runs them (…) as part of the repo's full invariant-check suite" — accurate now, and deliberately non-enumerating so it doesn't re-stale when an eighth check lands. Kept "enforces all three" (still true of the three brief constraints above it) and the CI workflow path (verified: `.github/workflows/hook-output-limits.yml`).
3. **"Principles live in two places" (claim fix).** The `<test-driven-development>` block now has three agent-def homes (`senior-engineer`, `chief-technology-officer` verbatim; `fast-worker` calibrated), so "two places" undersold the duplication and the update instruction. Rewrote: deliberately duplicated, brief **and** every relevant agent def, "some blocks in several defs at once", sync **all** homes, with a direct link to `runbooks/sync-a-shared-principle.md` (one hop instead of two via `RUNBOOKS.md`). Deliberately avoided hardcoding a count — defs drift; the runbook carries the exact homes + re-grep advice. Also pulled the maintainer ruling inline ("the rationale travels with the rule — never dedupe the *why* out of a copy") since a sync agent acting only on `CLAUDE.md` needs that rule before it edits.
4. **Authoring-register coherence (axis 2).** The paragraph was bolted on after the altitude paragraph with no connective; it now opens "Altitude decides *where* a capability lives; register decides what earns words once it lands in an agent def or the brief" — explicitly the companion rule to "Placing anything new", not a competitor to the brief's "Decisions, not mechanics" bullet (which stays: that one is about dispatch-vs-pointer, a different rule). No reorder needed — altitude → register → brief-constraints reads as a coherent ladder. Kept as a freestanding paragraph (see forward-compat below).
5. **Cut: hierarchical-graph sentence folded into the preceding line** (−1 line). The full convention lives in `agent-knowledge-wiki.md` § "Loaded orientation can be hierarchical" (linked twice from `CLAUDE.md`), and this repo itself has no subtree `CLAUDE.md` — the standalone sentence was wiki restatement. The load-bearing facts (hierarchy exists, `AGENTS.md -> CLAUDE.md` symlinks) survive as a clause, so nothing was demoted to a bare link.
6. **Cut: hook-delivery bullet list collapsed to one sentence** (−2 lines). The two bullets restated "main-agent-only, gated on `agent_id`" (already stated verbatim in the Main-agent bullet *and* the brief-isolation constraint) and gave `PROMODE_MAIN_AGENT.md` its own line (already named earlier as "the full promode brief"). The unique facts — hook file paths, `${CLAUDE_PLUGIN_ROOT}`, update-propagates-automatically, `promode-audit` flags copy-install leftovers — all survive inline. "There's no per-project install — enabling the plugin delivers the brief" was dropped as a restatement of "nothing is copied into a project" in the same sentence.

### Forward-compat: where the opinion register hooks in

Did not restructure against it. Natural hook: the **"Authoring register — opinions, not tutorials" paragraph**, kept freestanding — it already names the opinion categories (product design, software design, architecture, methodology) and links the wiki convention; a future opinion-register node would be linked from there (and secondarily from the "Core philosophy" line, whose items are the top-level opinions such a register would map). The README elevation is independent of this file.

### Flagged, not fixed (out of scope)

- `RUNBOOKS.md` index says `add-a-subagent.md` touches "the `CLAUDE.md` table" — root `CLAUDE.md` has a bullet list, not a table. Stale wording in the hub/runbook; owned by other work.
- `runbooks/sync-a-shared-principle.md` is titled/framed "two homes" while itself documenting three TDD homes — internally consistent enough (two *kinds* of home) but worth a look next time that runbook is touched.
