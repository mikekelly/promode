#!/usr/bin/env bash
# The main agent must be able to answer "what promode version is running": chunk 1's
# additionalContext (model-visible — unlike systemMessage, which only the user sees) must
# carry "Promode v<version>" matching plugin.json. Guards against the banner regressing to
# user-visible-only, or drifting from the real version.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN="$(cd "$DIR/../plugins/promode" && pwd)"

ver=$(jq -r '.version // empty' "$PLUGIN/.claude-plugin/plugin.json")
if [ -z "$ver" ]; then
  echo "✗ no version in plugin.json"
  exit 1
fi

ctx=$(printf '{"source":"startup"}' \
  | bash "$PLUGIN/hooks/promode-main-context.sh" "$PLUGIN/PROMODE_MAIN_AGENT.md" 1 \
  | jq -r '.hookSpecificOutput.additionalContext // empty')

if printf '%s' "$ctx" | grep -qF "Promode v$ver"; then
  echo "ok    chunk 1 additionalContext carries \"Promode v$ver\""
  echo
  echo "✓ version banner is model-visible and matches plugin.json"
else
  echo "✗ chunk 1 additionalContext does not contain \"Promode v$ver\" (model can't answer its promode version)"
  exit 1
fi
