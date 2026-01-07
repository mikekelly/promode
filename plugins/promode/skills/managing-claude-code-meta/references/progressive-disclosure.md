<overview>
Progressive disclosure keeps agent context lean by loading information just-in-time. CLAUDE.md provides essential behaviour instructions; AGENT_ORIENTATION.md files provide compact agent guidance when needed.
</overview>

<why_progressive_disclosure>
**The problem**: Large CLAUDE.md files waste context on every conversation.

Every agent conversation loads CLAUDE.md into context. If CLAUDE.md contains 500 lines of project-specific technical details, those tokens are consumed whether or not the task needs them.

**The solution**: Separate agent behaviour from project knowledge.

- **CLAUDE.md** (~100 lines): HOW the agent should work — loads every time, kept minimal
- **AGENT_ORIENTATION.md files** (distributed): WHAT the agent needs to know — loaded only when working in that area

**Token economics**:
- Bloated CLAUDE.md: ~2000 tokens every conversation
- Lean CLAUDE.md + just-in-time orientation files: ~400 tokens + only what's needed
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

**Key distinction**: AGENT_ORIENTATION.md is optimised for agent context windows. Every line should save more tokens than it costs. README.md is optimised for human readability and can be as verbose as needed.
</agent_orientation_vs_readme>

<what_belongs_where>
**CLAUDE.md (agent behaviour)**:
- Communication style and tone
- How to interact with user vs sub-agents
- Workflow patterns (brainstorming, planning, orchestrating)
- Task management approach
- Test-driven development philosophy
- Definition of done
- Pointers to AGENT_ORIENTATION.md for project-specific guidance

**Root AGENT_ORIENTATION.md (agent knowledge)**:
- Project structure overview (key directories)
- How to run tests and build
- Tech stack summary (terse)
- Links to package AGENT_ORIENTATION.md files
- Common gotchas across the codebase

**Package AGENT_ORIENTATION.md files (domain knowledge)**:
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

<content_migration_examples>
**Tech stack details**:
```
# FROM CLAUDE.md
The frontend uses React 18 with TypeScript. State management is
handled by Zustand. Styling uses Tailwind CSS with custom theme.

# TO AGENT_ORIENTATION.md
## Stack
React 18 + TypeScript, Zustand (state), Tailwind CSS

See `packages/web/AGENT_ORIENTATION.md` for frontend patterns.
```

**API endpoints**:
```
# FROM CLAUDE.md
Available endpoints:
- POST /auth/login
- POST /auth/register
- GET /users/:id
...

# TO packages/api/AGENT_ORIENTATION.md
## Routes
Routes in `src/routes/`:
- auth.ts — login, register, logout
- users.ts — CRUD operations
```

**Environment setup**:
```
# FROM CLAUDE.md
Required environment variables:
DATABASE_URL=postgresql://...
JWT_SECRET=...
API_KEY=...

# TO AGENT_ORIENTATION.md
## Environment
See `.env.example` for required variables.
```

**Testing instructions**:
```
# FROM CLAUDE.md
Run tests: npm test
Run specific test: npm test -- --grep "pattern"
Watch mode: npm test -- --watch

# TO AGENT_ORIENTATION.md
## Commands
- `npm test` — run test suite
- `npm run dev` — start dev server
```
</content_migration_examples>

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

❌ **Single massive CLAUDE.md**
Everything in one file — wastes context on every conversation.

❌ **No AGENT_ORIENTATION.md files**
Agent has no way to learn project knowledge without reading source code.

❌ **Deep nesting**
CLAUDE.md → AGENT_ORIENTATION.md → docs/guide.md → docs/details/api.md
Too many hops; agent may not follow the chain.

❌ **Duplicate content**
Same information in CLAUDE.md and AGENT_ORIENTATION.md — drifts over time.

❌ **Verbose AGENT_ORIENTATION.md**
These files load into agent context. Verbosity defeats the purpose.

❌ **AGENT_ORIENTATION.md with code examples for everything**
Point to tests and source files, not duplicate code.

**Do this instead**:

✅ **Lean CLAUDE.md + distributed AGENT_ORIENTATION.md**
Agent behaviour in CLAUDE.md, domain knowledge in AGENT_ORIENTATION.md files.

✅ **One level of navigation**
CLAUDE.md → AGENT_ORIENTATION.md → package AGENT_ORIENTATION.md (max 2 hops).

✅ **Terse orientation files**
Every line should save more tokens than it costs.

✅ **Tests as documentation**
AGENT_ORIENTATION.md describes purpose; tests document behaviour.
</anti_patterns>

<navigation_chain>
The ideal agent navigation path:

```
1. Conversation starts
   ↓
2. Load CLAUDE.md (~100 lines)
   Learn: how to behave, workflow patterns, where to find info
   ↓
3. Read AGENT_ORIENTATION.md for project context
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
