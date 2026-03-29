# Test Prompts

Use these prompts to test each branch on each surface. Run one surface at a time. Record results in `RESULTS.md` and paste raw session output into `results/raw/YYYY-MM-DD-<surface>-<branch>.md`.

## How to run a test

1. Switch the repo (or point your agent session) to the branch you are testing.
2. Use the relevant prompt for your surface (see below).
3. Record what the agent reports in `RESULTS.md`.
4. Paste the full raw session output into `results/raw/`.

## Surface: Copilot coding agent (GitHub issue)

Create a new GitHub issue in this repo with the following body. Assign it to Copilot.

```
You are operating in the agent-surface-test repository on branch: {{BRANCH_NAME}}.

Read all instruction files you have access to. Then do the following:

1. State the SENTINEL_ID value if you found it. If you did not find it, state "SENTINEL_ID not found".
2. List every instruction file you loaded, with its path.
3. Check whether `.github/skills/` contains files or is empty. List what you find.
4. List all files in the repo root.
5. Create `results/raw/session-report.md` containing all of the above, plus the current UTC date and time, and commit it with message: `test: session report from copilot-coding-agent on {{BRANCH_NAME}}`
```

## Surface: Copilot CLI (GitHub Actions workflow)

Add a workflow to `.github/workflows/test-cli.yml` on the branch you are testing:

```yaml
name: Test CLI Surface

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
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
      - run: npm install -g @github/copilot
      - name: Run test prompt
        env:
          GITHUB_TOKEN: ${{ secrets.COPILOT_GITHUB_TOKEN }}
        run: |
          copilot -p "You are operating in the agent-surface-test repository. Read all instruction files you have access to. Report: (1) the SENTINEL_ID value if found, (2) every instruction file you loaded with its path, (3) whether .github/skills/ contains files or is empty, (4) all files in the repo root. Then create results/raw/session-report.md containing all of the above plus the UTC date/time, and commit it with message: test: session report from copilot-cli on $(git branch --show-current)" \
            --autopilot \
            --allow-all
```

Trigger via Actions tab → "Test CLI Surface" → Run workflow → enter the branch name.

## Surface: Copilot Spaces

Open this repo in a Copilot Space. Send the following message:

```
You are in the agent-surface-test repository. I need you to run a surface detection test.

Read all instruction files available to you. Then report:
1. The SENTINEL_ID value if you found it. If not found, say so.
2. Every instruction file you loaded, with its full path.
3. Whether `.github/skills/` contains files or is empty, and what you find there.
4. All files visible at the repo root.
5. Identify your surface as best you can.

Do not create any files. This is a read-and-report test only.
```

Record the full response verbatim in `results/raw/`.

## Surface: Claude iOS app (code feature)

Open this repo in the Claude iOS app using the `code` feature. Select the branch you are testing. Send the following message:

```
You are in the agent-surface-test repository. I need you to run a surface detection test.

Read all instruction files available to you. Then report:
1. The SENTINEL_ID value if you found it. If not found, say "SENTINEL_ID not found".
2. Every instruction file you loaded, with its full path.
3. Whether `.github/skills/` contains files or is empty.
4. All files visible at the repo root.
5. Identify your surface as: "Claude iOS app".

Then create a file `results/raw/session-report.md` containing all of the above plus the UTC date/time, and commit it with message: `test: session report from claude-ios on <branch-name>`
```

## Diagnostic: symlink resolution test

For branches `config/symlink-agents-md` and `config/symlink-claude-md`, add this to your prompt:

```
The file AGENTS.md (or CLAUDE.md) at the repo root is a git symlink. 
Report exactly what you see when you read that file:
- Did you receive the contents of `.github/copilot-instructions.md`?
- Or did you receive a short string like ".github/copilot-instructions.md" (the raw symlink target)?
- Or did you receive an error?
State which one happened, exactly.
```

## Diagnostic: @import test

For branch `config/claude-md-import`, add this to your prompt (Claude surfaces only):

```
The file CLAUDE.md at the repo root contains only: @import .github/copilot-instructions.md
Report:
- Did you receive the contents of `.github/copilot-instructions.md` when you read CLAUDE.md?
- Or did you see the literal text "@import .github/copilot-instructions.md"?
- State which one happened, exactly.
```
