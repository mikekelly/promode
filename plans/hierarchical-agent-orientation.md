# Plan: Hierarchical Agent Orientation In Promode

## Context

Promode already treats a project's `CLAUDE.md` as the root of the project-owned agent knowledge graph, while Promode methodology is delivered separately through the main-agent hook and phase-agent definitions. That split is correct and must remain intact.

The missing nuance is that real projects often need **hierarchical loaded orientation**, not just one root launchpad:

- Critical workflow rules that agents must obey must be in automatically loaded orientation, not only in linked docs.
- Claude Code loads `CLAUDE.md` from the working context, and project subdirectories can carry their own `CLAUDE.md` files so agents touching that subtree receive local rules without bloating the repo root.
- Other harnesses commonly load `AGENTS.md`, so each `CLAUDE.md` orientation file should have an adjacent `AGENTS.md` symlink where the filesystem supports it.

This is project knowledge, not Promode orchestration. Do not put "delegate everything" or other main-agent methodology into project `CLAUDE.md` files.

## Goal

Update the Promode Claude Code plugin so its guidance, audit rubric, and repair skill teach agents to structure project orientation as:

1. A concise root `CLAUDE.md` with repo-wide critical rules and links.
2. Optional subdirectory `CLAUDE.md` files for major subsystems with local critical rules, commands, concepts, and links.
3. Adjacent `AGENTS.md -> CLAUDE.md` symlinks for harness compatibility.
4. Detailed workflow docs kept as linked expansion nodes, with only the must-obey rules mirrored inline in the loaded orientation file that governs the work area.

## Non-Goals

- Do not make Promode install or overwrite project `CLAUDE.md`/`AGENTS.md` files.
- Do not move Promode methodology into project orientation files.
- Do not require every directory to have a `CLAUDE.md`; only major top-level or subsystem roots where the local rules materially differ.
- Do not inline full manuals into `CLAUDE.md`; preserve the launchpad discipline.
- Do not mandate `AGENTS.md` regular-file duplication when a symlink works.

## Source Evidence To Preserve

Relevant current plugin files:

- `plugins/promode/skills/promode-audit/references/main-agent-delivery.md` explains why Promode methodology stays out of project `CLAUDE.md`.
- `plugins/promode/skills/promode-audit/references/agent-knowledge-wiki.md` defines the `CLAUDE.md`-rooted knowledge graph and inline-criticality rule.
- `plugins/promode/skills/reinforce-design-constraints/SKILL.md` is the write action that hoists hidden constraints into loaded orientation.
- `plugins/promode/skills/promode-audit/SKILL.md` audits `CLAUDE.md` health and should detect missing hierarchy/symlinks.
- `plugins/promode/PROMODE_MAIN_AGENT.md` tells the main agent how to capture knowledge after substantial work.
- `plugins/promode/agents/implementer.md`, `debugger.md`, `environment-manager.md`, and `product-design-expert.md` contain reusable knowledge-capture instructions.
- `README.md` and root `CLAUDE.md` explain Promode's public model and should stay consistent.

User-provided project lesson to encode: when a repo has critical workflow rules in a detailed doc, mirror the non-negotiable parts into the relevant loaded `CLAUDE.md` file, and use subdirectory `CLAUDE.md` files plus `AGENTS.md` symlinks so agents working locally get the right context automatically.

## Proposed Changes

### 1. Update the agent-knowledge reference

Edit `plugins/promode/skills/promode-audit/references/agent-knowledge-wiki.md`.

Add a section after the root-entry-point discussion:

- Root `CLAUDE.md` is the repo-wide launchpad.
- Major subdirectories may have their own `CLAUDE.md` when local rules, commands, concepts, or landmines would bloat the root or are only relevant in that subtree.
- Put critical local rules in the nearest loaded orientation, not only in a linked doc.
- Keep detailed docs as expansion nodes and link to them from the loaded orientation.
- Add an adjacent `AGENTS.md` symlink to each `CLAUDE.md` orientation file for other harnesses.
- If symlinks are impossible, duplicate minimally and document that the two files must stay in lockstep.

Keep the "compact launchpad" principle: subdirectory orientation is a way to reduce root bloat, not permission to write local manuals.

### 2. Update `reinforce-design-constraints`

Edit `plugins/promode/skills/reinforce-design-constraints/SKILL.md`.

Change the model from "always hoist into root `CLAUDE.md`" to "hoist into the **nearest loaded orientation file that governs the affected area**, with repo-wide constraints in root."

Implementation nuance:

- During graph traversal, detect existing `CLAUDE.md` files along relevant paths.
- When reinforcing a constraint, choose placement:
  - repo-wide or cross-cutting rule -> root `CLAUDE.md`
  - subsystem/package/workflow-specific rule -> that subtree's `CLAUDE.md`
  - missing suitable subtree orientation and several local critical rules exist -> create a concise subtree `CLAUDE.md` and link it from the parent/root
- Ensure adjacent `AGENTS.md` symlink exists for every created or maintained orientation file.
- Report which rules went to root versus subtree orientation.

