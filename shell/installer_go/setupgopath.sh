#!/bin/bash

set -x

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

#################################
' | tee -a ~/.bashrc
    
    export GOPATH=$HOME/go
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:$GOBIN:/usr/local/go/bin
fi

