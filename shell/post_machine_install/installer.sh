#!/bin/bash

set -x
#===================================================================
# add fastest mirror
cat /etc/dnf/dnf.conf | grep 'fastestmirror'
if [ $? -ne 0 ]; then
    echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
fi

# rpm installead softwares
su -c 'dnf -y install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'

sudo dnf -y update
sudo dnf -y install python-pip gcc-c++ hexchat @virtualization vlc unzip qbittorrent vim python-devel ruby-devel vagrant vagrant-libvirt httrack tuxtype2 hstr cmake rpm-build youtube-dl gnome-tweak-tool python3-ipython percol python-virtualenvwrapper docker git hg gcc make byobu nload htop libvirt-client

sudo dnf -y groupinstall "Development Tools"

# install go latest
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/pullgo.sh | sh

#===================================================================
# create go workspace
mkdir $HOME/go
echo "export GOPATH=\$HOME/work" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc


export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

#===================================================================
# install gotools
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/install_gotools.sh | sh

#===================================================================
# pip installed softwares


#===================================================================
# Configuration files
cd
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/configs/.vimrc
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/configs/.gitconfig

#==================================================================
# url shortner
mkdir -p ~/.local/bin
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/shorturl.sh
chmod a+x ./shorturl.sh
mv ./shorturl.sh ~/.local/bin/

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

#===================================================================

## Add new things here


#===================================================================
# install some other softwares


cd
git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt
echo '#=================================================================' >> ~/.bashrc
echo 'source ~/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc
echo 'GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc
echo '#' >> ~/.bashrc


git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
