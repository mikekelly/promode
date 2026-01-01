# Promode

Promode is a Claude Code plugin that implements a **methodology for AI agents to develop software**. It emphasises TDD, context conservation, progressive disclosure, and clear delegation patterns.

## Core Philosophy

- **TDD is non-negotiable**: Write failing tests first, then implementation. No exceptions.
- **Context is precious**: Main agents delegate aggressively to subagents to conserve main agent context for high level planning and user conversation. Subagents enjoy a context focused on a specific task.
- **Tests are the documentation**: Executable tests document system behaviour, not markdown files.
- **Progressive disclosure**: CLAUDE.md defines agent behaviour; README.md files hold project knowledge. READMEs are distributed across relevant subcomponents and discovered by reference — agents load only the sections they need, further conserving context.

## What Promode Provides

### The Promode Subagent

Claude Code subagents don't inherit CLAUDE.md from the main conversation. This is a problem: subagents spawned via the Task tool don't know your project conventions.

**Solution**: The `promode-subagent` has the methodology baked in. When delegating, prefer it over the built-in agent:

```
Use the promode-subagent to [task description]
```

The subagent already knows TDD, behavioural-authority, context conservation, and all promode conventions.

### Skills

- **managing-skills** — Install, update, list, and remove skills from GitHub repos or local sources
- **managing-claude-code-meta** — Set up, migrate, and audit CLAUDE.md files following promode conventions

### MCP Servers

The plugin includes three MCP servers that start automatically when the plugin is enabled:

- **context7** — Fetches up-to-date official documentation for libraries ([upstash/context7](https://github.com/upstash/context7))
- **exa** — Real-time web search powered by Exa AI (requires `EXA_API_KEY` environment variable)
- **grep_app** — Ultra-fast code search across millions of public GitHub repositories via [grep.app](https://grep.app)

## Installation

```
/plugin marketplace add mikekelly/promode
/plugin install promode
```

Then restart Claude Code and tell Claude:

```
Update the claude code meta to install promode
```

## Skills Management

Managing Claude Code skills is awkward without tooling. You either need to use marketplace commands repeatedly or manually download files from GitHub.

Promode's skill management lets you just ask Claude:

- "Install the skill mikekelly/debugging-react-native"
- "Install the skill https://github.com/metabase/metabase/tree/master/.claude/skills/typescript-review"
- "Update my installed skills"
- "Remove the pdf skill"
- "List my installed skills"

### Why Skills Matter

Skills are an important way to enhance Claude Code. Many MCP servers would likely be better off packaged as skills—they're simpler to create, don't require running a separate process, and integrate more naturally with Claude's workflow.

### Skills vs MCPs

MCPs provide deterministic tools that the model calls—useful, but limited. Skills offer something more powerful: the ability to blend the determinism of scripts with the advanced reasoning of the model. A skill can guide Claude through a complex workflow, injecting structured steps where needed while letting the model apply judgment at decision points.

This hybrid approach makes more efficient use of both context and model capabilities. Instead of burning tokens on rigid back-and-forth tool calls, skills let you encode expertise directly into prompts that the model can interpret and adapt.

One reason more capabilities aren't packaged as skills is that MCP has better tooling for packaging and distribution. Skills Management is an attempt to fix this gap.

Skills Management promotes a simple packaging model: **a skill is a git repo**. This allows for:
- Clean forking of skills to customize them
- Issue tracking for bugs and feature requests
- Pull requests for community contributions
- Version history and release management

Skills Management also supports installing individual skills from subdirectories within larger repos or plugins—the current common approach to sharing skills. This gives you the best of both worlds: use standalone repos for your own skills, while still accessing skills packaged in collections.

### Supported Sources

- GitHub repositories (`user/repo`)
- GitHub subdirectory URLs (`github.com/user/repo/tree/branch/path`)
- `.skill` zip files

Skills Management handles both user level (`~/.claude/skills/`) and project level (`.claude/skills/`).
