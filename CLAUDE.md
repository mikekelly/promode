> Keep this file under 50 lines. This is a plugin repository - see plugins/promode/ for the actual plugin.

## What is Promode?

Promode is a Claude Code plugin that enhances how Claude builds software. It provides:

- **Skills** — Domain knowledge that loads just-in-time (managing CLAUDE.md files, installing skills)
- **Agents** — Phase-specific subagents for implementation, debugging, testing, and git operations

The core philosophy: TDD is non-negotiable, tests are the documentation, context is precious, and agents should delegate aggressively to conserve it.

### Phase Agents

Claude Code subagents do NOT inherit CLAUDE.md from the main conversation. This creates a problem: subagents spawned via the Task tool don't know project conventions, TDD practices, or behavioural-authority rules.

**Solution**: Phase-specific agents in `plugins/promode/agents/` each have promode methodology baked in:

| Agent | Purpose | Model |
|-------|---------|-------|
| `promode:implementer` | TDD workflow, write code | sonnet |
| `promode:debugger` | Root cause analysis, fix failures | sonnet |
| `promode:tester` | Run tests, return AI-optimized results, critique quality | sonnet |
| `promode:smoke-tester` | Create/execute smoke tests as readable markdown | sonnet |
| `promode:git-manager` | Commits, pushes, PRs, git research | sonnet |
| `promode:environment-manager` | Docker, services, health checks, env scripts | sonnet |
| `promode:python-reviewer` | Python code review | sonnet |
| `promode:typescript-reviewer` | TypeScript/JS code review | sonnet |
| `promode:security-reviewer` | Security-focused review | sonnet |
| `promode:performance-reviewer` | Performance-focused review | sonnet |
| `promode:architecture-reviewer` | Architecture review | sonnet |
| `promode:simplicity-reviewer` | Code simplicity review | sonnet |
| `promode:pattern-reviewer` | Pattern/anti-pattern review (any language) | sonnet |

**Note**: Brainstorming, planning, and orchestration are done by the main agent. Use built-in `Explore` agents for codebase research.

### Keeping Agents in Sync

All phase agents share the same **principles and conventions** but have **phase-specific workflows**:
- `plugins/promode/skills/managing-claude-code-meta/standard/MAIN_AGENT_CLAUDE.md` — main agent (orchestrates, converses with user)
- `plugins/promode/agents/*.md` — phase agents (execute specific tasks, report back)

When updating shared content (principles, TDD rules, behavioural-authority), update the main agent file and relevant phase agents.
