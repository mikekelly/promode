Keep this file under 50 lines. This is a plugin repository - see plugins/promode/ for the actual plugin.

## What is Promode?

Promode is a Claude Code plugin that provides a methodology for AI agents to develop software. The core principle: **the repo is always ready for a fresh agent**.

- **TDD is non-negotiable** — write failing tests first, then implementation
- **Repo as source of truth** — all state lives in committed files (TODO.md, plan docs, tests)
- **Continuous handoff readiness** — work so that any agent can pick up with zero prior context
- **Tests are the documentation** — executable tests document behaviour, not markdown

### Standard CLAUDE.md

The methodology is defined in `plugins/promode/skills/managing-claude-code-meta/standard/MAIN_AGENT_CLAUDE.md`. This file gets installed into projects that adopt promode.

### Skills

- **managing-skills** — Install, update, list, and remove skills
- **managing-claude-code-meta** — Set up and audit CLAUDE.md files

### Keeping Files in Sync

When updating shared methodology content, update `MAIN_AGENT_CLAUDE.md`. The root CLAUDE.md (this file) is just a pointer.
