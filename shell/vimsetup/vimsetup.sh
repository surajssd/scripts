#!/bin/bash
set -x

curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/fastmirror.sh | sh

# install all the dnf based dependencies
sudo dnf -y install golang git neovim ctags-etags

# setup gopath
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/setupgopath.sh | sh

# make sure you have gotools are pulled up
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/install_gotools.sh | sh

# make nvim as alias for vim and vi
cat ~/.bashrc | grep 'nvim'
if [ $? -ne 0 ]; then
    echo '
alias vim=nvim
alias vi=nvim
' | tee -a ~/.bashrc
fi

# Download the init.vim
mkdir -p $HOME/.config/nvim
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/vimsetup/init.vim -o $HOME/.config/nvim/init.vim

# install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# source bashrc
source ~/.bashrc

# Setup all the nvim setup
echo "Run ':GoInstallBinaries' in your vim when you open it!"
nvim -c ':GoInstallBinaries' -c ':q!'
nvim -c ':PlugInstall' -c ':q!'

