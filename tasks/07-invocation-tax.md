# Research: can promode cut the per-session skill-description tax? (report-only)

## Brief
- **Orient** — promode ships 7 skills; their frontmatter descriptions (~985 tokens total) load into **every** session's skill list. The mattpocock/skills repo uses a `disable-model-invocation: true` skill frontmatter key so user-invoked skills cost zero context. Promode's own new design goal (root `CLAUDE.md`): optimise for the *current* Claude Code harness, verified via the community changelog and the live harness itself.
- **Specify** — a report (no file changes) answering:
  1. **Does current Claude Code support suppressing a skill's description/model-invocation via frontmatter?** Exact key name + semantics + version introduced. Sources in order: the community-tracked changelog (https://github.com/marckrenn/claude-code-changelog/releases), official docs (https://code.claude.com/docs), and **the live harness** — you are running in it; probe empirically where documentation is silent (e.g. create a scratch skill in a temp/scratchpad directory with the candidate frontmatter and observe whether it's listed/invocable — do NOT modify the promode plugin or any project files).
  2. **Which of promode's 7 skills qualify as user/main-agent-triggered-only?** Assess each: `handoff`, `promode-audit`, `task-docs`, `recovering-subagents`, `discovery-to-determinism`, `design-system-lookbook`, `reinforce-design-constraints`. Caution: several are *model*-invoked by the main agent mid-work (task-docs at planning time, recovering-subagents on failures) — suppressing those would break dispatch. Only skills invoked exclusively by an explicit user request qualify.
  3. **Estimated per-session token savings** for the qualifying set, and any risks (e.g. plugin-skill frontmatter handled differently from project skills; slash-command availability implications).
- **Why** — a signal:noise audit found the description tax is the only always-paid cost in the skills corpus; if the harness supports the lever, it's free savings — but only for skills whose just-in-time triggering we'd never need.
- **Verified vs assumed** — the ~985-token figure is from the 2026-07-06 audit (verified); mattpocock's key name is verified in *his* repo but NOT yet against Claude Code itself — that's the question.
- **Not / exit** — REPORT ONLY: change nothing outside scratch/temp dirs. Exit: findings + a go/no-go recommendation per skill, recorded in the Outcome below and in your final report.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — no file changes; empirical probes in scratch dirs only
- **Established facts** — audit figure; mattpocock usage
- **Pending goals / next step** — research, report, record Outcome

## Outcome
_(research completed 2026-07-06, report-only; no promode files changed)_

### 1. Is the lever supported? **YES — including plugin skills, verified live on v2.1.201**

`disable-model-invocation: true` in SKILL.md frontmatter is an officially documented Claude Code frontmatter field (docs: code.claude.com/docs/en/skills, "Control who invokes a skill"). Documented semantics, all three **empirically confirmed** on the live harness (v2.1.201, scratch project + scratch plugin via `--plugin-dir`):

| Behaviour | Docs | Live probe (2.1.201) |
|---|---|---|
| Description removed from model's skill listing | "Description not in context" | ✅ flagged project **and plugin** skills absent from listing; unflagged present |
| User slash invocation still works | Yes | ✅ `/probe-shut` and `/probeplug:probe-plug-shut` both loaded and ran |
| Model (Skill tool) invocation blocked | Yes | ✅ hard error: `Skill probe-shut cannot be used with Skill tool due to disable-model-invocation` — **even when the user explicitly asked for it in prose** |

Extra semantics from docs/binary: also blocks preloading into subagents via agent `skills:` frontmatter (promode uses none) and, as of v2.1.196, blocks scheduled tasks using the skill as prompt. Internally the flag resolves to listing-state `user-invocable-only` ("hides it from the model but keeps /name").

**Version history (the plugin catch):** the field long worked for user/project skills (first changelog ref: a v2.1.110 fix; `skillOverrides` states landed v2.1.129), but **plugin-source skills ignored it** — issue #22345 (still OPEN), confirmed by binary disassembly at v2.1.138: `if (H.source === "plugin") return "on"` before any flag check. In the **v2.1.201 binary the resolution order changed**: policy → flags → **author `disableModelInvocation` → then** the plugin short-circuit — i.e. the plugin-author frontmatter is now honored (matches the live probe), while *user-level* `skillOverrides` for plugin skills remain ignored ("Plugin skills are managed via /plugin"). No changelog entry announces the fix; it landed somewhere in (2.1.138, 2.1.201].

