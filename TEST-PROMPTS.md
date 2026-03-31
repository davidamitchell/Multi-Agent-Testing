# Test Prompts

Use these prompts to test each branch on each surface. Run one surface at a time. Record results in `RESULTS.md` and paste raw session output into `results/raw/YYYY-MM-DD-<surface>-<branch>.md`.

> **`{{BRANCH_NAME}}`** — replace this placeholder with the actual branch name before sending (e.g. `config/copilot-only`).

> **Session report filename convention** — all prompts ask the agent to create `results/raw/session-report-<surface>-<branch>.md`. The agent fills in `<surface>` from its self-identification. For `<branch>`, replace `/` with `-` (e.g. `config/copilot-only` → `config-copilot-only`).

---

## How to run a test

1. Switch the repo (or point your agent session) to the branch you are testing.
2. Copy the relevant prompt for your surface (see below).
3. Replace `{{BRANCH_NAME}}` with the actual branch name.
4. Send the prompt.
5. Record what the agent reports in `RESULTS.md`.
6. Paste the full raw session output into `results/raw/`.

---

## Surface: Copilot coding agent (GitHub issue)

Create a new GitHub issue in this repo with the following body. Assign it to Copilot.

```
You are operating in the agent-surface-test repository on branch: {{BRANCH_NAME}}.

Read all instruction files you have access to. Then do the following:

1. State the SENTINEL_ID value if you found it. If you did not find it, state "SENTINEL_ID not found".
2. List every instruction file you loaded, with its path.
3. Check whether `.github/skills/` contains files or is empty. List what you find.
4. List all files in the repo root.
5. Identify your surface as: "Copilot coding agent".

Create `results/raw/session-report-copilot-coding-agent-{{BRANCH_NAME}}.md` (replacing `/` with `-` in the branch name) containing all of the above plus the current UTC date and time. Commit it with message: `test: session report from copilot-coding-agent on {{BRANCH_NAME}}`
```

---

## Surface: Copilot issues

Open a GitHub issue in this repo while the repo is pointed at branch `{{BRANCH_NAME}}`. Use "Ask Copilot" on the issue, or send the following as the issue body:

```
You are operating in the agent-surface-test repository on branch: {{BRANCH_NAME}}.

Read all instruction files you have access to. Then report:

1. The SENTINEL_ID value if found. If not found, state "SENTINEL_ID not found".
2. Every instruction file you loaded, with its path.
3. Whether `.github/skills/` contains files or is empty. List what you find.
4. All files visible at the repo root.
5. Identify your surface as: "Copilot issues".

Create `results/raw/session-report-copilot-issues-{{BRANCH_NAME}}.md` (replacing `/` with `-` in the branch name) containing all of the above plus the current UTC date and time. Commit it with message: `test: session report from copilot-issues on {{BRANCH_NAME}}`
```

---

## Surface: Copilot CLI (GitHub Actions workflow)

Add a workflow to `.github/workflows/test-cli.yml` on the branch you are testing:

```yaml
name: Test Copilot CLI Surface

on:
  workflow_dispatch:
    inputs:
      branch:
        description: "Branch to test"
        required: true

jobs:
  test:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ inputs.branch }}
          submodules: false
      - name: Install GitHub Copilot CLI extension
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: gh extension install github/gh-copilot
      - name: Run test prompt
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          BRANCH=$(git branch --show-current)
          BRANCH_SLUG="${BRANCH//\//-}"
          gh copilot suggest -t shell \
            "Read all instruction files in this repository on branch ${BRANCH}. Report: (1) SENTINEL_ID if found, (2) every instruction file with path, (3) whether .github/skills/ contains files or is empty, (4) all files in the repo root. Then create results/raw/session-report-copilot-cli-${BRANCH_SLUG}.md with all findings plus UTC date/time, and commit it with message: test: session report from copilot-cli on ${BRANCH}" \
            2>&1 | tee /tmp/copilot-output.txt
          cat /tmp/copilot-output.txt
```

> **Note:** `gh copilot suggest` returns shell command suggestions and does not autonomously browse the filesystem. Capture the raw CLI output and record it as the session result. This surface primarily tests whether the Copilot CLI respects repo instruction files when invoked in a CI context.

Trigger via Actions tab → "Test Copilot CLI Surface" → Run workflow → enter the branch name.

---

## Surface: Copilot Spaces

Open this repo in a Copilot Space on branch `{{BRANCH_NAME}}`. Send the following message:

