#!/bin/bash

set -x
#===================================================================
# rpm installead softwares
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf

su -c 'dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'

sudo dnf -y update
sudo dnf -y install python-pip gcc-c++ hexchat @virtualization vlc unzip qbittorrent vim python-devel ruby-devel vagrant vagrant-libvirt httrack tuxtype2 hstr cmake go rpm-build youtube-dl gnome-tweak-tool python3-ipython percol python-virtualenvwrapper

sudo dnf -y groupinstall "Development Tools"

curl -L git.io/sublimetext | sh

sudo dnf copr enable rommon/telegram
sudo dnf -y install telegram-desktop

#===================================================================
# create go workspace
mkdir $HOME/go

# export environment variables
export GOPATH=$HOME/go
echo 'export GOPATH=$HOME/go' >> ~/.bash_profile

export PATH=$PATH:$GOPATH/bin
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bash_profile



#===================================================================
# pip installed softwares
echo 'source virtualenvwrapper.sh' >> ~/.bashrc


#===================================================================
# Configuration files
cat > ~/.gitconfig <<EOF 
[user]
    name = Suraj Deshmukh
    email = surajssd009005@gmail.com
EOF

#===================================================================
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

#==================================================================
mkdir -p ~/.local/bin
cat > ~/.local/bin/shorturl <<EOF
#!/bin/env python

import sys
import requests

URL = 'http://api.bit.ly/v3/shorten'

data = {
    "login": "",
    "apiKey": "",
    "longURL": sys.argv[1],
    "format": "txt"
}

response = requests.get(URL, data)
print response.text
EOF
chmod a+x ~/.local/bin/shorturl
echo ">>>>> Goto https://bitly.com/a/settings/advanced"
echo ">>>>> and copy Login and API Key and put in "
echo ">>>>> ~/.local/bin/shorturl "

#===================================================================
# Install pathogen
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
./install.sh
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


#===================================================================

## Add new things here


#===================================================================
# install some other softwares


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
