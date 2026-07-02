#!/usr/bin/env bash
# One command for all repo validation checks (hook-delivery invariants + JSON-manifest
# validity + the inspect-agent transcript walker). Each sibling check owns one invariant
# and exits non-zero on violation; this runner fails if any of them do. Wired into CI as a
# single job (see .github/workflows/hook-output-limits.yml). Requires jq.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fail=0
for check in \
  check-json-valid.sh \
  check-skill-frontmatter.sh \
  check-hook-output-limits.sh \
  check-hook-agent-gating.sh \
  check-hook-chunk-registration.sh \
  check-version-in-context.sh \
  check-inspect-agent.sh
do
  echo "==> $check"
  "$DIR/$check" || fail=1
  echo
done
if [ "$fail" -ne 0 ]; then
  echo "✗ one or more hook-delivery invariants failed"
  exit 1
fi
echo "✓ all hook-delivery invariants pass"
