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

skill_in_list() {
  local needle="$1"
  shift
  local skill_name

  for skill_name in "$@"; do
    if [[ "$skill_name" == "$needle" ]]; then
      return 0
    fi
  done

  return 1
}

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

prune_removed_skills() {
  local skill_name
  local target_path

  if [[ ! -f "$MANIFEST_PATH" ]]; then
    return
  fi

  while IFS= read -r skill_name; do
    [[ -z "$skill_name" ]] && continue

    if skill_in_list "$skill_name" "${SOURCE_SKILLS[@]}"; then
      continue
    fi

    target_path="$TARGET_DIR/$skill_name"

    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[dry-run] prune $target_path"
      continue
    fi

    if [[ -d "$target_path" ]]; then
      rm -rf "$target_path"
      echo "pruned $skill_name"
    fi
  done < "$MANIFEST_PATH"
}

write_manifest() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    return
  fi

  printf '%s\n' "${SOURCE_SKILLS[@]}" > "$MANIFEST_PATH"
}

SOURCE_SKILLS=()

while IFS= read -r skill_path; do
  skill_name="$(basename "$skill_path")"

  if [[ "$skill_name" == ".system" ]]; then
    continue
  fi

  SOURCE_SKILLS+=("$skill_name")
done < <(list_source_skills)

if [[ "$DRY_RUN" -ne 1 ]]; then
  mkdir -p "$TARGET_DIR"
fi

prune_removed_skills

for skill_name in "${SOURCE_SKILLS[@]}"; do
  copy_skill "$skill_name"
done

write_manifest

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Dry run complete."
else
  echo "Install complete."
fi
