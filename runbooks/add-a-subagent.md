# Runbook: Add a new subagent

What this is: the complete checklist of files to touch when adding a phase-specific subagent to
promode. A subagent is listed in **two** places besides its own definition; miss one and it is
either undiscoverable or undelegated.

## Why these places

A subagent is real only when (a) its definition exists, (b) the **main agent's brief** routes work
to it, and (c) the human-facing `README.md` table describes it. The brief is the load-bearing one —
it reaches the main agent via the SessionStart hook, and the main agent delegates from it. The
`README.md` table is a descriptive mirror. (There is no agent table in `CLAUDE.md` — the brief's
`<delegation-map>` is the canonical routing, as `CLAUDE.md` itself states.)

## Checklist (touch all of these)

1. **Create the definition** — `plugins/promode/agents/<name>.md`.
   - YAML frontmatter: `name`, `description`, `model` (e.g. `sonnet` for routine work; `inherit` for hard/judgement-heavy work — never name the top-tier model, it goes stale).
   - Body carries the agent's own methodology (it gets nothing from `CLAUDE.md`'s methodology — see
     the existing agents for the section shape: `<reporting>`, `<your-role>`, principles, etc.).
   - Match an existing sibling in `plugins/promode/agents/` for structure.

2. **Brief — `<delegation-map>`** — `plugins/promode/PROMODE_MAIN_AGENT.md`.
   - Add a routing line under `<delegation-map>`. This is the load-bearing one — it is how the main
     agent learns to delegate to the agent. Without it the agent is defined but never dispatched.
     (The brief carries no agent *table*; routing is the map. The descriptive tables live in
     `CLAUDE.md` and `README.md`, below.)
   - If you change the brief, re-run `./scripts/check-hooks.sh` (the added text must keep each chunk
     under the 10k cap; add/move a `<!-- CHUNK -->` marker if a chunk goes red, and register the new
     chunk count in `hooks.json`). See [verify-hook-delivery.md](verify-hook-delivery.md).

3. **`README.md` agent table** — the human-facing doc.
   - Add a row to the `| Agent | Job |` table, plain register, no `promode:` prefix (README omits it).

## Verify

- `./scripts/check-hooks.sh` is green (if you edited the brief/hooks).
- The brief's `<delegation-map>` actually routes work to the new agent (not just a table mention).

## See also

- Existing agents: `plugins/promode/agents/`
- Hub: [`RUNBOOKS.md`](../RUNBOOKS.md)
