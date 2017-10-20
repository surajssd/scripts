#!/bin/bash

set -x

# Install bash-completion so that CDPATH works
sudo dnf -y install bash-completion

###############################
# export all the paths and variables

cat ~/.bashrc | grep 'GOPATH'
if [ $? -ne 0 ]; then
    mkdir $HOME/go
    echo '
#################################
# Setting golang envs

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN:/usr/local/go/bin
export CDPATH=.:$GOPATH/src/github.com:$GOPATH/src

#################################
' | tee -a ~/.bashrc
    
fi

