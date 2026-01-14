---
description: Prepare for context clear by writing a handoff document
---

# Pre-Clear Handoff

Your context is about to be cleared. Another agent will continue this work without the benefit of your conversation history. You must write a handoff document that captures everything they need to continue effectively.

## Your Task

Write a handoff document to `docs/handoff.md` (or `docs/{feature}/handoff.md` if working on a specific feature) that includes:

### 1. Current State
- What were we working on? (the goal, the user's intent)
- Where are we in the process? (brainstorming, planning, implementation, debugging)
- What's the current state of the codebase? (working, broken, partially implemented)

### 2. What's Been Done
- Key decisions made and why
- Files created or modified
- Tests written or updated
- Any commits made

### 3. What's Pending
- Remaining tasks (reference `tsk tree` output if applicable)
- Known issues or blockers
- Next immediate step

### 4. Context the Next Agent Needs
- Key files to read for orientation
- Important patterns or conventions discovered
- Gotchas or non-obvious details
- Any user preferences expressed during the conversation

### 5. Open Questions
- Unresolved decisions waiting on user input
- Uncertainties about approach
- Risks identified but not yet addressed

## Guidelines

- Be specific and concrete, not vague
- Include file paths, not just descriptions
- Capture the "why" behind decisions, not just the "what"
- Assume the next agent has no memory of this conversation
- Run `tsk tree` and include the output if tasks exist
- Commit the handoff document so it persists

## After Writing

1. **Show the user a summary** of what you've documented
2. **Ask for confirmation** - "Is there anything else I should capture before the clear?"
3. **Iterate** if the user identifies gaps
4. **Once confirmed**, end with a clear reference:

```
Handoff document ready: docs/handoff.md (or docs/{feature}/handoff.md)
You can now run /clear. The next agent should start by reading this file.
```
