# Workflow: Develop a New Skill

<required_reading>
**Read these reference files NOW:**
1. references/recommended-structure.md
2. references/skill-structure.md
3. references/core-principles.md
4. references/use-xml-tags.md
</required_reading>

<escalation_triggers>
Stop and ask when:
- Requirements remain unclear after 2 rounds of questions
- Multiple valid architectural patterns exist (let user choose)
- External API documentation is conflicting or outdated
- Skill would duplicate existing skill functionality
- User's phrasing suggests they may want domain expertise skill instead
</escalation_triggers>

<process>
## Step 1: Adaptive Requirements Gathering

**If user provided context** (e.g., "build a skill for X"):
→ Analyze what's stated, what can be inferred, what's unclear
→ Skip to asking about genuine gaps only

**If user just invoked skill without context:**
→ Ask what they want to build

### Using AskUserQuestion

Ask 2-4 domain-specific questions based on actual gaps. Each question should:
- Have specific options with descriptions
- Focus on scope, complexity, outputs, boundaries
- NOT ask things obvious from context

Example questions:
- "What specific operations should this skill handle?" (with options based on domain)
- "Should this also handle [related thing] or stay focused on [core thing]?"
- "What should the user see when successful?"

### Decision Gate

After initial questions, ask:
"Ready to proceed with building, or would you like me to ask more questions?"

Options:
1. **Proceed to building** - I have enough context
2. **Ask more questions** - There are more details to clarify
3. **Let me add details** - I want to provide additional context

## Step 2: Research Trigger (If External API)

**When external service detected**, ask using AskUserQuestion:
"This involves [service name] API. Would you like me to research current endpoints and patterns before building?"

Options:
1. **Yes, research first** - Fetch current documentation for accurate implementation
2. **No, proceed with general patterns** - Use common patterns without specific API research

If research requested:
- Use Context7 MCP to fetch current library documentation
- Or use WebSearch for recent API documentation
- Focus on 2024-2025 sources
- Store findings for use in content generation

## Step 3: Decide Structure

**Simple skill (single workflow, <200 lines):**
→ Single SKILL.md file with all content

**Complex skill (multiple workflows OR domain knowledge):**
→ Router pattern:
```
skill-name/
├── SKILL.md (router + principles)
├── workflows/ (procedures - FOLLOW)
├── references/ (knowledge - READ)
├── templates/ (output structures - COPY + FILL)
└── scripts/ (reusable code - EXECUTE)
```

Factors favoring router pattern:
- Multiple distinct user intents (create vs debug vs ship)
- Shared domain knowledge across workflows
- Essential principles that must not be skipped
- Skill likely to grow over time

**Consider templates/ when:**
- Skill produces consistent output structures (plans, specs, reports)
- Structure matters more than creative generation

**Consider scripts/ when:**
- Same code runs across invocations (deploy, setup, API calls)
- Operations are error-prone when rewritten each time

See references/recommended-structure.md for templates.

## Step 4: Detect Skill Location

**Check if user is in a standalone repo context:**

Signs of standalone repo intent:
- Working directory is a git repo (has `.git/`)
- Repo is empty or near-empty (just README, LICENSE, .gitignore)
- User is NOT already in a personal skills directory
- User mentioned "distributable", "shareable", "GitHub", or "standalone"

If standalone repo detected, ask using AskUserQuestion:
"I notice you're in an empty repository. Are you creating:"

Options:
1. **A standalone skill (Recommended)** - Distributable via GitHub. I'll create SKILL.md here in this repo.
2. **A personal skill** - For your use only. I'll create it in the personal skills directory instead.

**For standalone skills, also create:**
- README.md with installation instructions
- Appropriate directory structure in current repo

**For personal skills:**
- Use the personal skills directory path

## Step 5: Create Directory

