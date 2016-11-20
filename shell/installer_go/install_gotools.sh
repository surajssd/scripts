#!/bin/bash

set -x

# check if go is installed
which go
if [ $? -ne 0 ]; then
    # install go latest
    curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/pullgo.sh | sh

    # export all the paths and variables
    curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/setupgopath.sh | sh
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
