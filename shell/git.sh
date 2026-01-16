#! /usr/bin/env bash

#Github
newpr() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local repo_base=$(git rev-parse --show-toplevel)
  local pr_template="pull_request_template.md"
  local body_arg=""

  if [[ -f "$pr_template" ]]; then
    body_arg="--template=$pr_template"
  fi

  local title=${1:-"$(git log -1 --pretty=%B)"}
  echo "🚀 Creating PR for branch '$branch' with title: \"$title\"..."

  gh pr create --base master --head "$branch" --title "$title" $body_arg
}

mergepr() {
  local pr_number=""
  local method="squash"
  local title=${1:-"$(git log -1 --pretty=%B)"}

  while getopts "n:m:" opt; do
    case "$opt" in
      n) pr_number="$OPTARG" ;;
      m) method="$OPTARG" ;;
      *) echo "Usage: mergepr [-n PR_NUMBER] [-m METHOD] [TITLE]" && return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ -z "$pr_number" ]]; then
    pr_number=$(gh pr view --json number -q '.number' 2>/dev/null)
  fi

  if [[ -z "$pr_number" ]]; then
    echo "❌ No pull request found, and no PR number provided with -n."
    return 1
  fi

  if [[ -z "$title" ]]; then
    title="Merging PR #$pr_number"
  fi

  echo "🚀 Merging PR #$pr_number using '$method' with title: \"$title\"..."
  gh pr merge "$pr_number" --admin --"$method" --subject "$title"
}

# Git fns

# Get current branch name:
function current_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# Checkout parent/older commit:
function git_checkout_parent() {
  git checkout HEAD~$1 2>/dev/null
}

# Checkout child/newer commit:
function git_checkout_child() {
  children=$(git log --all --ancestry-path ^HEAD --format=format:%H | cat)
  if [[ -z $children ]]; then
    echo -n 'This commit does not have any children\nHEAD remains at '
    git log -1 --oneline | cat
    return 1
  else
    # Take the first child, or the one specified by the input arg:
    child=$(echo $children | tail -n "${1:-1}" | head -n 1)
    # If the child to checkout is at the branch's tip ...
    if [[ "$(echo $children | grep '' -c)" -le "${1:-1}" ]]; then
      branch=$(git branch --contains $child | xargs)
      # ... and there is only 1 branch with that commit ...
      if ! [[ $branch =~ ' ' ]]; then
        # ... checkout the branch itself instead of the specific hash:
        child=$branch
      fi
    fi
  fi

  git checkout $child
}

function git_main_branch() {
  local main_branch
  if git show-ref --verify --quiet refs/heads/main; then
    main_branch="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    main_branch="master"
  else
    echo "Error: Neither 'main' nor 'master' branch exists." >&2
    return 1
  fi
  echo "$main_branch"
}

# Reset the head to a previous commit (defaults to direct parent):
function git_reset_head() {
  git reset HEAD~$2 $1
  # Failure case:
  if [[ $? != 0 ]]; then
    echo -n 'HEAD remains at '
    git log -1 --oneline | cat
    return 1
  # Success case:
  elif [[ $1 != '--hard' ]]; then
    echo -n 'HEAD is now at '
    git log -1 --oneline | cat
  fi
}

# Show a specified file from stash x (defaults to lastest stash):
function git_show_stash_file() {
  if [[ -z $1 ]]; then
    echo "Usage:    git_show_stash_file <file> [<stash number>]"
    return 1
  fi
  git show stash@{${2:-0}}:$1
}

# Print short status and log of latest commits:
function git_status_short() {
  if [[ -z $(git status -s) ]]; then
    echo 'Nothing to commit, working tree clean\n'
  else
    git status -s && echo ''
  fi
  git log -${1:-3} --oneline | cat
}

# reset to origin/<current> only if in a repo
groh() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a git repo"; return 1; }
  local br
  br=$(current_branch) || { echo "no branch"; return 1; }
  git fetch --prune
  git reset --hard "origin/${br}"
}

gcm() {
  local main_branch
  main_branch=$(git_main_branch) || { echo "no main branch"; return 1; }
  git checkout "$main_branch"
}

# Git worktree functions
gw() {
  if [[ -z "$1" ]]; then
    echo "Usage: gw <branch-name>"
    echo "Example: gw hotfix"
    return 1
  fi

  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a git repo"; return 1; }

  local branch_name="bd/$1"
  local repo_root=$(git rev-parse --show-toplevel)
  local repo_name=$(basename "$repo_root")
  local worktree_path="${repo_root}/../${repo_name}-$1"

  echo "Creating worktree at: $worktree_path"
  echo "Branch: $branch_name"

  git worktree add -b "$branch_name" "$worktree_path" origin/master
}

