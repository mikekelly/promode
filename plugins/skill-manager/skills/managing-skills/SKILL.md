---
name: managing-skills
description: Install, update, list, and remove Claude Code skills. Supports GitHub repositories (user/repo), GitHub subdirectory URLs (github.com/user/repo/tree/branch/path), and .skill zip files. Use when user wants to install, add, download, update, sync, list, remove, uninstall, or delete skills.
---

<objective>
Manage Claude Code skills from multiple source types. This skill handles the full lifecycle of skill management: installation, updates, listing, and removal.
</objective>

<install_locations>
Skills can be installed in two locations:

- **User skills** (`~/.claude/skills/<skill-name>/`) - available in all projects
- **Project skills** (`<project>/.claude/skills/<skill-name>/`) - available only in that project

<decision_criteria>
**Suggest user location when:**
- Skill is general-purpose (not project-specific)
- User wants skill available across all projects
- Default choice if user doesn't specify

**Suggest project location when:**
- Skill is specific to this project's tech stack
- Team needs shared access via version control
- Skill contains project-specific customizations
</decision_criteria>

**Always ask the user which location they want before installing.**
</install_locations>

<quick_start>
**Install from GitHub repo:**
```bash
mkdir -p ~/.claude/skills
git clone https://github.com/user/repo ~/.claude/skills/repo
```

**List installed skills:**
```bash
ls ~/.claude/skills/
ls .claude/skills/
```

**Remove a skill:**
```bash
rm -rf ~/.claude/skills/skill-name
```

After any operation, remind user to restart Claude Code.
</quick_start>

<skill_reference_types>
<type name="github_repository">
A dedicated GitHub repo containing a skill.

**How to recognize:**
- Shorthand: `user/repo`
- Full URL: `https://github.com/user/repo`
- May contain `/tree/<branch>` but NO path after the branch

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
</type>

<type name="github_subdirectory">
A skill living as a subdirectory within a larger repository.

**How to recognize:**
- Contains `/tree/<branch>/` followed by a path within the repo
- Example: `https://github.com/org/repo/tree/main/skills/my-skill`
- Differs from github_repository: has path AFTER the branch name

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
</type>

<type name="skill_zip">
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
</type>
</skill_reference_types>

<remove_skill>
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
</remove_skill>

<check_skill_source>
**GitHub repo:**
```bash
git -C ~/.claude/skills/skill-name remote get-url origin
git -C ~/.claude/skills/skill-name rev-parse --short HEAD
```

**Subdirectory or Zip (has .skill-manager-ref):**
```bash
cat ~/.claude/skills/skill-name/.skill-manager-ref
```
</check_skill_source>

<post_install>
After installing any skill, check for and install dependencies:

```bash
if [ -f ~/.claude/skills/skill-name/requirements.txt ]; then
  pip install -r ~/.claude/skills/skill-name/requirements.txt
fi
```
</post_install>

<error_handling>
**Network failure during clone/download:**
- Check internet connectivity
- Verify URL is accessible
- Retry with `--depth 1` for large repos

**Permission denied:**
- Check write permissions on target directory
- Use `sudo` only if installing to system location (not recommended)

**Skill already exists:**
- Ask user: overwrite, rename, or cancel
- For updates, overwrite is expected behavior

**Invalid skill structure:**
- Verify SKILL.md exists in the skill directory
- Check for valid YAML frontmatter
</error_handling>

<success_criteria>
Installation is successful when:
- Skill directory exists at target location
- SKILL.md file is present and readable
- Dependencies installed (if requirements.txt exists)
- User reminded to restart Claude Code

Update is successful when:
- Latest version pulled/downloaded
- No merge conflicts (for git repos)
- User reminded to restart Claude Code

Removal is successful when:
- Skill directory no longer exists
- Submodule fully removed (if applicable)
- User reminded to restart Claude Code
</success_criteria>
