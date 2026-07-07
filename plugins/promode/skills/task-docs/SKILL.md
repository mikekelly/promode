---
name: task-docs
description: "Persist a multi-task plan as durable per-task markdown docs (the canonical brief + state + outcome), so the plan/execution trace survives the prompt, hands off cleanly to fresh sessions, and feeds durable history. Invoke when planning multi-task work, when delegating a planned task to a subagent, or when a subagent records its outcome. The Kanban board tracks flow; these docs hold the detail."
---

A plan written straight into a subagent prompt evaporates when the turn ends. For multi-task work, persist the **task tree as durable task docs** — one markdown file per task — so the brief, decisions, and outcome live in the repo: readable by the agent doing the work, by a fresh session resuming after a `/clear`, and by the cross-session retrospective (`<after-action-review>`). This serves *context is precious*: the plan state lives on disk, not in the main agent's window.

<where>
One doc per task under a repo `tasks/` directory (e.g. `tasks/<id>-<slug>.md`), committed. The **board** (`KANBAN_BOARD.md`) carries flow — a one-line card per task linking to its doc; the **doc** carries detail. (A task doc is *durable in-repo coordination + a decision log* — distinct from a `handoff` doc, which is ephemeral conversation state written to tmp.)
</where>

<single-source-of-status>
**Status lives in exactly one place: the board column** (`## Ready` / `## Doing` / done). The task doc holds the brief, detail, and final outcome — **never** a competing live `status:` field, or the two drift. Move the card across columns; don't duplicate state into the doc.
</single-source-of-status>

<doc-shape>
Keep it lean — a coordination + decision artifact, **not** a duplicate spec of the code (code + tests remain the source of truth for *what the system does*; the doc is the source of truth for *what work is in flight and why*).

```markdown
# <task title>

## Brief
- **Orient** — files/state to start from
- **Specify** — the one deliverable + what success looks like (acceptance criteria)
- **Why** — so the agent can make judgement calls
- **Verified vs assumed** — what's confirmed vs inherited assumption (challengeable)
- **Not / exit** — what NOT to do; the exit condition

## State (Active-State Index)
- **Unresolved errors** —
- **Open constraints** —
- **Established facts** —
- **Pending goals / next step** —

## Outcome  (filled by the agent on completion)
- What was done, key decisions made + why, follow-ups flagged
```
The **Brief** block mirrors `<prompting-subagents>` — so delegating a task = pointing the agent at its doc. The **State** block is the four-bucket Active-State Index: the exact payload a fresh session or handoff needs to resume.
</doc-shape>

<fog-of-war>
Plan tasks only to the **fog edge**. Beyond it, carry the fog as **named unknowns** — never pre-sliced into fake tasks that guess at work no one can specify yet. The fog test: you can state the question precisely *now* — **not** answer it. A named unknown spawns real tasks only once the work that resolves it lands.
</fog-of-war>

<durability>
Write the brief for when it will be read. A dispatch brief consumed immediately may cite file paths and line numbers; a task doc that may sit in `## Ready` describes **behavioural contracts and interfaces** instead — paths rot as the codebase moves, contracts don't.
</durability>

<anti-drift>
- **Open-loop only** — carry the live task + last outcome, not a full replay; prior state is recoverable from git/files.
- **Decisions-as-constraints, not prose** — record a decision as a rule the next agent must honour, not a narrative.
- **Don't let it rot** — a doc the code has moved past is actively misleading. On completion, promote the durable residue (decisions, outcome) into the `CLAUDE.md` graph by locality (per `<after-action-review>`) and retire the card to done; supersede, don't silently overwrite, superseded facts.
</anti-drift>

<lifecycle>
1. **Plan** — the main agent writes one doc per task (Brief + initial State), adds a linked card to `KANBAN_BOARD.md` under `## Ready`.
2. **Delegate** — reference the task doc in the subagent's prompt; move the card to `## Doing`.
3. **Execute** — the agent reads its doc, does the work, and records the Outcome before reporting (its definition baked this in). A worktree-isolated agent can't write the shared checkout's copy: it records the Outcome in its **own worktree's tracked copy**, which lands in the canonical doc on merge — dispatch briefs should say so, not point at the shared path.
4. **Close** — main agent moves the card to done (`DONE.md`), and promotes durable residue into the knowledge graph; the retrospective later mines accumulated docs for recurring patterns.
</lifecycle>
