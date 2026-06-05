---
name: handoff
description: "Write a handoff document so a fresh agent can continue this work after the conversation ends. Invoke when the user is about to /clear or /compact, when context is filling up, or when the user asks to hand off, checkpoint, or pause work for a later session. Argument (optional): what the next session will focus on."
argument-hint: "[what the next session will focus on]"
---

The conversation is about to end or be cleared. A fresh agent will continue **without any of this conversation's history** — write it what it needs to pick up cleanly.

<where>
Save to the OS temp directory (`$TMPDIR`, falling back to `/tmp`), e.g. `<tmpdir>/handoff-<feature>.md` — **not** the repo. A handoff is ephemeral conversation state, not durable project knowledge (durable knowledge belongs in the agent-knowledge graph rooted at `CLAUDE.md`). Tell the user the absolute path at the end so they can point the next agent at it.
</where>

<what-to-capture>
Write for an agent with zero context. Be concrete — file paths, not vague descriptions; the *why* behind decisions, not just the *what*.

1. **Goal & current state** — what we're doing and why; where we are (planning / implementing / debugging); whether the codebase is working, broken, or half-done.
2. **Decisions made & why** — especially trade-offs a fresh agent would otherwise re-litigate or accidentally undo.
3. **What's pending** — remaining work and the **single next immediate step**; known blockers.
4. **Orientation** — the few files to read first, non-obvious patterns/gotchas, and any user preferences expressed this session.
5. **Open questions** — unresolved decisions waiting on the user.
6. **Suggested skills/agents** — which promode agents or skills the next session should reach for.
</what-to-capture>

<keep-it-lean>
- **Reference, don't duplicate.** Anything already captured in commits, PRDs, plans, ADRs, issues, or the knowledge graph → link it by path, don't restate it. The handoff is the connective tissue between those artifacts, not a copy of them.
- **Redact secrets** — no API keys, passwords, tokens, or PII in the document.
- If the user passed an argument, treat it as the next session's focus and tailor the doc to it.
</keep-it-lean>

<after-writing>
1. Show the user a short summary of what you captured.
2. Ask: "Anything else to capture before you clear?" — iterate if they flag gaps.
3. End with the absolute path and a one-line pointer for the next agent:
   `Handoff ready: <path> — the next agent should read this first.`
</after-writing>
