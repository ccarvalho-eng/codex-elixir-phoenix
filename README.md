# codex-elixir-phoenix

Portable Elixir and Phoenix skills for Codex.

This repo packages the custom skills from my local Codex setup in a layout that can be cloned and installed into another machine's `~/.codex/skills` directory.

## Credit

This project is heavily inspired by Oliver Kriska's Claude-focused Elixir/Phoenix plugin:

- https://github.com/oliver-kriska/claude-elixir-phoenix

This repo adapts that direction for a Codex-oriented skills setup. It is not an official fork, and Claude-specific orchestration details are only imported here as reference material unless explicitly ported.

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
