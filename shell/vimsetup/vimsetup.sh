#!/bin/bash

# make sure your golang is properly setup
sudo dnf -y install golang git

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

# make sure you have gotools are pulled up
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/install_gotools.sh | sh


which nvim
if [ $? -ne 0 ]; then
	sudo dnf -y install neovim ctags-etags
fi

echo '
alias vim=nvim
' | tee -a ~/.bashrc

# Download the init.vim
mkdir -p $HOME/.config/nvim
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/vimsetup/init.vim -o $HOME/.config/nvim/init.vim

# install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Setup all the nvim setup
echo "Run ':GoInstallBinaries' in your vim when you open it!"
nvim -c ':GoInstallBinaries' -c ':q!'
nvim -c ':PlugInstall' -c ':q!'

