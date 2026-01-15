<overview>
Skills have three structural components: YAML frontmatter (metadata), pure XML body structure (content organization), and progressive disclosure (file organization). This reference defines requirements and best practices for each component.
</overview>

<critical_warning>
## ⚠️ NAME AND DESCRIPTION ARE THE #1 CAUSE OF SKILL FAILURE ⚠️

**If an agent never invokes your skill, nothing else matters.**

The name and description are how agents discover skills. When a user asks for help, the agent scans available skills and decides which (if any) to use based SOLELY on names and descriptions.

**Common failure modes:**
- Skill exists but agent doesn't use it → description doesn't match how users phrase requests
- Agent uses wrong skill → names are too similar or descriptions overlap
- Agent uses skill too late → description lacks "PROACTIVELY" trigger language
- Agent never considers skill → description is vague ("helps with X")

**Your skill's name and description are prompt engineering.** Apply the same rigor you would to any critical prompt. Test with real requests. Iterate until the agent reliably invokes the skill for all intended use cases.
</critical_warning>

<xml_structure_requirements>
<critical_rule>
**Remove ALL markdown headings (#, ##, ###) from skill body content.** Replace with semantic XML tags. Keep markdown formatting WITHIN content (bold, italic, lists, code blocks, links).
</critical_rule>

<required_tags>
Every skill MUST have these three tags:

- **`<objective>`** - What the skill does and why it matters (1-3 paragraphs)
- **`<quick_start>`** - Immediate, actionable guidance (minimal working example)
- **`<success_criteria>`** or **`<when_successful>`** - How to know it worked
</required_tags>

<conditional_tags>
Add based on skill complexity and domain requirements:

- **`<context>`** - Background/situational information
- **`<workflow>` or `<process>`** - Step-by-step procedures
- **`<advanced_features>`** - Deep-dive topics (progressive disclosure)
- **`<validation>`** - How to verify outputs
- **`<examples>`** - Multi-shot learning
- **`<anti_patterns>`** - Common mistakes to avoid
- **`<security_checklist>`** - Non-negotiable security patterns
- **`<testing>`** - Testing workflows
- **`<common_patterns>`** - Code examples and recipes
- **`<reference_guides>` or `<detailed_references>`** - Links to reference files

See [use-xml-tags.md](use-xml-tags.md) for detailed guidance on each tag.
</conditional_tags>

<tag_selection_intelligence>
**Simple skills** (single domain, straightforward):
- Required tags only
- Example: Text extraction, file format conversion

**Medium skills** (multiple patterns, some complexity):
- Required tags + workflow/examples as needed
- Example: Document processing with steps, API integration

**Complex skills** (multiple domains, security, APIs):
- Required tags + conditional tags as appropriate
- Example: Payment processing, authentication systems, multi-step workflows
</tag_selection_intelligence>

<xml_nesting>
Properly nest XML tags for hierarchical content:

```xml
<examples>
<example number="1">
<input>User input</input>
<output>Expected output</output>
</example>
</examples>
```

Always close tags:
```xml
<objective>
Content here
</objective>
```
</xml_nesting>

<tag_naming_conventions>
Use descriptive, semantic names:
- `<workflow>` not `<steps>`
- `<success_criteria>` not `<done>`
- `<anti_patterns>` not `<dont_do>`

Be consistent within your skill. If you use `<workflow>`, don't also use `<process>` for the same purpose (unless they serve different roles).
</tag_naming_conventions>
</xml_structure_requirements>

<yaml_requirements>
<invocation_optimization>
**Name and description are the ONLY discovery mechanisms**

The name and description are not just metadata — they are the PRIMARY and ONLY mechanism by which agents decide whether to use a skill. When a user makes a request, the agent scans available skills and matches against their names and descriptions. **If your name and description don't match how users phrase their requests, the skill will never be used.**

**Goal**: Maximize the probability the agent will invoke the skill for EVERY relevant task.

This means optimizing for:
1. **Recognition** — The agent must recognize that the skill applies to the current task
2. **Confidence** — The agent must feel confident the skill is the right tool (not just possibly relevant)
3. **Timing** — The agent must invoke the skill at the right moment (before starting, not mid-task)

**Common failure modes (in order of frequency):**
1. **Missing activity coverage** → Description says "creating" but user asks to "assess" or "review" — skill never invoked
2. **Vague descriptions** → Agent doesn't recognize relevance ("helps with documents" - which documents? when?)
3. **Missing trigger words** → Agent doesn't know WHEN to use it (missing "Use when..." or "MUST be loaded...")
4. **Passive/advisory language** → Agent treats skill as optional reference, not required tool ("Expert guidance for..." sounds optional)
5. **Wrong verb scope** → Agent doesn't invoke for review/update tasks if description only mentions "create"
6. **Missing synonyms** → User says "assess" but description only says "review", or "spreadsheet" vs "Excel"

**Think of it as prompt engineering for skill selection.** The name and description are a prompt that must convince the agent to use the skill. Apply the same rigor you would to any critical prompt.

**Test your descriptions:** Ask yourself "If a user said [X], would the agent choose this skill?" Test with multiple phrasings of the same request.
</invocation_optimization>

<required_fields>
```yaml
---
name: skill-name-here
description: "What it does and when to use it (third person, specific triggers)"
---
```

**Critical**: Always wrap the description value in double quotes to avoid YAML parsing errors. Descriptions often contain colons, special characters, or line breaks that break YAML parsing without quotes.
</required_fields>

<name_field>
**Validation rules**:
- Maximum 64 characters
- Lowercase letters, numbers, hyphens only
- No XML tags
- No reserved words: "anthropic", "claude"
- Must match directory name exactly

**Examples**:
- ✅ `processing-pdfs`
- ✅ `managing-facebook-ads`
- ✅ `setting-up-stripe-payments`
- ❌ `PDF_Processor` (uppercase)
- ❌ `helper` (vague)
- ❌ `claude-helper` (reserved word)
</name_field>

<description_field>
**Validation rules**:
- Non-empty, maximum 1024 characters
- No XML tags
- Third person (never first or second person)
- Include what it does AND when to use it

**Critical rule**: Always write in third person.
- ✅ "Processes Excel files and generates reports"
- ❌ "I can help you process Excel files"
- ❌ "You can use this to process Excel files"

**Structure**: Include both capabilities and triggers.

**Effective examples**:
```yaml
description: "Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction."
```

```yaml
description: "Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files."
```

```yaml
description: "Generate descriptive commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes."
```

**Avoid** (content is too vague, but note descriptions are still quoted):
```yaml
description: "Helps with documents"
```

```yaml
description: "Processes data"
```

<proactive_invocation>
**Proactive vs Reactive Descriptions**

Descriptions control when an agent invokes a skill. Match your description to intended usage:

**Reactive (wait for explicit request or mid-task):**
```yaml
description: "Expert guidance for X. Use when working with X files."
```
- Agent waits for user to mention skill or already be working on X
- Appropriate for reference/consultation skills

**Proactive (invoke before starting work):**
```yaml
description: "MUST be loaded before working with X. Covers creating, reviewing, and updating X."
```
- Agent invokes the skill automatically when task matches
- Appropriate for skills that should guide the process from the start

**Key elements for proactive descriptions:**
- Lead with "MUST be loaded before..." to indicate this is required, not optional
- **List ALL activities covered** — "creating, reviewing, auditing, updating, modifying"
- Use "PROACTIVELY" or "MUST BE USED" explicitly
- Specify trigger point: "before writing", "when starting to", "before beginning"
- Avoid passive/advisory language: "Expert guidance for..." sounds optional

**Critical: Cover all activity synonyms**

Users phrase requests in many ways. If your skill handles any of these, include them:
- Creating: "create", "build", "make", "develop", "write", "new"
- Reviewing: "review", "assess", "check", "audit", "evaluate", "analyze"
- Updating: "update", "modify", "change", "edit", "fix", "improve"

If you only say "creating" but the user asks to "assess", the agent won't invoke your skill.

**Examples (note: all descriptions must be wrapped in quotes in actual YAML):**
- ❌ `"Expert guidance for creating skills. Use when working with SKILL.md files."`
- ✅ `"MUST be loaded before working with any Skill. Covers creating, reviewing, auditing, updating, and modifying skills."`

- ❌ `"Helps with commit messages. Use when committing code."`
- ✅ `"Use PROACTIVELY to generate commit messages. Invoke before running git commit."`

- ❌ `"Code review assistance for pull requests."`
- ✅ `"Use PROACTIVELY after writing code. MUST be invoked to review changes before committing."`
</proactive_invocation>
</description_field>
</yaml_requirements>

<naming_conventions>
Use **gerund-noun convention** for skill names (verb in -ing form):

<pattern name="managing">
Managing external services or resources

Examples: `managing-facebook-ads`, `managing-zoom`, `managing-stripe`, `managing-supabase`
</pattern>

<pattern name="setting-up">
Configuration/integration tasks

Examples: `setting-up-stripe-payments`, `setting-up-meta-tracking`
</pattern>

<pattern name="generating">
Generation tasks

Examples: `generating-ai-images`
</pattern>

<pattern name="developing">
Full lifecycle development (create + review + update + iterate)

Examples: `developing-agent-skills`, `developing-mcp-servers`, `developing-hooks`

Use for any skill that builds artifacts that may need revision or iteration.
</pattern>

<pattern name="processing">
Transformation and data processing

Examples: `processing-pdf`, `processing-images`, `processing-csv`
</pattern>

<avoid_patterns>
- Vague: `helper`, `utils`, `tools`
- Generic: `documents`, `data`, `files`
- Reserved words: `anthropic-helper`, `claude-tools`
- Inconsistent: Directory `facebook-ads` but name `managing-facebook-ads`
</avoid_patterns>

<verb_selection>
**Choosing the Right Verb (Gerund Form)**

The verb should match the skill's actual scope:

| Pattern | Scope | Use When |
|---------|-------|----------|
| `developing-*` | Full lifecycle | Builds artifacts that may need revision (create + review + update) |
| `generating-*` | One-shot output | Produces output from input, no iteration expected |
| `managing-*` | CRUD + ongoing | External resources, services, ongoing operations |
| `setting-up-*` | One-time config | Initial setup, integration, configuration |
| `processing-*` | Transformation | Converting, extracting, transforming data |

**Key distinction**: Use `generating-*` for one-shot outputs (images, commit messages). Use `developing-*` when the artifact may need iteration (skills, hooks, servers).

**Examples:**
- Skill builds hooks that may need debugging → `developing-hooks`
- Skill produces images from prompts → `generating-images`
- Skill sets up Stripe integration once → `setting-up-stripe`
- Skill manages ongoing Stripe operations → `managing-stripe`
</verb_selection>

<singular_vs_plural>
**Singular vs Plural Nouns**

Match the noun to the operational unit:

**Use plural nouns by default.** This matches how users think about skill categories.

**Examples:**
- ✅ `developing-skills` — skill for developing skills
- ✅ `managing-facebook-ads` — skill for managing ads
- ✅ `processing-images` — skill for processing images
- ✅ `generating-commit-messages` — skill for generating commit messages
- ✅ `developing-hooks` — skill for developing hooks
</singular_vs_plural>
</naming_conventions>

<progressive_disclosure>
<principle>
SKILL.md serves as an overview that points to detailed materials as needed. This keeps context window usage efficient.
</principle>

<practical_guidance>
- Keep SKILL.md body under 500 lines
- Split content into separate files when approaching this limit
- Keep references one level deep from SKILL.md
- Add table of contents to reference files over 100 lines
</practical_guidance>

<pattern name="high_level_guide">
Quick start in SKILL.md, details in reference files:

```markdown
---
name: processing-pdfs
description: "Extracts text and tables from PDF files, fills forms, and merges documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction."
---

<objective>
Extract text and tables from PDF files, fill forms, and merge documents using Python libraries.
</objective>

<quick_start>
Extract text with pdfplumber:

```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
</quick_start>

<advanced_features>
**Form filling**: See [forms.md](forms.md)
**API reference**: See [reference.md](reference.md)
</advanced_features>
```

The agent loads forms.md or reference.md only when needed.
</pattern>

<pattern name="domain_organization">
For skills with multiple domains, organize by domain to avoid loading irrelevant context:

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

When user asks about revenue, the agent reads only finance.md. Other files stay on filesystem consuming zero tokens.
</pattern>

<pattern name="conditional_details">
Show basic content in SKILL.md, link to advanced in reference files:

```xml
<objective>
Process DOCX files with creation and editing capabilities.
</objective>

<quick_start>
<creating_documents>
Use docx-js for new documents. See [docx-js.md](docx-js.md).
</creating_documents>

<editing_documents>
For simple edits, modify XML directly.

**For tracked changes**: See [redlining.md](redlining.md)
**For OOXML details**: See [ooxml.md](ooxml.md)
</editing_documents>
</quick_start>
```

The agent reads redlining.md or ooxml.md only when the user needs those features.
</pattern>

<critical_rules>
**Keep references one level deep**: All reference files should link directly from SKILL.md. Avoid nested references (SKILL.md → advanced.md → details.md) as agents may only partially read deeply nested files.

**Add table of contents to long files**: For reference files over 100 lines, include a table of contents at the top.

**Use pure XML in reference files**: Reference files should also use pure XML structure (no markdown headings in body).
</critical_rules>
</progressive_disclosure>

<file_organization>
<filesystem_navigation>
Agents navigate your skill directory using bash commands:

- Use forward slashes: `reference/guide.md` (not `reference\guide.md`)
- Name files descriptively: `form_validation_rules.md` (not `doc2.md`)
- Organize by domain: `reference/finance.md`, `reference/sales.md`
</filesystem_navigation>

<directory_structure>
Typical skill structure:

```
skill-name/
├── SKILL.md (main entry point, pure XML structure)
├── references/ (optional, for progressive disclosure)
│   ├── guide-1.md (pure XML structure)
│   ├── guide-2.md (pure XML structure)
│   └── examples.md (pure XML structure)
└── scripts/ (optional, for utility scripts)
    ├── validate.py
    └── process.py
```
</directory_structure>
</file_organization>

<anti_patterns>
<pitfall name="markdown_headings_in_body">
❌ Do NOT use markdown headings in skill body:

```markdown
# PDF Processing

## Quick start
Extract text...

## Advanced features
Form filling...
```

✅ Use pure XML structure:

```xml
<objective>
PDF processing with text extraction, form filling, and merging.
</objective>

<quick_start>
Extract text...
</quick_start>

<advanced_features>
Form filling...
</advanced_features>
```
</pitfall>

<pitfall name="vague_descriptions">
- ❌ "Helps with documents"
- ✅ "Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction."
</pitfall>

<pitfall name="inconsistent_pov">
- ❌ "I can help you process Excel files"
- ✅ "Processes Excel files and generates reports"
</pitfall>

<pitfall name="wrong_naming_convention">
- ❌ Directory: `facebook-ads`, Name: `facebook-ads-manager`
- ✅ Directory: `managing-facebook-ads`, Name: `managing-facebook-ads`
- ❌ Directory: `stripe-integration`, Name: `stripe`
- ✅ Directory: `setting-up-stripe-payments`, Name: `setting-up-stripe-payments`
</pitfall>

<pitfall name="deeply_nested_references">
Keep references one level deep from SKILL.md. Claude may only partially read nested files (SKILL.md → advanced.md → details.md).
</pitfall>

<pitfall name="windows_paths">
Always use forward slashes: `scripts/helper.py` (not `scripts\helper.py`)
</pitfall>

<pitfall name="missing_required_tags">
Every skill must have: `<objective>`, `<quick_start>`, and `<success_criteria>` (or `<when_successful>`).
</pitfall>
</anti_patterns>

<validation_checklist>
Before finalizing a skill, verify:

- ✅ YAML frontmatter valid (name matches directory, description in third person)
- ✅ No markdown headings in body (pure XML structure)
- ✅ Required tags present: objective, quick_start, success_criteria
- ✅ Conditional tags appropriate for complexity level
- ✅ All XML tags properly closed
- ✅ Progressive disclosure applied (SKILL.md < 500 lines)
- ✅ Reference files use pure XML structure
- ✅ File paths use forward slashes
- ✅ Descriptive file names
</validation_checklist>
