---
name: promode-audit
description: "Audit how well a repository's codebase and practices align with the promode methodology, then produce a prioritised, actionable improvement plan. Fans out parallel assessors (one per dimension) and synthesises their findings. Use when the user wants to assess promode alignment/fit, audit a repo against the methodology, or get a plan to bring a codebase in line with promode. Also flags stale per-project install leftovers — promode ships its own SessionStart hook, so nothing should be copied into a project."
---

You (the main agent) run this audit: fan out parallel assessors, one per dimension, then synthesise their findings into a prioritised, actionable plan. The assessors gather evidence; the **prioritisation and plan are yours** — that judgement is not delegated.

This audits the **repo's alignment with promode's working practices**, plus a pre-flight setup check. promode ships its delivery via its own plugin SessionStart hook, so nothing is installed per-project — the only setup issue to catch is *stale* leftovers from the retired copy-install.

Each dimension is a **reusable lens, not just a step in the full sweep** — it mirrors what a working agent is already responsible for. The same standard runs at three cadences: every agent upholds its dimension *continuously* while working; a single owning agent can be asked to audit just its dimension for a *targeted* spot-check (e.g. `promode:code-reviewer` for tests or architecture); or you run this skill for the *full* parallel sweep. Auditing and doing are the same standard, zoomed differently.

<process>
1. **Frame** — Skim `CLAUDE.md` and `README` to understand the repo (language, stack, size, test setup). Pick which dimensions apply and scale the assessor count to the repo (a small library may merge dimensions; a large system warrants all of them, possibly split by area). Also do a quick **setup check**: the promode plugin delivers its brief via its own SessionStart hook, so a project needs nothing installed — flag any stale leftovers from the retired per-project copy-install (`.claude/PROMODE_MAIN_AGENT.md`, `.claude/hooks/promode-main-context.sh`, or a promode `SessionStart` entry in `.claude/settings.json`); they now double-inject the brief and should be removed.
2. **Fan out assessors in parallel** — Dispatch one background agent per dimension using the standard fire-and-forget pattern (all in one turn, then end the turn; their `<task-notification>`s wake you). Each is **read-only — instruct it to modify nothing**. Give each the assessor brief below. Wait for all to report.
3. **Synthesise** — Merge findings into one assessment and a single prioritised plan (format below). Resolve overlaps between dimensions; rank across all of them.
4. **Deliver & offer to capture** — Present the report. Offer to turn the plan into tracked work (e.g. `KANBAN_BOARD.md` / `IDEAS.md`) or a saved report file.
</process>

<dimensions>
The promode-alignment axes. Each is one assessor's deliverable.

| Dimension | Assesses (promode principle) | Suggested assessor |
|-----------|------------------------------|--------------------|
| **Framing & traceability** | Apply the **framing & traceability check** (below): does a top-down document hierarchy (goals/risks/priorities, realistic customer profiles / personas → marketing → feature definitions → feature tests) make the repo self-describing, each layer explaining WHY and linking up to a goal? *(feature knowledge-base, self-describing repo)* | `general-purpose` |
| **Tests & feedback loops** | Behaviour-focused tests on critical paths; tested through public interfaces vs coupled to implementation / over-mocked; speed & determinism (can an agent get a fast pass/fail signal?); a documented one-command way to run tests, lint, typecheck, and the app. Where a UI fronts real logic, apply the **Discovery → Determinism layered-coverage check** (below). *(TDD, tests-as-documentation, fast feedback, verifier-readiness)* | `promode:code-reviewer` (opus) |
| **Agent knowledge & orientation** | Apply the **CLAUDE.md health check** (below). Beyond it, the core question is whether durable reusable knowledge is **captured as linked nodes reachable from `CLAUDE.md`, or left tribal** — across the kinds the knowledge-graph model names: subsystem orientation, non-obvious build/run gotchas, **decisions** (ADR-style), and **runbooks** (repeatable operational procedures — deploy, migration, env bring-up, recovery, recurring incidents). Flag any kind that's missing, unlinked, or lives only in someone's head. *(CLAUDE.md-rooted knowledge graph; decision, runbook & operational-knowledge capture)* | `general-purpose` |
| **Architecture & navigability** | Module depth vs shallowness; testability (dependency injection, seams, return-values over side-effects); oversized files that burn agent context; tangled coupling, dead code, misleading names. *(small diffs, testability, context-frugality)* | `promode:code-reviewer` (opus) |
| **Observability & traceability** | Apply the **observability & traceability check** (below): do runtime logs carry a correlation/tracer ID that threads one request client→backend (and across service hops), filterable on both sides, so an agent can pull a single request's whole trace instead of slurping unfiltered logs? *(context is precious applied to runtime; cheap agent debugging)* | `promode:code-reviewer` (opus) |
| **Change hygiene** *(optional)* | Commit focus & size; messages explain *why*; do tests land with the code they cover? *(small focused commits, explain-why, visible TDD)* | `general-purpose` |
</dimensions>

