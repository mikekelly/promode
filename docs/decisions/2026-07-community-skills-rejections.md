# Considered and rejected: 2026-07 community-skills evaluation

A rejected-work node (per the conventions in [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md)): concepts evaluated in July 2026 from [dzhng/skills](https://github.com/dzhng/skills) and [mattpocock/skills](https://github.com/mattpocock/skills) and **rejected** — ideation and reviews must not re-suggest them, and should match against these by *concept*, not wording. (What the same evaluation *adopted* lives where it landed: the wiki's glossary / rejected-work / authoring conventions, and the fog + durability rules now in the main-agent brief's `<task-docs>` section — adopted into the then task-docs skill, migrated with it.)

## Smart-zone / deliberate session-ending

Rejected. It conflicts with the main-agent brief's rule that the remedy for context pressure is *always delegation*. Promode's orchestrator-plus-fresh-subagents architecture is the structural fix for context pressure; smart-zone session-ending is a doctrine that patches around the absence of that architecture.

## Refactoring outside the TDD loop

Rejected. The two authors disagree with *each other* on how it should work — no convergence signal to adopt against. Promode keeps RED→GREEN→REFACTOR as the single loop; refactoring happens with the tests green, inside it.

## Issue-tracker-as-durable-memory

Rejected. It competes with task docs + the Kanban board as the home for in-flight work and decisions — violating *one home per fact*.

## "Prompt the positive" as a ban on prohibitions

Rejected as a ban; adopted only as an authoring *lens*. Promode's audited best-performing passages are load-bearing prohibitions with rationale attached — banning prohibitions would delete them.
