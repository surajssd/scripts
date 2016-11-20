#!/bin/bash
set -x

# export all the paths and variables

mkdir $HOME/go
echo "export GOPATH=\$HOME/work" >> ~/.bash_profile
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bash_profile
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bash_profile


export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
