#!/usr/bin/env python3
"""List installed Claude Code skills with their paths, origins, and versions."""

import argparse
import subprocess
import sys
from pathlib import Path

USER_SKILLS_DIR = Path.home() / ".claude" / "skills"


def get_short_sha(skill_path: Path) -> str | None:
    """Get the short git SHA for a skill."""
    result = subprocess.run(
        ["git", "rev-parse", "--short", "HEAD"],
        cwd=skill_path,
        capture_output=True,
        text=True
    )
    if result.returncode == 0:
        return result.stdout.strip()
    return None


def get_origin_url(skill_path: Path) -> str | None:
    """Get the origin remote URL for a skill."""
    result = subprocess.run(
        ["git", "remote", "get-url", "origin"],
        cwd=skill_path,
        capture_output=True,
        text=True
    )
    if result.returncode == 0:
        return result.stdout.strip()
    return None


def list_skills_in_dir(skills_dir: Path) -> list[tuple[str, str | None, str | None]]:
    """List skills in a directory. Returns list of (path, origin_url, sha)."""
    if not skills_dir.exists():
        return []

    skills = []
    for item in skills_dir.iterdir():
        if item.is_dir() and ((item / "SKILL.md").exists() or (item / ".git").exists()):
            origin = get_origin_url(item)
            sha = get_short_sha(item)
            skills.append((str(item), origin, sha))

    return sorted(skills)


def main():
    parser = argparse.ArgumentParser(
        description="List installed Claude Code skills with paths, origins, and versions"
    )
    parser.add_argument(
        "project_path",
        nargs="?",
        help="Project path to check for project-level skills"
    )

    args = parser.parse_args()

    # User skills
    user_skills = list_skills_in_dir(USER_SKILLS_DIR)
    if user_skills:
        print("User skills:")
        for path, origin, sha in user_skills:
            print(f"  {path}")
            if origin:
                print(f"    origin: {origin}")
            if sha:
                print(f"    sha: {sha}")
        print()

    # Project skills
    if args.project_path:
        project_path = Path(args.project_path).resolve()
        if not project_path.exists():
            print(f"Error: Project path does not exist: {project_path}", file=sys.stderr)
            sys.exit(1)
        skills_dir = project_path / ".claude" / "skills"
        project_skills = list_skills_in_dir(skills_dir)
        if project_skills:
            print("Project skills:")
            for path, origin, sha in project_skills:
                print(f"  {path}")
                if origin:
                    print(f"    origin: {origin}")
                if sha:
                    print(f"    sha: {sha}")
            print()

    if not user_skills and (not args.project_path or not project_skills):
        print("No skills installed.")


if __name__ == "__main__":
    main()
