#!/usr/bin/env python3
"""Update installed Claude Code skills."""

import argparse
import sys
from pathlib import Path

from utils import (
    USER_SKILLS_DIR,
    PROJECT_SKILLS_DIR,
    run_git,
    is_skills_dir_a_repo,
    find_skill,
)


def update_skill(skill_name: str, skills_dir: Path):
    """Update an installed skill."""
    skill_path = skills_dir / skill_name

    if not skill_path.exists():
        print(f"Skill '{skill_name}' is not installed.", file=sys.stderr)
        sys.exit(1)

    print(f"Updating {skill_name}...")

    if is_skills_dir_a_repo(skills_dir):
        # Update submodule
        result = run_git(["submodule", "update", "--remote", "--merge", skill_name], cwd=skills_dir)
    else:
        # Regular pull
        result = run_git(["pull", "--ff-only"], cwd=skill_path)

    if result.returncode != 0:
        sys.exit(1)

    if "Already up to date" in result.stdout or "Already up-to-date" in result.stdout:
        print(f"{skill_name} is already up to date")
    else:
        print(f"Successfully updated {skill_name}")


def update_all_in_dir(skills_dir: Path, label: str):
    """Update all skills in a directory."""
    if not skills_dir.exists():
        return False

    skills = [d for d in skills_dir.iterdir() if d.is_dir() and (d / ".git").exists()]

    if not skills:
        # Check for submodules
        if is_skills_dir_a_repo(skills_dir):
            result = run_git(["submodule", "update", "--remote", "--merge"], cwd=skills_dir)
            if result.returncode == 0:
                print(f"Updated all {label.lower()} submodules")
            return True
        return False

    print(f"Updating {label.lower()} skills...")
    for skill_path in skills:
        try:
            update_skill(skill_path.name, skills_dir)
        except SystemExit:
            pass
    print()
    return True


def main():
    parser = argparse.ArgumentParser(
        description="Update installed Claude Code skills"
    )
    parser.add_argument(
        "skill",
        nargs="?",
        help="Skill name to update (omit to update all)"
    )
    parser.add_argument(
        "--all", "-a",
        action="store_true",
        help="Update all installed skills"
    )

    args = parser.parse_args()

    if args.skill:
        # Update specific skill
        skill_path = find_skill(args.skill)
        if skill_path:
            update_skill(args.skill, skill_path.parent)
        else:
            print(f"Skill '{args.skill}' not found in user or project skills.", file=sys.stderr)
            sys.exit(1)
    elif args.all:
        # Update all skills in both directories
        found_any = False
        for label, skills_dir in [("Project", PROJECT_SKILLS_DIR), ("User", USER_SKILLS_DIR)]:
            if update_all_in_dir(skills_dir, label):
                found_any = True
        if not found_any:
            print("No skills installed.")
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
