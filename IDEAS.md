# Ideas backlog

Raw, not-yet-spec'd ideas for promode. Before adding or reviving an idea, check the rejected-work log ([docs/decisions/](docs/decisions/2026-07-community-skills-rejections.md)) — match by concept, don't re-suggest.

- Wire checker unit-tests (`test-check-claude-md-imports.sh`, `test-check-component-frontmatter.sh`) into `.github/workflows/` (P2)
- Complete DOC-d2d span at `opinion-register.md:231` — add `operator-seam-and-agent-tools.md` (K5)
- Verify/retire `plugins/promode/docs/managing-promode-retirement.md` (dead migration leftover?) and `plans/hierarchical-agent-orientation.md` (orphaned) (K1,K4,K5)
- Bump ⚙ harness pin to 2.1.202; prune ~10 dead local `claude/*` branches + empty `.claude/hooks/` dir (⚙,P5)
- **AAR:** make `plugins/promode/agents/auditor.md` foreground-synchronous-await requirement unmissable — its fan-out stalled 2026-07-07 when the harness returned background child handles (probe P2). Harden against that.
