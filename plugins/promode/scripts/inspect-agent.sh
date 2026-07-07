#!/usr/bin/env bash
# promode — inspect a subagent's transcript compactly, for failure recovery.
#
# A spawned agent's full transcript (the `.output` file whose path arrives in the
# <task-notification>) is large JSONL — reading it whole overflows your context.
# This prints ONE step at a time, compact, so you can walk backwards from the most
# recent step and expand only what you need.
#
# Usage:
#   inspect-agent.sh <output-file>             # the latest step (the "tip")
#   inspect-agent.sh <output-file> <step>      # that step, compact
#   inspect-agent.sh <output-file> <step> full # that step, full JSON (when you need detail)
#
# Steps are 1-indexed transcript lines, chronological; the tip is the latest.
# Every call prints the current tip, so if a *running* agent has advanced past
# where you're walking, you'll see it (and know your view is behind).
set -euo pipefail
file="${1:?usage: inspect-agent.sh <output-file> [step] [full]}"
[ -f "$file" ] || { echo "no such file: $file" >&2; exit 1; }

tip=$(grep -c '' "$file")                 # total steps (lines)
step="${2:-$tip}"
mode="${3:-compact}"

echo "tip=$tip  (latest step; total steps in transcript)"
echo "step=$step"

line=$(sed -n "${step}p" "$file")
[ -n "$line" ] || { echo "(no step $step — out of range)"; exit 0; }

if [ "$mode" = "full" ]; then
  printf '%s' "$line" | jq '.'
  exit 0
fi

printf '%s' "$line" | jq -r '
  .type as $t
  | if $t == "assistant" then
      [ .message.content[]? |
        if   .type=="text"     then "text: "      + ((.text // "") | gsub("\\s+";" ") | .[0:220])
        elif .type=="thinking" then "thinking…"
        elif .type=="tool_use" then "tool_use: "  + .name + " " +
              ((.input.file_path // .input.command // .input.path // (.input|tostring)) | tostring | gsub("\\s+";" ") | .[0:100])
        else .type end
      ] | join("  ·  ")
    elif $t == "user" then
      (.message.content as $c
       | if ($c|type)=="string" then "user: " + ($c | gsub("\\s+";" ") | .[0:220])
         else [ $c[]? |
                 if .type=="tool_result" then "tool_result: " + (if .is_error then "ERROR " else "ok " end) +
                       (((.content | if type=="array" then (.[0].text // "") else (. // "") end)) | tostring | gsub("\\s+";" ") | .[0:160])
                 elif .type=="text" then "user: " + ((.text // "") | gsub("\\s+";" ") | .[0:220])
                 else .type end
               ] | join("  ·  ") end)
    else $t end'
