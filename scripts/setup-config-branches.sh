#!/usr/bin/env bash
# setup-config-branches.sh
#
# Run this script ONCE from the main branch after the setup PR is merged.
# It creates and pushes all 7 config branches used in the agent-surface-test.
#
# Usage:
#   git checkout main
#   git pull origin main
#   bash scripts/setup-config-branches.sh
#
# Requires write access to the repository.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "Error: run this script from the main branch (currently on '$CURRENT_BRANCH')."
  exit 1
fi

# ---------------------------------------------------------------------------
# Sentinel content template
# ---------------------------------------------------------------------------
# Usage: sentinel_content <canonical_file_path> <branch_name>
sentinel_content() {
  local file_path="$1"
  local branch="$2"
  cat <<SENTINEL
# SENTINEL INSTRUCTIONS — agent-surface-test repo

These instructions exist solely to verify that an agent loaded this file.

## Sentinel identity

SENTINEL_ID: AGENT-SURFACE-TEST-V1
CANONICAL_FILE: ${file_path}
BRANCH: ${branch}

## Mandatory behaviour

If you have loaded this file, you MUST do all of the following before responding to any task prompt:

1. State the exact value of SENTINEL_ID from above.
2. State which file you loaded it from (the path as you see it).
3. State whether \`.github/skills/\` contains files or is empty.
   - If it contains files, list the subdirectory names you can see.
   - If it is empty, state "skills submodule is empty".
4. State which other instruction files you can see at the repo root and in \`.github/\`. List their paths. Do not open them — just list what exists.
5. State your surface. Choose from: "Copilot CLI", "Copilot Spaces", "Copilot coding agent", "Copilot issues", "Claude iOS app", "Claude issues", "Claude agent task", "unknown".

Do not proceed to the task until you have stated all five items above.

## Test task

After completing the five-item report above, perform this task:

Create a file called \`results/raw/session-report.md\` in the repository. The file must contain:

- The date and time (UTC)
- The surface you identified in item 5
- The branch name
- Which instruction files you found (item 4)
- Whether the skills submodule was populated (item 3)
- The full text of any instruction file you loaded (paste it verbatim)
- Any anomalies you noticed about how your environment was configured

Commit the file with the message: \`test: session report from <surface> on <branch>\`
SENTINEL
}

# ---------------------------------------------------------------------------
# branch 1: config/copilot-only
# ---------------------------------------------------------------------------
echo "==> Creating config/copilot-only"
git checkout -b config/copilot-only main
mkdir -p .github
sentinel_content ".github/copilot-instructions.md" "config/copilot-only" > .github/copilot-instructions.md
git add .github/copilot-instructions.md
git commit -m "config/copilot-only: add sentinel copilot-instructions.md"
git push origin config/copilot-only
git checkout main

# ---------------------------------------------------------------------------
# branch 2: config/agents-md-only
# ---------------------------------------------------------------------------
echo "==> Creating config/agents-md-only"
git checkout -b config/agents-md-only main
sentinel_content "AGENTS.md" "config/agents-md-only" > AGENTS.md
git add AGENTS.md
git commit -m "config/agents-md-only: add sentinel AGENTS.md"
git push origin config/agents-md-only
git checkout main

# ---------------------------------------------------------------------------
# branch 3: config/claude-md-only
# ---------------------------------------------------------------------------
echo "==> Creating config/claude-md-only"
git checkout -b config/claude-md-only main
sentinel_content "CLAUDE.md" "config/claude-md-only" > CLAUDE.md
git add CLAUDE.md
git commit -m "config/claude-md-only: add sentinel CLAUDE.md"
git push origin config/claude-md-only
git checkout main

# ---------------------------------------------------------------------------
# branch 4: config/all-three-full-content
# ---------------------------------------------------------------------------
echo "==> Creating config/all-three-full-content"
git checkout -b config/all-three-full-content main
mkdir -p .github
sentinel_content ".github/copilot-instructions.md" "config/all-three-full-content" > .github/copilot-instructions.md
sentinel_content "AGENTS.md" "config/all-three-full-content" > AGENTS.md
sentinel_content "CLAUDE.md" "config/all-three-full-content" > CLAUDE.md
git add .github/copilot-instructions.md AGENTS.md CLAUDE.md
git commit -m "config/all-three-full-content: add all three sentinel files"
git push origin config/all-three-full-content
git checkout main

# ---------------------------------------------------------------------------
# branch 5: config/symlink-agents-md
# ---------------------------------------------------------------------------
echo "==> Creating config/symlink-agents-md"
git checkout -b config/symlink-agents-md main
mkdir -p .github
sentinel_content ".github/copilot-instructions.md" "config/symlink-agents-md" > .github/copilot-instructions.md
ln -sf .github/copilot-instructions.md AGENTS.md
git add .github/copilot-instructions.md AGENTS.md
git commit -m "config/symlink-agents-md: canonical file + AGENTS.md symlink"
git push origin config/symlink-agents-md
git checkout main

# ---------------------------------------------------------------------------
# branch 6: config/symlink-claude-md
# ---------------------------------------------------------------------------
echo "==> Creating config/symlink-claude-md"
git checkout -b config/symlink-claude-md main
mkdir -p .github
sentinel_content ".github/copilot-instructions.md" "config/symlink-claude-md" > .github/copilot-instructions.md
ln -sf .github/copilot-instructions.md CLAUDE.md
git add .github/copilot-instructions.md CLAUDE.md
git commit -m "config/symlink-claude-md: canonical file + CLAUDE.md symlink"
git push origin config/symlink-claude-md
git checkout main

# ---------------------------------------------------------------------------
# branch 7: config/claude-md-import
# ---------------------------------------------------------------------------
echo "==> Creating config/claude-md-import"
git checkout -b config/claude-md-import main
mkdir -p .github
sentinel_content ".github/copilot-instructions.md" "config/claude-md-import" > .github/copilot-instructions.md
printf '@import .github/copilot-instructions.md\n' > CLAUDE.md
git add .github/copilot-instructions.md CLAUDE.md
git commit -m "config/claude-md-import: sentinel + CLAUDE.md with @import"
git push origin config/claude-md-import
git checkout main

# ---------------------------------------------------------------------------
# branch 8: config/copilot-setup-steps
# ---------------------------------------------------------------------------
echo "==> Creating config/copilot-setup-steps"
git checkout -b config/copilot-setup-steps main
mkdir -p .github/workflows
sentinel_content ".github/copilot-instructions.md" "config/copilot-setup-steps" > .github/copilot-instructions.md
cat > .github/workflows/copilot-setup-steps.yml <<'WORKFLOW'
name: Copilot Setup Steps

on:
  workflow_call:

jobs:
  copilot-setup-steps:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repo with submodules
        uses: actions/checkout@v4
        with:
          submodules: recursive
WORKFLOW
git add .github/copilot-instructions.md .github/workflows/copilot-setup-steps.yml
git commit -m "config/copilot-setup-steps: add sentinel + copilot-setup-steps.yml"
git push origin config/copilot-setup-steps
git checkout main

echo ""
echo "All config branches created and pushed successfully."
echo "Verify with: git branch -r | grep 'config/'"
