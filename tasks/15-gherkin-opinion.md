# Gherkin-driven headless E2E: opinion supersession + style doc

## Brief
- **Orient** — `tasks/15-gherkin-research.md` (the extracted overlay-mono doctrine — source material, committed alongside this doc), `plugins/promode/docs/discovery-to-determinism.md` (carries the anti-BDD-framework stance to supersede), `plugins/promode/docs/opinion-register.md`, the brief's `<feature-knowledge-base>` ("Gherkin is *one* option, not a mandate"), SE def's trace-user-need bullet, `runbooks/sync-a-shared-principle.md`.
- **Specify** — maintainer-ratified opinion change (2026-07-07): **Gherkin drives the headless E2E suites by default.** Why (record verbatim in substance): fast wall-clock feedback (headless seam + parallel workers), and a text-readable description of behaviour in product/domain terminology that agents use for orientation — in an agent-first codebase the `.feature` file always has a reader, which dissolves the old "only if a non-technical stakeholder reads it" gate. Deliverables, one commit:
  1. **New routed doc `plugins/promode/docs/gherkin-style.md`** — distilled from the research (cite overlay-mono provenance): declarative-not-imperative (implementation nouns live in step defs, with the before/after example pattern); business/domain language + vocabulary discipline (glossary-node tie-in); Given=context / When=one action / Then=one observable business outcome per line; environment preconditions in Before hooks never Given; one behaviour per scenario, named in the title; third-person named personas (tie to PERSONAS.md); feature-level "So that …, <product> lets …" narrative; Background = single business-language Given; tag taxonomy (lifecycle `@todo` spec-ahead / tier / family / traceability); WHY-comments welcome, implementation nouns not; no duplication across tiers — one owner per behaviour; **black-box assertions only** (dev seams are Given-fixtures, never Then-evidence — steps assert via product-visible surfaces, and a scenario needing a backend shortcut means a missing product surface); fail-loud, never soft-skip (zero-assertion false green); step-def organisation (family split over a shared world/seam module, no copy-paste helpers); parallel workers + per-scenario entity isolation for wall-clock; spec-first — the feature directory is the canonical product spec, scenarios written as the product decision. Generalise: promode-generic, no tinytill nouns except in attributed examples.
  2. **Supersede in `discovery-to-determinism.md`**: the anti-BDD-framework paragraph → gherkin default (step definitions bind scenarios to the operator seam; the indirection buys the agent-orientation layer). Mark superseded-not-overwritten with the why.
  3. **Register**: new opinion row (gherkin-drives-headless-e2e; homes: d2d doc, gherkin-style doc, brief, SE/VER defs) + supersession note on the old optionality clause; Components: add the routed-doc entry.
  4. **Brief `<feature-knowledge-base>`**: "(Gherkin is *one* option, not a mandate)" → the new default, one clause, chunk sizes checked.
  5. **Defs**: SE + VER get the conditional read of `${CLAUDE_PLUGIN_ROOT}/docs/gherkin-style.md` when writing/running feature scenarios (PDE too if its scenario-bridge mention warrants it); sync-runbook discipline for any shared-block touch.
- **Verified vs assumed** — research file-verified against overlay-mono 2026-07-07; current promode wording locations assumed from the 09 inventory — re-read before editing (D's sweep may have moved them).
- **Not / exit** — blocked until Migration D lands (it owns register/README/CLAUDE.md right now). No README change needed beyond what D establishes unless a stale claim surfaces. `./scripts/check-hooks.sh` green; bump 2.37.0; Outcome here; no push.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — blocked on D; supersede-don't-overwrite; chunk caps
- **Established facts** — ratified 2026-07-07; research committed
- **Pending goals / next step** — dispatch when D lands

## Outcome
_(filled by the agent on completion)_
