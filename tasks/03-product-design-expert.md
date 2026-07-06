# product-design-expert: collapse internal repeats, adopt reactable-prototype discipline

## Brief
- **Orient** — `plugins/promode/agents/product-design-expert.md` (heaviest agent def, ~12.3k chars; a signal:noise audit rated it Medium — most internal overlap in the corpus).
- **Specify** — one edited def, committed. Work items:

  **Cuts (~2.5–3k chars):**
  1. Persona-realism / post-hoc-justification is stated 4–5× (expertise list, `<how-you-think>`, two `<lenses>` questions, `<red-flags>`) → ONE full statement (keep the strongest, with rationale) + one red-flag line.
  2. The anti-complexity stance appears 3× ("You hate unnecessary complexity…" / "You think most features should be cut…" in character; "Removing over adding" in how-you-think; "Complexity added 'in case'…" in red-flags) → one home.
  3. The generic psychology/behavioural-econ/network/growth lens question-lists are latent opus knowledge (the audit: an opus model prompted "behavioural economics lens" produces these questions unaided) → compress to lens headers + one line each. KEEP the persona lens whole (promode-specific). Cut "Where's the dopamine?" (colour, not instruction).
  4. Drop the inline DESIGN_SYSTEM bootstrapping template — the def already defers that format to the `design-system-lookbook` skill two lines earlier; keep the deferral, delete the duplicate template.

  **Keep untouched (audit-flagged load-bearing):** the propagation rationale (user-need assumption → domain model → architecture), the graded-evidence discipline, the PERSONAS.md/DECISIONS.md format templates, the three-shape `<giving-feedback>` contract.

  **Additions:**
  5. **"Reacting beats imagining"** — tacit taste is extracted with *reactable artifacts*, not questions about preferences.
  6. **UI-prototype mechanics** for taste extraction: 3 (max 5) **radically different** variants — "three slightly-tweaked card grids isn't a UI prototype, it's wallpaper" — mounted **inside the existing page/app**, not a standalone route ("a throwaway route is a vacuum: every variant looks fine in isolation"), switchable (e.g. `?variant=`), hidden from production builds; no persistence, no tests, no polish. The expected feedback shape is compositional ("the header from B with the sidebar from C — that's the actual design they want"). Capture the *answer* (decision node / DECISIONS.md), then delete the prototype.
- **Why** — cuts per the audit; additions converged on by two community authors (dzhng "reactable artifacts", mattpocock `prototype`/UI). The main-agent brief is gaining a matching prototype-detour dispatch clause (separate task), so this def carries the mechanics end.
- **Verified vs assumed** — repeat locations from the 2026-07-06 audit; confirm by reading before cutting.
- **Not / exit** — this file only; keep the persona-first voice. Exit: committed in your worktree, Outcome recorded below.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — persona-realism must survive as one strong statement + red-flag (it's core doctrine — collapse, don't delete)
- **Established facts** — audit + convergence findings above
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
_(filled by the agent on completion)_
