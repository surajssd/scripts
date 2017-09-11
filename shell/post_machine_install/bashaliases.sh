#!/bin/bash

cd

cat ~/.bashrc | grep 'aliases'
if [ $? -ne 0 ]; then

echo '
#=================================================================
# aliases

# GIT related
alias gpm="git pull --ff upstream master"
alias gcm="git checkout master"

function pr() {
    id=$1
    if [ -z $id ]; then
        echo "Need Pull request number as argument"
        return 1
    fi
    git fetch upstream pull/${id}/head:pr_${id}
    git checkout pr_${id}
}

# Kubernetes related
alias k=kubectl

# Vim related
alias vim=nvim
alias vi=nvim

#=================================================================
' | tee -a ~/.bashrc

fi
source ~/.bashrc
