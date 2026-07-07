# Fork-and-customise positioning + register component coverage

## Brief
- **Orient** — `README.md`, root `CLAUDE.md` (49/50-line hard cap), `plugins/promode/docs/opinion-register.md` (the register, `@`-imported into repo sessions and shipped with the plugin), the brief's `<delegation-map>`, `plugins/promode/agents/*.md` (9), `plugins/promode/skills/*/SKILL.md` (7), `tasks/09-opinion-inventory.md` (slug conventions).
- **Specify** — one commit, three strands (maintainer-ratified 2026-07-07):
  1. **Positioning (README).** Promode is **intended to be forked and customised per user** — methodology differs between people by taste and preference; this repo is the mikekelly fork. Installing it as-is = adopting this fork's taste; forking = making it yours. **The opinion register is the primary focal point of a fork** — the customisation surface: change an opinion there, sync its homes (defs/brief), and the fork is coherently yours; the register + sync runbook + "every clause serves the register" constraint are what make customisation mechanical rather than archaeological. Weave this into the README's opening framing and a short "Fork it" section (near Install); keep the shop-window prose quality. Don't bury the direct-install path — it stays first-class for people whose taste this fork already fits.
  2. **Positioning (CLAUDE.md).** State the fork intent + register-as-focal-point in the "What is Promode?" opening — the file is at 49/50 lines, so extend an existing line/paragraph rather than adding lines; trim elsewhere only if unavoidable (nothing load-bearing).
  3. **Register component coverage.** Extend `plugins/promode/docs/opinion-register.md` with a **Components** section: one entry per subagent (9) and per skill (7). Each entry: stable slug (e.g. `AG-cto`, `SK-task-docs`), one line on **why it exists** (the need it serves / the opinions it instantiates — cite opinion slugs), one line on **coordination** (who dispatches it / what it returns / key handoffs, e.g. debugger→senior-engineer for the fix, verifier↔discovery-to-determinism). Existence-as-opinion framing: each entry is a fork decision point (a fork may delete/replace the component if its underlying opinions are rejected). Cite, don't duplicate — the delegation map and defs stay canonical for mechanics. Report the register's new total size (it's @-imported every repo session; keep entries to the two lines).
- **Why** — the register already maps *what promode believes*; a forker also needs *what instantiates the beliefs and how the pieces interlock* to customise coherently. Making fork-intent explicit converts "reading every prompt it ships" from transparency into an invitation.
- **Verified vs assumed** — file locations + line cap verified by dispatcher 2026-07-07; component coordination edges must come from reading the actual defs/brief, not memory.
- **Not / exit** — defs, brief, and hooks untouched; CLAUDE.md ≤ 50 lines; `./scripts/check-hooks.sh` green (import check included); bump 2.35.0; Outcome recorded here; no push.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — CLAUDE.md cap; register import tax (report new size)
- **Established facts** — ratification above; register ships in-plugin since v2.34.0
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
_(filled by the agent on completion)_
