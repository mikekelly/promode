# Evaluation-Driven Skill Development

Build evaluations BEFORE writing extensive documentation. This ensures your skill solves real problems rather than documenting imagined ones.

<process>
## Step 1: Identify Gaps

Run Claude on representative tasks WITHOUT a skill. Document specific failures:
- What context was missing?
- What instructions were needed?
- Where did Claude make wrong assumptions?

## Step 2: Create Evaluation Scenarios

Build 3+ scenarios that test these gaps:

```json
{
  "skill": "skill-name",
  "query": "User request that exercises the skill",
  "files": ["test-files/example.txt"],
  "expected_behavior": [
    "Specific observable behavior 1",
    "Specific observable behavior 2",
    "Specific observable behavior 3"
  ]
}
```

## Step 3: Establish Baseline

Measure Claude's performance WITHOUT the skill:
- What percentage of expected behaviors occur?
- What common failure patterns emerge?

## Step 4: Write Minimal Instructions

Create just enough content to address the gaps. Don't anticipate requirements that may never materialize.

## Step 5: Iterate

1. Run evaluations with skill loaded
2. Compare against baseline
3. Refine based on actual failures, not assumptions
</process>

<claude_a_b_pattern>
## The Claude A/B Development Pattern

Work with one instance of Claude ("Claude A") to create a skill that will be used by other instances ("Claude B").

**Claude A** (the expert):
- Helps design and refine instructions
- Reviews your work and suggests improvements
- Understands agent needs

**Claude B** (the user):
- Fresh instance with skill loaded
- Tests the skill on real tasks
- Reveals gaps through actual usage

**Workflow:**
1. Complete a task with Claude A using normal prompting
2. Identify what context you repeatedly provided
3. Ask Claude A to create a skill capturing that pattern
4. Test with Claude B on related tasks
5. Observe Claude B's behavior, note failures
6. Return to Claude A with specifics: "Claude B forgot to X when asked for Y"
7. Refine and repeat
</claude_a_b_pattern>

<model_testing>
## Test Across Models

Skills act as additions to models, so effectiveness depends on the underlying model.

**Claude Haiku** (fast, economical):
- Does the skill provide enough guidance?
- Are instructions explicit enough?

**Claude Sonnet** (balanced):
- Is the skill clear and efficient?
- Does it activate reliably?

**Claude Opus** (powerful reasoning):
- Does the skill avoid over-explaining?
- Is there unnecessary hand-holding?

What works perfectly for Opus might need more detail for Haiku.
</model_testing>

<observation_checklist>
## What to Observe During Testing

- **Unexpected exploration paths** - Does Claude read files in an order you didn't anticipate?
- **Missed connections** - Does Claude fail to follow references to important files?
- **Overreliance on sections** - Does Claude repeatedly read the same file?
- **Ignored content** - Does Claude never access a bundled file?

Iterate based on observations, not assumptions.
</observation_checklist>
