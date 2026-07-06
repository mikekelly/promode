# Skills: cut within-file restatement, add claim-verification to the audit, fix description tails

## Brief
- **Orient** — `plugins/promode/skills/{discovery-to-determinism,promode-audit,reinforce-design-constraints,design-system-lookbook}/`. The corpus standard (its own bar): skills are "tight landmines-not-docs… not bloated comprehensive manuals." Frontmatter descriptions load into EVERY session — they're the most expensive text in the plugin. `./scripts/check-hooks.sh` runs the frontmatter check; keep it green.
- **Specify** — four skills edited, committed. Work items:

  **discovery-to-determinism/SKILL.md**
  - DELETE `<success_criteria>` — the third full pass over rules already stated in the body.
  - TRIM the "ratchet" paragraph in the flywheel/closing-the-loop essay (it re-argues the asymmetry the two arrows already establish).
  - Remove one of the two verbatim "an un-crystallised discovery is a missing feedback loop" statements (keep the `<disciplines>` copy).
  - Description: cut the third sentence ("Covers the Discovery⇄Determinism flywheel…" — a table of contents, not a trigger) and add the pre-filter "when a UI fronts real logic" so it fires less on plain E2E requests its own applicability gate then rejects.

  **promode-audit/SKILL.md**
  - `<dimensions>` table cells → one-line pointers to their detailed sections (every dimension with a long cell also has a full section below; the audit: "a table of one-line pointers would halve the table at no loss").
  - Description: drop the trailing parenthetical settings list (body detail).
  - ADD to the agent-knowledge dimension rubric: **claim verification** — knowledge-doc statements are evidence-bearing claims: spot-check them against the code (do greppable pointers still resolve? are asserted invariants actually enforced, or only asserted?), and apply the reconstruction test — "could a reader reconstruct this paragraph by reading the code? → cut it, leave a pointer." A doc the code has moved past is a finding.

  **reinforce-design-constraints/SKILL.md**
  - The plain-link/@import/locality rule currently has 4–5 homes in one file (intro, `<the-tension>`, process step 6, `<guardrails>`, `<success_criteria>`) → ONE authoritative statement in `<the-tension>`, short pointers elsewhere, and fold/delete `<success_criteria>`'s restatements.
  - Description: cut the mechanics sentence (it duplicates the body verbatim); keep the excellent trigger verbs.

  **design-system-lookbook/SKILL.md**
  - Description: move the trailing two sentences ("The visual analogue… Defers aesthetic taste…") into the body; the description keeps only trigger content.

  **references/operator-seam-and-agent-tools.md** (under discovery-to-determinism)
  - ~60% overlaps the SKILL's `<the-operator-seam>` section. Dedupe ONE side: either shrink the ref to its genuinely-new section (how to build the seam so it *could* serve agents later) or compress the SKILL bullet to axis names + dispatch. State which you chose and why in the Outcome.
- **Why** — a 2026-07-06 signal:noise audit: within-file restatement is where this corpus's waste concentrates, and description tails tax every session (~200 tokens/session across users).
- **Verified vs assumed** — finding locations from the audit; confirm by reading before cutting.
- **Not / exit** — do NOT touch other skills, agent defs, or the brief. No behavior changes beyond the claim-verification addition — cuts must be pure dedup. Exit: `./scripts/check-hooks.sh` green, committed in your worktree, Outcome recorded below.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — descriptions must keep trigger accuracy; rationale stays with rules (dedupe copies, never the why)
- **Established facts** — audit findings above
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
**Done** — commit `db2a944` (includes this Outcome, added by amend) on branch `worktree-agent-a234f9ec09b6d6ae0` (agent worktree), `./scripts/check-hooks.sh` green (frontmatter check included). 4 skill files, +16/−36 lines; no version bump, not pushed.

Per work item:
- **discovery-to-determinism/SKILL.md** — `<success_criteria>` deleted; ratchet paragraph trimmed to its non-duplicated caveat (kept "model not measured law" + stale-map inversion, cut the sentence restating the two arrows); "un-crystallised discovery is a missing feedback loop" now only in `<disciplines>` (quick_start item 5 points there); description lost the "Covers…" table-of-contents sentence and gained the "when a UI fronts real logic" pre-filter.
- **promode-audit/SKILL.md** — table cells for Framing, Tests (the layered-coverage tail), Agent knowledge, Observability, and Design compressed to pointers at their full sections; Architecture and Change hygiene cells kept (no sections below). Description dropped "(in-repo auto-memory, worktree baseRef)". **Claim verification added** to the agent-knowledge cell as rubric item (3), with "docs verified against code" appended to the principle tag.
- **reinforce-design-constraints/SKILL.md** — `<the-tension>` is now the single authoritative home for plain-link/@import/locality (the guardrail's locality-cost sentence and "a plain link never carries a critical rule" folded in); intro, process step 6, and the guardrail bullet reduced to short pointers at `<the-tension>`; `<success_criteria>` deleted whole — every bullet restated the objective, `<the-tension>`, `<inline-format>`, or `<guardrails>`. Description mechanics clause ("stated inline, or @import-transcluded… expanded discovery") cut; trigger verbs intact.
- **design-system-lookbook/SKILL.md** — the two trailing description sentences were cut rather than moved: the body already carries both verbatim-equivalent (visual-analogue framing in `<objective>`'s table + `<related>`; the frontend-design deferral in `<objective>` and `<boundary-with-frontend-design>`), so a move would have created the very duplication this task removes.

**Operator-seam dedup choice: compressed the SKILL bullet (axis names + `axi` dispatch + pointer), kept the ref intact.** Why: SKILL.md loads on every trigger of the skill while the ref loads only when the seam↔agent-tools question is actually live, so the detail belongs on the cheaper, on-demand side; the ref is already framed as the "in depth" home and holds genuinely-new material (per-axis table, security fence, build-toward guidance, n=1 status). Rationale travels with the rule — the full why stays at the ref, and the SKILL keeps its binding one-liners un-deduped (never one interface, never god-mode to an agent, n=1 honesty).

**Task-doc corrections found while confirming the audit's locations:**
- The reinforce-design-constraints rule had **substantively 4 homes, not 4–5**: intro, `<the-tension>`, step 6, `<guardrails>` — `<success_criteria>` restated inline+link/lean-launchpad themes but never the @import/plain-link rule itself. Deleted it anyway (it was 100% restatement of other sections).
- The promode-audit premise "every dimension with a long cell also has a full section below" was **wrong for Agent knowledge**: the cell's capture and skill-quality checks exist nowhere in `<claude-md-health>`, so a pure one-line pointer would have lost them. Kept both in the cell (compressed) alongside the new claim-verification item; only the discoverability/hierarchy/symlink content — which the health check does fully carry — became pointer text.
- design-system-lookbook "move into the body" was already satisfied by the existing body; the edit is description-only.

*(Recorded in the worktree copy of this doc — the shared-checkout path is write-blocked for this isolated agent; this Outcome travels with the commit.)*
