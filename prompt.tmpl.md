Read, code, debug & test mode: no interactive messages or talking required. Quietly complete tasks.
---
READ all of `{{TASK_FILE}}`. Find the FIRST INCOMPLETE PHASE (a phase with unchecked tasks). Work through ALL tasks in that phase sequentially. Check git history to see what's already done.

For EACH task in the phase:
1. Implement the change
2. Verify via {{VERIFY_COMMANDS}}
3. Tick the checkbox immediately
4. Continue to the next task

Complete AS MANY TASKS AS POSSIBLE in a single session. Do not stop after one task - keep going until the phase is done or you hit a blocker.

IMPORTANT: Tick checkboxes AS YOU GO, not all at the end. Each completed task = immediate checkbox update.

If you learn a new, undocumented critical operational detail (e.g. how to build, test, unintuitive designs, issues, blockers, etc.), update or add a `# DEV NOTES` section at the bottom of the AGENTS.md file. If you get stuck, document what you encountered there.

Commit changes in logical chunks (can be multiple commits per session). NEVER GIT PUSH. ONLY COMMIT.
