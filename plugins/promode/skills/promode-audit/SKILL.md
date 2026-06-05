---
name: promode-audit
description: "Audit how well a repository's codebase and practices align with the promode methodology, then produce a prioritised, actionable improvement plan. Fans out parallel assessors (one per dimension) and synthesises their findings. Use when the user wants to assess promode alignment/fit, audit a repo against the methodology, or get a plan to bring a codebase in line with promode. NOT for checking the promode install itself (hook/settings) — that's the managing-promode audit."
---

You (the main agent) run this audit: fan out parallel assessors, one per dimension, then synthesise their findings into a prioritised, actionable plan. The assessors gather evidence; the **prioritisation and plan are yours** — that judgement is not delegated.

This audits the **repo's alignment with promode's working practices**, not whether promode is installed (that's `managing-promode` → audit).

<process>
1. **Frame** — Skim `CLAUDE.md` and `README` to understand the repo (language, stack, size, test setup). Pick which dimensions apply and scale the assessor count to the repo (a small library may merge dimensions; a large system warrants all of them, possibly split by area).
2. **Fan out assessors in parallel** — Dispatch one background agent per dimension using the standard fire-and-forget pattern (all in one turn, then end the turn; their `<task-notification>`s wake you). Each is **read-only — instruct it to modify nothing**. Give each the assessor brief below. Wait for all to report.
3. **Synthesise** — Merge findings into one assessment and a single prioritised plan (format below). Resolve overlaps between dimensions; rank across all of them.
4. **Deliver & offer to capture** — Present the report. Offer to turn the plan into tracked work (e.g. `KANBAN_BOARD.md` / `IDEAS.md`) or a saved report file.
</process>

<dimensions>
The promode-alignment axes. Each is one assessor's deliverable.

| Dimension | Assesses (promode principle) | Suggested assessor |
|-----------|------------------------------|--------------------|
| **Tests & feedback loops** | Behaviour-focused tests on critical paths; tested through public interfaces vs coupled to implementation / over-mocked; speed & determinism (can an agent get a fast pass/fail signal?); a documented one-command way to run tests, lint, typecheck, and the app. *(TDD, tests-as-documentation, fast feedback, verifier-readiness)* | `promode:code-reviewer` (opus) |
| **Agent knowledge & orientation** | Apply the **CLAUDE.md health check** (below). Beyond it: orientation for subsystems; non-obvious build/run/gotcha knowledge captured or tribal? Significant decisions recorded (ADR-style) or will agents re-litigate them? *(CLAUDE.md-rooted knowledge graph, decision capture)* | `general-purpose` |
| **Architecture & navigability** | Module depth vs shallowness; testability (dependency injection, seams, return-values over side-effects); oversized files that burn agent context; tangled coupling, dead code, misleading names. *(small diffs, testability, context-frugality)* | `promode:code-reviewer` (opus) |
| **Change hygiene** *(optional)* | Commit focus & size; messages explain *why*; do tests land with the code they cover? *(small focused commits, explain-why, visible TDD)* | `general-purpose` |
</dimensions>

<claude-md-health>
`CLAUDE.md` is auto-loaded into **every** agent's context, so it's the highest-leverage file in the repo. The Agent-knowledge assessor evaluates it specifically against three tests, and recommends a concrete restructure (what to cut, what to link, what signposts to add) where it falls short:

1. **Concise** — it enters *every* agent run, so every extra line is a token tax paid each time *and* dilutes attention, harming reasoning quality. Flag bloat: long prose, duplicated content, detail that belongs in a linked doc. It should be a launchpad, not a manual.
2. **Only critical essentials inline; everything else linked.** The decision rule is **criticality, not topic**: what an agent would *fail or do harm without* (build/run/test, hard constraints, landmines) must live **in** `CLAUDE.md` — a link may not be followed, so critical knowledge can't be merely discoverable. Everything else, including detailed role-specific guidance (engineering, QA, product design, marketing), is demoted to the wiki and reached by a **signpost link**. Flag both failures: (a) critical knowledge that's only linked, not inline; (b) non-critical detail bloating `CLAUDE.md` that belongs in a linked doc.
3. **Entry point to the knowledge graph** — does it link out to the key docs so an agent can reach any major area in a hop or two? Flag orphaned docs (reachable from nothing = invisible) and missing links.
</claude-md-health>

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
<2–4 sentences. Per-dimension rating: Tests <R> · Knowledge <R> · Architecture <R> · Hygiene <R>>

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