<framing-traceability>
The repo should be **self-describing top-down** — a reader (human or agent) can start at the high-level goals and follow links down to the tests that implement them. The Framing & traceability assessor checks:

1. **The hierarchy exists** — are there docs for high-level goals/risks/priorities, realistic customer profiles / personas (`docs/product/PERSONAS.md`), product/marketing framing, feature definitions, and feature tests? Note which layers are missing or thin.
2. **Every layer explains WHY and links up** — each artifact states *why* it exists and links to the layer above, ultimately to a goal. Flag docs that describe only WHAT/HOW with no WHY, and layers that don't connect upward.
3. **No orphans, no drift, no sprawl** — can each significant feature be traced up to a goal? Flag orphaned features (no link to any goal → likely superfluous, or the goals doc is stale) and goals nothing implements. Also flag **goal sprawl** — an unfocused or ballooning goals/risks/priorities list, or goals that look invented post-hoc to justify a feature; too many goals is itself a finding (focus is the scarce resource). A broken chain is a **diagnostic signal**, not just a missing file — say which interpretation is likely and recommend the fix (cut the work, sharpen the goal, or update a *genuinely* stale goals doc).
4. **User-facing features trace to a realistic persona** — can each user-facing feature name the documented customer profile / persona it serves? Flag features with no persona (who is this *actually* for?) and personas that look invented or flattered to justify a feature rather than grounded in real customer evidence — the same post-hoc-justification trap as a stretched goal. A persona with no evidence behind it is a finding, not a framing artifact.
</framing-traceability>

<claude-md-health>
`CLAUDE.md` is auto-loaded into **every** agent's context, so it's the highest-leverage file in the repo. The Agent-knowledge assessor evaluates it specifically against three tests, and recommends a concrete restructure (what to cut, what to link, what signposts to add) where it falls short:

1. **Concise** — it enters *every* agent run, so every extra line is a token tax paid each time *and* dilutes attention, harming reasoning quality. Flag bloat: long prose, duplicated content, detail that belongs in a linked doc. It should be a launchpad, not a manual.
2. **Only critical essentials inline; everything else linked.** The decision rule is **criticality, not topic**: what an agent would *fail or do harm without* (build/run/test, hard constraints, landmines) must live **in** `CLAUDE.md` — a link may not be followed, so critical knowledge can't be merely discoverable. Everything else, including detailed role-specific guidance (engineering, QA, product design, marketing), is demoted to the wiki and reached by a **signpost link**. Flag both failures: (a) critical knowledge that's only linked, not inline; (b) non-critical detail bloating `CLAUDE.md` that belongs in a linked doc.
3. **Entry point to the knowledge graph** — does it link out to the key docs so an agent can reach any major area in a hop or two? Flag orphaned docs (reachable from nothing = invisible) and missing links.
</claude-md-health>

<layered-coverage>
When a UI sits over real logic, the test suite should be **layered, not flat** — the bulk of coverage runs fast and headless below the UI; the UI itself is exercised only for what *only* surfaces there. Agent discoveries should harden into deterministic artifacts instead of manual lore. The Tests assessor checks:

