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
**Done 2026-07-07.** `tasks/09-opinion-inventory.md` committed: **~100 distinct opinions** extracted (grouped M/O/P/K/T/D/R/V/PD/A/E/AN by domain), each with slug, canonical statement, homes (verbatim/calibrated/decision↑/mechanics↓), rationale-attached verdict, flags, and inline stay/go/adjust rec; closing assessment carries the conflict list, coverage matrix, rec roll-up, and register seeds for task 10.

Key findings:
- **No hard contradictions.** SE↔CTO TDD blocks verified checksum-identical (`8562ef13…`); FW's divergence matches the runbook's documented calibration. 8 tensions/divergences catalogued (C1–C8), most designed or resolved.
- **Adjust recommendations (7):** within-brief double-statement of steer/resume (O5); CR lacks the task-doc verdict line its five executing peers have (O19); `behavioural-authority` is the only wide duplicate rationale-bare in all five homes (P11, violates rationale-travels); EM writes scripts but has no commit discipline (P12); VER+AA have no knowledge-capture section, plausibly deliberate but undocumented (K1/K2); **FW's agent-knowledge silently lacks the decision-node sentence — the one undocumented divergence in a designed-duplicate family (K3)**; two consider-tier widenings (T18 second-consumer rule, R4 consensus-audit → brief ratification).
- **Go: none** — every opinion traces to rationale and none is contradicted; harness-pinned opinions (O4, O6, V6, O14) need re-verification cadence, not removal.
- Corpus read in full (brief 3 chunks + all nine defs); no def/brief/skill changed; no version bump; no push.
