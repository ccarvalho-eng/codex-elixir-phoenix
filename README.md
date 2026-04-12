# codex-elixir-phoenix

Portable Elixir and Phoenix skills for Codex.

This repo packages the custom skills from my local Codex setup in a layout that can be cloned and installed into another machine's `~/.codex/skills` directory.

## What is included

- 42 Elixir/Phoenix-oriented skills under `skills/`
- Each skill keeps its `SKILL.md`
- Optional `agents/` and `references/` directories are preserved

## What is not included in this repo

- Codex-curated `.system` skills
- Personal config such as auth, sessions, logs, memories, and plugin caches are not part of this repo

## Install

Clone the repo anywhere:

```bash
git clone https://github.com/YOUR-ORG/codex-elixir-phoenix.git
cd codex-elixir-phoenix
./install.sh
```

By default this installs into:

```bash
~/.codex/skills
```

You can override the target:

```bash
CODEX_HOME=/path/to/.codex ./install.sh
```

Dry run:

```bash
./install.sh --dry-run
```

## Update

Pull the latest repo changes, then run:

```bash
./install.sh
```

## Notes

- Some skills intentionally refer to paths like `~/.codex/...` because they are meant to run inside a Codex home directory
- If you publish this repo, review the skill contents for any local assumptions before pushing
- If you want Codex to surface the skills in a specific curated order, add that separately through your own Codex plugin or marketplace metadata
