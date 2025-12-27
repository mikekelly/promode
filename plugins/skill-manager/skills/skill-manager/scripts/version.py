#!/usr/bin/env python3
"""Get the version (git SHA) of an installed Claude Code skill."""

import argparse
import sys

from utils import (
    find_skill,
    get_short_sha,
    get_remote_url,
)


def show_version(skill_name: str):
    """Show the version of an installed skill."""
    skill_path = find_skill(skill_name)

    if not skill_path:
        print(f"Skill '{skill_name}' not found in user or project skills.", file=sys.stderr)
        sys.exit(1)

    sha = get_short_sha(skill_path)
    url = get_remote_url(skill_path)

    if sha:
        print(f"{skill_name}: {sha}")
        if url:
            print(f"  Source: {url}")
        print(f"  Location: {skill_path}")
    else:
        print(f"{skill_name}: unknown version (not a git repository)", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Get the version (git SHA) of an installed Claude Code skill"
    )
    parser.add_argument(
        "skill",
        help="Name of the skill to check"
    )

    args = parser.parse_args()
    show_version(args.skill)


if __name__ == "__main__":
    main()
