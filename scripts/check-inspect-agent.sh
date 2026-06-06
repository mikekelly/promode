#!/usr/bin/env bash
# Guardrail: inspect-agent.sh (the recovering-subagents transcript walker) must keep
# working — it's jq-heavy and otherwise untested, so a stray edit to its jq program could
# break compact rendering silently. This smoke test runs it against a small committed
# fixture transcript and asserts it exits 0 and renders the expected content for the
# transcript's representative line types (assistant text/tool_use/thinking, user
# tool_result) across its compact, step, and full modes. Requires jq. Exit 1 on violation.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$REPO/plugins/promode/skills/recovering-subagents/scripts/inspect-agent.sh"
FIXTURE="$REPO/plugins/promode/skills/recovering-subagents/scripts/test-fixtures/sample-transcript.jsonl"
fail=0

[ -f "$SCRIPT" ]  || { echo "FAIL  missing script: $SCRIPT"; exit 1; }
[ -f "$FIXTURE" ] || { echo "FAIL  missing fixture: $FIXTURE"; exit 1; }

assert() {  # $1=label  $2=expected-substring  $3...=cmd
  local label="$1" needle="$2"; shift 2
  local out rc
  out="$("$@" 2>/dev/null)"; rc=$?
  if [ "$rc" -ne 0 ]; then
    printf 'FAIL  %-22s exited %s (expected 0)\n' "$label" "$rc"; fail=1; return
  fi
  if [ -z "$out" ]; then
    printf 'FAIL  %-22s produced empty output\n' "$label"; fail=1; return
  fi
  if ! printf '%s' "$out" | grep -qF "$needle"; then
    printf 'FAIL  %-22s missing expected text: %s\n' "$label" "$needle"; fail=1; return
  fi
  printf 'ok    %-22s exit 0, output contains "%s"\n' "$label" "$needle"
}

# tip view (no step arg) -> renders the latest line; fixture has 3 steps.
assert "tip view"      "tip=3"                       bash "$SCRIPT" "$FIXTURE"
# step 1: assistant text + tool_use rendered compactly.
assert "step1 tool_use" "tool_use: Bash"             bash "$SCRIPT" "$FIXTURE" 1
# step 2: user tool_result rendered compactly.
assert "step2 tool_result" "tool_result: ok"         bash "$SCRIPT" "$FIXTURE" 2
# step 3: assistant thinking rendered compactly.
assert "step3 thinking" "thinking…"                  bash "$SCRIPT" "$FIXTURE" 3
# full mode: emits the raw JSON object for the step.
assert "full mode JSON" "\"type\": \"user\""         bash "$SCRIPT" "$FIXTURE" 2 full

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ inspect-agent.sh smoke test failed — the transcript walker is broken."
  exit 1
fi
echo "✓ inspect-agent.sh renders all fixture line types and modes correctly"
