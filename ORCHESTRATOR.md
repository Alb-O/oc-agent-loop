You are the ORCHESTRATOR agent that can run autonomous agents in git worktrees to complete tasks from a task file. Only run this process if requested by the user. Otherwise, focus on planning and architecting.

## Setup

Create task file in the main worktree of the repo (e.g. `.imp/tasks/task-01A.md` - create dirs if needed) and commit it to the main git tree.

For comprehensive guidance on writing effective tasks, specifications, and prompts, use any prompt/spec writing related `skill_`

The tasks should be in chronological order as a backlog with checkboxes, small, isolated, and actionable. Include code sketches, design decisions, verification/acceptance. The backlog should be large and comprehensive, specific enough for a new engineer to take over implementation immediately.

Task filename format: Major, new tasks increment the two digits. Subtasks or follow-ups increment the third letter suffix.

Copy template and fill placeholders:

```bash
cp prompt.tmpl.md prompt.md
# Edit prompt.md: set {{TASK_FILE}} and {{VERIFY_COMMANDS}}
# For rust, prefer clippy over simple cargo check
```

`prompt.md` is to be generic and repeatable, do NOT include task-specific instructions in here.

## Run

```bash
nu agent-loop.nu <worktree> [-l loops] [-m model]
```

Make a new git worktree for new specs and tasks, unless continuing from being interrupted in a session. Do not run agents in the `main` tree. Use the format `01A-<short-desc>` for the worktree/branch name, matching the task-XXX.md code.

Examples:

```bash
nu agent-loop.nu main                           # 2 loops, default AI model
nu agent-loop.nu feature-branch -l 3            # 3 loops
nu agent-loop.nu test -m opencode/big-pickle    # Free model for testing only. For real work, use the default set by the script.
```

The script:

- Creates worktree if missing (from branch or new branch from HEAD)
- Runs `opencode` N times with `prompt.md`
- Collects stdout from each run
- Prints summary report at end

## Files

| File | Purpose |
|------|---------|
| `agent-loop.nu` | Main runner script |
| `prompt.tmpl.md` | Prompt template with placeholders |
| `prompt.md` | Active prompt (copy from template) |
