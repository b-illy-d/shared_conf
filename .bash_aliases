#!/bin/bash

# edit conf files
alias vimrc='g ~/.vimrc'
alias bash_aliases='g ~/.bash_aliases'
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
    local DEST=`pwd`
    local ORIGIN=${DEST/zon[[:digit:]]/zon$1}
    cp $ORIGIN/$2 $DEST/$2
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
