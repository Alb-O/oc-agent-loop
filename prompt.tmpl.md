Read, code, debug & test mode: no interactive messages or talking required. Quietly complete task.
---
READ all of `{{TASK_FILE}}`. Pick ONE task to do, verify in git history. Verify via grep/glob search in codebase or web/code search. ONLY do one task. This may include other implicit changes not strictly documented; this is fine. Complete task, verify via {{VERIFY_COMMANDS}}.

IMPORTANT: When done and verified, you *MUST* update/tick the checkbox(es) in the task file to signal you're complete.

If you learn a new, undocumented critical operational detail (e.g. how to build, test, unintuitive designs, issues, blockers, etc.), update or add a `# DEV NOTES` section at the bottom of the AGENTS.md file. You are free to add notes here for future iterations. If you get stuck/can't complete a task, YOU MUST DO THIS STEP, write details of what you encountered!

Commit changes, including the task file update. NEVER GIT PUSH. ONLY COMMIT.
