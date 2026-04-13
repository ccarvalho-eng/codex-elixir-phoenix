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

case "${1:-}" in
  --dry-run)
    DRY_RUN=1
    ;;
  "" )
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

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$REPO_ROOT/skills"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
TARGET_DIR="$CODEX_HOME/skills"

echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"

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

while IFS= read -r skill_path; do
  skill_name="$(basename "$skill_path")"

  if [[ "$skill_name" == ".system" ]]; then
    continue
  fi

  remove_skill "$skill_name"
done < <(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | sort)

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Dry run complete."
else
  echo "Uninstall complete."
fi
