# Agent knowledge: an interlinked markdown graph rooted at CLAUDE.md

Promode keeps a project's durable agent knowledge as a **graph of interlinked markdown docs**, rooted at the project's own **`CLAUDE.md`**. Two rules make it work; everything else is flexible.

## 1. The entry point is `CLAUDE.md`

`CLAUDE.md` is the one file Claude Code auto-loads into **every** agent — the main agent and every subagent — so it's already in context before any agent acts. That makes it the natural root of the knowledge graph: agents read it to orient, and it **links out** to the key areas. It is **not** an exhaustive index; it's a **launchpad**.

`CLAUDE.md` is the **project's own file**. Promode does not put its methodology there — the main-agent orchestration brief is hook-delivered (see `main-agent-delivery.md`). But the project's durable agent knowledge *does* live here and grows from here.

## 2. Docs link to each other, densely

Knowledge lives in plain markdown docs that **link to one another** (and back toward `CLAUDE.md`) with ordinary markdown links. The links *are* the structure — so **where a file lives doesn't matter**. A doc reachable from nothing is invisible; link generously. No naming convention, no mandated folders, no frontmatter.

## What goes in it — the capture rule

When an agent spends real effort uncovering something that **wasn't documented** and a **future agent will likely need** it — a non-obvious build/run step, an API gotcha, where a subsystem lives, *why* a thing is the way it is — it writes that as a linked doc and links it into the graph (from `CLAUDE.md`, or a doc reachable from it). It was learned by doing the work, so it's grounded.

Agents **maintain `CLAUDE.md`** as the knowledge root — adding a doc and a link to it is expected. **Never clobber** existing `CLAUDE.md` content; append and link. If a project has no `CLAUDE.md` yet, create a minimal one as the root.

What does **not** belong: things obvious from the code, one-off trivia, unverified speculation, or the main-agent orchestration brief (that's the hook's job).

## Keeping it healthy

- **Cold-readable.** An agent may land on any doc via a link, so each opens by saying what it is.
- **One idea, one home.** State a fact in one doc and link to it; don't duplicate.
- **Compact and current.** Prefer a small new linked doc over bloating `CLAUDE.md`. A documented script/make target beats a paragraph of prose.
- **Distinct from `README.md`.** `README.md` is for humans; this graph is agent-optimised project knowledge (and `CLAUDE.md` doubles as Claude Code's project file and the knowledge root).

## Going further

For a heavyweight, source-backed knowledge corpus (citations, freshness discipline, retrieval bundles, audits), see the **`managing-agent-knowledge`** skill. promode's default is deliberately lighter: a self-maintained graph of learned project knowledge.
