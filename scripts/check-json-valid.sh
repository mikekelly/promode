#!/usr/bin/env bash
# Guardrail: every JSON manifest the plugin ships must be well-formed. A typo in any of
# these silently breaks plugin loading / hook registration / marketplace discovery, and
# none of the other checks parse them as a whole — so a stray comma here is invisible
# until it bites at runtime. This is cheap regression insurance: `jq -e .` on each file.
# Requires jq. Exit 1 on violation.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0; checked=0

manifests=(
  "$REPO/plugins/promode/hooks/hooks.json"
  "$REPO/plugins/promode/.claude-plugin/plugin.json"
  "$REPO/.claude-plugin/marketplace.json"
)

for f in "${manifests[@]}"; do
  if [ ! -f "$f" ]; then
    printf 'FAIL  missing       %s\n' "$f"; fail=1; continue
  fi
  checked=$((checked + 1))
  if jq -e . "$f" >/dev/null 2>&1; then
    printf 'ok    valid JSON     %s\n' "$f"
  else
    printf 'FAIL  invalid JSON   %s\n' "$f"; fail=1
  fi
done

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ one or more JSON manifests are malformed or missing — plugin loading will break."
  exit 1
fi
echo "✓ all ${checked} JSON manifest(s) are well-formed"
