# Design draft: eliminate skills from the promode plugin (CTO)

## Brief
- **Orient** — the ratified new opinion (maintainer, 2026-07-07): *promode avoids skills altogether, in favour of dedicated agents or prompting shared across agents — skills require voluntary invocation, which is non-determinate and yields inconsistent behaviour.* Read: `plugins/promode/docs/opinion-register.md` (Components section — the 7 skills, their consumers and coordination edges), the brief (`PROMODE_MAIN_AGENT.md`, note chunk budgets: ~9.6k/7.3k/9.1k of 10k×3), all skill SKILL.md files, `tasks/07-invocation-tax.md` (prior research: which skills are dispatch targets vs NL-triggered), root `CLAUDE.md` (altitude + register doctrine).
- **Specify** — a **design + delegation-ready migration plan** (drafted for the main agent + maintainer to ratify; execute nothing beyond probes):
  1. **Per-skill disposition** for all 7 (promode-audit, discovery-to-determinism, design-system-lookbook, task-docs, handoff, recovering-subagents, reinforce-design-constraints): dedicated agent (JIT context economics preserved, invocation becomes deterministic dispatch via the delegation map) / shared prompting in existing defs (small, always-relevant mechanics) / plugin `commands/` (user-invoked flows like /handoff) / brief chunk (main-agent-only mechanics — weigh a 4th chunk: hooks.json registration procedure exists). For each: why that home, context-economics delta (what loads when, vs today's JIT skill), and what breaks if mis-homed.
  2. **Harness preconditions, probed live not assumed** (run scratch probes yourself or state exactly what must be verified before execution): (a) can a promode *subagent* use the Agent tool to fan out its own sub-assessors (decides whether promode-audit can become a dedicated agent, or its fan-out protocol must live in the brief)? (b) do plugin-shipped `commands/` work as the user-invoked replacement for /handoff (and /promode-audit's slash form)? (c) anything else your design leans on that the harness hasn't already verified (CLAUDE.md records what has been).
  3. **Corpus consequences**: register changes (the new opinion as a row; Components skill entries → their new homes; description-tax rows retired), README (Skills section, Fork it references), CLAUDE.md (altitude paragraph currently names skills as a mechanics home), wiki authoring conventions, sync runbook, check scripts (skill-frontmatter check retires?), delegation map rewiring.
  4. **Sequencing** as delegable tasks (sized per agent, dependencies named, verification checkpoints placed) + the risks/one-way doors (e.g. NL triggers lost: today a user saying "audit this repo" fires the skill description; after migration the main agent must route it — is the delegation map sufficient?), and the strongest rejected alternatives with why.
- **Why** — voluntary invocation is the last non-deterministic delivery surface in promode; everything else reaches agents by guaranteed load (hook, defs, @-import) or dispatch. The maintainer judges the inconsistency cost above the JIT benefit; the design must preserve the JIT *economics* through dedicated agents while removing the *voluntariness*.
- **Verified vs assumed** — task 07 verified skills' invocation semantics on 2.1.201; subagent-spawning-subagents and plugin commands/ are UNVERIFIED assumptions until probed; chunk budgets verified 2026-07-07.
- **Not / exit** — design + probes only: no corpus edits, no version bump. Record the draft (or a link to it) + probe results in this doc's Outcome. Exit: a plan the main agent can ratify and dispatch task-by-task.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — brief chunk caps; JIT economics must survive; user-invoked flows need a surface
- **Established facts** — opinion ratified; task-07 invocation semantics
- **Pending goals / next step** — CTO drafts; main agent + maintainer ratify

## Outcome
_(filled by the agent on completion)_
