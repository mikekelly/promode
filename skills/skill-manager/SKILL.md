---
name: skill-manager
description: Install, update, and manage Claude Code skills. Supports GitHub repositories (user/repo), GitHub subdirectory URLs (github.com/user/repo/tree/branch/path), and .skill zip files. Use when user wants to install, update, list, or remove skills.
---

# Skill Manager

Manage Claude Code skills from multiple source types.

## Install Locations

Skills can be installed in two locations:

- **User skills** (`~/.claude/skills/<skill-name>/`) - available in all projects
- **Project skills** (`<project>/.claude/skills/<skill-name>/`) - available only in that project

**Important:** Always ask the user which location they want before installing.

## Skill Reference Types

### Type 1: GitHub Repository

A dedicated GitHub repo containing a skill.

**How to recognize:**
- Shorthand: `user/repo`
- Full URL: `https://github.com/user/repo`
- May contain `/tree/<branch>` but NO path after the branch (e.g., `https://github.com/user/repo/tree/main`)

**Install (User):**
```bash
mkdir -p ~/.claude/skills
git clone https://github.com/user/repo ~/.claude/skills/repo
```

**Install (Project - as submodule):**
```bash
mkdir -p .claude/skills
git submodule add https://github.com/user/repo .claude/skills/repo
```

**Update (User):**
```bash
git -C ~/.claude/skills/skill-name pull
```

**Update (Project):**
```bash
git -C .claude/skills/skill-name pull
git add .claude/skills/skill-name
```

---

### Type 2: GitHub Subdirectory URL

A skill living as a subdirectory within a larger repository.

**How to recognize:**
- Contains `/tree/<branch>/` followed by a path within the repo
- Example: `https://github.com/org/repo/tree/main/skills/my-skill`
- Differs from Type 1 in that there's a path AFTER the branch name

**Parse the URL:**
- Repository: `https://github.com/org/repo`
- Subpath: `skills/my-skill`
- Skill name: `my-skill` (last path component)

**Install (User or Project):**
```bash
# Clone to temp directory
git clone --depth 1 https://github.com/org/repo /tmp/skill-clone-$$

# Copy subdirectory to target
mkdir -p ~/.claude/skills
cp -r /tmp/skill-clone-$$/skills/my-skill ~/.claude/skills/my-skill

# Create .skill-manager-ref with source URL
echo "https://github.com/org/repo/tree/main/skills/my-skill" > ~/.claude/skills/my-skill/.skill-manager-ref

# Cleanup
rm -rf /tmp/skill-clone-$$
```

**Update:**
```bash
# Read source URL
SOURCE_URL=$(cat ~/.claude/skills/my-skill/.skill-manager-ref)

# Re-run installation (same steps as above, overwrites existing)
```

---

### Type 3: Skill Zip URL

A `.skill` zip file hosted at any URL.

**How to recognize:**
- URL ends with `.skill`
- Example: `https://example.com/skills/my-skill.skill`

**Parse the URL:**
- Skill name: filename without `.skill` extension

**Install (User or Project):**
```bash
# Download to temp
curl -L -o /tmp/skill-$$.zip "https://example.com/skills/my-skill.skill"

# Create target and extract
mkdir -p ~/.claude/skills/my-skill
unzip -o /tmp/skill-$$.zip -d ~/.claude/skills/my-skill

# If zip contained a single directory, move contents up
if [ $(ls -1 ~/.claude/skills/my-skill | wc -l) -eq 1 ] && [ -d ~/.claude/skills/my-skill/* ]; then
  mv ~/.claude/skills/my-skill/*/* ~/.claude/skills/my-skill/
  rmdir ~/.claude/skills/my-skill/*/
fi

# Create .skill-manager-ref with source URL
echo "https://example.com/skills/my-skill.skill" > ~/.claude/skills/my-skill/.skill-manager-ref

# Cleanup
rm /tmp/skill-$$.zip
```

**Update:**
```bash
# Read source URL
SOURCE_URL=$(cat ~/.claude/skills/my-skill/.skill-manager-ref)

# Re-run installation (same steps as above, overwrites existing)
```

---

## Remove a Skill

**User skill:**
```bash
rm -rf ~/.claude/skills/skill-name
```

**Project skill (submodule):**
```bash
git submodule deinit -f .claude/skills/skill-name
git rm -f .claude/skills/skill-name
rm -rf .git/modules/.claude/skills/skill-name
```

**Project skill (not a submodule):**
```bash
rm -rf .claude/skills/skill-name
```

## List Installed Skills

```bash
ls ~/.claude/skills/
ls .claude/skills/
```

## Check Skill Source

**GitHub repo:**
```bash
git -C ~/.claude/skills/skill-name remote get-url origin
git -C ~/.claude/skills/skill-name rev-parse --short HEAD
```

**Subdirectory or Zip (has .skill-manager-ref):**
```bash
cat ~/.claude/skills/skill-name/.skill-manager-ref
```

## Post-Install: Check for Dependencies

After installing any skill, check for and install dependencies:

```bash
if [ -f ~/.claude/skills/skill-name/requirements.txt ]; then
  pip install -r ~/.claude/skills/skill-name/requirements.txt
fi
```
