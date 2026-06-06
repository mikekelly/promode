#!/usr/bin/env bash
# Guardrail: every capped output string a promode hook can emit
# (additionalContext, systemMessage, plain stdout) must stay under Claude Code's
# 10,000-character hook-output cap. Over the cap, Claude Code replaces the output
# with a truncated preview + file path, silently dropping the tail — e.g. the
# back third of the main-agent brief. See https://code.claude.com/docs/en/hooks
# ("Hook output strings ... are capped at 10,000 characters").
#
# Runs each registered command-hook on the main-agent SessionStart path and fails
# fast if any capped field exceeds the limit, so this can't recur inadvertently
# when the brief (or any hook output) grows. Requires jq. Exit 1 on violation.
set -uo pipefail
CAP=10000
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_ROOT="$REPO/plugins/promode"
HOOKS="$PLUGIN_ROOT/hooks/hooks.json"
STDIN='{"source":"startup","hook_event_name":"SessionStart"}'   # main agent (no agent_id)
fail=0; checked=0

[ -f "$HOOKS" ] || { echo "no hooks.json — nothing to check ($HOOKS)"; exit 0; }

while IFS=$'\t' read -r event command argsjson; do
  cmd="${command//\$\{CLAUDE_PLUGIN_ROOT\}/$PLUGIN_ROOT}"
  args=()
  while IFS= read -r a; do args+=("${a//\$\{CLAUDE_PLUGIN_ROOT\}/$PLUGIN_ROOT}"); done \
    < <(printf '%s' "$argsjson" | jq -r '.[]?')
  out="$(printf '%s' "$STDIN" | CLAUDE_PLUGIN_ROOT="$PLUGIN_ROOT" "$cmd" "${args[@]}" 2>/dev/null)"
  checked=$((checked + 1))
  if printf '%s' "$out" | jq -e . >/dev/null 2>&1; then
    ac=$(printf '%s' "$out" | jq -r '(.hookSpecificOutput.additionalContext // "") | length')
    sm=$(printf '%s' "$out" | jq -r '(.systemMessage // "") | length')
  else
    ac=$(printf '%s' "$out" | wc -m | tr -d ' '); sm=0
  fi
  for pair in "additionalContext=$ac" "systemMessage=$sm"; do
    name="${pair%%=*}"; n="${pair##*=}"
    [ "${n:-0}" -gt 0 ] || continue
    if [ "$n" -gt "$CAP" ]; then
      printf 'FAIL  %-12s %-17s %6s chars  (> %s)\n' "$event" "$name" "$n" "$CAP"; fail=1
    else
      printf 'ok    %-12s %-17s %6s chars\n' "$event" "$name" "$n"
    fi
  done
done < <(jq -r '
  .hooks | to_entries[] as $e | $e.value[]? as $entry | $entry.hooks[]?
  | select(.type == "command") | [$e.key, .command, ((.args // []) | @json)] | @tsv
' "$HOOKS" | sort -u)

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ hook output exceeds the ${CAP}-char cap — Claude Code will truncate it to a preview. Trim the source."
  exit 1
fi
echo "✓ all ${checked} hook output(s) within the ${CAP}-char cap"
