#!/usr/bin/env bash
# Guardrail: the chunked brief must be FULLY registered. The brief is split at
# `<!-- CHUNK -->` marker lines in PROMODE_MAIN_AGENT.md into N = (markers + 1) chunks,
# and hooks.json must register the delivery hook once per chunk (arg = 1..N) in EVERY
# matcher that delivers the brief. If a marker is added but the new chunk isn't
# registered, the tail is silently dropped on delivery — and the size guardrail still
# passes, because each individually-registered chunk is under-cap. This check closes that
# blind spot. Requires jq. Exit 1 on violation.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_ROOT="$REPO/plugins/promode"
HOOKS="$PLUGIN_ROOT/hooks/hooks.json"
BRIEF="$PLUGIN_ROOT/PROMODE_MAIN_AGENT.md"
fail=0

[ -f "$HOOKS" ] || { echo "no hooks.json — nothing to check ($HOOKS)"; exit 0; }
[ -f "$BRIEF" ] || { echo "no brief — nothing to check ($BRIEF)"; exit 0; }

markers=$(grep -c '^[[:space:]]*<!-- CHUNK -->[[:space:]]*$' "$BRIEF")
expected=$((markers + 1))
echo "brief has $markers chunk marker(s) -> expects chunks 1..$expected"

# For each matcher group, collect the chunk-number args registered for the brief hook.
# A "brief hook" entry is one whose args include the brief path; its chunk number is the
# trailing numeric arg. Emit one "<matcher>\t<chunk>" line per registered chunk.
while IFS=$'\t' read -r matcher chunk; do
  [ -n "$matcher" ] || continue
  printf '%s\t%s\n' "$matcher" "$chunk"
done < <(jq -r --arg brief "PROMODE_MAIN_AGENT.md" '
  .hooks.SessionStart[]? as $m
  | $m.hooks[]?
  | select(.type == "command")
  | select(any(.args[]?; type == "string" and contains($brief)))
  | ($m.matcher // "<none>") as $name
  | ([.args[]? | select(test("^[0-9]+$"))] | last) as $chunk
  | [$name, ($chunk // "")] | @tsv
' "$HOOKS") > /tmp/chunk-reg.$$ 2>/dev/null
# group per matcher
matchers=$(cut -f1 /tmp/chunk-reg.$$ | sort -u)
[ -n "$matchers" ] || { echo "FAIL  no brief-delivery hooks found in hooks.json"; rm -f /tmp/chunk-reg.$$; exit 1; }

for m in $matchers; do
  got=$(awk -F'\t' -v M="$m" '$1==M{print $2}' /tmp/chunk-reg.$$ | sort -n | tr '\n' ' ' | sed 's/ $//')
  highest=$(awk -F'\t' -v M="$m" '$1==M{print $2}' /tmp/chunk-reg.$$ | sort -n | tail -1)
  # build the expected sequence
  want=$(seq 1 "$expected" | tr '\n' ' ' | sed 's/ $//')
  if [ "$got" = "$want" ]; then
    printf 'ok    %-10s registers chunks: %s\n' "$m" "$got"
  else
    printf 'FAIL  %-10s registers chunks: [%s]  expected: [%s]  (highest=%s, want=%s)\n' \
      "$m" "$got" "$want" "${highest:-none}" "$expected"; fail=1
  fi
done
rm -f /tmp/chunk-reg.$$

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ chunk registration incomplete — part of the brief will be silently dropped on delivery."
  echo "  Fix: register the delivery hook for every chunk 1..$expected in each matcher in hooks.json,"
  echo "  or adjust the <!-- CHUNK --> markers in PROMODE_MAIN_AGENT.md to match."
  exit 1
fi
echo "✓ all matchers register every chunk 1..$expected"
