#!/bin/bash

# edit conf files
alias vimrc='v ~/.vimrc'
alias bash_aliases='v ~/.bash_aliases'
alias k='kubectl'

# change zon tree:
# example: from zon1/pkg/svc `cz 2` -> zon2/pkg/svc
function cz ()
{
    local ORIGIN=`pwd`
    local DEST=${ORIGIN/zon[[:digit:]]/zon$1}
    cd $DEST
}

# zon diff:
# example: from zon1/pkg `zd 2 env.js` diff zon1/pkg/env.js & zon2/pkg/env.js
function zd ()
{
    local ORIGIN=`pwd`
    local DEST=${ORIGIN/zon[[:digit:]]/zon$1}
    if [ -z $2 ]
    then
        local FILES=$(cvsu | grep "^[AMOG]" | cut -d' ' -f2)
        for FILE in $FILES
        do
            `gvim -d ${FILE} ${DEST}/${FILE} > /dev/null`
        done
        echo 'done'
    else
        echo $2
        gvim -d $2 $DEST/$2
    fi
}

# figure out which services to release (run from within zon tree)
function file2host ()
{
    cdr && cd pkg && node system/scripts/file2host.js
}

function regex { gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}'; }

function j {
    local -a FILES=`rgrep --js $1 | sed 's/:.*$//' | uniq`
    `g $FILES`
}

alias cdp='cdr && cd pkg'

# cp a file from a different zon to the current one
# example: `cpz 2 pkg/svc/dca/test.js` copies from zon2 -> current 
function cpz {
    if [[ -z $1 ]]; then
        echo "Usage: \`cpz 2 pkg/svc/dca/test.js\` copies from zon2 -> current"
    else
        local DEST=`pwd`
        local ORIGIN=${DEST/zon[[:digit:]]/zon$1}
        cp $ORIGIN/$2 $DEST/$2
    fi
}

# fuzzy find by filename
function ff {
    find . -name *$1*
}

# remind myself of a way much faster than find . -inum
function finode {
    readarray data <<< `rt debugfs -R "ncheck $1" /dev/sda5 2>/dev/null`
    for index in ${!data[@]}; do
        echo ${data[index]}
    done
}

alias vrc="v $HOME/.vimrc"
alias gvrc="v $HOME/.gvimrc"
alias zrc="mvim $HOME/.zshrc"
alias omzconf="mvim $HOME/.oh-my-zsh"
alias cdr="cd \$(git rev-parse --show-toplevel)" # cd to git root
alias cdt="cd $HOME/triplewhale"
alias rgs="rg --no-heading --max-columns=150 $@"
alias n="v $HOME/notes.md"
alias ff="find . -maxdepth 1000 * | fzf --sync | v -o"

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