### 2. Per-skill go/no-go

Decisive fact: the flag blocks **all** Skill-tool invocation — including the main agent acting on a *user's natural-language request* and including **subagents** loading a skill their definition dispatches them to. So any skill reached by dispatch (brief or agent defs) or by NL request is a NO-GO; a flagged skill is reachable **only** by the user literally typing `/promode:<name>`.

| Skill | Desc tokens (~) | Dispatched from | Verdict |
|---|---|---|---|
| `task-docs` | 99 | brief `<planning>` (plan time), subagents recording Outcomes | **NO-GO** (hard) |
| `recovering-subagents` | 96 | brief (recovery), `agent-analyzer` def | **NO-GO** (hard) |
| `discovery-to-determinism` | 175 | brief `<test-strategy>`; senior-engineer, verifier, fast-worker, product-design-expert defs | **NO-GO** (hard) |
| `design-system-lookbook` | 124 | brief; product-design-expert def (×3) | **NO-GO** (hard) |
| `promode-audit` | 136 | brief `<promode-audit>` ("use the promode-audit skill") — main agent invokes on user's NL request | **NO-GO** as-is (flag would break the brief's own dispatch) |
| `reinforce-design-constraints` | 133 | `promode-audit` SKILL.md recommends it as the write action for its highest-severity finding; own description has a model-noticed trigger ("an agent violated a rule") | **NO-GO** (soft — flagging breaks audit follow-through) |
| `handoff` | 79 | **nothing** — zero refs in brief or agent defs | **Conditional GO** — the only candidate |

Even `handoff` has a real regression: its own triggers ("context is filling up", user *says* "hand off" in prose) route through model invocation and would die; only a literally-typed `/promode:handoff` would work.

### 3. Estimated savings

Whole tax: ~3,380 desc chars + listing overhead ≈ **~900 tokens/session** (audit's ~985 same ballpark). Qualifying set under the strict criterion = `handoff` only: **~85 tokens/session (~9% of the tax)**. Adding `reinforce-design-constraints` against advice: ~230 (~23%). Note the listing is also injected into subagent contexts, so real savings ≈ 85 × (1 + subagent spawns) — still small against promode's orchestration-heavy token profile.

### 4. Risks

1. **NL-trigger loss** (verified): flagged skills become slash-typed-only; the model hard-errors even on explicit user request relayed in prose.
2. **Version skew** (fail-safe in our favour): users on ≤ ~2.1.138 simply get no savings (flag ignored for plugin skills, behaviour unchanged); on current versions the flag is fully enforced — so dispatch breakage, not savings, is the thing to guard.
3. **Users can't undo it**: project/user `skillOverrides` never reach plugin-source skills (binary-confirmed); only enterprise policy/flag settings resolve before the author flag. Flagging is a plugin-author one-way door per release.
4. **No middle lever for plugins**: `name-only` (keep name, drop description) exists only as a `skillOverrides` settings state — ignored for plugin skills; there is no frontmatter equivalent.
5. Stale-looking open bugs (#20816 resume, #26251 slash) — both contradicted by the live 2.1.201 probes; treat as fixed.

### 5. Recommendation

**Don't flag anything yet.** Six of seven skills are load-bearing dispatch targets (NO-GO), and the single qualifying skill (`handoff`) buys ~85 tokens at the cost of its most valuable trigger — proactive handoff under context pressure. If the description tax needs cutting, the higher-leverage, zero-risk lever is **tightening the description strings themselves** (e.g. `discovery-to-determinism` at 703 chars) — same savings order, no invocation semantics touched. Re-evaluate if Claude Code ships a frontmatter `name-only` equivalent for plugin skills (watch #22345, still open for the `skillOverrides` half).
