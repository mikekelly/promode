# Opinion register (blocked on 09's assessment being ratified)

## Brief
- **Orient** — `tasks/09-opinion-inventory.md` (the ratified inventory — this task must not start until the maintainer + main agent have made the stay/go/adjust calls over it), `README.md` ("The opinions" section), root `CLAUDE.md`.
- **Specify** — a durable **opinion register**, serving two readers at once:
  1. **Human-readable map** — what kinds of opinionatedness this fork of promode is based around; elevated into the README (the existing "The opinions" section becomes a view of / pointer into the register rather than a competing list).
  2. **Agent-usable register** — tracks every opinion promode instantiates: canonical statement + rationale, and its homes across the brief and subagent defs (verbatim/calibrated per home), so an agent can audit "is every home in sync in substance?" and "does any agent lack an opinion its role warrants?" mechanically. Natural consumers: `promode-audit`, the sync runbook, AARs.
  **Ratified architecture (2026-07-07):** the register is its own file, `@`-imported from root `CLAUDE.md` so it interpolates into every agent's context automatically — guaranteed-loaded shared vocabulary, not a pointer. README links it as the human view; defs trace to it; nothing forks it. **Leanness rule:** entries are slug + one-line canonical statement + homes; rationale stays in the defs/wiki — the import must stay cheap (low single-digit k), because it taxes every session in this repo (justified: nearly all work here is methodology work on the corpus the register governs). **Precondition — RESOLVED (probed live on Claude Code 2.1.201, 2026-07-07):** (1) imports **reach subagents identically** to the main agent — the architecture works; (2) the register file **must live inside the repo** (outside-project and `~/` paths silently fail to resolve, despite docs); (3) imported content is appended as a labelled `Contents of <path>…` block *after* the CLAUDE.md body, not spliced at the `@` anchor — put the register's framing sentence inside the register file itself; (4) a missing import target **drops silently** (exit 0, no warning) → the register build MUST add a CI existence check to the `check-hooks.sh` suite; (5) no size truncation ≤55KB; nesting resolves 4 levels deep (register at depth 1 — irrelevant); (6) imports in code blocks/inline spans stay literal.
- **Why** — maintainer's intent (2026-07-07): a map explaining the fork's opinionated basis + a register an agent can use to track opinions/principles/methodology across the definitions. Crystallises the 09 inventory into a maintained artifact instead of a one-off audit.
- **Ratified constraint the register must serve (2026-07-07, in `CLAUDE.md` + wiki):** every clause in every def/brief must trace to a register item (cut the clause or grow the register). So register items need **stable, citable identities** (slugs) an authoring or auditing agent can trace a clause to; the 09 inventory's coverage matrix is the seed of that trace.
- **Not / exit** — blocked until 09's assessment is ratified; the register records the *ratified* opinion set, not the raw extraction. One home per fact: the register indexes where opinions live; it does not duplicate the defs' full prose.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — blocked on 09 ratification; single-source discipline
- **Established facts** — maintainer intent captured above
- **Pending goals / next step** — wait for 09; then spec placement + format with the maintainer

## Outcome
_(filled on completion)_
