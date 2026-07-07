# Opinion extraction: full inventory across the brief + subagent defs

## Brief
- **Orient** — `plugins/promode/PROMODE_MAIN_AGENT.md` (the brief; 3 chunks) and all nine `plugins/promode/agents/*.md`. Context: the ratified authoring register ("opinions, not tutorials" — `CLAUDE.md` + wiki → Authoring agent definitions). Skills are OUT of extraction scope, but where an opinion's mechanics live in a skill, note the pointer.
- **Specify** — two committed artifacts:
  1. **`tasks/09-opinion-inventory.md`** — the complete inventory. One entry per distinct opinion/principle/methodological stance, structured:
     - **slug** + one-line canonical statement
     - **domain** — product design | software design | architecture | testing | methodology | orchestration | knowledge/memory
     - **homes** — every file+section carrying it, each marked `verbatim` / `calibrated` (deliberately reworded for the pin or role) / `decision↑` vs `mechanics↓` (altitude split)
     - **rationale attached?** — does every home carry the why (house rule: rationale travels with the rule)
     - **flags** — conflicts (contradicts another opinion, or copies that have drifted apart in *substance*), coverage gaps (an agent whose role plainly warrants the opinion but whose def lacks it), single-home opinions that plausibly belong wider, redundancy beyond designed duplication
  2. A closing **assessment summary**: the conflict list; a coverage matrix (opinions × agents, mark held/calibrated/absent/n-a); and a per-opinion `stay / go / adjust` *recommendation* with one-line reasoning — recommendations only; the maintainer and main agent make the calls.
- **Why** — this inventory is the evidence base for a joint stay/go/adjust assessment and the seed of a future *opinion register* (human-readable in README + agent-usable tracking of what promode instantiates where). Completeness matters more than concision here — a missed opinion silently survives the assessment.
- **Verified vs assumed** — designed duplication (brief ↔ defs, with per-pin calibration) is house policy, NOT a finding; only *substantive* drift between copies is. The TDD block is verbatim-shared by senior-engineer + CTO and deliberately calibrated in fast-worker (see `runbooks/sync-a-shared-principle.md`).
- **Not / exit** — extraction + assessment ONLY: change no def, no brief, no skill. Read every file in full; no sampling. Exit: both artifacts committed in your worktree, Outcome recorded in **your worktree's tracked copy of this doc** (worktree isolation blocks the shared path).

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — read-only w.r.t. the corpus; completeness over concision
- **Established facts** — authoring register ratified 2026-07-07
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
_(filled by the agent on completion)_
