# codex-elixir-phoenix

Portable Elixir and Phoenix skills for Codex.

This repository packages custom skills from a local Codex setup so they can be installed on any machine into `~/.codex/skills`.

## Included

- Elixir/Phoenix skills under [`skills/`](skills/)
- Skill definitions in `SKILL.md`
- Related `agents/` and `references/` folders when present
- Runtime durability review coverage for state-machine, persistence, retry, pause/resume, and restart-sensitive changes

## Not Included

- Codex-curated `.system` skills
- Personal Codex data (auth, sessions, logs, memories, plugin caches)

## Install

```bash
git clone https://github.com/ccarvalho-eng/codex-elixir-phoenix.git
cd codex-elixir-phoenix
./install.sh
```

Default target: `~/.codex/skills`

Custom target:

```bash
CODEX_HOME=/path/to/.codex ./install.sh
```

Dry run:

```bash
./install.sh --dry-run
```

## Update

```bash
git pull
./install.sh
```

## Uninstall

```bash
./uninstall.sh
```

Dry run:

```bash
./uninstall.sh --dry-run
```

Custom target:

```bash
CODEX_HOME=/path/to/.codex ./uninstall.sh
```

## Acknowledgment

Inspired by [oliver-kriska/claude-elixir-phoenix](https://github.com/oliver-kriska/claude-elixir-phoenix). This repository is a Codex-oriented adaptation and is not an official fork.
