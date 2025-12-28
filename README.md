# Promode for Claude Code

Promode enhances Claude Code to make advanced usage more convenient.

Promode v1 provides a Skill Manager that takes away the pain of managing skills.

## Skill Manager

Currently, managing Claude Code skills is awkward. You either need to:

1. Use a marketplace+plugin (multiple commands every time, plugins often come with multiple skills which will unnecessarily bloat context)
2. or manually download files from GitHub repos or skill zip files.

Skill Manager takes all of this away and you can just tell Claude Code to manage specific skills for you:

- "Install the skill mikekelly/react-native-debugger"
- "Install the skill https://github.com/anthropics/skills/tree/main/skills/skill-creator"
- "Update my installed skills"
- "Remove the pdf skill"
- "List my installed skills"

Skill Manager handles both the user level (`~/.claude/skills/`) and project level (`.claude/skills/`).

### Installation

Enable Promode and install Skill Manager in Claude Code:

1. `/plugin marketplace add mikekelly/promode`
2. `/plugin install skill-manager@promode`
3. Restart Claude Code 

### Features:
- Install skills from GitHub repositories (`user/repo`)
- Install skills from GitHub subdirectory URLs (`github.com/user/repo/tree/branch/path`)
- Install skills from `.skill` zip files
- Update installed skills
- Remove skills
- List installed skills
