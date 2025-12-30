# Promode for Claude Code

Promode enhances Claude Code to make advanced usage more convenient.

Promode v1 provides a Skills Management skill that takes away the pain of managing skills:

- "Install the skill mikekelly/debugging-react-native"
- "Update the typescript-review skill"

## Why Skills Matter

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

## Skills Management

Currently, managing Claude Code skills is awkward. You either need to:

1. Use a marketplace+plugin (multiple commands every time, plugins often come with multiple skills which will unnecessarily bloat context)
2. or manually download files from GitHub repos or skill zip files.

Skills Management takes all of this away and you can just tell Claude Code to manage specific skills for you:

- "Install the skill mikekelly/debugging-react-native"
- "Install the skill https://github.com/metabase/metabase/tree/master/.claude/skills/typescript-review"
- "Update my installed skills"
- "Remove the pdf skill"
- "List my installed skills"

Skills Management handles both the user level (`~/.claude/skills/`) and project level (`.claude/skills/`).

### Installation

Enable Promode and install Skills Management in Claude Code:

1. `/plugin marketplace add mikekelly/promode`
2. `/plugin install managing-skills@promode`
3. Restart Claude Code 

### Features:
- Install skills from GitHub repositories (`user/repo`)
- Install skills from GitHub subdirectory URLs (`github.com/user/repo/tree/branch/path`)
- Install skills from `.skill` zip files
- Update installed skills
- Remove skills
- List installed skills
