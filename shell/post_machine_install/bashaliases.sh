#!/bin/bash

cd

cat ~/.bashrc | grep 'my aliases'
if [ $? -ne 0 ]; then

echo '
#=================================================================
# my aliases

# GIT related
alias gpum="'"git pull --ff upstream master"'"
alias gpom="'"git pull --ff origin master"'"
alias gcm="'"git checkout master"'"

function pr() {
    id=$1
    if [ -z $id ]; then
        echo "Need Pull request number as argument"
        return 1
    fi
    git fetch upstream pull/${id}/head:pr_${id}
    git checkout pr_${id}
    git rebase master -i
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
