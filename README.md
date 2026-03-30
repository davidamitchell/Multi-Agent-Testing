# agent-instruction-surface-test

This repository is a test harness for empirically observing how different agent instruction file configurations behave across multiple agent surfaces. The goal is to discover, by direct observation, which instruction mechanisms actually work on each surface.

## What this repo tests

- Which instruction files each agent loads automatically at session start
- Whether git symlinks are resolved as file content or returned as raw target path strings
- Whether `CLAUDE.md` supports `@import` directives that Claude Code on the web follows
- Whether the `.github/skills/` git submodule is accessible or appears as an empty directory
- Whether any pre-session environment setup mechanism is available per surface

---

## Branch table

| Branch | What it tests |
|--------|--------------|
| `main` | Baseline repo with no instruction files; contains test infrastructure only |
| `config/copilot-only` | Only `.github/copilot-instructions.md` present |
| `config/agents-md-only` | Only `AGENTS.md` at repo root present |
| `config/claude-md-only` | Only `CLAUDE.md` at repo root present |
| `config/all-three-full-content` | All three files present with identical sentinel content |
| `config/symlink-agents-md` | `AGENTS.md` is a git symlink → `.github/copilot-instructions.md` |
| `config/symlink-claude-md` | `CLAUDE.md` is a git symlink → `.github/copilot-instructions.md` |
| `config/claude-md-import` | `CLAUDE.md` contains only `@import .github/copilot-instructions.md` |
| `config/copilot-setup-steps` | Like `config/copilot-only` but adds `copilot-setup-steps.yml` workflow |

---

## Surface table

| Surface | How to run | Key questions |
|---------|-----------|---------------|
| Copilot coding agent (GitHub issue) | Assign issue to Copilot | Does it load `.github/copilot-instructions.md`? Does it initialise the submodule? |
| Copilot CLI (Actions workflow) | `copilot -p <prompt> --autopilot --allow-all` in CI | Same as above; does CLI behave differently from the coding agent? |
| Copilot Spaces | Open repo in a Copilot Space | Which files are auto-loaded? |
| Copilot issues | "Ask Copilot" on an issue | Which instruction files are visible? |
| Claude iOS app (`code` feature) | Open repo in Claude iOS app `code` feature | Does it load `CLAUDE.md`? Does `@import` work? Does it resolve symlinks? |
| Claude issues integration | Claude issues surface if available | Same as above |
| Claude agent tasks | Claude agent task surface if available | Same as above |

---

## How to run a test session

1. Pick a branch from the branch table above.
2. Pick a surface from the surface table above.
3. Open the repo on that branch in the chosen surface.
4. Use the relevant prompt from `TEST-PROMPTS.md`.
5. Record the agent's response in `RESULTS.md` (one row per session).
6. Paste the full raw session output into `results/raw/YYYY-MM-DD-<surface>-<branch>.md`.

See `TEST-PROMPTS.md` for the canonical prompts to use on each surface.

---

## Repository structure

```
.
├── README.md               ← this file
├── RESULTS.md              ← results log (fill in after each session)
├── TEST-PROMPTS.md         ← canonical prompts per surface
├── results/
│   └── raw/               ← paste raw session output here
├── .github/
│   ├── skills/            ← git submodule → davidamitchell/Skills (public)
│   └── copilot-instructions.md  ← present on config branches only
├── AGENTS.md               ← present on config branches only
└── CLAUDE.md               ← present on config branches only
```

The `.github/skills/` entry is a git submodule. By default it is **not** initialised on checkout — the test will reveal which surfaces initialise it automatically.
