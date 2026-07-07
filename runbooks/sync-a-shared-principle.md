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
- **Subagents** — the relevant `plugins/promode/agents/*.md`. As of this writing, shared-principle
  text (TDD / evidence / operator-seam / crystallise) lives in:
  `chief-technology-officer.md`, `senior-engineer.md`, `fast-worker.md`, `code-reviewer.md`, `debugger.md`, `verifier.md`, `environment-manager.md`.
  (Re-grep before editing — `grep -ln 'TDD\|operator seam\|Crystallise\|Evidence over assumptions'
  plugins/promode/agents/*.md` — definitions drift.)
- **The full `<test-driven-development>` section has two verbatim homes** — `senior-engineer.md` and
  `chief-technology-officer.md` (which carries it to bind its execute-itself exception) — kept
  **checksum-identical**: after editing one, re-splice or re-verify the other
  (`awk '$0=="<test-driven-development>"{p=1} p{print} $0=="</test-driven-development>"{p=0}' <file> | shasum -a 256`
  must match). `fast-worker.md` is *not* a verbatim home: its TDD copy is deliberately calibrated to
  its weaker pin (fewer design-altitude bullets, no logic-spikes exception) — sync the substance,
  not the bytes.
- **The `<behavioural-authority>` block has five verbatim homes** — `senior-engineer.md`,
  `fast-worker.md`, `chief-technology-officer.md`, `code-reviewer.md`, `debugger.md` — kept
  **byte-identical**, closing why-line included (same awk/shasum check with the
  `behavioural-authority` tags; all five checksums must match).
- `fast-worker.md`'s `<agent-knowledge>` likewise deliberately omits the decision-node sentence its
  siblings (`senior-engineer.md`, `debugger.md`) carry: fast-worker doesn't author decision nodes —
  per its know-your-lane asymmetry it escalates decision-worthy findings to the main agent instead.
  Don't "fix" this by restoring the sentence.

## Worked example

Commit **`510b071`** ("Mirror methodology into working agents: runbooks, audit-as-a-lens") is the
canonical principle-sync: it introduced the *runbook* principle and updated **both** homes in one
commit — the brief (`PROMODE_MAIN_AGENT.md`), the producing agent definitions
(then `implementer.md` — since split into `senior-engineer.md` + `fast-worker.md` — plus `debugger.md`, `environment-manager.md`, `verifier.md`), **and** the audit
lens that checks for it (then a skill; the audit now lives in `plugins/promode/agents/auditor.md`) —
so the audit lens and every working agent agreed. Note it also bumped the
version in the same commit (see [cut-a-release.md](cut-a-release.md)).

## Steps

1. Decide the principle change (an architectural call — this stays with the main agent, not delegated).
2. Edit the **brief** copy.
3. Re-grep the agent definitions for the old wording; edit **every** definition that carries it so
   the working agents match the brief. Don't add it to agents the principle doesn't apply to.
4. If the auditor (`plugins/promode/agents/auditor.md`) has a dimension that checks this principle,
   update it too (as `510b071` did with the audit lens of its day) so auditing and doing stay consistent.
5. If you edited the brief, re-run `./scripts/check-hooks.sh` — see
   [verify-hook-delivery.md](verify-hook-delivery.md).
6. Commit both homes **together** (one commit), with the version bump if you're releasing.

## See also

- `CLAUDE.md` — "Principles live in two places by design"
- Hub: [`RUNBOOKS.md`](../RUNBOOKS.md)
