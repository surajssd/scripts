#!/bin/bash

set -x

# check if go is installed
which go
if [ $? -ne 0 ]; then
    sudo dnf -y install golang

    ###############################
    # export all the paths and variables
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
    
    ###############################
fi

go get -u -v golang.org/x/tools/cmd/goimports
go get -u -v github.com/nsf/gocode
go get -u -v github.com/rogpeppe/godef
go get -u -v github.com/golang/lint/golint
go get -u -v github.com/kisielk/errcheck
go get -u -v golang.org/x/tools/cmd/oracle
go get -u -v github.com/tools/godep
go get -u -v github.com/lukehoban/go-outline
go get -u -v sourcegraph.com/sqs/goreturns
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v github.com/tpng/gopkgs
go get -u -v github.com/newhook/go-symbols
go get -u -v golang.org/x/tools/cmd/guru
go get -u -v github.com/cweill/gotests/...
go get -u github.com/Masterminds/glide
go get github.com/sgotti/glide-vc
