#!/usr/bin/env python3
"""Shared utilities for skill management scripts."""

import subprocess
import sys
from pathlib import Path

USER_SKILLS_DIR = Path.home() / ".claude" / "skills"


def run_git(args: list[str], cwd: Path = None, check: bool = True) -> subprocess.CompletedProcess:
    """Run a git command."""
    result = subprocess.run(
        ["git"] + args,
        cwd=cwd,
        capture_output=True,
        text=True
    )
    if check and result.returncode != 0:
        print(f"Git error: {result.stderr.strip()}", file=sys.stderr)
    return result


def is_git_repo(path: Path) -> bool:
    """Check if a path is inside a git repository."""
    result = run_git(["rev-parse", "--git-dir"], cwd=path, check=False)
    return result.returncode == 0


def is_skills_dir_a_repo(skills_dir: Path) -> bool:
    """Check if the skills directory is a git repo or inside one."""
    if not skills_dir.exists():
        return False
    return is_git_repo(skills_dir)


def get_remote_url(skill_path: Path) -> str | None:
    """Get the remote URL for a skill."""
    result = run_git(["remote", "get-url", "origin"], cwd=skill_path, check=False)
    if result.returncode == 0:
        return result.stdout.strip()
    return None


def get_short_sha(skill_path: Path) -> str | None:
    """Get the short git SHA for a skill."""
    result = run_git(["rev-parse", "--short", "HEAD"], cwd=skill_path, check=False)
    if result.returncode == 0:
        return result.stdout.strip()
    return None


