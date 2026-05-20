---
description: Analyze unresolved review comments on the current branch's PR (or a given PR number), classify each as "needs change" or "leave as-is" with rationale, then apply fixes the user approves. Use when the user asks to review/triage/respond to PR comments, address review feedback, or work through reviewer suggestions.
argument-hint: [pr-number]
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh *), Bash(jq *), Agent, Read, Edit, Glob, Grep
---

Argument: $ARGUMENTS

If `$ARGUMENTS` contains a number, target that PR. Otherwise target the PR for the current branch.

## Phase 1 — Identify the PR

1. Resolve PR metadata. If `$ARGUMENTS` has a PR number use it as a positional; otherwise rely on current-branch resolution:

   ```bash
   gh pr view $PR_NUMBER_OR_EMPTY --json number,url,headRefName,baseRefName,author,headRepository,headRepositoryOwner,state
   ```

   If this fails or returns nothing, stop. Tell the user there is no PR to triage and suggest `/commit-push` to open one.

2. From that JSON capture: `number`, `url`, `headRepositoryOwner.login` (= owner), `headRepository.name` (= repo), `author.login` (= PR author).

3. Capture the viewer login (the human running this skill — used to filter their own comments):

   ```bash
   gh api user --jq .login
   ```

## Phase 2 — Gather comments

Run these two `gh` calls in parallel (single message, multiple Bash tool uses).

**A. Inline review threads (with resolved/outdated state) via GraphQL.** This is the only API that exposes `isResolved` and `isOutdated`:

```bash
gh api graphql -F owner="$OWNER" -F repo="$REPO" -F number="$NUMBER" -f query='
query($owner:String!,$repo:String!,$number:Int!) {
  repository(owner:$owner,name:$repo) {
    pullRequest(number:$number) {
      reviewThreads(first:100) {
        nodes {
          isResolved
          isOutdated
          isCollapsed
          comments(first:20) {
            nodes {
              databaseId
              path
              line
              originalLine
              diffHunk
              body
              author { login }
              createdAt
              url
            }
          }
        }
      }
    }
  }
}'
```

**B. General PR conversation comments** (issue-style, not file-anchored):

```bash
gh pr view $NUMBER --json comments
```

## Phase 3 — Filter

- **Inline threads**: drop the whole thread if `isResolved == true` OR `isOutdated == true`. Inside surviving threads, drop individual comments where `author.login == VIEWER_LOGIN`. Keep the thread anchored on the original reviewer comment so the context is intact.
- **General comments**: drop those where `author.login == VIEWER_LOGIN`. No resolved state exists for these.
- **Missing files**: if an inline comment's `path` does not exist in the working tree, do not spawn a subagent for it — mark it as `leave` with rationale "file no longer exists at this path".
- Track the skip tally: `{resolved: N, outdated: N, mine: N, missing_file: N}`.

If nothing survives the filter, print the tally and stop.

## Phase 4 — Analyze each surviving comment

Spawn one `Explore` subagent per surviving comment/thread, in parallel — single message with multiple `Agent` tool calls, **cap at 5 concurrent**. If there are more than 5, batch.

Each subagent gets a self-contained prompt of this shape (substitute real values):

> A reviewer left the following comment on PR #<N> (`<PR_URL>`).
>
> **File**: `<path>:<line>` *(omit this line for general PR comments)*
> **Reviewer**: `<login>`
> **Thread** *(oldest → newest; reviewer's original anchor first, then any back-and-forth)*:
>
> ```
> [<login> @ <createdAt>]
> <body>
>
> [<login> @ <createdAt>]
> <body>
> ...
> ```
>
> **Diff context the reviewer was looking at**:
>
> ```
> <diffHunk>
> ```
>
> Read the current state of `<path>` around line `<line>` (and any other files needed to understand the call). The code may have changed since the comment — verify against the *current* state, not the diff hunk. Decide whether this comment warrants a code change *right now*.
>
> Reply with **only** strict JSON, no prose:
>
> ```json
> {
>   "verdict": "change" | "leave" | "discuss",
>   "confidence": "high" | "medium" | "low",
>   "rationale": "<1-3 sentences>",
>   "proposed_change": "<concrete description of the edit, or null>",
>   "files_to_edit": ["<path>", ...]
> }
> ```
>
> Verdict guide:
> - `change` — reviewer is correct and the code should be edited.
> - `leave` — the comment is wrong, already addressed, or out of scope for this PR.
> - `discuss` — the comment is a legitimate question that needs a human reply, not a code change.

Collect the JSON verdicts in the main thread.

## Phase 5 — Report

Print one consolidated report. Numbered, grouped, scannable:

````
## PR #<N> — review comment triage

<URL>

Pulled <total> comments. Skipped <skipped> (<resolved> resolved, <outdated> outdated, <mine> yours, <missing> missing-file). Analyzed <analyzed>.

---

### 1. CHANGE  (high confidence)
**File**: `path/to/file.tsx:254`
**Reviewer**: <login>
> <reviewer comment body, quoted>

**Verdict**: <rationale>
**Proposed change**: <proposed_change>

---

### 2. LEAVE  (medium confidence)
**File**: `path/to/file.ts:198`
**Reviewer**: <login>
> <body>

**Verdict**: <rationale>

---

### 3. DISCUSS  (low confidence)
... (same shape, no proposed_change — suggest what to reply on GitHub)

---

(repeat for all analyzed comments — order: all CHANGE first, then DISCUSS, then LEAVE)
````

After the report, list just the `change` items as a numbered menu and ask:

> **Which should I apply?** Reply with `1,3` / `all` / `none`.

## Phase 6 — Apply approved fixes

On the user's reply:

1. Group approved items by file. For each file, Read once, then issue all Edits for that file.
2. After all edits, run `git status` and show the user what changed.
3. **Stop there.** Do not commit, do not push, do not post replies on GitHub. The user runs `/commit-push` separately when ready.

## Rules

- Never reply or react on GitHub from this skill. Read-only on GitHub; write-only locally.
- Never invoke this skill automatically — only when the user types `/pr-comments`.
- If the PR is on master/main or no PR exists, bail with a clear message.
- The reviewer's diff hunk is a snapshot; always verify against the *current* file before deciding `change` vs `leave`.
