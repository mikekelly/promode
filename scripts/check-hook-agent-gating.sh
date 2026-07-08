#!/usr/bin/env bash
# Guardrail: the main-agent brief must reach the MAIN agent only, never a subagent.
# The delivery hook (plugins/promode/hooks/promode-main-context.sh) distinguishes the
# two by stdin: Claude Code includes an "agent_id" field on a SUBAGENT hook call, and
# omits it for the main agent. The hook exits silently when it sees "agent_id".
#
# This invariant ("the brief never reaches subagents") is otherwise unproven. We assert
# both directions against the real hook:
#   - stdin WITH "agent_id"    -> empty output (brief withheld)
#   - stdin WITHOUT "agent_id" -> non-empty brief output
#
# SCOPE: only BRIEF-DELIVERY hooks (those whose args reference PROMODE_MAIN_AGENT.md),
# mirroring check-hook-chunk-registration.sh. Other command hooks (e.g. the Stop
# context-monitor) do not deliver the brief and are legitimately silent on a synthetic
# no-transcript main stdin — the brief-delivery contract does not apply to them. Their
# own main-only gating is structural (the context-monitor is Stop-only-registered; Stop
# fires for the main agent only, subagents fire SubagentStop). Requires jq. Exit 1 on
# violation.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_ROOT="$REPO/plugins/promode"
HOOKS="$PLUGIN_ROOT/hooks/hooks.json"
MAIN_STDIN='{"source":"startup","hook_event_name":"SessionStart"}'
SUB_STDIN='{"source":"startup","hook_event_name":"SessionStart","agent_id":"abc123"}'
fail=0; checked=0

[ -f "$HOOKS" ] || { echo "no hooks.json — nothing to check ($HOOKS)"; exit 0; }

run_hook() {  # $1=stdin  rest=cmd+args ; echoes char count of stdout
  local stdin="$1"; shift
  printf '%s' "$stdin" | CLAUDE_PLUGIN_ROOT="$PLUGIN_ROOT" "$@" 2>/dev/null | wc -m | tr -d ' '
}

while IFS=$'\t' read -r event command argsjson; do
  cmd="${command//\$\{CLAUDE_PLUGIN_ROOT\}/$PLUGIN_ROOT}"
  args=()
  while IFS= read -r a; do args+=("${a//\$\{CLAUDE_PLUGIN_ROOT\}/$PLUGIN_ROOT}"); done \
    < <(printf '%s' "$argsjson" | jq -r '.[]?')
  checked=$((checked + 1))
  label="$event ${args[*]:-}"

  sub_len="$(run_hook "$SUB_STDIN" "$cmd" "${args[@]}")"
  main_len="$(run_hook "$MAIN_STDIN" "$cmd" "${args[@]}")"

  if [ "${sub_len:-0}" -ne 0 ]; then
    printf 'FAIL  subagent  %-28s emitted %s chars (brief leaked to subagent)\n' "$label" "$sub_len"; fail=1
  else
    printf 'ok    subagent  %-28s withheld\n' "$label"
  fi
  if [ "${main_len:-0}" -le 0 ]; then
    printf 'FAIL  main      %-28s emitted nothing (brief not delivered)\n' "$label"; fail=1
  else
    printf 'ok    main      %-28s delivered %s chars\n' "$label" "$main_len"
  fi
done < <(jq -r '
  .hooks | to_entries[] as $e | $e.value[]? as $entry | $entry.hooks[]?
  | select(.type == "command")
  | select(any(.args[]?; type == "string" and contains("PROMODE_MAIN_AGENT.md")))
  | [$e.key, .command, ((.args // []) | @json)] | @tsv
' "$HOOKS" | sort -u)

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ agent_id gating broken — the main-agent brief is not isolated to the main agent."
  exit 1
fi
echo "✓ all ${checked} hook(s): brief withheld from subagents, delivered to main agent"
