---
name: skill-manager
description: Install, update, and manage Claude Code skills from GitHub repositories. Use when user wants to install a skill from a GitHub URL (e.g., https://github.com/user/repo) or shorthand (e.g., user/repo), update installed skills, list installed skills, check skill versions, or remove a skill.
---

# Skill Manager

Install and manage Claude Code skills from GitHub repositories.

## Important: Clarify Install Location First

When installing a skill, you MUST ask the user whether they want:
- **User install** (`--user`): Installs to `~/.claude/skills/` - skill will be available in ALL projects
- **Project install** (`--project /path/to/project`): Installs to `<project>/.claude/skills/` - skill will only be available in that project

Do NOT proceed with installation until the user has specified which location they want.

## Scripts

All scripts are in the `scripts/` directory and should be run from there (they use relative imports).

### install.py - Install a skill

```bash
# Install to user directory (~/.claude/skills/)
python scripts/install.py --user user/skill-name

# Install to project directory (requires explicit project path)
python scripts/install.py --project /path/to/project user/skill-name

# Force reinstall
python scripts/install.py --user --force user/skill-name
python scripts/install.py --project /path/to/project --force user/skill-name
```

### list.py - List installed skills

```bash
# List user skills (default when no args)
python scripts/list.py

# List user skills explicitly
python scripts/list.py --user

# List project skills
python scripts/list.py --project /path/to/project

# List both user and project skills
python scripts/list.py --user --project /path/to/project
```

### update.py - Update skills

```bash
# Update a skill in user directory
python scripts/update.py --user skill-name

# Update a skill in project directory
python scripts/update.py --project /path/to/project skill-name

# Update all skills in user directory
python scripts/update.py --all skill-name
```

### remove.py - Remove a skill

```bash
# Remove a skill from user directory
python scripts/remove.py --user skill-name

# Remove a skill from project directory
python scripts/remove.py --project /path/to/project skill-name
```

### version.py - Get skill version

```bash
# Get version of a user skill
python scripts/version.py --user skill-name

# Get version of a project skill
python scripts/version.py --project /path/to/project skill-name
```

## How It Works

- **User skills** (`~/.claude/skills/`) - available in all projects
- **Project skills** (`<project>/.claude/skills/`) - only in that specific project
- If the skills directory is inside a git repo, skills are added as submodules
- Otherwise, skills are cloned as standalone repos
- Version is tracked via short git SHA

## After Installing

If a skill has a `requirements.txt`, install dependencies:

```bash
pip install -r ~/.claude/skills/<skill-name>/requirements.txt
```

The installer will remind you when dependencies are needed.
