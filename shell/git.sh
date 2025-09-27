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
  git rev-parse --abbrev-ref HEAD
}

# Checkout parent/older commit:
function git_checkout_parent() {
  git checkout HEAD~$1
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

# Git
alias g="git"
alias ga="git add ."
alias gbd="git branch --delete"
alias gc="git checkout"
alias gb="git switch"
alias gbn="git switch -c"
alias gd="git difftool"
alias gdh="git difftool HEAD"
alias gds="git difftool --staged"
alias gdm="git difftool origin/master"
alias gp="git pull"
alias gs="git status"
alias gmm="git pull && git merge origin/master"
alias gpsu="git push --set-upstream origin \$(current_branch)"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=local"
alias gci="git commit -m"
alias gca="git add . && git commit -m"
alias groh="git reset origin/$(current_branch) --hard"
alias grh="git reset HEAD"
alias lg="lazygit"

