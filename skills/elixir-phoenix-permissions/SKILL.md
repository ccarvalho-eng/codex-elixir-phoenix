---
name: elixir-phoenix-permissions
description: Recommend safe Bash permissions for Elixir mix commands in settings.json.
  Use when permission prompts slow workflow, "fix permissions", "reduce prompts",
  "auto-allow mix".
metadata:
  short-description: Recommend safe Bash permissions for Elixir mix commands in settings.json.
    Use when permission prompts slow workflow, "fix permissions", "reduce prompts",
    "auto-allow mix".
---

# Codex Port Notes

- Treat original slash-command examples as references to the corresponding Codex skills, not as literal commands.
- Ask the user directly with concise plain-text questions in place of Claude interaction helpers.
- Use `update_plan` for progress tracking when it adds value; ignore Claude task APIs.
- Default to local execution. Only use `spawn_agent` or parallel agent work if the user explicitly asks for delegation.
- Use `.codex/` for workflow artifacts mentioned by the original instructions.
- Read supporting material from this skill's local `references/` directory whenever the source text points at the original skill directory.

# Permission Analyzer

Scan recent session transcripts to find Bash commands you keep approving,
cross-reference with current `settings.json`, and recommend adding the missing ones.

**Primary goal**: Discover MISSING permissions from actual usage.
**Secondary goal**: Clean up redundant/garbage entries.

## Usage

``elixir-phoenix-permissions` [--days=14] [--dry-run]` — Scans session JSONL files, finds uncovered Bash commands, classifies risk, and recommends `settings.json` changes. Use `--dry-run` to preview without writing.

## Arguments

`$ARGUMENTS` — `--days=N` (default: 14), `--dry-run` (preview only).

## Iron Laws

1. **NEVER auto-allow RED** — `rm`, `sudo`, `kill`, `curl|sh`, `mix ecto.reset`, `git push --force`, `chmod 777`
2. **Evidence-based only** — Only recommend commands actually approved in sessions
3. **Show before writing** — Present full diff, get explicit confirmation
4. **Preserve existing** — Merge, never overwrite

## Risk Classification

| Level | Examples | Action |
|-------|----------|--------|
| GREEN | `ls`, `cat`, `grep`, `tail`, `which`, `mkdir`, `cd`, `mix test/compile/credo/format`, `git status/log/diff` | Auto-recommend |
| YELLOW | `git add/commit/push`, `mix ecto.migrate`, `mix deps.get`, `npm install`, `docker build/run`, `source`, `mise exec` | Recommend with note |
| RED | `rm -rf`, `sudo`, `kill`, `curl|sh`,`mix ecto.reset/drop`,`git push --force`,`git reset --hard` | Never recommend |

## Workflow

### Step 1: Extract Bash Commands from Session JSONL Files

Run the extraction script from `references/extraction-script.md`.
This scans all project JSONL files from the last N days, checks each Bash command
against current `settings.json` patterns, and reports uncovered commands with counts.

**IMPORTANT**: Run this FIRST. Do NOT skip to settings cleanup.

### Step 2: Classify and Recommend

For each uncovered command from Step 1 output:

1. **Classify** as GREEN / YELLOW / RED per table above
2. **Generate permission pattern**: normalize to `Bash(base_command *)` format
   (use SPACE before `*`, NOT colon — `:*` is deprecated)
   - `mkdir -p` (94x) → `Bash(mkdir *)`
   - `mise exec` (39x) → `Bash(mise *)`
   - `tail -5` (20x) → `Bash(tail *)`
3. **Check for redundancy**: skip if a broader existing pattern covers it
4. **Also scan for garbage** in current settings: `Bash(done)`, `Bash(fi)`,
   `Bash(__NEW_LINE_*)`, partial heredocs, entries covered by broader patterns
5. **Fix deprecated `:*` patterns** — replace any `Bash(name:*)` with `Bash(name *)`
   (space before `*`). The `:*` suffix is deprecated and may not match reliably

Present a combined table:

```
## Permission Recommendations (last N days)

### ADD — Missing permissions (from session scan)
| Pattern to Add | Times Used | Risk | Example |
|...

### REMOVE — Redundant/garbage entries
| Entry | Reason |
|...

### RED — Require manual approval (not adding)
| Command | Count | Risk |
|...
```

### Step 3: Interactive Triage (unless `--dry-run`)

Walk through findings interactively using `ask the user directly`. Present items
in batches by risk level, starting with GREEN (safest):

**Batch 1 — GREEN items** (read-only, tests, safe tools):
Use `ask the user directly` with options:

- "Add all GREEN" — approve entire batch
- "Pick individually" — show each one for yes/no
- "Skip GREEN" — move to YELLOW

**Batch 2 — YELLOW items** (write ops, need caution):
Always show individually — one `ask the user directly` per item with options:

- "Add" — include in settings
- "Skip" — keep requiring manual approval
- "Customize" — let user edit the pattern before adding

**Batch 3 — REMOVE candidates** (garbage/redundant):
Use `ask the user directly` with options:

- "Remove all" — clean up entire batch
- "Pick individually" — show each for yes/no
- "Keep all" — skip cleanup

Track approved items in a list. After triage, show final summary of
what will be added/removed and ask for confirmation.

### Step 4: Apply

Merge approved additions into `~/.codex/settings.json` under `permissions.allow`.
Remove approved garbage entries. Report final counts.

## References

- `references/risk-classification.md` — Full classification rules
- `references/settings-format.md` — Permission pattern format
