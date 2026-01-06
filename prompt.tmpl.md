Read, code, debug & test mode: no interactive messages or talking required. Quietly complete tasks.
---
READ all of `{{TASK_FILE (path relative to worktree, e.g. .imp/tasks/task-01A.md)}}`. Find the first incomplete phase (a markded heading with unchecked tasks). Work through all tasks in that phase sequentially.

For each task (or subtask) in the phase:
1. Implement the change
2. Verify via {{VERIFY_COMMANDS}}
3. Tick the checkbox immediately
4. Continue to the next task

Complete as many tasks as possible in a single phase. Keep going until the phase is done or you hit a blocker. ONLY complete 1 phase (and all its subtasks), after it's done, end your turn. Commit changes in logical chunks (can be multiple commits per session). NEVER GIT PUSH. ONLY COMMIT.

Tick checkboxes as you go, not all at the end. Each completed task = immediate checkbox update.

If you learn a new, undocumented critical operational detail (e.g. how to build, test, unintuitive designs, issues, blockers, etc.), update or add detailed notes to the task file. If you get stuck, document what you encountered there.

