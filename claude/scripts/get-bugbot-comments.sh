#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./get-bugbot-comments.sh
#   ./get-bugbot-comments.sh [OWNER] [REPO]
#
# Requirements:
#   - gh (GitHub CLI) authenticated
#   - jq
#
# Behavior:
#   - Finds the PR associated with the current branch (via gh)
#   - Fetches PR review comments (inline) + issue comments (conversation)
#   - Filters to likely "Cursor"/"Bugbot" comments by author login and/or body

OWNER="Triple-Whale"
REPO="${2:-}"

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "error: $1 not found"; exit 1; }; }
need_cmd gh
need_cmd jq

if ! gh auth status >/dev/null 2>&1; then
  echo "error: gh not authenticated (run: gh auth login)"
  exit 1
fi

# Determine owner/repo if not provided
if [[ -z "${OWNER}" || -z "${REPO}" ]]; then
  remote_url="$(git remote get-url origin 2>/dev/null || true)"
  if [[ -z "${remote_url}" ]]; then
    echo "error: OWNER/REPO not provided and could not infer from git remote origin"
    exit 1
  fi
  if [[ "${remote_url}" =~ github\.com[:/]{1}([^/]+)/([^/.]+)(\.git)?$ ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
  else
    echo "error: could not parse GitHub owner/repo from origin: ${remote_url}"
    exit 1
  fi
fi

API="repos/${OWNER}/${REPO}"

# Identify current branch
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ -z "${BRANCH}" || "${BRANCH}" == "HEAD" ]]; then
  echo "error: could not determine current branch"
  exit 1
fi

# Find PR for current branch (assumes at most one open PR allowed for the branch)
PR_JSON="$(gh pr view --json number,title,url,headRefName,baseRefName,state 2>/dev/null || true)"
if [[ -z "${PR_JSON}" || "${PR_JSON}" == "null" ]]; then
  echo "error: no PR found for current branch (${BRANCH})"
  exit 1
fi

PR_NUMBER="$(echo "${PR_JSON}" | jq -r '.number')"
PR_URL="$(echo "${PR_JSON}" | jq -r '.url')"
PR_TITLE="$(echo "${PR_JSON}" | jq -r '.title')"

echo "PR: #${PR_NUMBER} ${PR_TITLE}"
echo "URL: ${PR_URL}"
echo
#
# Unresolved Cursor bot review threads for a PR
# Requires: gh auth, jq
gh api graphql \
  -F owner="$OWNER" \
  -F name="$REPO" \
  -F number="$PR_NUMBER" \
  -f query='
    query($owner:String!, $name:String!, $number:Int!) {
      repository(owner:$owner, name:$name) {
        pullRequest(number:$number) {
          number
          url
          reviewThreads(first: 100) {
            nodes {
              id
              isResolved
              isOutdated
              comments(first: 50) {
                nodes {
                  id
                  url
                  path
                  line
                  author { login }
                  body
                }
              }
            }
          }
        }
      }
    }
  ' \
| jq -c '
  def between($s; $a; $b):
    ($s | capture("(?s)" + $a + "(?<m>.*?)" + $b).m // "");

  def locations($s):
    (between($s; "<!-- LOCATIONS START\\n"; "\\nLOCATIONS END -->")
     | split("\n") | map(select(length>0)));

  def description($s):
    (between($s; "<!-- DESCRIPTION START -->\\n"; "\\n<!-- DESCRIPTION END -->")
     | gsub("^\\s+|\\s+$";""));

  .data.repository.pullRequest.reviewThreads.nodes
  | map(
      select(.isResolved == false)
      | .comments.nodes as $cs
      | ($cs[0]? // {}) as $root
      | select(($root.author.login // "") as $login
      | $login == "cursor" or $login == "tw-orion")
      | {
          author: $root.author,
          path: $root.path,
          line: $root.line,
          description: (
            description($root.body // "") as $d
            | if $d == "" then ($root.body // "") else $d end
          ),
          locations: locations($root.body // ""),
          replies: (
            ($cs[1:] // [])
            | map({
                author: .author.login,
                createdAt: (.createdAt // null),
                body: .body
              })
          )
        }
    )
  | .[]
'