**Personal skill:**
```bash
mkdir -p {skills-directory}/{skill-name}
# If complex:
mkdir -p {skills-directory}/{skill-name}/workflows
mkdir -p {skills-directory}/{skill-name}/references
# If needed:
mkdir -p {skills-directory}/{skill-name}/templates
mkdir -p {skills-directory}/{skill-name}/scripts
```

**Standalone skill (in current repo):**
```bash
# If complex:
mkdir -p workflows
mkdir -p references
# If needed:
mkdir -p templates
mkdir -p scripts
```

## Step 6: Craft Name and Description (CRITICAL)

**⚠️ This is the most important step. If the name and description are wrong, the skill will never be used.**

Before writing any content, draft the YAML frontmatter:

```yaml
---
name: {skill-name}
description: "{description}"
---
```

**Name requirements:**
- Lowercase with hyphens (e.g., `processing-pdfs`, `managing-stripe`)
- Use gerund-noun pattern (`developing-*`, `managing-*`, `processing-*`, `setting-up-*`)
- Must match directory name exactly

**Description requirements (ALL THREE are mandatory):**
1. **What it does** — Specific capabilities, not vague ("processes PDFs" not "helps with documents")
2. **When to use it** — Trigger conditions ("Use when working with PDF files")
3. **Proactive signal** (if needed) — "Use PROACTIVELY when..." for auto-invoke skills

**Test the description:** Ask "If a user said [typical request], would an agent choose this skill based on the description?" If not, revise.

**Read references/skill-structure.md for comprehensive guidance.**

## Step 7: Write SKILL.md

**Simple skill:** Use `templates/simple-skill.md` as starting point. Write complete skill file with:
- YAML frontmatter (name, description) — **from Step 6**
- `<objective>`
- `<quick_start>`
- Content sections with pure XML
- `<success_criteria>`

**Complex skill:** Use `templates/router-skill.md` as starting point. Write router with:
- YAML frontmatter — **from Step 6**
- `<essential_principles>` (inline, unavoidable)
- `<intake>` (question to ask user)
- `<routing>` (maps answers to workflows)
- `<reference_index>` and `<workflows_index>`

## Step 8: Write Workflows (if complex)

For each workflow:
```xml
<required_reading>
Which references to load for this workflow
</required_reading>

<process>
Step-by-step procedure
</process>

<success_criteria>
How to know this workflow is done
</success_criteria>
```

## Step 9: Write References (if needed)

Domain knowledge that:
- Multiple workflows might need
- Doesn't change based on workflow
- Contains patterns, examples, technical details

## Step 10: Validate Structure

Check:
- [ ] YAML frontmatter valid
- [ ] Name matches directory (lowercase-with-hyphens)
- [ ] Description says what it does AND when to use it (third person)
- [ ] No markdown headings (#) in body - use XML tags
- [ ] Required tags present: objective, quick_start, success_criteria
- [ ] All referenced files exist
- [ ] SKILL.md under 500 lines
- [ ] XML tags properly closed

## Step 11: Create Command Shortcut (if supported by agent harness)

Create a command shortcut if your agent harness supports them. The shortcut should invoke the skill with appropriate arguments.

## Step 12: Test

Invoke the skill and observe:
- Does it ask the right intake question?
- Does it load the right workflow?
- Does the workflow load the right references?
- Does output match expectations?

Iterate based on real usage, not assumptions.
</process>

<success_criteria>
Skill is complete when:
- [ ] Requirements gathered with appropriate questions
- [ ] API research done if external service involved
- [ ] Directory structure correct
- [ ] **Name and description are optimized for agent discovery** (CRITICAL)
- [ ] Description includes: what it does + when to use it + proactive trigger (if needed)
- [ ] SKILL.md has valid frontmatter
- [ ] Essential principles inline (if complex skill)
- [ ] Intake question routes to correct workflow
- [ ] All workflows have required_reading + process + success_criteria
- [ ] References contain reusable domain knowledge
- [ ] Command shortcut exists and works (if supported)
- [ ] Tested with real invocation — agent invokes skill for intended use cases
</success_criteria>
