# Plugin Tutorial Content

Content for each section of the `$elixir-phoenix-intro` tutorial.
Present ONE section at a time with ask the user directly between sections.
IMPORTANT: Present ALL content in each section — every paragraph, table, and code block. Do NOT abbreviate or summarize.

## Contents

- [Section 1: Welcome](#section-1-welcome)
- [Section 2: Core Workflow Commands](#section-2-core-workflow-commands)
- [Section 3: Knowledge & Safety Net](#section-3-knowledge--safety-net)
- [Section 4: Hooks & Behavioral Rules](#section-4-hooks--behavioral-rules)
- [Section 5: Init, Review & Gaps](#section-5-init-review--gaps)
- [Section 6: Cheat Sheet & Next Steps](#section-6-cheat-sheet--next-steps)

---

## Section 1: Welcome

### What This Plugin Does

This plugin adds **specialist Elixir/Phoenix agents**, **auto-loaded knowledge**, and **Iron Laws** to Codex. It turns a general-purpose AI into an opinionated Elixir pair programmer.

### The Core Concept

Everything revolves around a 4-phase workflow cycle:

```text
$elixir-phoenix-plan → $elixir-phoenix-work → $elixir-phoenix-verify → $elixir-phoenix-review → $elixir-phoenix-compound
   |             |            |              |              |
   v             v            v              v              v
 Research &   Execute     Full check     Parallel       Capture what
 plan tasks   tasks       compile/test   code review    you learned
```

Each phase reads from the previous phase's output. Plans become checkboxes. Checkboxes track progress. Reviews catch mistakes. Compound knowledge makes future work faster.

### What You Get

| Feature | What It Does |
|---------|-------------|
| 20 specialist agents | Ecto, LiveView, security, OTP, Oban, deployment experts |
| 38 skills | Commands for every phase of development |
| 22 Iron Laws | Non-negotiable rules enforced automatically |
| Auto-loaded references | Context-aware docs loaded when you edit relevant files |
| Tidewave integration | Runtime debugging when Tidewave MCP is connected |

---

## Section 2: Core Workflow Commands

### The Full Cycle

For features that need planning and review:

```bash
# 0. Brainstorm (optional) — explore requirements interactively
$elixir-phoenix-brainstorm Add some kind of notification system

# 1. Plan — spawns research agents, outputs checkbox plan
$elixir-phoenix-plan Add user avatars with S3 upload

# 1b. Brief (optional) — understand the plan before starting
$elixir-phoenix-brief .codex/plans/user-avatars/plan.md

# 2. Work — executes plan, checks off tasks, runs mix compile
$elixir-phoenix-work .codex/plans/user-avatars/plan.md

# 3. Review — parallel agents check Elixir idioms, security, tests
$elixir-phoenix-review

# 4. Compound — capture what you learned for future reference
$elixir-phoenix-compound Fixed S3 upload timeout with multipart streaming
```

### Shortcuts

Not everything needs the full cycle:

| Command | When to Use | Time |
|---------|------------|------|
| `$elixir-phoenix-quick` | Bug fixes, small features (<100 lines) | ~2 min |
| `$elixir-phoenix-full` | New features, autonomous plan-work-verify-review | ~10 min |
| `$elixir-phoenix-investigate` | Debugging — checks obvious things first | ~3 min |

### Decision Guide

```text
Is it a bug?
  Yes --> $elixir-phoenix-investigate
  No  --> Do you know what you want?
            No  --> $elixir-phoenix-brainstorm
            Yes --> Is it < 100 lines?
                      Yes --> $elixir-phoenix-quick
                      No  --> Do you want full autonomy?
                                Yes --> $elixir-phoenix-full
                                No  --> $elixir-phoenix-plan then $elixir-phoenix-work
```

### Deepening an Existing Plan

Already have a plan but want to add research or refine tasks?

```bash
$elixir-phoenix-plan --existing .codex/plans/user-avatars/plan.md
```

This spawns specialist agents to analyze your existing plan and enhance it with research findings.

---

## Section 3: Knowledge & Safety Net

### Auto-Loaded Knowledge

The plugin loads relevant reference docs based on what you're editing:

| You're editing... | Plugin loads... |
|-------------------|----------------|
| `*_live.ex` | LiveView patterns, async/streams, components |
| `*_test.exs` | ExUnit patterns, Mox, factory patterns |
| `migrations/*` | Migration patterns, safe operations |
| `*auth*`, `*session*` | Security patterns, authorization rules |
| `router.ex` | Routing patterns, plug patterns, scopes |
| `*_worker.ex` | Oban patterns, idempotency rules |

This means you don't need to explicitly load anything — open a LiveView file and the plugin already knows the patterns.

### Iron Laws (22 Rules, Always Enforced)

Iron Laws are non-negotiable rules that every agent enforces. If your code violates one, the plugin stops and explains before proceeding.

**Examples:**

| Law | Why |
|-----|-----|
| No DB queries in disconnected mount | Would run twice, waste resources |
| Use streams for lists >100 items | Regular assigns = O(n) memory per user |
| No `:float` for money | Floating point math loses precision |
| Pin values with `^` in Ecto queries | Prevents SQL injection |
| Jobs must be idempotent | Oban retries on failure |
| No `String.to_atom` with user input | Atom table exhaustion DoS |
| Authorize in EVERY `handle_event` | Mount auth alone is insufficient |

### Analysis & Verification Commands

| Command | What It Does |
|---------|-------------|
| `$elixir-phoenix-verify` | Full check: compile, format, credo, test, dialyzer |
| `$elixir-phoenix-audit` | 5-agent project health audit with scores |
| `$elixir-phoenix-n1-check` | Detect N+1 query patterns |
| `$elixir-phoenix-assigns-audit` | Audit LiveView socket assigns for memory |
| `$elixir-phoenix-boundaries` | Check Phoenix context boundary violations |
| `$elixir-phoenix-perf` | Performance analysis (Ecto, LiveView, OTP) |

### Tidewave Integration

When Tidewave MCP is connected to your running Phoenix app:

```bash
# Get docs for your exact dependency versions
mcp__tidewave__get_docs "Ecto.Query"

# Execute code in your running app
mcp__tidewave__project_eval "MyApp.Repo.aggregate(User, :count)"

# Query your dev database directly
mcp__tidewave__execute_sql_query "SELECT count(*) FROM users"
```

The plugin automatically prefers Tidewave tools over alternatives when available.

---

## Section 4: Hooks & Behavioral Rules

The plugin uses **layered enforcement** — some things run automatically, some depend on Codex following instructions, some are on-demand. Here's what actually happens:

### Layer 1: Hooks (Automatic, Every Edit)

Codex hooks run shell scripts automatically after tool use. These are real automation — no instructions needed:

| Hook | Trigger | What It Does |
|------|---------|-------------|
| Dangerous ops block | Before Bash command | Blocks `mix ecto.reset/drop`, `git push --force`, `MIX_ENV=prod` |
| Format check | Every `.ex`/`.exs` edit | Runs `mix format --check-formatted`, warns via stderr + exit 2 |
| Iron Law verifier | Every `.ex`/`.exs` edit | Scans code content for Iron Law violations with line numbers |
| Debug stmt warning | Every `.ex` edit | Warns about `IO.inspect`/`dbg()`/`IO.puts` in production code |
| Security reminder | Editing auth/session/password files | Outputs relevant Iron Laws via stderr + exit 2 |
| Progress logging | Every file edit | Appends to `.codex/plans/{slug}/progress.md` (async) |
| Failure hints | Bash command fails | Injects debugging hints via `additionalContext` |
| Error critic | Repeated mix failures | Escalates to structured critic analysis after 3+ failures |
| Iron Laws injection | Any subagent spawns | Injects all 22 Iron Laws into subagents via `additionalContext` |
| PreCompact rules | Before context compaction | Re-injects workflow rules via JSON `systemMessage` |

Format check **warns only** — it doesn't auto-fix (that would cause race conditions with the editor).

The PreCompact hook detects active workflow phases (`$elixir-phoenix-plan`, `$elixir-phoenix-work`, `$elixir-phoenix-full`) and re-injects their critical rules
before context compaction. This prevents "rule amnesia" where Codex loses behavioral constraints after context is compressed.

Note: Compilation verification was moved to `$elixir-phoenix-work` phase checkpoints for speed. The `verify-elixir.sh` hook has been removed.

### Layer 2: Iron Laws in Skills (Behavioral)

Each domain skill (ecto-patterns, liveview-patterns, security, etc.) embeds its own Iron Laws.
When Codex loads a skill, the laws become active context.
Codex is instructed to **stop and explain** before writing code that violates them.

This is behavioral — it works because the rules are in Codex's context, not because code enforces them. It's effective but not 100% guaranteed.

### Layer 3: Skill Loading by File Type (Behavioral)

AGENTS.md instructs Codex to load specific skills based on file patterns:

```text
*_live.ex       → liveview-patterns (streams, async, components)
*auth*, *session* → security (authorization, XSS, atom safety)
*_worker.ex     → oban (idempotency, string keys, queue config)
*_test.exs      → testing (ExUnit, Mox, factories)
Any .ex file    → elixir-idioms (always)
```

This is **not plugin infrastructure** — it's instructions that Codex follows. No hooks trigger skill loading.
This is the plugin's biggest known gap — in practice, skills rarely auto-load from file context alone.
Running `$elixir-phoenix-init` significantly improves this.

---

## Section 5: Init, Review & Gaps

### Layer 4: `$elixir-phoenix-init` (Strengthens Everything)

Running `$elixir-phoenix-init` injects enforcement rules **directly into your project's AGENTS.md**. This is stronger than plugin-level instructions because AGENTS.md is always read at session start.

What it adds:

- **7-step mandatory procedure** — complexity scoring, interview questions before coding, reference loading
- **Iron Laws with STOP protocol** — explicitly tells Codex to halt on violations
- **Verification rules** — `mix compile --warnings-as-errors && mix format` after code changes
- **Stack-specific rules** — detects Phoenix version, Oban, Ash, Tidewave from `mix.exs`

```bash
$elixir-phoenix-init           # First-time setup
$elixir-phoenix-init --update  # Update after plugin updates
```

If you're finding the plugin inconsistent, running `$elixir-phoenix-init` is the single biggest improvement you can make.

### Layer 5: `$elixir-phoenix-review` + Iron Law Judge (On-Demand)

The `iron-law-judge` agent does **pattern-based violation detection** — it uses `rg` to search your changed files for known anti-patterns. But it only runs when you invoke `$elixir-phoenix-review`.

What it catches with automated detection:

- `String.to_atom(` in lib code
- `field :price, :float` in schemas
- `raw(@variable)` (XSS risk)
- `Repo.` calls in LiveView mount without `connected?` guard
- Missing `^` pin in Ecto query fragments

### Layer 6: Planning Sets Structure Early

The `$elixir-phoenix-plan` phase sets naming conventions, context boundaries, and module structure
**before any code exists**. This is where you prevent Rails-y patterns at the architecture
level — fat controllers, service objects, and ActiveRecord patterns get caught in the plan,
not in code review.

### What's NOT Automated (Yet)

Being honest about the gaps:

| Check | Status | Why |
|-------|--------|-----|
| `mix compile --warnings-as-errors` | `$elixir-phoenix-work` checkpoints + `$elixir-phoenix-full` VERIFYING phase | Compilation runs in workflow steps, not per-edit hooks |
| `mix credo` | `$elixir-phoenix-full` VERIFYING phase + on-demand (`$elixir-phoenix-verify`) | Not run per-task edit, only between phases |
| `mix test` | `$elixir-phoenix-full` VERIFYING phase + on-demand (`$elixir-phoenix-verify`) | Not run per-task, only between phases |
| `mix dialyzer` | On-demand (`$elixir-phoenix-verify`) | Takes minutes, not seconds |
| Iron Law detection during coding | Behavioral only | `iron-law-judge` is review-time only |

### The Honest Summary

```text
AUTOMATIC (hooks):     Format check, security reminders, progress logging, failure hints,
                       Iron Laws in subagents, PreCompact rule preservation
BEHAVIORAL (Codex):   Iron Laws, skill loading, stop-and-explain
ON-DEMAND (commands):  $elixir-phoenix-review (iron-law-judge), $elixir-phoenix-verify (compile/credo/dialyzer)
STRENGTHENED BY:       $elixir-phoenix-init (injects rules into project AGENTS.md)
```

The plugin works best when all layers are active: `$elixir-phoenix-init` for persistent rules, hooks for automatic checks, and `$elixir-phoenix-review` to catch what the behavioral layer missed.

---

## Section 6: Cheat Sheet & Next Steps

### Command Reference

**Workflow (use in order):**

| Command | Phase |
|---------|-------|
| `$elixir-phoenix-brainstorm <topic>` | Adaptive requirements gathering |
| `$elixir-phoenix-plan <feature>` | Plan with research agents |
| `$elixir-phoenix-plan --existing <file>` | Enhance existing plan |
| `$elixir-phoenix-brief [plan file]` | Interactive plan walkthrough |
| `$elixir-phoenix-work <plan file>` | Execute plan with verification |
| `$elixir-phoenix-review` | Parallel agent code review |
| `$elixir-phoenix-triage` | Interactive review finding triage |
| `$elixir-phoenix-compound` | Capture solved problem |

**Standalone:**

| Command | Purpose |
|---------|---------|
| `$elixir-phoenix-quick <task>` | Fast implementation, skip ceremony |
| `$elixir-phoenix-full <feature>` | Autonomous plan-work-review cycle |
| `$elixir-phoenix-investigate <bug>` | Structured bug investigation |
| `$elixir-phoenix-verify` | Run all quality checks |
| `$elixir-phoenix-research <topic>` | Research with parallel workers, Tidewave-first |
| `$elixir-phoenix-pr-review <PR#>` | Address PR review comments |
| `$elixir-phoenix-permissions` | Scan sessions, recommend safe Bash permissions |
| `$elixir-phoenix-help [description]` | Interactive command advisor — helps pick the right command |

**Analysis:**

| Command | Purpose |
|---------|---------|
| `$elixir-phoenix-audit` | Full project health audit |
| `$elixir-phoenix-perf` | Performance analysis |
| `$elixir-phoenix-n1-check` | N+1 query detection |
| `$elixir-phoenix-assigns-audit` | LiveView memory audit |
| `$elixir-phoenix-boundaries` | Context boundary check |
| `$elixir-phoenix-techdebt` | Technical debt analysis |
| `$elixir-phoenix-call-tracing <function>` | Call chain tracing |
| `$elixir-phoenix-ecto-constraint-debug` | Debug Ecto constraint errors |

**Knowledge:**

| Command | Purpose |
|---------|---------|
| `$elixir-phoenix-examples` | Practical walkthroughs |
| `$elixir-phoenix-learn-from-fix` | Capture a lesson from a fix |
| `$elixir-phoenix-challenge` | Rigorous review mode |

### 3 Tips for Getting the Most Out of the Plugin

1. **Start with `$elixir-phoenix-plan` for any feature that touches multiple files.** The research agents catch architectural issues early, before you've written code that needs rewriting.

2. **Let Iron Laws stop you.** When the plugin flags a violation, read the explanation.
   These rules exist because the Elixir community learned them the hard way
   (atom exhaustion in prod, N+1 queries at scale, double-mount in LiveView).

3. **Use `$elixir-phoenix-compound` after solving hard bugs.** The solution gets indexed and searchable. Next time you hit something similar, the plugin finds your past solution automatically.

### Next Steps

- Try `$elixir-phoenix-plan` with your next feature to see the full workflow
- Run `$elixir-phoenix-verify` to see your project's current health
- Run `$elixir-phoenix-audit` for a comprehensive project assessment
- Check `$elixir-phoenix-examples` for detailed walkthroughs
