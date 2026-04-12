#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run]

Installs this repo's skills into:
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

mkdir -p "$TARGET_DIR"

echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"

copy_skill() {
  local skill_name="$1"
  local source_path="$SOURCE_DIR/$skill_name"
  local target_path="$TARGET_DIR/$skill_name"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] sync $skill_name -> $target_path"
    return
  fi

  rm -rf "$target_path"
  cp -R "$source_path" "$target_path"
  echo "installed $skill_name"
}

while IFS= read -r skill_path; do
  skill_name="$(basename "$skill_path")"

  if [[ "$skill_name" == ".system" ]]; then
    continue
  fi

  copy_skill "$skill_name"
done < <(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | sort)

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Dry run complete."
else
  echo "Install complete."
fi
