# codex-elixir-phoenix

Portable Elixir and Phoenix skills for Codex.

This repository packages custom skills from a local Codex setup so they can be installed on any machine into `~/.codex/skills`.

Each install writes a manifest of the skills this repository manages. Future installs use that manifest to prune skills that were removed from the repo without touching unrelated skills in the target directory.

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

If a previously installed skill has been removed from this repository, a subsequent install prunes it automatically by consulting the stored manifest.

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

## Validate

```bash
bash ./scripts/validate_skills.sh
```

This checks the skill catalog for broken local `references/...` links and verifies the install and uninstall scripts, including the guarantee that `install.sh --dry-run` leaves the filesystem untouched.

## Acknowledgment

Inspired by [oliver-kriska/claude-elixir-phoenix](https://github.com/oliver-kriska/claude-elixir-phoenix). This repository is a Codex-oriented adaptation and is not an official fork.
