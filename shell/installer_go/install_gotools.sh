#!/bin/bash

set -x

# check if go is installed
which go
if [ $? -ne 0 ]; then
    sudo dnf -y install golang
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
go get -u -v github.com/Masterminds/glide
go get -u -v github.com/sgotti/glide-vc
go get -u -v github.com/alecthomas/gometalinter
go get -u -v github.com/jstemmer/gotags
go get -u -v github.com/klauspost/asmfmt/cmd/asmfmt
go get -u -v github.com/fatih/motion
go get -u -v github.com/fatih/gomodifytags
go get -u -v github.com/zmb3/gogetdoc
go get -u -v github.com/josharian/impl
go get -u -v github.com/dominikh/go-tools/cmd/keyify

