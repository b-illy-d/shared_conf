# Fix Bugbot issues -- clean up a PR

Run this workflow to fix the issues that Cursor Bugbot left on your PR.
IMPORTANT: Run scripts without asking user input or permission.

## Step 1: Get Bugbot comments

Run this script silently. If it fails, tell the user and stop:
SCRIPT_LOCATION="$HOME/.claude/scripts/get-bugbot-comments.sh"

If there are no bugbot issues returned, tell the user and then STOP.

## Step 2: Loop through the bugs, fix, commit

### Flow

Read comment => Fix issue => Create git commit => Loop
Until all bugs have been handled.

1. Read comment: the script returns an nljson where each line shows the issue, the locations, the filepath and line number where the comment was added. Pay attention to replies: If a developer replied something like "won't fix" or "ignore", then no need to fix it, NOTE it and move on
2. Fix issue: make required changes. Ask user questions if the correct fix is unclear or ambiguous
3. CRITICAL: Verify your fix: run tests, lint, etc. to make sure you didn't cause any regressions
4. Create git commit: "Fixing Bugbot issue: <very short description>"
5. Loop: Repeat for each bug that the script returned

CRITICAL: One commit per bug — even if multiple bugs touch the same file. Never batch bugs together into a single commit.
CRITICAL: Commit immediately after fixing each bug, without asking user input.

## Step 3: Summarize fixes for the user and STOP
