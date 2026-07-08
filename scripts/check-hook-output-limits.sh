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
#
# The CAP applies to EVERY command hook. The non-empty-additionalContext rule
# applies ONLY to BRIEF-DELIVERY hooks (args reference PROMODE_MAIN_AGENT.md):
# other hooks (e.g. the Stop context-monitor) are legitimately silent on a
# synthetic no-transcript stdin, so empty output from them is not a failure.
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
  is_brief=0
  printf '%s' "$argsjson" | grep -q 'PROMODE_MAIN_AGENT.md' && is_brief=1
  if printf '%s' "$out" | jq -e . >/dev/null 2>&1; then
    ac=$(printf '%s' "$out" | jq -r '(.hookSpecificOutput.additionalContext // "") | length')
    sm=$(printf '%s' "$out" | jq -r '(.systemMessage // "") | length')
  else
    ac=$(printf '%s' "$out" | wc -m | tr -d ' '); sm=0
  fi
  for pair in "additionalContext=$ac" "systemMessage=$sm"; do
    name="${pair%%=*}"; n="${pair##*=}"
    # A 0-char additionalContext is a FAILURE, not a skip: the brief-delivery output must
    # be non-empty. A missing brief file or an out-of-range chunk arg degrades silently to
    # empty output, which would otherwise pass unnoticed. The systemMessage is legitimately
    # absent on every chunk but the first, so empty there is fine — only enforce non-empty
    # on additionalContext (the brief payload).
    if [ "${n:-0}" -le 0 ]; then
      if [ "$name" = "additionalContext" ] && [ "$is_brief" = 1 ]; then
        printf 'FAIL  %-12s %-17s %6s chars  (empty brief output — missing file or out-of-range chunk?)\n' "$event" "$name" "${n:-0}"; fail=1
      fi
      continue
    fi
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
  echo "✗ hook output invalid — either it exceeds the ${CAP}-char cap (Claude Code truncates"
  echo "  it to a preview; trim the source) or a brief-delivery output came back empty"
  echo "  (missing file / out-of-range chunk; the brief would be silently dropped)."
  exit 1
fi
echo "✓ all ${checked} hook output(s) non-empty and within the ${CAP}-char cap"
