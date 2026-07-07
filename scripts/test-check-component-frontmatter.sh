#!/usr/bin/env bash
# Test harness for check-component-frontmatter.sh. Self-contained: builds deliberately-broken
# agent/command/skill fixtures in a temp dir, points the check at them (via AGENTS_DIR /
# COMMANDS_DIR / SKILLS_DIR overrides), and asserts the check FAILS on each kind of breakage —
# then asserts it passes on valid fixtures and on the real tree. Crucially it also asserts the
# check does NOT fail when commands/ or skills/ is absent (pre- vs post-skills-migration trees
# both occur; CI runs on the merged result). Run directly; exits non-zero if any expectation
# is unmet.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$DIR/.." && pwd)"
CHECK="$DIR/check-component-frontmatter.sh"

fail=0
tmproot="$(mktemp -d)"
trap 'rm -rf "$tmproot"' EXIT

# A minimal valid agents dir every case reuses (the check requires >=1 agent def).
VALID_AGENTS="$tmproot/_valid_agents"
mkdir -p "$VALID_AGENTS"
printf '%s' $'---\nname: good-agent\ndescription: A perfectly valid agent.\nmodel: sonnet\n---\n\nBody.\n' > "$VALID_AGENTS/good-agent.md"

# run_check <agents-dir> <commands-dir> <skills-dir>
# Empty string for commands/skills dir means "point at a nonexistent path" (absence case).
run_check() {
  local agents="$1" commands="$2" skills="$3"
  AGENTS_DIR="${agents:-$tmproot/_absent}" \
  COMMANDS_DIR="${commands:-$tmproot/_absent}" \
  SKILLS_DIR="${skills:-$tmproot/_absent}" \
  "$CHECK" >/dev/null 2>&1
}

expect_fail() { # <label> <agents-dir> <commands-dir> <skills-dir>
  local label="$1"
  if run_check "$2" "$3" "$4"; then
    printf 'FAIL  expected breakage to be flagged: %s\n' "$label"; fail=1
  else
    printf 'ok    flagged: %s\n' "$label"
  fi
}

expect_pass() { # <label> <agents-dir> <commands-dir> <skills-dir>
  local label="$1"
  if run_check "$2" "$3" "$4"; then
    printf 'ok    passed: %s\n' "$label"
  else
    printf 'FAIL  expected to pass: %s\n' "$label"; fail=1
  fi
}

# make_agents <case> <filename-sans-md> <body>  — echoes the agents dir
make_agents() {
  local case="$1" fname="$2" body="$3"
  local d="$tmproot/agents-$case"
  mkdir -p "$d"
  printf '%s' "$body" > "$d/$fname.md"
  echo "$d"
}

# make_commands <case> <filename-sans-md> <body>  — echoes the commands dir
make_commands() {
  local case="$1" fname="$2" body="$3"
  local d="$tmproot/commands-$case"
  mkdir -p "$d"
  printf '%s' "$body" > "$d/$fname.md"
  echo "$d"
}

# make_skills <case> <skillname> <body>  — echoes the skills dir
make_skills() {
  local case="$1" skillname="$2" body="$3"
  local d="$tmproot/skills-$case"
  mkdir -p "$d/$skillname"
  printf '%s' "$body" > "$d/$skillname/SKILL.md"
  echo "$d"
}

# ---------- agents ----------

# valid baseline: agents only, commands/ and skills/ both ABSENT (post-migration shape,
# and the regression this harness exists to pin: absence must not fail the check).
expect_pass "valid agent; commands/ and skills/ absent" "$VALID_AGENTS" "" ""

d=$(make_agents nofm bad-agent $'# Just a heading\n\nNo frontmatter here.\n')
expect_fail "agent: no frontmatter block" "$d" "" ""

d=$(make_agents notline1 bad-agent $'\n---\nname: bad-agent\ndescription: x\n---\n')
expect_fail "agent: opening delimiter not on line 1" "$d" "" ""

d=$(make_agents noclose bad-agent $'---\nname: bad-agent\ndescription: x\n\nbody with no closing fence\n')
expect_fail "agent: missing closing delimiter" "$d" "" ""

d=$(make_agents badyaml bad-agent $'---\nname: bad-agent\n  description: : : not: valid\n\tbad tab indent\n---\n')
expect_fail "agent: malformed YAML" "$d" "" ""

d=$(make_agents emptydesc bad-agent $'---\nname: bad-agent\ndescription: ""\n---\n')
expect_fail "agent: empty description" "$d" "" ""