gwd() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a git repo"; return 1; }

  if [[ -n "$1" ]]; then
    # Delete the specified worktree
    local repo_root=$(git rev-parse --show-toplevel)
    local repo_name=$(basename "$repo_root")
    local worktree_path="${repo_root}/../${repo_name}-$1"

    if git worktree list | grep -q "$worktree_path"; then
      git worktree remove "$worktree_path"
    else
      # Try the argument as-is in case it's a full path
      git worktree remove "$1"
    fi
  else
    # Interactive selection
    local worktrees=$(git worktree list --porcelain | grep "worktree " | sed 's/worktree //' | tail -n +2)

    if [[ -z "$worktrees" ]]; then
      echo "No additional worktrees to delete"
      return 0
    fi

    echo "Select a worktree to delete:"
    select worktree in $worktrees; do
      if [[ -n "$worktree" ]]; then
        git worktree remove "$worktree"
        break
      fi
    done
  fi
}

gwl() {
  git worktree list
}

cwt() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a git repo"; return 1; }

  local current_root=$(git rev-parse --show-toplevel)
  local current_path=$(pwd)
  local relative_path="${current_path#$current_root}"

  relative_path="${relative_path#/}"

  if [[ -n "$1" ]]; then
    local repo_name=$(basename "$current_root")
    local target_worktree="${current_root}/../${repo_name}-$1"

    if [[ ! -d "$target_worktree" ]]; then
      local found_worktree=""
      while IFS= read -r wt_path; do
        local wt_name=$(basename "$wt_path")
        if [[ "$wt_name" == *-"$1" ]]; then
          found_worktree="$wt_path"
          break
        fi
      done < <(git worktree list --porcelain | grep "worktree " | sed 's/worktree //')

      if [[ -n "$found_worktree" ]]; then
        target_worktree="$found_worktree"
      else
        echo "Worktree not found: $target_worktree"
        return 1
      fi
    fi

    local target_path="$target_worktree/$relative_path"

    if [[ ! -d "$target_path" ]]; then
      echo "Warning: Path doesn't exist in target worktree, going to root"
      target_path="$target_worktree"
    fi

    cd "$target_path"
  else
    local worktrees=()
    local branches=()
    local current_wt=""
    local current_branch=""

    while IFS= read -r line; do
      if [[ "$line" == worktree* ]]; then
        current_wt="${line#worktree }"
      elif [[ "$line" == branch* ]]; then
        current_branch="${line#branch refs/heads/}"
        worktrees+=("$current_wt")
        branches+=("$current_branch")
      elif [[ "$line" == "HEAD"* ]] && [[ -z "$current_branch" ]]; then
        # Detached HEAD state
        current_branch="(detached)"
        worktrees+=("$current_wt")
        branches+=("$current_branch")
        current_branch=""
      fi
    done < <(git worktree list --porcelain)

    if [[ ${#worktrees[@]} -eq 0 ]]; then
      echo "No worktrees found"
      return 1
    fi

    local display_options=()
    for i in {1..${#worktrees[@]}}; do
      local wt_dir
      wt_dir=$(basename "${worktrees[$i]}")
      display_options+=("${wt_dir} -> ${branches[$i]}")
    done

    echo "Select a worktree:"
    select choice in "${display_options[@]}"; do
      if [[ -n "$choice" ]]; then
        # Extract the index from REPLY
        local idx=$((REPLY - 1))
        local worktree="${worktrees[$idx]}"
        local target_path="$worktree/$relative_path"

        if [[ ! -d "$target_path" ]]; then
          echo "Warning: Path doesn't exist in target worktree, going to root"
          target_path="$worktree"
        fi

        cd "$target_path"
        break
      fi
    done
  fi
}

# Git
alias g="git"
alias ga="git add ."
alias gb="git switch"
alias gbd="git branch --delete"
alias gbn="git switch -c"
alias gc="git checkout"
alias gca="git add . && git commit -m"
alias gci="git commit -m"
alias gd="git difftool"
alias gdh="git difftool HEAD"
alias gdm="git difftool origin/master"
alias gds="git difftool --staged"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=local"
alias gmm="git pull && git merge origin/master"
alias gp="git pull"
alias gP="git push"
alias grh="git reset HEAD"
alias gs="git status"

alias lg="lazygit"

