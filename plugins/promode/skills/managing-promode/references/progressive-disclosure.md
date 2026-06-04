<overview>
Progressive disclosure keeps agent context lean by loading information just-in-time. `AGENT_ORIENTATION.md` files hold compact, token-efficient project knowledge that agents read when they need it — distinct from `CLAUDE.md`, which is the project's own file and belongs to the project team.
</overview>

<why_progressive_disclosure>
**The problem**: Bloated context degrades agent reasoning.

Every agent conversation loads context at startup. If all project knowledge is crammed into one place, those tokens are consumed whether or not the task needs them — and context is a finite, precious resource.

**The solution**: Separate project knowledge by area and load it just-in-time.

- **`CLAUDE.md`** — the project's own file. Kept by the project team. Agents read it for project conventions, build notes, and team-specific guidance.
- **`AGENT_ORIENTATION.md` files** (distributed) — compact, agent-optimised project knowledge, loaded only when working in that area.

**Token economics**:
- All project knowledge in one place: ~2000 tokens every conversation
- Just-in-time orientation files: only what's needed for the current task
</why_progressive_disclosure>

<agent_orientation_vs_readme>
**AGENT_ORIENTATION.md** — compact, token-efficient guidance for agents:
- Tools and how to use them
- Patterns and conventions
- Gotchas and workarounds
- Entry points and key files
- Anything an agent would otherwise waste time rediscovering

**README.md** — documentation for humans:
- Project overview and purpose
- Installation and setup instructions
- Usage examples
- API documentation
- Contributing guidelines
- Links to external resources

**Key distinction**: `AGENT_ORIENTATION.md` is optimised for agent context windows. Every line should save more tokens than it costs. `README.md` is optimised for human readability and can be as verbose as needed.
</agent_orientation_vs_readme>

<what_belongs_where>
**`CLAUDE.md` (project conventions — owned by the project team)**:
- Project-specific rules the team wants to enforce
- Build notes, workflow conventions, commit standards
- Anything both the main agent and subagents should know about the project

**Root `AGENT_ORIENTATION.md` (agent knowledge — project-wide)**:
- Project structure overview (key directories)
- How to run tests and build
- Tech stack summary (terse)
- Links to package `AGENT_ORIENTATION.md` files
- Common gotchas across the codebase

**Package `AGENT_ORIENTATION.md` files (domain knowledge)**:
- What this package does (1 sentence)
- Key files and entry points
- Domain-specific patterns and conventions
- API gotchas
- Related packages

**README.md (human documentation)**:
- Detailed project description
- Installation steps for humans
- Usage examples
- API reference
- Contributing guidelines
</what_belongs_where>

<orientation_structure_guidelines>
**Root AGENT_ORIENTATION.md**:
```markdown
# Agent Orientation

## Structure
- `packages/api/` — Backend API
- `packages/web/` — Frontend app
- `docs/` — Architecture decisions

## Commands
- `npm test` — Run tests
- `npm run dev` — Start dev server

## Gotchas
- {issue}: {workaround}

See package AGENT_ORIENTATION.md files for domain-specific guidance.
```

**Package AGENT_ORIENTATION.md**:
```markdown
# {Package} Agent Orientation

## Purpose
{One sentence description}

## Key Files
- `src/index.ts` — Entry point
- `src/routes/` — API routes

## Patterns
- {pattern}: {when and how to use}

## Gotchas
- {issue}: {workaround}
```
</orientation_structure_guidelines>

<anti_patterns>
**Don't do this**:

❌ **No AGENT_ORIENTATION.md files**
Agent has no way to learn project knowledge without reading source code.

❌ **Deep nesting**
`AGENT_ORIENTATION.md` → `docs/guide.md` → `docs/details/api.md`
Too many hops; agent may not follow the chain.

❌ **Duplicate content**
Same information in multiple places — drifts over time.

❌ **Verbose AGENT_ORIENTATION.md**
These files load into agent context. Verbosity defeats the purpose.

❌ **AGENT_ORIENTATION.md with code examples for everything**
Point to tests and source files; don't duplicate code.

**Do this instead**:

✅ **Distributed AGENT_ORIENTATION.md files**
Domain knowledge per area, loaded just-in-time.

✅ **One level of navigation**
Root `AGENT_ORIENTATION.md` → package `AGENT_ORIENTATION.md` (max 1 hop from root).

✅ **Terse orientation files**
Every line should save more tokens than it costs.

✅ **Tests as documentation**
`AGENT_ORIENTATION.md` describes purpose; tests document behaviour.
</anti_patterns>

<navigation_chain>
The ideal agent navigation path:

```
1. Conversation starts
   ↓
2. Load CLAUDE.md (project conventions — main agent AND subagents read this)
   ↓
3. Read AGENT_ORIENTATION.md for project-wide context
   Learn: structure, commands, gotchas
   ↓
4. Working in packages/api/?
   Read packages/api/AGENT_ORIENTATION.md for domain context
   ↓
5. Need to understand specific behaviour?
   Read the tests
```

Each step loads only what's needed. Total context used depends on task complexity, not file bloat.
</navigation_chain>
