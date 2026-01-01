<overview>
Progressive disclosure keeps agent context lean by loading information just-in-time. CLAUDE.md provides essential behaviour instructions; README.md files provide domain knowledge when needed.
</overview>

<why_progressive_disclosure>
**The problem**: Large CLAUDE.md files waste context on every conversation.

Every agent conversation loads CLAUDE.md into context. If CLAUDE.md contains 500 lines of project-specific technical details, those tokens are consumed whether or not the task needs them.

**The solution**: Separate agent behaviour from project knowledge.

- **CLAUDE.md** (~100 lines): HOW the agent should work — loads every time, kept minimal
- **README.md files** (distributed): WHAT the project contains — loaded only when working in that area

**Token economics**:
- Bloated CLAUDE.md: ~2000 tokens every conversation
- Lean CLAUDE.md + just-in-time READMEs: ~400 tokens + only what's needed
</why_progressive_disclosure>

<what_belongs_where>
**CLAUDE.md (agent behaviour)**:
- Communication style and tone
- How to interact with user vs sub-agents
- Workflow patterns (planning, implementing, reviewing)
- Task management approach (TODO.md usage)
- Test-driven development philosophy
- Definition of done
- Pointers to README.md for orientation

**Root README.md (project overview)**:
- Project name and purpose (1-2 sentences)
- Quick start (how to run locally)
- Tech stack summary
- Project structure with links to package READMEs
- Links to documentation

**Package README.md files (domain knowledge)**:
- What this package does
- Key files and entry points
- Domain-specific patterns and conventions
- Related packages and dependencies
- API documentation for that module
</what_belongs_where>

<content_migration_examples>
**Tech stack details**:
```
# FROM CLAUDE.md
The frontend uses React 18 with TypeScript. State management is
handled by Zustand. Styling uses Tailwind CSS with custom theme.

# TO README.md
## Tech Stack
- React 18, TypeScript
- Zustand for state
- Tailwind CSS

See `packages/web/README.md` for frontend details.
```

**API endpoints**:
```
# FROM CLAUDE.md
Available endpoints:
- POST /auth/login
- POST /auth/register
- GET /users/:id
...

# TO packages/api/README.md
## Routes
See `src/routes/` for endpoint definitions.

Key modules:
- `auth.ts` — Authentication (login, register, logout)
- `users.ts` — User management
```

**Environment setup**:
```
# FROM CLAUDE.md
Required environment variables:
DATABASE_URL=postgresql://...
JWT_SECRET=...
API_KEY=...

# TO README.md
## Environment
Copy `.env.example` to `.env` and fill in values.
See `.env.example` for required variables.
```

**Testing instructions**:
```
# FROM CLAUDE.md
Run tests: npm test
Run specific test: npm test -- --grep "pattern"
Watch mode: npm test -- --watch

# TO README.md
## Development
```bash
npm test        # Run test suite
npm run dev     # Start dev server
npm run build   # Production build
```
```
</content_migration_examples>

<readme_structure_guidelines>
**Root README.md** (~50-150 lines):
```markdown
# Project Name

Brief description.

## Quick Start
How to run locally (3-5 steps max).

## Project Structure
- `packages/api/` — Backend API ([README](packages/api/README.md))
- `packages/web/` — Frontend app ([README](packages/web/README.md))
- `docs/` — Architecture decisions

## Development
Key commands for developers.
```

**Package README.md** (~20-50 lines):
```markdown
# Package Name

What this package does.

## Key Files
- `src/index.ts` — Entry point
- `src/routes/` — API routes
- `src/services/` — Business logic

## Patterns
Domain-specific conventions used here.

## Related
- [Other Package](../other/README.md)
```
</readme_structure_guidelines>

<anti_patterns>
**Don't do this**:

❌ **Single massive CLAUDE.md**
Everything in one file — wastes context on every conversation.

❌ **No README.md files**
Agent has no way to learn project knowledge without reading source code.

❌ **Deep nesting**
CLAUDE.md → README.md → docs/guide.md → docs/details/api.md
Too many hops; agent may not follow the chain.

❌ **Duplicate content**
Same information in CLAUDE.md and README.md — drifts over time.

❌ **README.md with code examples for everything**
READMEs should point to tests and source files, not duplicate code.

**Do this instead**:

✅ **Lean CLAUDE.md + distributed READMEs**
Agent behaviour in CLAUDE.md, domain knowledge in READMEs.

✅ **One level of README navigation**
CLAUDE.md → README.md → package READMEs (max 2 hops).

✅ **Tests as documentation**
READMEs describe purpose; tests document behaviour.
</anti_patterns>

<navigation_chain>
The ideal agent navigation path:

```
1. Conversation starts
   ↓
2. Load CLAUDE.md (~100 lines)
   Learn: how to behave, workflow patterns, where to find info
   ↓
3. Read README.md for orientation
   Learn: project structure, how to navigate
   ↓
4. Working in packages/api/?
   Read packages/api/README.md for domain context
   ↓
5. Need to understand specific behaviour?
   Read the tests
```

Each step loads only what's needed. Total context used depends on task complexity, not file bloat.
</navigation_chain>
