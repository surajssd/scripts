#!/bin/bash

set -x

###############################
# create all the files
cd
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/configs/.vimrc
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/configs/.gitconfig


###############################
# install the basic required softwares

echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf

sudo dnf -y update
# git for go, wget to pull go, python2 for pip and percol
# cmake, gcc, gcc-c++, python-devel, make for vim plugin installer
sudo dnf -y install git wget vim python2 cmake gcc-c++ gcc python-devel make \
                    percol byobu nload

# install go latest
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/pullgo.sh | sh
###############################
# export all the paths and variables
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/setupgopath.sh | sh

###############################
# Install gotools

go get github.com/tools/godep


###############################
# clone henge
cd
mkdir -p $GOPATH/src/github.com/redhat-developer
cd $GOPATH/src/github.com/redhat-developer
git clone https://github.com/surajssd/henge
cd henge/
git remote add upstream https://github.com/redhat-developer/henge
git pull --ff upstream master

###############################
# clone kompose
cd
mkdir -p $GOPATH/src/github.com/skippbox
cd $GOPATH/src/github.com/skippbox
git clone https://github.com/surajssd/kompose.git
cd kompose
git remote add upstream https://github.com/skippbox/kompose
git pull --ff upstream master


#===================================================================
# Install pathogen
cd
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install vim-sensible
git clone git://github.com/tpope/vim-sensible.git ~/.vim/bundle/vim-sensible

# Install syntastic
git clone https://github.com/scrooloose/syntastic.git ~/.vim/bundle/syntastic

# Install vim-go
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go

# Install YouCompleteMe (requires building)
git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
cd ~/.vim/bundle/YouCompleteMe
git submodule update --init --recursive
./install.py
cd

# goimports
go get -u golang.org/x/tools/cmd/goimports

# gocode
go get -u github.com/nsf/gocode

# godef
go get -u github.com/rogpeppe/godef

# golint
go get -u github.com/golang/lint/golint

# errcheck
go get -u github.com/kisielk/errcheck

# oracle
go get -u golang.org/x/tools/cmd/oracle

##
echo "Run ':GoInstallBinaries' in your vim when you open it!"
vim -c ':GoInstallBinaries' -c ':q!'

###############################
# install other things

cd
git clone https://github.com/pindexis/qfc $HOME/.qfc
echo '#=================================================================' >> ~/.bashrc
echo '[[ -s "$HOME/.qfc/bin/qfc.sh" ]] && source "$HOME/.qfc/bin/qfc.sh"' >> ~/.bashrc
echo '#' >> ~/.bashrc


git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt
echo '#=================================================================' >> ~/.bashrc
echo 'source ~/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc
echo 'GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc
echo '#' >> ~/.bashrc


git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
