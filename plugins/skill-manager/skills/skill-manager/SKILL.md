---
name: skill-manager
description: Install, update, and manage Claude Code skills from GitHub repositories. Use when user wants to install a skill from a GitHub URL (e.g., https://github.com/user/repo) or shorthand (e.g., user/repo), update installed skills, list installed skills, check skill versions, or remove a skill.
---

# Skill Manager

Manage Claude Code skills as git repositories cloned from GitHub.

## Strategy

Skills are git repositories containing a `SKILL.md` file. They can be installed in two locations:

- **User skills** (`~/.claude/skills/<skill-name>/`) - available in all projects
- **Project skills** (`<project>/.claude/skills/<skill-name>/`) - available only in that project

Each skill is cloned from a GitHub repository. Updates are done via `git pull`. Versions are tracked by git commit SHA.

**Important**: Most projects are already git repositories. When installing a skill into a project, it must be added as a **git submodule** so it can be tracked and shared with collaborators. User skills are regular clones since `~/.claude/skills/` is typically not a git repo.

## Important: Clarify Install Location First

When installing a skill, ALWAYS ask the user whether they want:
- **User install** - available in ALL projects (regular git clone)
- **Project install** - available only in the current project (git submodule)

Do NOT proceed with installation until the user has specified which location they want.

## Helper Script

### resolve_url.py

Resolves GitHub shorthand to full URL. Returns: `<url> <repo-name>`

```bash
python scripts/resolve_url.py user/repo
# Output: https://github.com/user/repo repo
```

**Note**: The repo name is used as the default skill directory name. If a skill with that name already exists, ask the user for an alternative name to avoid conflicts.

## Install a Skill (User)

1. Resolve the repository URL:
```bash
python scripts/resolve_url.py user/repo
```

2. Create the skills directory if needed:
```bash
mkdir -p ~/.claude/skills
```

3. Clone the repository:
```bash
git clone https://github.com/user/repo ~/.claude/skills/repo
```

4. Check for dependencies:
```bash
cat ~/.claude/skills/repo/requirements.txt
```
If the file exists, install with:
```bash
pip install -r ~/.claude/skills/repo/requirements.txt
```

## Install a Skill (Project)

1. Resolve the repository URL:
```bash
python scripts/resolve_url.py user/repo
```

2. Create the skills directory if needed:
```bash
mkdir -p /path/to/project/.claude/skills
```

3. Add as a git submodule:
```bash
git -C /path/to/project submodule add https://github.com/user/repo .claude/skills/repo
```

4. Check for dependencies:
```bash
cat /path/to/project/.claude/skills/repo/requirements.txt
```
If the file exists, install with:
```bash
pip install -r /path/to/project/.claude/skills/repo/requirements.txt
```

## Update a Skill (User)

```bash
git -C ~/.claude/skills/skill-name pull
```

## Update a Skill (Project)

```bash
git -C /path/to/project/.claude/skills/skill-name pull
git -C /path/to/project add .claude/skills/skill-name
```

## Remove a Skill (User)

```bash
rm -rf ~/.claude/skills/skill-name
```

## Remove a Skill (Project)

```bash
git -C /path/to/project submodule deinit -f .claude/skills/skill-name
git -C /path/to/project rm -f .claude/skills/skill-name
rm -rf /path/to/project/.git/modules/.claude/skills/skill-name
```

## Check Skill Version

```bash
git -C ~/.claude/skills/skill-name rev-parse --short HEAD
```
