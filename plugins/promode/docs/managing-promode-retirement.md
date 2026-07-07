# Decision: retire `managing-promode`, fold its residue into `promode-audit`

Status: decided (commits `36145c3`, `148d01f`). The `managing-promode` skill no longer exists in the tree; this doc is the only place it is named, as history.

## What was retired

The `managing-promode` skill and its three workflows — **install**, **update**, **audit** — plus its `standard/` copy-template (the `PROMODE_MAIN_AGENT.md` brief and a template hook that were copied into each project's `.claude/`).

## Why

The plugin now **ships its own `SessionStart` delivery** of the main-agent brief (`plugins/promode/hooks/` reading `plugins/promode/PROMODE_MAIN_AGENT.md` via `${CLAUDE_PLUGIN_ROOT}`). That removed the entire premise of `managing-promode`:

- **No per-project install.** Enabling the plugin delivers the brief; there is nothing to copy into `.claude/`. The `install` workflow became dead.
- **No per-project update.** A plugin update delivers the new brief automatically, so files never drift out of date in a project. The `update` workflow became dead.
- **Audit had no install to check.** With nothing copied in, `managing-promode`'s `audit` workflow lost its subject; the broader methodology-alignment audit it gestured at is what `promode-audit` does.

## What absorbed it

- **`promode-audit`** absorbed the only residual setup concern as a **pre-flight check**: flag stale per-project install *leftovers* from the old copy-install (`.claude/PROMODE_MAIN_AGENT.md`, a copied hook, a `settings.json` `SessionStart` entry) that would now **double-inject** alongside the plugin-shipped hook.
- The brief moved to a clean plugin home: `skills/managing-promode/standard/PROMODE_MAIN_AGENT.md` → `plugins/promode/PROMODE_MAIN_AGENT.md` (hook, `hooks.json`, and self-relative fallback updated to match).
- The reference docs `agent-knowledge-wiki.md` and `main-agent-delivery.md` relocated into `promode-audit/references/` (and later into `plugins/promode/docs/`, when the plugin's skills were themselves retired in July 2026 — including `promode-audit`, whose audit now runs as the `promode:auditor` agent).

See `main-agent-delivery.md` for *why* the brief is hook-delivered (and never lives in `CLAUDE.md`) — the architectural shift that made this retirement possible.
