#!/usr/bin/env bash
# promode — deliver the main-agent orchestration brief to the MAIN agent only.
#
# Installed at <project>/.claude/hooks/ and registered as a SessionStart hook
# (matchers: startup|resume|clear|compact) in <project>/.claude/settings.json.
# Reads <project>/.claude/PROMODE_MAIN_AGENT.md and injects it as additional
# context — but ONLY for the main agent. Subagent invocations include an
# "agent_id" field on stdin, so the brief never leaks into subagent context.
# Re-fires on clear/compact, so the brief survives both.
input=$(cat)
if printf '%s' "$input" | grep -q '"agent_id"'; then
  exit 0
fi
brief="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/PROMODE_MAIN_AGENT.md"
[ -f "$brief" ] || exit 0
jq -Rs '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:.}}' < "$brief"
exit 0
