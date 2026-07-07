# Decided: what "A Field Guide to Fable: Finding Your Unknowns" changed (2026-07 unknowns integration)

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) →
decision/rejected-work capture). Maintainer-ratified 2026-07-07. Landed as
[`tasks/17-unknowns-ux-opinions.md`](../../tasks/17-unknowns-ux-opinions.md) (commit `2bffea5`).
Register opinions: **O40 `blind-spot-pass`**, **O41 `user-comprehension-gate`**,
**O42 `plans-lead-with-tweakables`**, plus an **O18 `clarify-outcomes-first`** calibration.

## What the article was

"A Field Guide to Fable: Finding Your Unknowns" is a catalogue of **main-agent↔user interaction UX**
for draining the user's unknowns across a session — interviewing before work starts, surfacing blind
spots, checking comprehension before ratifying autonomous work, and shaping plans/notes for reaction.
Most of its substance was **already carried agent-side** in promode before this pass:

- interviews → O18 `clarify-outcomes-first`
- brainstorm / prototype reaction → O29 `spikes-answer-questions` / PD10 `reacting-beats-imagining`
- plans weighted by reversibility → A2 `reversibility-weighted-depth` / A3 `recommendation-plus-strongest-rejected`
- implementation notes → O19 `plans-persist-as-task-docs`

The genuinely new ground was the **user-facing UX layer** these agent-side mechanics didn't yet
cover: draining *unknown* unknowns (not just perceived ones), gating ratification on comprehension
rather than volume, and ordering ratification artifacts for reaction. That's what O40/O41/O42 add.

## What was adopted

- **O40 `blind-spot-pass`** — when work enters territory the user signals or the agent infers is
  unfamiliar, run a blind-spot pass (delegated exploration) before pinning outcomes: the O18
  interview only drains unknowns the user already perceives; a user who doesn't know what good looks
  like can't accept criteria for it. Home: `B§clarifying-outcomes`.
- **O41 `user-comprehension-gate`** — a two-ended contract around autonomous runs: the autonomy
  remit is set at dispatch/plan time (how autonomous, which decision classes the main agent may
  settle vs. must surface); at the ratification/merge point the main agent *offers* an explainer +
  comprehension check over the *unratified decision risk* the run accumulated. Three load-bearing
  calibrations preserved: **offer, never an agent-enforced gate**; trigger is **unratified decision
  risk, never volume** (diff size / run length / "wasn't watching" must never fire it); it lives **at
  the ratification point only**, never pausing execution mid-run. Home: `B§execution`.
- **O42 `plans-lead-with-tweakables`** — plans and design drafts presented for ratification lead with
  the decisions most likely to change (entity/data model, interfaces, user-facing flows) and bury the
  mechanical tail — the ratification artifact is a reaction surface, so ordering it for reaction is
  part of the deliverable. Homes: `B§planning`; CTO (calibrated — its drafts are the main ratification
  artifacts).
- **O18 calibration** — `<clarifying-outcomes>` now opens with starting-point disclosure (where the
  user is in their thinking, their experience with the problem and this part of the codebase — this
  is what decides whether O40 fires) and invites a reference when articulation stalls (source code —
  a folder, a library, a site's markup, even in another language — beats a lossy verbal description).

Canonical wording for all four lives in the register
([`plugins/promode/docs/opinion-register.md`](../../plugins/promode/docs/opinion-register.md), rows
O18/O40/O41/O42) — this node restates substance for the rejection record below, the register is the
source of truth.

## Rejected, with why (anti-re-proposal record — the K3 point of this node)

a. **Skill-suite delivery form** (dzhng's `explore-unknowns` et al., the article's own packaging).
   Rejected under **M5**: voluntary invocation is non-determinate — a skill fires off a description
   competing in a listing, the model may or may not invoke it. The article's mechanics were borrowed
   as prompting reference only; delivery is via the brief (guaranteed load), not a skill.

b. **"Hit an edge case → pick the conservative option, log it under Deviations, keep going."**
   Rejected: conflicts **O37** (escalate-early, bounded attempts) and **O25** (reslicing is progress,
   not silent deviation). Promode's stance is escalate-early or reslice the plan — never silently
   deviate-and-continue under a logged exception. Deviations that legitimately do happen are already
   recorded in the task-doc Outcome section (O19); no separate "Deviations" mechanism is needed.

c. **A new opinion for pre-implementation HTML prototypes / brainstorm artifacts.** Rejected: already
   covered by the workflow's spike detour (**O29** `spikes-answer-questions`) and PDE's
   reacting-beats-imagining (**PD10**). No register gap — this would have been a duplicate opinion
   under a new name.

d. **A standalone `implementation-notes.md` file.** Rejected: task docs are already the durable home
   for a task's brief/state/outcome (**O19**); a second live notes file competes with the single
   source of status and reintroduces the drift **O20** (`kanban-flow`) explicitly designed out — the
   column owns status, task docs never carry a competing live-status field, and a parallel notes file
   would be the same failure mode one layer up.

e. **The four-quadrant framework as its own register section.** Rejected: the framework is carried as
   the *rationale inside* O40, not promoted to a standalone taxonomy. Per **M1**
   (`opinions-not-tutorials`), a framework the pinned model already knows how to reason about earns no
   dedicated tutorial section — only the opinion (when to run a blind-spot pass) needs stating.

f. **Delta-vs-attention as O41's trigger** — the first-draft heuristic: gate on "substantial work the
   user didn't watch." Superseded during ratification, not merely rejected: it keys on *volume*
   (diff size, run length, "wasn't watching"), which taxes autonomy itself — exactly the failure mode
   O41's own calibrations rule out. The ratified trigger is **unratified decision risk** (plan
   divergence, under-explored consequential decisions, remit strain), measured against the autonomy
   remit agreed at dispatch, with the gate confined to the ratification point — never pausing
   execution mid-run. See O41's row in the register for the full three-calibration statement.

## Parked

- **Pitch/explainer packaging** (a buy-in artifact for teams evaluating or adopting promode) — parked
  to `IDEAS.md`. The solo-owner need is already covered by O41's explainer half (the comprehension
  check offered at ratification); a dedicated pitch artifact is only worth building if promode grows
  multi-stakeholder consumers (a team evaluating adoption, not a single owner ratifying their own
  runs). Revisit if that changes.

## Reversibility

Cheap to reverse in-repo: O40/O41/O42 are brief/def prose plus register rows, no schema or external
state. A revert is a normal git revert + patch release. The rejected alternatives (b, d, f especially)
were rejected for conflicting with existing load-bearing opinions (O37/O25, O20, O41's own
calibrations) — reversing this node would require first reversing those, not just this decision.