1. **A below-UI operator seam exists** — is there an interaction/operator layer beneath the UI that a test (or an agent) can drive end-to-end against real logic and persistence with no GUI? Flag suites that can only reach business logic *through* the UI: that forces slow, flaky tests to carry coverage a fast headless test could own. The same seam that makes the system headless-testable is *also* what would make it agent-operable — but that second payoff is an unproven prediction (n=1), so the **test-speed** gap is the finding here; note any agent-operability upside only as a secondary, speculative observation, never as a required-capability gap.
2. **Coverage is layered, not duplicated** — the headless tier should hold the bulk of acceptance coverage; any UI-level tests should be surgical, reserved for behaviour that manifests *only* through the running GUI (navigation gating, view/provider/persistence wiring, render defects). Flag slow UI tests re-checking logic the headless tier already covers — that merge is the central anti-pattern. (UI-tier tests are **verification-only and surgical** by design — they do not invert promode's "fast feedback = unit/integration; system tests are for verification, not debugging"; the headless seam is what keeps the bulk of feedback fast.)
3. **Discoveries are crystallised** — when an agent explores an unknown surface, is the finding hardened into deterministic, self-checking code (a map, recognizer, fixture, or test) rather than left as one-off manual knowledge? Flag exploration whose result wasn't captured as a re-runnable check, and UI checks pinned to coordinates/screenshots rather than stable selectors (they drift). Determinism that breaks *imprecisely* is a finding too: a failure that can't say which state/edge broke can't tell an agent where to re-discover.
</layered-coverage>

<observability-tracing>
Runtime traceability is **"context is precious" applied to debugging**: an agent that can filter a whole request by one correlation/tracer ID across client and backend never has to slurp megabytes of unfiltered logs into context — cheaper tokens, faster root-causing. The Observability & traceability assessor checks:

1. **Correlation IDs exist and propagate** — does a request carry a correlation/tracer ID that threads from the client through to the backend (and across service hops), rather than each tier logging in isolation? Flag boundaries where the ID is dropped or regenerated, so a single request can't be followed end-to-end.
2. **Logs are filterable by that ID on both sides** — are client and backend logs emitted in a form (a structured field or a consistent greppable tag) that lets an agent isolate one request's complete trace with a single filter? Flag unstructured or untagged logging that forces a full-log read to reconstruct one request.
3. **The discipline is built in, not bolted on** — is tracing present in the code paths that matter (boundary crossings, error paths) and asserted where it's load-bearing, rather than absent until someone needs to debug? Flag boundary-crossing code with no traceability as a **debugging feedback-loop gap**, not a cosmetic one — it's the runtime analogue of a missing test seam.
</observability-tracing>

<assessor-brief>
Give each assessor:
- **Scope** — its one dimension, and which part of the repo to read (whole repo, or an area for large codebases).
- **Read-only** — "Assess and report only. Do not modify, create, or commit any files."
- **Rubric** — the dimension's checklist (from the table), framed as "rate how well the repo does this, with evidence."
- **Required output** (so you can synthesise cleanly):
  - **Rating** — `Strong` / `Partial` / `Weak` for the dimension.
  - **Findings** — concrete, each citing file/path evidence (not "tests are weak" but "`src/checkout.ts` has no tests; `auth.test.ts` mocks the internal `UserStore`, coupling to implementation").
  - **Recommendations** — specific changes, each with rough effort (S/M/L) and the promode principle it serves.
</assessor-brief>

<output>
Synthesise into:

```
# Promode Methodology Audit — <repo>

## Overall alignment
<2–4 sentences. Per-dimension rating: Framing <R> · Tests <R> · Knowledge <R> · Architecture <R> · Observability <R> · Hygiene <R>>

## Findings by dimension
### <Dimension> — <rating>
- <finding with file evidence>

## Prioritised action plan
Ranked across all dimensions by impact × effort. Each item:
**[Now/Next/Later] <change>** — why it matters for promode · effort S/M/L · suggested executor (`promode:<agent>`)
```

- **Now** = high impact, low/medium effort (unblocks agents working effectively — e.g. "no fast test loop", "no CLAUDE.md orientation"). **Next** = high impact, higher effort. **Later** = lower impact / nice-to-have.
- Lead with the items that most improve an agent's ability to work the codebase (a fast feedback loop and a usable knowledge root usually rank highest — they compound).
- Keep every item actionable and concrete; tie each to the promode agent that would execute it.
</output>
