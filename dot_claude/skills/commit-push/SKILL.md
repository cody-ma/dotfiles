---
description: Stage, commit, push, and create or update a PR. Use when the user asks to commit, push, ship, open a PR, or update an existing PR.
argument-hint: [new|amend|feature-name]
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh *), Agent
---

Argument: $ARGUMENTS

If an argument is provided, only stage files related to that feature. Otherwise, infer what to commit from conversation context or `git status`.

## Rules

- Always include Potential Risk, Worst Case Incident, or Testing Strategy sections in new commit messages
- **NEVER hard-wrap prose lines.** This applies to commit message bodies, PR descriptions, and any free-form text written via HEREDOC. Each paragraph is exactly **one physical line** — no manual breaks at 72/80/100 columns. The user's tooling (GitHub, terminals, editors) wraps long lines on display; hard wrapping in the source corrupts that. Insert a `\n` only to separate paragraphs or section headings, never mid-paragraph.

  **Wrong** (hard-wrapped at ~72 cols):
  ```
  The empty-state CTA on the agent preview panel inherited the PDS-default
  button weight of 400, which read as too thin against the rest of the
  panel typography. Wraps the local Button in a styled component that
  bumps font-weight to 500.
  ```

  **Right** (one line per paragraph, no manual breaks):
  ```
  The empty-state CTA on the agent preview panel inherited the PDS-default button weight of 400, which read as too thin against the rest of the panel typography. Wraps the local Button in a styled component that bumps font-weight to 500.
  ```

  Lists, code blocks, and section headings still use newlines as normal — the rule is specifically about prose paragraphs.

## Phase 1 — Commit

1. Run in parallel: `git status`, `git diff`, `git branch --show-current`

2. **Determine commit mode** (create vs amend):
   - If `$ARGUMENTS` contains the word "new" → **create mode** (skip detection)
   - If `$ARGUMENTS` contains the word "amend" → **amend mode** (skip detection)
   - Otherwise, detect automatically:
     - Run `git rev-list --count HEAD ^master 2>/dev/null || git rev-list --count HEAD ^main 2>/dev/null` to count commits ahead of base branch
     - If **0 commits ahead** (or currently on master/main) → **create mode**
     - If **1+ commits ahead** → **amend mode**

3. **Create mode** (new commit):

   a. If on master/main, create and checkout a new feature branch before committing.

   b. Stage relevant files (never stage secrets like .env or credentials).

   c. Commit using HEREDOC format (NEVER use `git commit -m`). Each `<body>`, `<what could go wrong>`, and `<how tested>` placeholder is a **single unbroken physical line** — do not insert mid-paragraph newlines, regardless of length:

   ```bash
   git commit -F - <<'EOF'
   <type>(<scope>): <description>

   <body — one line, no manual wrapping>

   **AI Usage**
   Pair programmed with Claude

   **Potential Risk**
   <what could go wrong — one line, no manual wrapping>

   Worst Case Incident: SEV-<1-4>

   **Testing Strategy**
   <how tested — one line, no manual wrapping>
   EOF
   ```

   Types: feat, fix, chore, docs, style, refactor, perf, test, build, ci, revert
   Severity: SEV-1 (critical) → SEV-4 (minor)

4. **Amend mode** (amend existing commit):

   a. Stage relevant files (never stage secrets like .env or credentials).

   b. Read the current commit message: `git log -1 --format=%B`

   c. Compare the **full diff** of the branch against the base (`git diff master...HEAD` or `git diff main...HEAD`) with the existing commit message. Decide:
      - If the existing message already accurately describes the full set of changes → amend with `--no-edit`
      - If the new changes meaningfully alter the scope, purpose, or risk of the commit → rewrite the commit message to reflect the **entire** set of changes (not just the new delta), then amend with the updated message using HEREDOC format:

      ```bash
      git commit --amend -F - <<'EOF'
      <updated commit message following the same format as create mode>
      EOF
      ```

## Phase 2 — Push & PR

5. **Detect whether a PR already exists** for the current branch:
   - Run `gh pr view --json state -q .state 2>/dev/null`
   - If the command fails or returns nothing → **create PR**
   - If it returns a state (e.g. OPEN, DRAFT) → **update PR**

6. **Create PR** (no existing PR):

   a. Push the branch:

   ```bash
   git push -u origin $(git rev-parse --abbrev-ref HEAD)
   ```

   b. Create a draft PR:

   ```bash
   gh pr create -a @me --fill --base master --draft
   ```

   c. Open PR in browser and return URL: `gh pr view --web`

7. **Update PR** (PR already exists):

   a. Force push the branch:

   ```bash
   git push -f origin $(git rev-parse --abbrev-ref HEAD)
   ```

   b. If the commit message was rewritten in step 4c, also update the PR title and body to match:
      - Fetch the current PR title/body: `gh pr view --json title,body`
      - Compare against the new commit message and full diff — if the PR description no longer accurately reflects the changes, update it:

      Each prose paragraph in `<updated body>` is a **single unbroken physical line** — no manual newlines mid-paragraph:

      ```bash
      gh pr edit --title "<updated title>" --body "$(cat <<'EOF'
      <updated body — paragraphs are one line each, no manual wrapping>
      EOF
      )"
      ```

   c. Open existing PR in browser and return URL: `gh pr view --web`

8. After pushing, launch the `buildkite-monitor` agent in the background to monitor the build and automatically fix any CI failures:
   - Use the Agent tool with `subagent_type: buildkite-monitor`, `run_in_background: true`, `mode: "auto"`
   - In the prompt, tell the agent which branch and PR to monitor
   - Compute the status file path from the current branch: `tmp/buildkite-monitor-<branch-slug>.md` (branch name with `/` replaced by `-`). The buildkite-monitor writes live progress updates to this file throughout its run (polling state, failure counts, current phase, last-updated timestamp).
   - Tell the user the CI monitor is running in the background, share the **status file path**, and let them know they can ask for status anytime (or check the file directly).
   - **Proactively check the status file yourself** when:
     - The user asks anything about CI, the build, or the agent
     - Significant time has passed since the agent started and the user is waiting
     - Before reporting "done" on any follow-up work that depends on CI passing
   - When reading the status file, note the `Last updated` timestamp. If it has not advanced in more than ~2 minutes while the build is still running, treat the agent as dead and relaunch it — the harness exposes no in-flight transcript for background subagents, so the status file is the only reliable liveness signal.
