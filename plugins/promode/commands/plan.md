---
description: Research-informed planning with parallel research agents. Use inside plan mode for complex features.
---

# Research-Informed Planning

You are in plan mode, working on a complex feature that needs comprehensive research before planning.

## Your Task

Run 3 research agents **in parallel** to gather information, then synthesize findings into a plan.

### Step 1: Launch Research Agents

Launch all three agents simultaneously using parallel Task calls with `run_in_background: true`:

**Agent 1: Repo Research Analyst**
```
Analyze the codebase to understand:
- Existing patterns relevant to this feature
- Code that will need to be modified or extended
- Test patterns used in similar areas
- Any existing attempts or related functionality

Focus on: {feature area}
```

**Agent 2: Best Practices Researcher**
```
Research best practices for:
- The problem domain (what patterns/approaches are recommended)
- Common pitfalls and how to avoid them
- Testing strategies for this type of feature

Use WebSearch to find authoritative sources.
Focus on: {feature type}
```

**Agent 3: Framework/Library Docs Researcher**
```
Research framework and library documentation for:
- APIs we'll need to use
- Configuration options
- Known limitations or gotchas
- Example implementations

Use WebFetch to read official docs.
Focus on: {frameworks/libraries involved}
```

### Step 2: Synthesize Findings

Once all agents complete, synthesize their findings:

1. **Patterns discovered** — What existing patterns should we follow?
2. **Best practices** — What does the industry recommend?
3. **API understanding** — What capabilities do we have?
4. **Risks identified** — What could go wrong?

### Step 3: Write the Plan

Write your plan to the plan file (specified in plan mode) with:

```markdown
## Research Summary
{Key findings from each research agent}

## Approach
{How we'll implement this, informed by research}

## Delegation Breakdown
{Tasks sized for individual agents}
- Task 1: {description} → delegate to promode:implementer
- Task 2: {description} → delegate to promode:implementer
...

## Risks & Mitigations
{What could go wrong and how we'll handle it}

## Acceptance Criteria
{How we'll know we're done}
```

### Step 4: Exit Plan Mode

Use `ExitPlanMode` with appropriate `allowedPrompts` for the implementation phase.

## Guidelines

- Always run research agents in parallel (single message, multiple Task calls)
- Use `model: sonnet` for research agents (fast, good enough for research)
- Focus research prompts on the specific feature, not generic questions
- Synthesize findings before planning — don't just dump agent outputs
- Frame plan tasks as delegations, not direct work