Update success criteria so "no agent editing an affected area could miss the rule" can be satisfied by subtree-loaded `CLAUDE.md`, not only the root.

### 3. Update `promode-audit`'s Agent Knowledge dimension

Edit `plugins/promode/skills/promode-audit/SKILL.md`.

In the Agent knowledge & orientation dimension and `<claude-md-health>` rubric:

- Evaluate the orientation hierarchy, not just the root file.
- Check that root `CLAUDE.md` links to major subdir orientation files when present.
- Check whether critical workflow/build/test rules are inline in the loaded orientation governing the affected area.
- Flag "critical rule only in linked workflow doc" as a `Now` finding.
- Flag missing `AGENTS.md` symlinks beside `CLAUDE.md` orientation files as a compatibility finding.
- Flag bloated root `CLAUDE.md` where content should move to subtree orientation.

Add recommended write action: use `reinforce-design-constraints` for buried constraints and, when the issue is broad orientation shape, create or split `CLAUDE.md` files plus symlinked `AGENTS.md`.

### 4. Update main-agent brief knowledge guidance

Edit `plugins/promode/PROMODE_MAIN_AGENT.md`.

In `<after-action-review>` or a small `<agent-knowledge>` addition, add the decision-level rule only:

- Project knowledge belongs in the loaded orientation graph.
- Critical rules discovered during work should be mirrored into the nearest relevant `CLAUDE.md`, with detailed rationale linked out.
- For major subtrees, prefer local `CLAUDE.md` files over bloating the root.
- Keep `AGENTS.md` symlinks beside orientation files for harness portability.

Do not add mechanics-heavy prose. The mechanics belong in `agent-knowledge-wiki.md` and `reinforce-design-constraints`.

After editing the brief, run `./scripts/check-hooks.sh` because hook output size/chunking is load-bearing.

### 5. Update working agent definitions that maintain knowledge

Edit the `<agent-knowledge>` sections in:

- `plugins/promode/agents/implementer.md`
- `plugins/promode/agents/debugger.md`
- `plugins/promode/agents/environment-manager.md`
- `plugins/promode/agents/product-design-expert.md`

Add concise instructions:

- Capture reusable project knowledge into the graph rooted at `CLAUDE.md`.
- If the knowledge is a critical rule for a specific subtree, mirror the rule into that subtree's `CLAUDE.md` rather than only linking a doc from root.
- Add or preserve an adjacent `AGENTS.md` symlink when creating a `CLAUDE.md`.
- Never clobber existing orientation; integrate and link.

Consider `plugins/promode/agents/code-reviewer.md` too: add a review check that critical workflow/constraint changes landed in the relevant loaded orientation file and that `AGENTS.md` symlinks exist where new orientation files were added.

### 6. Update public docs

Edit `README.md` and root `CLAUDE.md` only enough to keep the public model accurate:

- `CLAUDE.md` is still project-owned and methodology-free.
- The knowledge graph can be hierarchical: root plus subsystem `CLAUDE.md` files.
- `AGENTS.md` symlinks are recommended compatibility shims for harnesses that load that filename.

Keep root `CLAUDE.md` under its stated 50-line cap.

## Acceptance Criteria

- Plugin docs distinguish clearly between:
  - Promode methodology: hook-delivered main brief plus phase-agent definitions.
  - Project knowledge: root/subtree `CLAUDE.md` files loaded by agents.
- `agent-knowledge-wiki.md` describes hierarchical `CLAUDE.md` orientation and `AGENTS.md` symlink compatibility.
- `reinforce-design-constraints` can place a critical rule in the nearest relevant loaded orientation, not only root.
- `promode-audit` can flag:
  - critical rules only present in linked docs,
  - missing subtree orientation where root bloat or local rules justify it,
  - missing `AGENTS.md` symlinks beside orientation files.
- Main brief includes only the decision-level reminder and stays within hook output limits.
- Agent definitions that create/update project knowledge know how to maintain subtree orientation and symlinks.
- Public README/root `CLAUDE.md` remain consistent with the new model.

## Verification

Run from `/Users/mike/code/promode`:

```bash
./scripts/check-hooks.sh
./scripts/check-skill-frontmatter.sh
./scripts/check-json-valid.sh
```

Then run targeted text checks:

```bash
rg -n "AGENTS.md|subdir|subdirectory|nearest .*CLAUDE|loaded orientation|critical .*workflow|critical .*rule" \
  README.md CLAUDE.md plugins/promode
```

Manual review checklist:

- No wording suggests Promode should overwrite project orientation files.
- No wording suggests putting main-agent orchestration methodology into project `CLAUDE.md`.
- The root/subtree split is framed as context-budget discipline, not more documentation for its own sake.
- Symlink guidance includes the fallback for filesystems/harnesses that cannot use symlinks.
- Brief chunk sizes remain green after `./scripts/check-hooks.sh`.

## Suggested Commit Shape

One commit is appropriate if all changes are doc/prompt updates:

```text
Teach hierarchical CLAUDE orientation
```

If the brief edit causes hook chunk reshaping, include that in the same commit so the delivery contract stays green.
