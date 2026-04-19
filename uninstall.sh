#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./uninstall.sh [--dry-run]

Removes this repo's installed skills from:
  ${CODEX_HOME:-$HOME/.codex}/skills
EOF
}

DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac

  shift
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$REPO_ROOT/skills"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
TARGET_DIR="$CODEX_HOME/skills"
MANIFEST_PATH="$TARGET_DIR/.codex-elixir-phoenix-manifest"

echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"

list_source_skills() {
  find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | sort
}

remove_skill() {
  local skill_name="$1"
  local target_path="$TARGET_DIR/$skill_name"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] remove $target_path"
    return
  fi

  if [[ -d "$target_path" ]]; then
    rm -rf "$target_path"
    echo "removed $skill_name"
  else
    echo "skip $skill_name (not installed)"
  fi
}

OWNED_SKILLS=()

if [[ -f "$MANIFEST_PATH" ]]; then
  while IFS= read -r skill_name; do
    [[ -z "$skill_name" ]] && continue
    OWNED_SKILLS+=("$skill_name")
  done < "$MANIFEST_PATH"
else
  while IFS= read -r skill_path; do
    skill_name="$(basename "$skill_path")"

    if [[ "$skill_name" == ".system" ]]; then
      continue
    fi

    OWNED_SKILLS+=("$skill_name")
  done < <(list_source_skills)
fi

for skill_name in "${OWNED_SKILLS[@]}"; do
  remove_skill "$skill_name"
done

if [[ -f "$MANIFEST_PATH" ]]; then
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] remove $MANIFEST_PATH"
  else
    rm -f "$MANIFEST_PATH"
    echo "removed manifest"
  fi
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Dry run complete."
else
  echo "Uninstall complete."
fi
