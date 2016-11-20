#!/bin/bash

set -x

###############################
# create all the files

cat > ~/.gitconfig <<EOF 
[user]
    name = Suraj Deshmukh
    email = surajssd009005@gmail.com
[color]
  diff = auto
  status = auto
  branch = auto
  interactive = auto
  ui = true
  pager = true
EOF


cat > ~/.vimrc <<EOF
" pathogen will load the other modules
execute pathogen#infect()

" we want to tell the syntastic module when to run
" we want to see code highlighting and checks when  we open a file
" but we don't care so much that it reruns when we close the file
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" we also want to get rid of accidental trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" tell vim to allow you to copy between files, remember your cursor
" position and other little nice things like that
set viminfo='100,\"2500,:200,%,n~/.viminfo

set nu
set expandtab
set tabstop=4
set shiftwidth=4
set clipboard=unnamed


" use goimports for formatting
let g:go_fmt_command = "goimports"

" turn highlighting on
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

" Open go doc in vertical window, horizontal, or tab
au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
au Filetype go nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
au Filetype go nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>
EOF


###############################
# install the basic required softwares

echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf

sudo dnf -y update
# git for go, wget to pull go, python2 for pip and percol
# cmake, gcc, gcc-c++, python-devel, make for vim plugin installer
sudo dnf -y install git wget vim python2 cmake gcc-c++ gcc python-devel make \
                    percol byobu nload

wget https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.7.linux-amd64.tar.gz

###############################
# export all the paths and variables

mkdir $HOME/work
echo "export GOPATH=\$HOME/work" >> ~/.bash_profile
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bash_profile 
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bash_profile


export GOPATH=$HOME/work
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
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
