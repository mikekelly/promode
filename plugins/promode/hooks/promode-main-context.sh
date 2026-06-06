#!/usr/bin/env bash
# promode — deliver the main-agent orchestration brief to the MAIN agent only.
#
# Shipped by the promode plugin and registered as a SessionStart hook in
# plugins/promode/hooks/hooks.json, so it fires in every session where promode
# is enabled — no per-project install, and a plugin update delivers the new
# brief automatically (the brief is read from the plugin's own install dir,
# never copied into the project).
#
# Injects PROMODE_MAIN_AGENT.md as additionalContext (model-facing), and also
# emits a short `systemMessage` so the USER sees a "promode vX.Y.Z active in
# this session" line in the UI confirming the hook ran and which version is
# loaded — but ONLY
# for the main agent: subagent hook calls carry an "agent_id" field on stdin,
# so neither the brief nor the notice reaches subagents. Registered for the
# startup|resume|clear|compact sources so it survives /clear and /compact.
# Requires jq.
#
# $1 = absolute path to the brief (passed from hooks.json via
# ${CLAUDE_PLUGIN_ROOT}); falls back to a path relative to this script.
input=$(cat)
if printf '%s' "$input" | grep -q '"agent_id"'; then
  exit 0
fi
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
brief="${1:-}"
[ -f "$brief" ] || brief="$root/skills/managing-promode/standard/PROMODE_MAIN_AGENT.md"
[ -f "$brief" ] || exit 0
ver=$(jq -r '.version // empty' "$root/.claude-plugin/plugin.json" 2>/dev/null)
msg="promode${ver:+ v$ver} active in this session"
jq -Rs --arg msg "$msg" '{systemMessage:$msg, hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:.}}' < "$brief"
exit 0