d=$(make_agents nodesc bad-agent $'---\nname: bad-agent\n---\n')
expect_fail "agent: missing description" "$d" "" ""

d=$(make_agents emptyname bad-agent $'---\nname: ""\ndescription: something\n---\n')
expect_fail "agent: empty name" "$d" "" ""

d=$(make_agents noname bad-agent $'---\ndescription: something\n---\n')
expect_fail "agent: missing name" "$d" "" ""

d=$(make_agents mismatch the-file-name $'---\nname: a-different-name\ndescription: something\n---\n')
expect_fail "agent: name != filename" "$d" "" ""

d=$(make_agents emptymodel bad-agent $'---\nname: bad-agent\ndescription: something\nmodel:\n---\n')
expect_fail "agent: model key present but empty" "$d" "" ""

d=$(make_agents nomodel ok-agent $'---\nname: ok-agent\ndescription: model is optional, only checked when pinned.\n---\n')
expect_pass "agent: no model key (model is optional)" "$d" "" ""

# zero agent defs is always a breakage (the plugin ships agents; an empty glob means
# a wrong path or a botched migration)
d="$tmproot/agents-empty"; mkdir -p "$d"
expect_fail "agent: no agent defs found" "$d" "" ""

# ---------- commands ----------

d=$(make_commands valid good-command $'---\ndescription: A perfectly valid command.\n---\n\nDo the flow.\n')
expect_pass "command: valid (description only, no name key)" "$VALID_AGENTS" "$d" ""

d=$(make_commands named good-command $'---\nname: good-command\ndescription: Valid, with matching name.\n---\n\nBody.\n')
expect_pass "command: valid with matching name key" "$VALID_AGENTS" "$d" ""

d=$(make_commands nofm bad-command $'Just a body, no frontmatter.\n')
expect_fail "command: no frontmatter block" "$VALID_AGENTS" "$d" ""

d=$(make_commands noclose bad-command $'---\ndescription: x\n\nno closing fence\n')
expect_fail "command: missing closing delimiter" "$VALID_AGENTS" "$d" ""

d=$(make_commands badyaml bad-command $'---\ndescription: x\n\tbad tab\n---\n')
expect_fail "command: malformed YAML" "$VALID_AGENTS" "$d" ""

d=$(make_commands emptydesc bad-command $'---\ndescription: ""\n---\n')
expect_fail "command: empty description" "$VALID_AGENTS" "$d" ""

d=$(make_commands nodesc bad-command $'---\nargument-hint: "[topic]"\n---\n')
expect_fail "command: missing description" "$VALID_AGENTS" "$d" ""

d=$(make_commands mismatch the-file-name $'---\nname: a-different-name\ndescription: something\n---\n')
expect_fail "command: name key != filename" "$VALID_AGENTS" "$d" ""

# commands dir exists but holds no .md files → wrong path / botched migration
d="$tmproot/commands-empty"; mkdir -p "$d"
expect_fail "command: dir present but empty" "$VALID_AGENTS" "$d" ""

# ---------- skills (legacy: validated while present, skipped once deleted) ----------

d=$(make_skills valid good-skill $'---\nname: good-skill\ndescription: A perfectly valid description.\n---\n\nBody.\n')
expect_pass "skill: valid SKILL.md while skills/ still present" "$VALID_AGENTS" "" "$d"

d=$(make_skills mismatch the-dir-name $'---\nname: a-different-name\ndescription: something\n---\n')
expect_fail "skill: name != directory" "$VALID_AGENTS" "" "$d"

d=$(make_skills nodesc bad-skill $'---\nname: bad-skill\n---\n')
expect_fail "skill: missing description" "$VALID_AGENTS" "" "$d"

# skills dir exists but holds no SKILL.md → wrong path, not a clean deletion
d="$tmproot/skills-empty"; mkdir -p "$d"
expect_fail "skill: dir present but no SKILL.md files" "$VALID_AGENTS" "" "$d"

# ---------- real tree ----------
# Defaults must pass on this repo whatever migration state it is in (pre: agents+skills,
# no commands; post: agents+commands, no skills).
if "$CHECK" >/dev/null 2>&1; then
  printf 'ok    passed: real tree with default dirs\n'
else
  printf 'FAIL  expected to pass: real tree with default dirs\n'; fail=1
fi

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ check-component-frontmatter.sh did not behave as specified"
  exit 1
fi
echo "✓ check-component-frontmatter.sh behaves correctly on all fixtures"
