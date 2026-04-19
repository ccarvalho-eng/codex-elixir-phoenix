#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
TEMP_DIRS=()
ERRORS=0

cleanup() {
  local dir

  for dir in "${TEMP_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
      rm -rf "$dir"
    fi
  done
}

trap cleanup EXIT

make_temp_dir() {
  local dir

  dir="$(mktemp -d "${TMPDIR:-/tmp}/codex-elixir-phoenix.XXXXXX")"
  TEMP_DIRS+=("$dir")
  printf '%s\n' "$dir"
}

record_error() {
  echo "ERROR: $*" >&2
  ERRORS=$((ERRORS + 1))
}

list_source_skills() {
  find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d | sort
}

validate_skill_references() {
  local skill_dir
  local skill_file
  local ref

  while IFS= read -r skill_dir; do
    skill_file="$skill_dir/SKILL.md"

    if [[ ! -f "$skill_file" ]]; then
      record_error "$(basename "$skill_dir") is missing SKILL.md"
      continue
    fi

    while IFS= read -r ref; do
      [[ -z "$ref" ]] && continue

      if [[ ! -f "$skill_dir/$ref" ]]; then
        record_error "$(basename "$skill_dir") references missing file: $ref"
      fi
    done < <(rg -o 'references/[A-Za-z0-9._/-]+' "$skill_file" | sort -u || true)
  done < <(list_source_skills)
}

validate_dry_run_is_clean() {
  local sandbox

  sandbox="$(make_temp_dir)"
  CODEX_HOME="$sandbox" "$REPO_ROOT/install.sh" --dry-run >/dev/null

  if [[ -e "$sandbox/skills" ]]; then
    record_error "install.sh --dry-run created $sandbox/skills"
  fi
}

validate_install_round_trip() {
  local sandbox
  local manifest_path
  local skill_dir
  local skill_name

  sandbox="$(make_temp_dir)"
  manifest_path="$sandbox/skills/.codex-elixir-phoenix-manifest"

  CODEX_HOME="$sandbox" "$REPO_ROOT/install.sh" >/dev/null

  if [[ ! -f "$manifest_path" ]]; then
    record_error "install.sh did not write the ownership manifest"
  fi

  while IFS= read -r skill_dir; do
    skill_name="$(basename "$skill_dir")"

    if [[ ! -d "$sandbox/skills/$skill_name" ]]; then
      record_error "install.sh did not install $skill_name"
    fi
  done < <(list_source_skills)

  CODEX_HOME="$sandbox" "$REPO_ROOT/uninstall.sh" >/dev/null

  if [[ -f "$manifest_path" ]]; then
    record_error "uninstall.sh did not remove the ownership manifest"
  fi

  while IFS= read -r skill_dir; do
    skill_name="$(basename "$skill_dir")"

    if [[ -e "$sandbox/skills/$skill_name" ]]; then
      record_error "uninstall.sh did not remove $skill_name"
    fi
  done < <(list_source_skills)
}

validate_skill_references
validate_dry_run_is_clean
validate_install_round_trip

if [[ "$ERRORS" -gt 0 ]]; then
  echo "Validation failed with $ERRORS error(s)." >&2
  exit 1
fi

echo "Skill catalog validation passed."
