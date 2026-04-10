# AGENTS.md - ClawTeam Lab

Project-level instructions for all AI agents entering this workspace.

## Labs in This Project

| Lab | Location | Description |
|---|---|---|
| **openclaw_auth_lab** | `openclaw_auth_lab/` | OpenClaw authentication lab (read `openclaw_auth_lab/README.md` first) |
| **qwen_auth_lab** | `qwen_auth_lab/` | Qwen authentication lab (read `qwen_auth_lab/README.md` first) |

## Sub-Agent Setup

When starting a new lab or workspace, create an isolated sub-agent sandbox so other AI agents can operate without conflicting with the main session.

### Why?

- **Isolation** — sub-agents have their own identity, memory, and workspace
- **No confusion** — main agent and sub-agents don't share context or memory files
- **Multi-agent ready** — any AI (OpenClaw, OpenCode, Qwen, Claude, Gemini) can drop in and work independently

### How to Create a Sub-Agent Sandbox

1. **Create the directory:** `mkdir agent_sandbox` (or use the lab name, e.g. `openclaw_auth_lab/agent_sandbox/`)
2. **Copy this AGENTS.md** into it: `cp AGENTS.md agent_sandbox/AGENTS.md`
3. **Initialize identity files inside `agent_sandbox/`:**
   - `SOUL.md` — who the sub-agent is (its role, personality, scope)
   - `USER.md` — who it's helping (can be the same human or a project-specific role)
   - `memory/` — empty directory for daily notes
4. **Optional: `BOOTSTRAP.md`** — if you want the sub-agent to follow setup instructions on first run

### Sub-Agent Rules

- Sub-agents **only operate within their sandbox** — they don't touch main session files
- Each sub-agent has its **own** `MEMORY.md`, `memory/`, `SOUL.md`, `USER.md`
- Sub-agents **cannot** access the main session's memory or identity files
- If a sub-agent needs something from the main workspace, it should **ask**, not grab
- When done, clean up: remove `BOOTSTRAP.md`, leave a summary in `memory/YYYY-MM-DD.md`

### When to Create One

- Starting a new lab, project, or experiment
- Want to test something risky without affecting main workspace
- Delegating a task to a focused sub-agent with a specific role
- Preparing the workspace for another AI agent to join

## Red Lines

- Don't exfiltrate private data. Ever.
- Don't run destructive commands without asking.
- `trash` > `rm` (recoverable beats gone forever)
- **No secrets** — never commit, log, or expose API keys, tokens, or credentials
- When in doubt, ask

## General Conventions

- Read the lab's `README.md` before making changes
- Stay within your lab directory — don't cross into other labs without asking
- Document decisions and context in daily memory files
- Keep code consistent with existing project style

## Make It Yours

This is a starting point. Add your own conventions, style, and rules as you figure out what works.
