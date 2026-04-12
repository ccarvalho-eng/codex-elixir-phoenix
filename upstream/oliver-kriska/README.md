# Upstream Snapshot

This directory contains a conservative snapshot of passive assets from:

- https://github.com/oliver-kriska/claude-elixir-phoenix

These files are included as reference material only.

## Intent

- Preserve useful upstream agent and hook designs
- Avoid pretending Claude-specific orchestration works in Codex today
- Keep upstream material quarantined from the active `skills/` tree

## Imported

- `agents/planning-orchestrator.md`
- `agents/parallel-reviewer.md`
- `agents/context-supervisor.md`
- `hooks/hooks.json`
- `hooks/scripts/plan-stop-reminder.sh`
- `plugin.json`
- `Makefile.upstream`

## Not imported yet

- Full hook script set
- Active plugin wiring
- Slash-command flows
- `.claude/` runtime artifact assumptions
- Contributor/dev-only lab framework beyond the Makefile reference

## Compatibility note

These files use Claude-specific concepts such as:

- `/phx:*` commands
- `.claude/...` artifact paths
- `AskUserQuestion`
- `permissionMode: bypassPermissions`
- hook lifecycle names and output contracts

Treat them as source material for future Codex-native ports, not executable config.
