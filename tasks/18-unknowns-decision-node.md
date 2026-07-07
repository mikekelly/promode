# Unknowns field-guide integration: decision node + parked ideas + bump

## Brief
- **Orient** — `docs/decisions/` (house style: `2026-07-skills-elimination.md`), `IDEAS.md`, `tasks/17-unknowns-ux-opinions.md` (the adopted half — must be landed first), `plugins/promode/docs/opinion-register.md`, RUNBOOKS.md (version-bump runbook).
- **Specify** — record what was adopted, rejected, and parked from "A Field Guide to Fable: Finding Your Unknowns" (2026-07-07 ratification). Deliverables, one commit:
  1. **New decision node `docs/decisions/2026-07-unknowns-field-guide.md`** — decided / rejected / why, house style:
     - **Adopted**: O40 `blind-spot-pass`, O41 `user-comprehension-gate`, O42 `plans-lead-with-tweakables`, O18 calibration (starting-point disclosure + reference invitation). Framing: the article is a catalogue of *main-agent↔user interaction UX* for draining the user's unknowns; most of it promode already carried agent-side (interviews = O18; brainstorm/prototype reaction = O29/PD10; plans weighted by reversibility = A2/A3; implementation notes = O19 task docs).
     - **Rejected, with why** (anti-re-proposal record, the K3 point of this node):
       a. *Skill-suite delivery form* (dzhng's `explore-unknowns` et al.) — M5: voluntary invocation is non-determinate; borrowed as prompting reference only, delivered via the brief.
       b. *"Hit an edge case → pick the conservative option, log it under Deviations, keep going"* — conflicts O37/O25: promode's stance is escalate-early or reslice, never silently deviate-and-continue; deviations that do happen are already recorded in the task-doc Outcome (O19).
       c. *A new opinion for pre-implementation HTML prototypes/brainstorm artifacts* — already covered: the workflow's spike detour (O29) and PDE's reacting-beats-imagining (PD10); no register gap.
       d. *A standalone `implementation-notes.md` file* — task docs are the durable home (O19); a second live notes file competes with the single source of status (O20's drift argument).
       e. *The four-quadrant framework as its own register section* — carried as the rationale inside O40, not a standalone taxonomy (M1: frameworks the model already knows earn no tutorial).
       f. *Delta-vs-attention as O41's trigger* (the first-draft heuristic: "substantial work the user didn't watch") — superseded during ratification: it keys on volume and so taxes autonomy itself; the ratified trigger is unratified decision risk (plan divergence, under-explored consequential decisions, remit strain), with the autonomy remit agreed at dispatch as the yardstick, and the gate confined to the ratification point — never pausing execution.
     - **Parked → IDEAS.md**: pitch/explainer packaging (buy-in artifact for teams; solo-owner need is covered by O41's explainer half — revisit if promode grows multi-stakeholder consumers).
  2. **IDEAS.md**: one entry for the parked pitch/explainer packaging, linking the decision node.
  3. **Version bump** per the release runbook: 2.38.7 → **2.39.0** (new register opinions = minor).
- **Why** — K3: rejections without a recorded why get re-proposed; CM directs agents to check `docs/decisions/` before suggesting methodology ideas, so this node is the enforcement surface for the rejected clauses.
- **Verified vs assumed** — Rejection rationales ratified in-session 2026-07-07. Assumed: task 17 landed the register rows exactly as slugged — verify slugs/ids against the landed register before citing them.
- **Not / exit** — do not edit the register, brief, or defs (task 17 owned those; if a mismatch surfaces, stop and report — don't fix). Exit: node + IDEAS entry + bump committed, `./scripts/check-hooks.sh` still green, Outcome recorded. No push.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — chained after task 17 (cites its landed slugs); bump 2.39.0
- **Established facts** — ratified 2026-07-07; article text preserved in the ratifying conversation, substance restated in this doc
- **Pending goals / next step** — dispatch to fast-worker after task 17 lands

## Outcome

Landed 2026-07-07. Verified task 17's landed register rows (`2bffea5`) against the register before
citing them — O18/O40/O41/O42 slugs and substance matched the task doc's assumptions exactly, no
mismatch surfaced.

Deliverables, one commit:
1. `docs/decisions/2026-07-unknowns-field-guide.md` — new decision node, house style matching
   `2026-07-skills-elimination.md`: what was adopted (O40/O41/O42 + O18 calibration, with the
   already-carried-agent-side framing), rejected a–f with why in full (substance preserved
   verbatim-in-substance per M3, not compressed), parked pitch/explainer packaging, reversibility note.
2. `IDEAS.md` — one entry for the parked pitch/explainer packaging, linking the new node.
3. Version bump via `scripts/bump-version.sh 2.39.0` (2.38.7 → 2.39.0, minor: new register opinions
   landed in task 17; this task only documents/bumps).

`./scripts/check-hooks.sh` green (all 9 checks, including the version-banner check confirming
"Promode v2.39.0" is model-visible in chunk 1). Did not touch the register, brief, or agent defs —
none needed touching; no mismatch found.

Not verified / assumptions: relied on task 17's commit (`2bffea5`) and its diff as the source of
truth for landed wording rather than re-deriving it independently — read the actual register rows
directly (not just the commit message) before drafting the node, so this is a direct read, not an
inference from the commit message alone.
