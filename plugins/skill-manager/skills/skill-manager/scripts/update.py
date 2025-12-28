#!/usr/bin/env python3
"""Update installed Claude Code skills."""

import argparse
import sys
from pathlib import Path

from utils import (
    USER_SKILLS_DIR,
    run_git,
    is_skills_dir_a_repo,
)


def update_skill(skill_name: str, skills_dir: Path):
    """Update an installed skill."""
    skill_path = skills_dir / skill_name

    if not skill_path.exists():
        print(f"Skill '{skill_name}' is not installed in {skills_dir}.", file=sys.stderr)
        sys.exit(1)

    print(f"Updating {skill_name}...", flush=True)

    if is_skills_dir_a_repo(skills_dir):
        # Update submodule
        result = run_git(["submodule", "update", "--remote", "--merge", skill_name], cwd=skills_dir)
    else:
        # Regular pull
        result = run_git(["pull", "--ff-only"], cwd=skill_path)

    if result.returncode != 0:
        print(f"Error: Failed to update {skill_name}", file=sys.stderr)
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
        help="Skill name to update"
    )

    location = parser.add_mutually_exclusive_group(required=True)
    location.add_argument(
        "--user",
        action="store_true",
        help="Update skill in user directory (~/.claude/skills/)"
    )
    location.add_argument(
        "--project",
        metavar="PATH",
        type=str,
        help="Update skill in project directory (PATH/.claude/skills/)"
    )
    location.add_argument(
        "--all", "-a",
        action="store_true",
        help="Update all installed skills in user directory"
    )

    args = parser.parse_args()

    if args.all:
        # Update all skills in user directory
        if not update_all_in_dir(USER_SKILLS_DIR, "User"):
            print("No skills installed in user directory.")
    elif args.user:
        update_skill(args.skill, USER_SKILLS_DIR)
    else:
        project_path = Path(args.project).resolve()
        if not project_path.exists():
            print(f"Error: Project path does not exist: {project_path}", file=sys.stderr)
            sys.exit(1)
        skills_dir = project_path / ".claude" / "skills"
        update_skill(args.skill, skills_dir)


if __name__ == "__main__":
    main()
