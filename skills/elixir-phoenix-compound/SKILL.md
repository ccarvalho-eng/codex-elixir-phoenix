---
name: elixir-phoenix-compound
description: 'Elixir/Phoenix: Capture solved problems as searchable solution docs.
  Use after fixing bugs, when "that worked", or after successful $elixir-phoenix-review or $elixir-phoenix-investigate.'
metadata:
  short-description: 'Elixir/Phoenix: Capture solved problems as searchable solution
    docs. Use after fixing bugs, when "that worked", or after successful $elixir-phoenix-review
    or $elixir-phoenix-investigate.'
---

# Compound — Capture Solutions as Knowledge

After fixing a problem, capture the solution as searchable
institutional documentation.

## Usage

```
`elixir-phoenix-compound` Fixed N+1 query in user listing
`elixir-phoenix-compound` Resolved LiveView timeout in dashboard
`elixir-phoenix-compound`   # Auto-detects from recent session context
```

## Philosophy

> Each unit of engineering work should make subsequent units
> easier — not harder.

## Workflow

### Step 1: Detect Context

1. If `$ARGUMENTS` provided, use as description
2. If no args, check scratchpad DEAD-END/DECISION entries,
   `git diff`, `.codex/plans/{slug}/progress.md` for recent completions
3. If unclear, ask: "What problem did you just solve?"

**Only document non-trivial problems** that required investigation.

### Step 2: Search Existing Solutions

Create `.codex/solutions/` directory if it doesn't exist (run `mkdir -p .codex/solutions`).
Then search `.codex/solutions/` for relevant keywords using `rg`.

If found: **Create new** (different root cause), **Update
existing** (same root cause, new symptom), or **Skip**.

### Step 3: Gather Details and Create Solution

Extract from session context: module, symptoms, investigation
steps, root cause, solution code, and prevention advice.

Validate frontmatter against `compound-docs/references/schema.md`,
then create file using `compound-docs/references/resolution-template.md`.

### Step 4: Decision Menu

1. **Continue** (default)
2. **Promote to Iron Law check** — Add to iron-law-judge
3. **Update skill reference** — Add to relevant skill
4. **Update AGENTS.md** — Add prevention rule

## Auto-Trigger Phrases

When user says "that worked", "it's fixed", "problem solved",
"the fix was" — suggest ``elixir-phoenix-compound``.

## Iron Laws

1. **YAML frontmatter validates or STOP**
2. **Symptoms must be specific** — not "it broke"
3. **Root cause is WHY, not WHAT**
4. **One problem per file**
5. **NEVER document a fix before verifying it works** — run `mix compile && mix test` first; unverified solutions poison the knowledge base

## Integration with Workflow

```text
`elixir-phoenix-review` → Complete → `elixir-phoenix-compound`  ← YOU ARE HERE
                              │
                 .codex/solutions/{category}/{fix}.md
                              │
              `elixir-phoenix-investigate` and `elixir-phoenix-plan` search here
```

## References

- `references/compound-workflow.md` — Detailed step-by-step
- See also: `compound-docs` skill for schema and templates
