#!/usr/bin/env python3
"""Install a Claude Code skill from a GitHub repository."""

import argparse
import re
import shutil
import sys
from pathlib import Path

from utils import (
    USER_SKILLS_DIR,
    PROJECT_SKILLS_DIR,
    run_git,
    is_skills_dir_a_repo,
)


def parse_repo_url(url: str) -> tuple[str, str]:
    """Parse a GitHub URL or shorthand into (full_url, skill_name)."""
    # Handle shorthand: user/repo
    if re.match(r"^[\w-]+/[\w.-]+$", url):
        url = f"https://github.com/{url}"

    # Extract skill name from URL
    match = re.search(r"github\.com[/:]([^/]+)/([^/.]+)", url)
    if not match:
        print(f"Error: Could not parse repository URL: {url}", file=sys.stderr)
        sys.exit(1)

    skill_name = match.group(2)

    # Normalize URL to HTTPS
    if not url.startswith("https://"):
        url = f"https://github.com/{match.group(1)}/{match.group(2)}"

    url = re.sub(r"\.git$", "", url)
    return url, skill_name


def install_skill(url: str, skills_dir: Path, force: bool = False):
    """Install a skill from a GitHub repository."""
    url, skill_name = parse_repo_url(url)
    skill_path = skills_dir / skill_name

    skills_dir.mkdir(parents=True, exist_ok=True)

    if skill_path.exists():
        if force:
            print(f"Removing existing {skill_name}...")
            # If it's a submodule, remove properly
            if is_skills_dir_a_repo(skills_dir):
                run_git(["submodule", "deinit", "-f", skill_name], cwd=skills_dir, check=False)
                run_git(["rm", "-f", skill_name], cwd=skills_dir, check=False)
                git_modules = skills_dir.parent / ".git" / "modules" / "skills" / skill_name
                if git_modules.exists():
                    shutil.rmtree(git_modules)
            if skill_path.exists():
                shutil.rmtree(skill_path)
        else:
            print(f"Skill '{skill_name}' already exists.", file=sys.stderr)
            print(f"Use update.py {skill_name} to update, or --force to reinstall", file=sys.stderr)
            sys.exit(1)

    print(f"Installing {skill_name} from {url}...")

    if is_skills_dir_a_repo(skills_dir):
        # Add as submodule
        result = run_git(["submodule", "add", "--depth", "1", url, skill_name], cwd=skills_dir)
        if result.returncode != 0:
            sys.exit(1)
        print(f"Added as git submodule")
    else:
        # Regular clone
        result = run_git(["clone", "--depth", "1", url, str(skill_path)])
        if result.returncode != 0:
            sys.exit(1)

    # Verify SKILL.md exists
    if not (skill_path / "SKILL.md").exists():
        print(f"Warning: No SKILL.md found in repository", file=sys.stderr)

    print(f"Successfully installed {skill_name}")

    # Check for requirements.txt
    requirements = skill_path / "requirements.txt"
    if requirements.exists():
        print(f"\nThis skill has dependencies. Install with:")
        print(f"  pip install -r {requirements}")


def main():
    parser = argparse.ArgumentParser(
        description="Install a Claude Code skill from GitHub"
    )
    parser.add_argument(
        "url",
        help="GitHub URL or shorthand (user/repo) to install"
    )
    parser.add_argument(
        "--force", "-f",
        action="store_true",
        help="Force reinstall if skill exists"
    )

    location = parser.add_mutually_exclusive_group(required=True)
    location.add_argument(
        "--user",
        action="store_true",
        help="Install to user directory (~/.claude/skills/)"
    )
    location.add_argument(
        "--project",
        action="store_true",
        help="Install to project directory (./.claude/skills/)"
    )

    args = parser.parse_args()

    if args.user:
        skills_dir = USER_SKILLS_DIR
    else:
        skills_dir = PROJECT_SKILLS_DIR

    install_skill(args.url, skills_dir, force=args.force)


if __name__ == "__main__":
    main()
