---
name: skill-manager
description: Install, update, and manage Claude Code skills from GitHub repositories. Use when user wants to install a skill from a GitHub URL (e.g., https://github.com/user/repo) or shorthand (e.g., user/repo), update installed skills, list installed skills, check skill versions, or remove a skill.
---

# Skill Manager

Install and manage Claude Code skills from GitHub repositories.

## Important: Clarify Install Location First

When installing a skill, you MUST ask the user whether they want:
- **User install** (`--user`): Installs to `~/.claude/skills/` - skill will be available in ALL projects
- **Project install** (`--project`): Installs to `./.claude/skills/` - skill will only be available in the current project

Do NOT proceed with installation until the user has specified which location they want.

## Scripts

All scripts are in the `scripts/` directory and should be run from there (they use relative imports).

### install.py - Install a skill

```bash
# Install to user directory (~/.claude/skills/)
python scripts/install.py --user user/skill-name

# Install to project directory (./.claude/skills/)
python scripts/install.py --project user/skill-name

# Force reinstall
python scripts/install.py --user --force user/skill-name
```

### list.py - List installed skills

```bash
# List all installed skills (shows version SHA)
python scripts/list.py
```

### update.py - Update skills

```bash
# Update a specific skill
python scripts/update.py skill-name

# Update all installed skills
python scripts/update.py --all
```

### remove.py - Remove a skill

```bash
# Remove a skill (auto-finds location)
python scripts/remove.py skill-name
```

### version.py - Get skill version

```bash
# Get the git SHA and details for a skill
python scripts/version.py skill-name
```

## How It Works

- **User skills** (`~/.claude/skills/`) - available in all projects
- **Project skills** (`./.claude/skills/`) - only in current project
- If the skills directory is inside a git repo, skills are added as submodules
- Otherwise, skills are cloned as standalone repos
- Version is tracked via short git SHA

## After Installing

If a skill has a `requirements.txt`, install dependencies:

```bash
pip install -r ~/.claude/skills/<skill-name>/requirements.txt
```

The installer will remind you when dependencies are needed.
