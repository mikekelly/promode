# Opinion register (blocked on 09's assessment being ratified)

## Brief
- **Orient** — `tasks/09-opinion-inventory.md` (the ratified inventory — this task must not start until the maintainer + main agent have made the stay/go/adjust calls over it), `README.md` ("The opinions" section), root `CLAUDE.md`.
- **Specify** — a durable **opinion register**, serving two readers at once:
  1. **Human-readable map** — what kinds of opinionatedness this fork of promode is based around; elevated into the README (the existing "The opinions" section becomes a view of / pointer into the register rather than a competing list).
  2. **Agent-usable register** — tracks every opinion promode instantiates: canonical statement + rationale, and its homes across the brief and subagent defs (verbatim/calibrated per home), so an agent can audit "is every home in sync in substance?" and "does any agent lack an opinion its role warrants?" mechanically. Natural consumers: `promode-audit`, the sync runbook, AARs.
  Placement to decide at execution time (likely a `docs/` node linked from `CLAUDE.md`; single source — README and defs point at it, never fork it).
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