```
You are in the agent-surface-test repository on branch: {{BRANCH_NAME}}.

Read all instruction files available to you. Then report:

1. The SENTINEL_ID value if you found it. If not found, say "SENTINEL_ID not found".
2. Every instruction file you loaded, with its full path.
3. Whether `.github/skills/` contains files or is empty, and what you find there.
4. All files visible at the repo root.
5. Identify your surface as: "Copilot Spaces".

Create `results/raw/session-report-copilot-spaces-{{BRANCH_NAME}}.md` (replacing `/` with `-` in the branch name) containing all of the above plus the current UTC date and time. Commit it with message: `test: session report from copilot-spaces on {{BRANCH_NAME}}`
```

Record the full response verbatim in `results/raw/`.

---

## Surface: Claude iOS app (code feature)

Open this repo in the Claude iOS app using the `code` feature. Select branch `{{BRANCH_NAME}}`. Send the following message:

```
You are in the agent-surface-test repository on branch: {{BRANCH_NAME}}.

Read all instruction files available to you. Then report:

1. The SENTINEL_ID value if found. If not found, state "SENTINEL_ID not found".
2. Every instruction file you loaded, with its full path.
3. Whether `.github/skills/` contains files or is empty.
4. All files visible at the repo root.
5. Identify your surface as: "Claude iOS app".

Create `results/raw/session-report-claude-ios-{{BRANCH_NAME}}.md` (replacing `/` with `-` in the branch name) containing all of the above plus the current UTC date and time. Commit it with message: `test: session report from claude-ios on {{BRANCH_NAME}}`
```

---

## Surface: Claude issues integration

Trigger the Claude issues integration on this repo. Create a GitHub issue (or comment on an existing one) with the following body, ensuring the integration is operating on branch `{{BRANCH_NAME}}`:

```
You are operating in the agent-surface-test repository on branch: {{BRANCH_NAME}}.

Read all instruction files you have access to. Then report:

1. The SENTINEL_ID value if found. If not found, state "SENTINEL_ID not found".
2. Every instruction file you loaded, with its full path.
3. Whether `.github/skills/` contains files or is empty. List what you find.
4. All files visible at the repo root.
5. Identify your surface as: "Claude issues".

Create `results/raw/session-report-claude-issues-{{BRANCH_NAME}}.md` (replacing `/` with `-` in the branch name) containing all of the above plus the current UTC date and time. Commit it with message: `test: session report from claude-issues on {{BRANCH_NAME}}`
```

---

## Surface: Claude agent tasks

Start a Claude agent task session (e.g. via Claude Code CLI or the Claude web interface) with the repository set to branch `{{BRANCH_NAME}}`. Use the following prompt:

```
You are operating in the agent-surface-test repository on branch: {{BRANCH_NAME}}.

Read all instruction files you have access to. Then report:

1. The SENTINEL_ID value if found. If not found, state "SENTINEL_ID not found".
2. Every instruction file you loaded, with its full path.
3. Whether `.github/skills/` contains files or is empty. List what you find.
4. All files visible at the repo root.
5. Identify your surface as: "Claude agent task".

Create `results/raw/session-report-claude-agent-task-{{BRANCH_NAME}}.md` (replacing `/` with `-` in the branch name) containing all of the above plus the current UTC date and time. Commit it with message: `test: session report from claude-agent-task on {{BRANCH_NAME}}`
```

---

## Baseline: main branch (no instruction files)

Use this prompt on the `main` branch, which has no sentinel files. This is the control case.

Use the standard prompt for your chosen surface, replacing `{{BRANCH_NAME}}` with `main`.

Expected result:
- SENTINEL_ID: not found (no instruction files present)
- No instruction files loaded
- `.github/skills/` empty
- Agent identifies its surface as best it can

---

## Diagnostic: symlink resolution

**Use for branches:** `config/symlink-agents-md`, `config/symlink-claude-md`

Add this to your prompt when testing these branches:

```
The file AGENTS.md (or CLAUDE.md) at the repo root is a git symlink pointing to `.github/copilot-instructions.md`.

Report exactly what you observed when reading that file:
- Did you receive the full contents of `.github/copilot-instructions.md` (symlink was followed)?
- Or did you receive a short string like ".github/copilot-instructions.md" (raw symlink target, not followed)?
- Or did you receive an error?

State which one happened, exactly.
```

---

## Diagnostic: @import directive

**Use for branch:** `config/claude-md-import` — Claude surfaces only

Add this to your prompt when testing this branch:

```
The file CLAUDE.md at the repo root contains only: @import .github/copilot-instructions.md

Report:
- Did you receive the full contents of `.github/copilot-instructions.md` when you loaded CLAUDE.md (import was resolved)?
- Or did you see the literal text "@import .github/copilot-instructions.md" (import not processed)?

State which one happened, exactly.
```
