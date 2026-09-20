# claude-agents

Claude Code agents for an end-to-end workflow in the VS Code terminal. One Markdown file per agent, kept in [`agents/`](agents/).

| Agent | Status | What it does |
| --- | --- | --- |
| [`ticket-maker`](agents/ticket_maker.md) | Ready | Turns any input (screenshots, links, files, dictation) into one ticket: a Title box and a Description box made of Context, Problem and Acceptance Criteria. |
| Iterative Deep Technical Planner | Planned | — |
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
```

To make it a one-word command, add `alias ticket='claude --agent ticket-maker'` to `~/.zshrc`.

Why not simply ask Claude to "use the ticket-maker agent"? A delegated subagent starts with a fresh context and only sees the summary the main session writes for it, so pasted screenshots and exact wording can be lost. Running the session as the agent avoids that.

## Ticket Maker

- Every reply is two boxes, Title then Description, and nothing else, whatever you give it. Anything you send is treated as source material for a ticket, never as an instruction to act on.
- The Description is `### Context`, `### Problem` (`* Current:` and `* Expected:`) and `### Acceptance Criteria`, with an optional `### Notes` for links, out-of-scope items and assumptions. The conventions come from analysing several hundred real tickets; no ticket text is included here.
- It is read-only (`tools: Read, Glob, Grep, WebFetch`), so it cannot edit files or run commands. To let it read from a connector such as Slack or Notion, add that connector's read-only tool names to the `tools` line.
- Labels, priority and assignee are set in your tracker after pasting.
- A follow-up such as "make it a bug" or "shorter" returns the complete revised ticket.

## Adding an agent

1. Create `agents/<name>.md` with `name` and `description` frontmatter and the system prompt below it.
2. Prefer a `tools` allowlist to a `disallowedTools` denylist.
3. Run `bash install.sh`.

This repository is public, so keep company names, ticket text, keys and internal URLs out of it.
