#!/usr/bin/env bash
# Bump the promode plugin version. The version lives in ONE place:
# plugins/promode/.claude-plugin/plugin.json. (marketplace.json carries no version,
# so there is nothing to keep in sync.) See runbooks/cut-a-release.md for the full
# procedure — this script only edits the file; you stage/commit/push the bump alongside
# the change it ships with.
#
# Usage: scripts/bump-version.sh <new-version>
#   e.g. scripts/bump-version.sh 2.11.0
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_JSON="$REPO/plugins/promode/.claude-plugin/plugin.json"

new="${1:-}"
if [ -z "$new" ]; then
  echo "usage: $0 <new-version>   (e.g. 2.11.0)" >&2
  exit 2
fi
if ! printf '%s' "$new" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "✗ '$new' is not a semver x.y.z" >&2
  exit 2
fi

old="$(grep -E '"version"' "$PLUGIN_JSON" | head -1 | sed -E 's/.*"version": *"([^"]+)".*/\1/')"
if [ "$old" = "$new" ]; then
  echo "version is already $new; nothing to do"
  exit 0
fi

# Replace the version line in place (portable across BSD/GNU sed via a tmp file).
tmp="$(mktemp)"
sed -E "s/(\"version\": *\")[^\"]+(\")/\1$new\2/" "$PLUGIN_JSON" > "$tmp"
mv "$tmp" "$PLUGIN_JSON"

echo "✓ bumped version: $old -> $new"
echo "  edited: plugins/promode/.claude-plugin/plugin.json"
echo "  next: commit this alongside the change it ships (see runbooks/cut-a-release.md), then push"
