---
name: elixir-phoenix-full
description: 'Run the full plan-build-review-compound workflow for large Phoenix work.'
metadata:
  short-description: 'Run the full Phoenix work loop'
---

# Full Phoenix Feature Development

Execute complete Elixir/Phoenix feature development autonomously: research patterns,
plan with specialist agents, implement with verification, Elixir code review.
Cycles back automatically if review finds issues.

## Usage

```
`elixir-phoenix-full` Add user authentication with magic links
`elixir-phoenix-full` Real-time notification system with Phoenix PubSub
`elixir-phoenix-full` Background job processing for email campaigns --max-cycles 5
```

## Workflow Overview

```
┌───────────────────────────────────────────────────────────────────────────────┐
│                 `elixir-phoenix-full` {feature}                               │
├───────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐       │
│  │Discover│→ │  Plan  │→ │  Work  │→ │ Verify │→ │ Review │→ │Compound│→ Done │
│  │ Assess │  │[Pn-Tm] │  │Execute │  │  Full  │  │4 Agents│  │Capture │       │
│  │ Decide │  │ Phases │  │ Tasks  │  │  Loop  │  │Parallel│  │ Solve  │       │
│  └───┬────┘  └────────┘  └────────┘  └─────┬──┘  └────────┘  └────────┘       │
│      │                               ↑     │       ↑              │           │
│      ├── "just do it" ───────────────┤     │       │              │           │
│      ├── "plan it" ──┐               │     ↓       │              │           │
│      │               ↓               │   ┌────────┐│              │           │
│      │     ┌──────────────┐          │   │  Fix   ││  ┌────────┐  │           │
│      │     │   PLANNING   │          │   │ Issues │└─→│  Fix   │──┘           │
│      │     └──────────────┘          │   └───┬────┘   │ Review │              │
│      │                               │       ↓        │Findings│              │
│      │                        ┌──────┴─────────┐      └────┬───┘              │
│      │                        │   VERIFYING    │◄──────────┘                  │
│      └── "research it" ───────┘  (re-verify)                                  │
│           (comprehensive plan)                                                │
│                                                                               │
│  On Completion:                                                               │
│  Auto-compound: Capture solved problems → .codex/solutions/                   │
│  Auto-suggest: `elixir-phoenix-document` → `elixir-phoenix-learn-from-fix`    │
│                                                                               │
└───────────────────────────────────────────────────────────────────────────────┘
```

## State Machine

```
STATES: INITIALIZING → DISCOVERING → PLANNING → WORKING →
        VERIFYING → REVIEWING → COMPLETED → COMPOUNDING | BLOCKED
```

Save state in `.codex/plans/{slug}/progress.md` AND via Codex
tasks. Create one task per phase at start, mark `in_progress` on
entry and `completed` on exit:

Create one progress task per phase with these titles and active texts:
- `Discover & assess complexity` -> `Discovering...`
- `Plan feature` -> `Planning...`
- `Implement tasks` -> `Working...`
- `Verify implementation` -> `Verifying...`
- `Review with specialists` -> `Reviewing...`
- `Capture solutions` -> `Compounding...`

Set up `blockedBy` dependencies between phases (sequential).

Run COMPOUNDING phase on COMPLETED to capture solved problems in `.codex/solutions/`.
Suggest ``elixir-phoenix-document`` for docs and ``elixir-phoenix-learn-from-fix`` for quick pattern capture.

## Cycle Limits

| Setting | Default | Description |
|---------|---------|-------------|
| `--max-cycles` | 10 | Max plan→review cycles |
| `--max-retries` | 3 | Max retries per task |
| `--max-blockers` | 5 | Max blockers before stopping |

Stop with INCOMPLETE status when limits exceeded. List remaining work and recommended action.

## Integration

```text
`elixir-phoenix-full` = `elixir-phoenix-plan` → `elixir-phoenix-work` → `elixir-phoenix-verify` → `elixir-phoenix-review` → (fix → `elixir-phoenix-verify`) → `elixir-phoenix-compound`
```

Use Ralph Wiggum Loop for fully autonomous execution:

```bash
/ralph-loop:ralph-loop "`elixir-phoenix-full` {feature}" --completion-promise "DONE" --max-iterations 50
```

## Iron Laws

1. **NEVER skip verification** — Every task must pass `mix compile --warnings-as-errors` before moving to the next. Run `mix test <affected>` per-phase, full suite only at final gate
2. **Respect cycle limits** — When `--max-cycles` is exhausted, STOP with INCOMPLETE status. Do not continue indefinitely hoping the next fix works
3. **One state transition at a time** — Follow the state machine strictly. Never jump from PLANNING to REVIEWING — each state produces artifacts the next state needs
4. **Discover before deciding** — Always run DISCOVERING phase to assess complexity. Skipping it for "simple" features leads to underplanned implementations
5. **Agent output is findings, not fixes** — Review agents report issues. Only the WORKING state makes code changes
6. **Skip redundant review agents** — In REVIEWING phase: skip
   verification-runner (work phase already verified), skip iron-law-judge
   if PostToolUse hooks verified all files. For <200 lines changed,
   spawn only elixir-reviewer + security-analyzer (if auth files)
7. **ZERO narration in autonomous mode** — This is a HARD rule, not
   a suggestion. NEVER write "Let me now...", "Now I need to...",
   "I'll now...", "Next, I will...", or any preamble before a tool
   call. Just call the tool. Only output text for: decisions that
   need explanation, errors, or phase transitions. If you catch
   yourself narrating, delete the text and just make the tool call.
   (Post-PR validation: 30% of messages still violated this — the
   instruction was too soft. This stronger wording is required.)

## References

- `references/execution-steps.md` — Detailed step-by-step execution
- `references/example-run.md` — Example full cycle run
- `references/safety-recovery.md` — Safety rails, resume, rollback
- `references/cycle-patterns.md` — Advanced cycling strategies
