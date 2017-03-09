#!/bin/bash

set -x

# check if go is installed
which go
if [ $? -ne 0 ]; then
    # install go latest
    curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/pullgo.sh | sh

    # export all the paths and variables
    mkdir $HOME/go
    echo "export GOPATH=\$HOME/go" >> ~/.bashrc
    echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc
    echo "export GOBIN=\$GOPATH/bin" >> ~/.bashrc
    echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc


    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:/usr/local/go/bin
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
