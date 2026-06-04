# Agent knowledge: an interlinked markdown graph

Promode keeps a project's durable agent knowledge as a **graph of interlinked markdown docs** — not one big file, and not a rigid directory layout. Two rules make it work; everything else is flexible.

## 1. The entry point is `AGENT_ORIENTATION.md`

Every promode project's knowledge graph is entered through **`AGENT_ORIENTATION.md` at the project root** — the one fixed convention. Agents read it first to orient. It is **not** an exhaustive index; it's a **launchpad** that links out to the key areas of the graph. An agent starting cold reads it and follows links to whatever it needs.

## 2. Docs link to each other, densely

Knowledge lives in plain markdown docs that **link to one another** (and back toward the entry point) with ordinary markdown links. The links *are* the structure — so **where a file lives doesn't matter**. A doc reachable from nothing is invisible; link generously.

That's it. No naming convention, no mandated folders, no frontmatter.

## What goes in it — the capture rule

When an agent spends real effort uncovering something that **wasn't documented** and a **future agent will likely need** it — a non-obvious build/run step, an API gotcha, where a subsystem lives, *why* a thing is the way it is — it writes that down as a linked doc. It was learned by doing the work, so it's grounded.

What does **not** belong: things obvious from the code, one-off trivia no one will need again, or unverified speculation.

## Keeping it healthy

- **Cold-readable.** An agent may land on any doc via a link, so each opens by saying what it is.
- **One idea, one home.** State a fact in one doc and link to it; don't duplicate (duplicates drift).
- **Compact and current.** Prefer a small new linked doc over bloating the entry point. If you spent significant effort deriving a check, a script/make target documented in a line beats a paragraph of prose.
- **Distinct from `CLAUDE.md` and `README.md`.** `CLAUDE.md` is the project team's own file; `README.md` is for humans. This graph is agent-optimised project knowledge.

## Going further

For a heavyweight, source-backed knowledge corpus (citations, freshness discipline, retrieval bundles, audits), see the **`managing-agent-knowledge`** skill. promode's default is deliberately lighter: a self-maintained graph of learned project knowledge.
