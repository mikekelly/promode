# Runbook: Sync a shared principle across its homes

What this is: how to change a methodology principle without leaving any of its copies inconsistent.
Promode keeps a principle in **multiple homes by design** — the brief plus every agent definition
that carries it (the TDD block alone lives in three) — change one copy, you must change them all.

## Why multiple homes (don't "fix" this by centralising)

This is deliberate, stated in `CLAUDE.md` ("Principles live in two places by design" — the two
*sides*: the brief side and the definition side; on the definition side a principle may have
several agent homes) and in the brief's design notes:

- The **main agent** gets principles from the hook-delivered brief
  (`plugins/promode/PROMODE_MAIN_AGENT.md`, `<principles>` and the surrounding decision sections).
  It must be self-contained because a pointer may not be read.
- **Subagents** get nothing from the brief or `CLAUDE.md` methodology — each carries its own
  methodology inline in its definition (`plugins/promode/agents/*.md`).

So a shared principle (TDD non-negotiable, evidence over assumptions, crystallise discovery into
determinism, the operator-seam test strategy, runbooks/knowledge capture) is intentionally
duplicated. A doc link won't do — the inline copy is load-bearing in each home.

**The rationale travels with the rule.** When syncing, don't dedupe the *why* out of any copy to
save tokens: explaining why is as important as the rule itself — it's the frame for the judgement
calls the rule can't anticipate, and a rule stripped of its rationale gets misapplied. (Maintainer
ruling, 2026-07-02, after a prompt-corpus review proposed exactly that dedup.)

## Which files hold which principles

- **Brief** — `plugins/promode/PROMODE_MAIN_AGENT.md`: `<principles>`, plus the decision sections
  (`<test-strategy>`, `<after-action-review>` runbook/knowledge rules, `<feature-knowledge-base>`).
- **Subagents** — the relevant `plugins/promode/agents/*.md`. Shared-principle text (TDD / evidence /
  operator-seam / crystallise / behavioural-authority) lives across the engineer rungs, the CTO, and
  the review/debug/verify/env agents. (Re-grep before editing — `grep -ln 'TDD\|operator seam\|Crystallise\|Evidence over assumptions'
  plugins/promode/agents/*.md` — definitions drift.)

### Byte-identical families — enforced by a script, not eyeballed

The roster restructure (2026-07-10, [`docs/decisions/2026-07-agent-roster-restructure.md`](../docs/decisions/2026-07-agent-roster-restructure.md))
organised the engineer/worker rungs so several defs share a prompt **body** verbatim and differ only
in YAML frontmatter (`model:`/`effort:`) — "same prompt, different frontmatter." These families are
guarded deterministically by **`scripts/check-shared-principle-checksums.sh`** (CI-run): it re-splices
each block with awk and compares shasums, failing on any drift. **Run it after touching any member — it
IS the sync check for these blocks; do not eyeball them.** The families it pins (membership derived from
the committed defs):

- **Engineer body ×2** — `senior-engineer.md` and `mid-level-engineer.md` share their **whole body**
  (everything below the frontmatter) byte-identical: one engineer prompt, the Opus/high rung and the
  Sonnet/medium rung differing only in frontmatter.
- **Worker body ×4** — `elite-worker.md`, `high-level-worker.md`, `fast-worker.md`, `cheap-worker.md`
  share their **whole body** byte-identical: one generic-executor prompt across four cost tiers
  (inherit / Opus / Sonnet / Haiku). Workers carry no TDD / constraint-ladder / behavioural-authority —
  a worker that hits production code bounces it up to an engineer.
- **`<reporting>` ×7** — byte-identical across the engineer rungs (`senior-engineer`,
  `mid-level-engineer`), the four workers, and `gui-driver`. The specialist / judging / product defs
  (reviewer, verifier, debugger, CTO, CPO, SPD, auditor, agent-analyzer, environment-manager,
  constraint-reinforcer) carry a role-**calibrated** reporting payload (P13: pattern verbatim, payload
  calibrated) and are deliberately NOT members — asserting them equal would turn valid calibration into
  a false failure.
- **`<behavioural-authority>` ×5** — byte-identical (closing why-line included) across
  `senior-engineer.md`, `mid-level-engineer.md`, `chief-technology-officer.md`, `code-reviewer.md`,
  `debugger.md`.
- **`<test-driven-development>` ×3** — `senior-engineer.md`, `mid-level-engineer.md`,
  `chief-technology-officer.md`. SE and mid are already covered transitively by the engineer-body
  family; CTO is not a body-family member, so this check is what binds CTO's TDD copy to the engineers'.

**Superseded record (M3 — never silently deleted).** Before the roster restructure the families were
different, and the migration note in the decision node requires keeping the old shape visible: the full
`<test-driven-development>` section had **two** verbatim homes (`senior-engineer.md` +
`chief-technology-officer.md`); the old **`fast-worker.md`** was a *TDD-bound engineer* whose TDD copy
was deliberately **calibrated** to a weaker pin (fewer design-altitude bullets, no logic-spikes
exception) rather than byte-identical, and whose `<agent-knowledge>` omitted the decision-node sentence
by lane asymmetry; `<behavioural-authority>` listed that old fast-worker among its five homes. That
engineer role is now **`mid-level-engineer.md`** (a full engineer-body sibling of SE, so its TDD/BA are
now byte-identical, not merely calibrated); the name **`fast-worker.md`** now denotes a *generic worker*
with no TDD block at all, and the old fast-worker's behavioural-authority slot is now `mid-level-engineer`.

## Worked example

Commit **`510b071`** ("Mirror methodology into working agents: runbooks, audit-as-a-lens") is the
canonical principle-sync: it introduced the *runbook* principle and updated **both** homes in one
commit — the brief (`PROMODE_MAIN_AGENT.md`), the producing agent definitions
(then `implementer.md` — since split into the engineer rungs `senior-engineer.md` + `mid-level-engineer.md` — plus `debugger.md`, `environment-manager.md`, `verifier.md`), **and** the audit
lens that checks for it (then a skill; the audit now lives in `plugins/promode/agents/auditor.md`) —
so the audit lens and every working agent agreed. Note it also bumped the
version in the same commit (see [cut-a-release.md](cut-a-release.md)).

## Steps

1. Decide the principle change (an architectural call — this stays with the main agent, not delegated).
2. Edit the **brief** copy.
3. Re-grep the agent definitions for the old wording; edit **every** definition that carries it so
   the working agents match the brief. Don't add it to agents the principle doesn't apply to.
4. If your edit touched a member of a **byte-identical family** (above — engineer body, worker body,
   `<reporting>`, `<behavioural-authority>`, `<test-driven-development>`), re-run
   `./scripts/check-shared-principle-checksums.sh` and fix any drift before committing — it fails CI
   otherwise. This is the deterministic replacement for eyeballing the copies.
5. If the auditor (`plugins/promode/agents/auditor.md`) has a dimension that checks this principle,
   update it too (as `510b071` did with the audit lens of its day) so auditing and doing stay consistent.
6. If you edited the brief, re-run `./scripts/check-hooks.sh` — see
   [verify-hook-delivery.md](verify-hook-delivery.md).
7. Commit all homes **together** (one commit), with the version bump if you're releasing.

## See also

- `CLAUDE.md` — "Principles live in two places by design"
- Hub: [`RUNBOOKS.md`](../RUNBOOKS.md)
