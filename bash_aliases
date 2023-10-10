#!/bin/bash

function regex { gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}'; }

# remind myself of a way much faster than find . -inum
function finode {
    readarray data <<< `rt debugfs -R "ncheck $1" /dev/sda5 2>/dev/null`
    for index in ${!data[@]}; do
        echo ${data[index]}
    done
}

alias bash_aliases='v ~/.bash_aliases'
alias vrc="v $HOME/.vimrc"
alias gvrc="v $HOME/.gvimrc"
alias zrc="mvim $HOME/.zshrc"
alias omzconf="mvim $HOME/.oh-my-zsh"

alias rgs="rg --no-heading --max-columns=150 $@"
alias n="v $HOME/notes.md"
alias ff="find . -maxdepth 1000 * | fzf --sync | v -o"

# TW cd's
alias cdr="cd \$(git rev-parse --show-toplevel)" # cd to git root
alias cdt="cd $HOME/triplewhale"
alias cdb="cd $HOME/triplewhale/backend"
alias cdp="cd $HOME/triplewhale/backend/packages"
alias cdc="cd $HOME/triplewhale/client"
alias cdd="cd $HOME/triplewhale/devops"

# Git
alias g="git $@"
alias ga="git add ."
alias gbd="git branch --delete $@"
alias gc="git checkout $@"
alias gcm="git checkout master"
alias gd="git difftool"
alias gdh="git difftool HEAD"
alias gds="git difftool --staged"
alias gdm="git difftool origin/master"
alias gp="git pull $@"
alias gs="git status"
alias gmm="git co master && git pull && git co - && git merge master"
alias gpsu="git push --set-upstream origin \$(current_branch)"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

source ~/.tw_cli_completion

# random
alias k="kubectl $@"

