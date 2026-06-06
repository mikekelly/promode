#!/usr/bin/env bash
# promode — deliver the main-agent orchestration brief to the MAIN agent only.
#
# Shipped by the promode plugin (registered in plugins/promode/hooks/hooks.json as a
# SessionStart hook), so it fires in every session where promode is enabled — no
# per-project install, and a plugin update delivers the new brief automatically (read
# from the plugin's own install dir, never copied into the project).
#
# Injects PROMODE_MAIN_AGENT.md as additionalContext for the MAIN agent only: subagent
# hook calls carry an "agent_id" field on stdin, so the brief never reaches subagents.
# Also emits a `systemMessage` notice (chunk 1 only) so the user sees "promode vX.Y.Z
# active in this session". Registered for the startup|resume|clear|compact sources.
# Requires jq.
#
# CHUNKING: a hook output string is capped at 10,000 chars by Claude Code (it silently
# truncates anything larger to a preview, dropping the tail). The brief is split at
# `<!-- CHUNK -->` marker lines into self-contained parts; hooks.json registers this hook
# once per part, and Claude merges the parts (parallel, unspecified order — so each part
# must be whole sections). The leading maintainer comment is stripped before delivery so
# it costs no budget.
#
# Args: $1 = brief path (passed via ${CLAUDE_PLUGIN_ROOT}); $2 = 1-based chunk number
# (emit the whole brief if unset). Falls back to a path relative to this script.
input=$(cat)
if printf '%s' "$input" | grep -q '"agent_id"'; then
  exit 0
fi
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
brief="${1:-}"
[ -f "$brief" ] || brief="$root/PROMODE_MAIN_AGENT.md"
[ -f "$brief" ] || exit 0
chunk="${2:-}"

# Select the requested chunk (drop the marker lines), then strip the leading maintainer
# comment and any leading blank lines.
content="$(awk -v want="$chunk" '
    BEGIN { seg = 1 }
    /^[[:space:]]*<!-- CHUNK -->[[:space:]]*$/ { seg++; next }
    want == "" { print; next }
    seg == want + 0 { print }
  ' "$brief" | sed '/^<!--/,/-->/d' | awk 'NF { p = 1 } p')"
[ -n "$content" ] || exit 0

if [ "$chunk" = "1" ] || [ -z "$chunk" ]; then
  ver=$(jq -r '.version // empty' "$root/.claude-plugin/plugin.json" 2>/dev/null)
  msg="promode${ver:+ v$ver} active in this session"
  printf '%s' "$content" | jq -Rs --arg msg "$msg" '{systemMessage:$msg, hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:.}}'
else
  printf '%s' "$content" | jq -Rs '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:.}}'
fi
exit 0
