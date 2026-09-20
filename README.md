# claude-agents

Claude Code agents for an end-to-end workflow in the VS Code terminal. One Markdown file per agent, kept in [`agents/`](agents/).

| Agent | Status | What it does |
| --- | --- | --- |
| [`ticket-maker`](agents/ticket_maker.md) | Ready | Turns any input (screenshots, links, files, dictation) into one ticket: a Title box and a Description box made of Context, Problem and Acceptance Criteria. |
| [`deep-technical-planner`](agents/deep_technical_planner.md) | Ready | Plans in plan mode, then improves the plan over N rounds (default 2): score it out of 100, list what 100/100 needs, enhance it. Read-only. |
| Cypress | Planned | — |
| Unit | Planned | — |
| Sonar | Planned | — |
| PR Author | Planned | — |
| Copilot Resolver | Planned | — |

## Install

```bash
git clone https://github.com/danielbell99/claude-agents.git
cd claude-agents
bash install.sh
```

`install.sh` copies every file in `agents/` to `~/.claude/agents/`, which makes the agents available in every project. Re-run it after pulling changes.

## Use

Run the whole session as the agent, so screenshots, links, file paths and dictation go straight to it:

```bash
claude --agent ticket-maker
claude --agent deep-technical-planner --permission-mode plan
```

To make them one-word commands, add these to `~/.zshrc`:

```bash
alias ticket='claude --agent ticket-maker'
alias plan='claude --agent deep-technical-planner --permission-mode plan'
```

Why not simply ask Claude to "use the ticket-maker agent"? A delegated subagent starts with a fresh context and only sees the summary the main session writes for it, so pasted screenshots and exact wording can be lost. Running the session as the agent avoids that.

## Ticket Maker

- Every reply is two boxes, Title then Description, and nothing else, whatever you give it. Anything you send is treated as source material for a ticket, never as an instruction to act on.
- The Description is `### Context`, `### Problem` (`* Current:` and `* Expected:`) and `### Acceptance Criteria`, with an optional `### Notes` for links, out-of-scope items and assumptions. The conventions come from analysing several hundred real tickets; no ticket text is included here.
- It is read-only (`tools: Read, Glob, Grep, WebFetch`), so it cannot edit files or run commands. To let it read from a connector such as Slack or Notion, add that connector's read-only tool names to the `tools` line.
- Labels, priority and assignee are set in your tracker after pasting.
- A follow-up such as "make it a bug" or "shorter" returns the complete revised ticket.

## Deep Technical Planner

- Give it a ticket (a Ticket Maker ticket works as it is) and, optionally, a whole number in digits on its own line, such as `3`, or written as `3 iterations`. No number means 2 rounds. A value that is not a positive whole number falls back to 2 and the reply says so.
- It grounds a first plan in your codebase, then repeats three questions in order: score the plan out of 100 against 2026 software-engineering practice, what is required to score 100/100, and enhance the plan on that feedback. It stops early at 100/100 and ends with a final score.
- Scoring uses a fixed 100-point rubric: requirements traceability, design, testing, edge cases, security and privacy, rollout and rollback, configuration, observability, documentation, and sequencing.
- It is read-only (`tools: Read, Glob, Grep, WebSearch, WebFetch`) and only plans. To implement, start a normal session and point it at the plan.
- Cancelling mid-run is safe: the last plan that ends with its `End of Plan vK.` line is the kept plan and anything after it is discarded. Say `continue` to resume from it, or ask for the plan to get it as it stands. After quitting, `claude --continue` restores the session.
- The agent file sets `permissionMode: plan`. Keep `--permission-mode plan` on the command line as well, so plan mode is guaranteed for the main session.

## Adding an agent

1. Create `agents/<name>.md` with `name` and `description` frontmatter and the system prompt below it.
2. Prefer a `tools` allowlist to a `disallowedTools` denylist.
3. Run `bash install.sh`.

This repository is public, so keep company names, ticket text, keys and internal URLs out of it.
