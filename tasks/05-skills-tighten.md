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
_(filled by the agent on completion)_
