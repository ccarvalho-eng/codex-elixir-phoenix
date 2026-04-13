---
name: elixir-phoenix-help
description: 'Elixir/Phoenix: Recommend the right /phx: command for planning, review,
  debug, deploy, or test tasks. Use when "which command", "what should I use", or
  "how do I". NOT for /help.'
metadata:
  short-description: 'Elixir/Phoenix: Recommend the right /phx: command for planning,
    review, debug, deploy, or test tasks. Use when "which command", "what should I
    use", or "how do I". NOT for /help.'
---

# Plugin Help — Interactive Command Advisor

Helps users find the right command, skill, or agent for their situation.

## Usage

```
`elixir-phoenix-help`                          # Analyze context, suggest commands
`elixir-phoenix-help` how do I debug this?     # Route to `elixir-phoenix-investigate`
`elixir-phoenix-help` add a new feature        # Route to `elixir-phoenix-plan` -> `elixir-phoenix-work`
```

## Arguments

- `$ARGUMENTS` — optional description of what the user wants to do
- Empty = analyze current context (git status, existing plans, file patterns)

## Execution Flow

### Step 1: Gather Context

If `$ARGUMENTS` is non-empty, use it as primary signal.

Always gather ambient context (run in parallel):

1. Check for existing plans: use Glob on `.codex/plans/*/plan.md` — active work in progress?
2. Check git status: uncommitted changes? which files?
3. Check for solution docs: use Glob on `.codex/solutions/**/*.md` — prior knowledge?

### Step 2: Classify Intent

Read `references/tool-catalog.md` for the full routing table.

Map the user's situation to one of these categories:

| Category | Signals | Primary Commands |
|----------|---------|-----------------|
| **Starting out** | No plans, new to plugin | ``elixir-phoenix-intro`` |
| **Ideation** | "explore", "brainstorm", "not sure", "how to approach", "vague idea" | ``elixir-phoenix-brainstorm`` |
| **New feature** | "add", "build", "implement", multi-file | ``elixir-phoenix-plan`` → ``elixir-phoenix-work`` |
| **Quick change** | Single file, <50 lines, "fix typo" | ``elixir-phoenix-quick`` |
| **Bug** | Error, stack trace, "broken", "failing" | ``elixir-phoenix-investigate`` |
| **Review** | "check", "review", PR ready | ``elixir-phoenix-review`` |
| **Performance** | "slow", "N+1", "memory" | ``elixir-phoenix-perf``, ``elixir-phoenix-n1-check``, ``elixir-phoenix-assigns-audit`` |
| **Research** | "how to", "best practice", "evaluate lib" | ``elixir-phoenix-research`` |
| **Resume work** | Existing plan with unchecked tasks | ``elixir-phoenix-work` --continue` |
| **Post-fix** | "that worked", solved a hard bug | ``elixir-phoenix-compound`` |
| **Full cycle** | Large feature, new domain area | ``elixir-phoenix-full`` |
| **Project health** | "audit", "tech debt", "overall quality" | ``elixir-phoenix-audit``, ``elixir-phoenix-techdebt`` |
| **Deployment** | "deploy", "release", "production" | ``elixir-phoenix-verify`` then deploy skill |
| **Permissions** | "too many prompts", "allow", "permission fatigue" | ``elixir-phoenix-permissions`` |

### Step 3: Respond or Clarify

**If high confidence** (clear match to one category):
Present the recommendation with:

- The command to run (with exact syntax)
- One-line explanation of what it does
- What artifacts it creates (if any)
- Suggested next step after it completes

**If medium confidence** (2-3 possible matches):
Use `ask the user directly` with the top options, each with a one-line explanation.

**If low confidence** (vague or no signal):
Ask ONE focused clarifying question. Examples:

- "Are you starting something new or continuing existing work?"
- "Is this a bug fix or a new feature?"
- "How many files do you expect to change?"

Then recommend based on the answer.

### Step 4: Offer Follow-up

After recommending, always add:

- "Run ``elixir-phoenix-help`` anytime to get routing advice"
- If they seem new: "Try ``elixir-phoenix-intro`` for a full plugin walkthrough"

## Iron Laws

1. **ONE recommendation** — don't dump the full catalog, pick the best match
2. **MAX ONE clarifying question** — don't interrogate, make your best guess
3. **Show exact syntax** — ``elixir-phoenix-plan` Add user notifications` not just "use the plan command"
4. **Context over keywords** — existing plans + git state matter more than word matching
5. **Never block** — if user already knows what they want, don't redirect

## Integration

- Complements `intent-detection` (auto-trigger) with explicit invocation
- References same routing logic but adds interactive clarification
- Can recommend ``elixir-phoenix-intro`` for onboarding
