# Runbook: Sync a shared principle across both homes

What this is: how to change a methodology principle without leaving the two copies inconsistent.
Promode keeps principles in **two homes by design** — change one, you must change the other.

## Why two homes (don't "fix" this by centralising)

This is deliberate, stated in `CLAUDE.md` ("Principles live in two places by design") and in the
brief's design notes:

- The **main agent** gets principles from the hook-delivered brief
  (`plugins/promode/PROMODE_MAIN_AGENT.md`, `<principles>` and the surrounding decision sections).
  It must be self-contained because a pointer may not be read.
- **Subagents** get nothing from the brief or `CLAUDE.md` methodology — each carries its own
  methodology inline in its definition (`plugins/promode/agents/*.md`).

So a shared principle (TDD non-negotiable, evidence over assumptions, crystallise discovery into
determinism, the operator-seam test strategy, runbooks/knowledge capture) is intentionally
duplicated. A doc link won't do — the inline copy is load-bearing in each home.

## Which files hold which principles

- **Brief** — `plugins/promode/PROMODE_MAIN_AGENT.md`: `<principles>`, plus the decision sections
  (`<test-strategy>`, `<after-action-review>` runbook/knowledge rules, `<feature-knowledge-base>`).
- **Subagents** — the relevant `plugins/promode/agents/*.md`. As of this writing, shared-principle
  text (TDD / evidence / operator-seam / crystallise) lives in:
  `senior-engineer.md`, `fast-worker.md`, `code-reviewer.md`, `debugger.md`, `verifier.md`, `environment-manager.md`.
  (Re-grep before editing — `grep -ln 'TDD\|operator seam\|Crystallise\|Evidence over assumptions'
  plugins/promode/agents/*.md` — definitions drift.)

## Worked example

Commit **`510b071`** ("Mirror methodology into working agents: runbooks, audit-as-a-lens") is the
canonical principle-sync: it introduced the *runbook* principle and updated **both** homes in one
commit — the brief (`PROMODE_MAIN_AGENT.md`), the producing agent definitions
(then `implementer.md` — since split into `senior-engineer.md` + `fast-worker.md` — plus `debugger.md`, `environment-manager.md`, `verifier.md`), **and** the audit
skill that checks for it — so the audit lens and every working agent agreed. Note it also bumped the
version in the same commit (see [cut-a-release.md](cut-a-release.md)).

## Steps

1. Decide the principle change (an architectural call — this stays with the main agent, not delegated).
2. Edit the **brief** copy.
3. Re-grep the agent definitions for the old wording; edit **every** definition that carries it so
   the working agents match the brief. Don't add it to agents the principle doesn't apply to.
4. If `promode-audit` has a dimension that checks this principle, update that skill too (as `510b071`
   did) so the audit lens stays consistent.
5. If you edited the brief, re-run `./scripts/check-hooks.sh` — see
   [verify-hook-delivery.md](verify-hook-delivery.md).
6. Commit both homes **together** (one commit), with the version bump if you're releasing.

## See also

- `CLAUDE.md` — "Principles live in two places by design"
- Hub: [`RUNBOOKS.md`](../RUNBOOKS.md)
