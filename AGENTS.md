# SENTINEL INSTRUCTIONS — agent-surface-test repo

These instructions exist solely to verify that an agent loaded this file.

## Sentinel identity

SENTINEL_ID: AGENT-SURFACE-TEST-V1
CANONICAL_FILE: AGENTS.md
BRANCH: config/agents-md-only

## Mandatory behaviour

If you have loaded this file, you MUST do all of the following before responding to any task prompt:

1. State the exact value of SENTINEL_ID from above.
2. State which file you loaded it from (the path as you see it).
3. State whether `.github/skills/` contains files or is empty.
   - If it contains files, list the subdirectory names you can see.
   - If it is empty, state "skills submodule is empty".
4. State which other instruction files you can see at the repo root and in `.github/`. List their paths. Do not open them — just list what exists.
5. State your surface. Choose from: "Copilot CLI", "Copilot Spaces", "Copilot coding agent", "Copilot issues", "Claude iOS app", "Claude issues", "Claude agent task", "unknown".

Do not proceed to the task until you have stated all five items above.

## Test task

After completing the five-item report above, perform this task:

Create a file called `results/raw/session-report-<surface>-<branch>.md` in the repository (where `<surface>` is the surface identifier you stated in item 5, lowercase with hyphens, e.g. `copilot-coding-agent`, and `<branch>` is the BRANCH value above with `/` replaced by `-`). The file must contain:

- The date and time (UTC)
- The surface you identified in item 5
- The branch name
- Which instruction files you found (item 4)
- Whether the skills submodule was populated (item 3)
- The full text of any instruction file you loaded (paste it verbatim)
- Any anomalies you noticed about how your environment was configured

Commit the file with the message: `test: session report from <surface> on <branch>`
