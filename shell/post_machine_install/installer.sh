#!/bin/bash

set -x
#===================================================================
# rpm installead softwares
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf

su -c 'dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'

sudo dnf -y update
sudo dnf -y install python-pip gcc-c++ hexchat @virtualization vlc unzip qbittorrent vim python-devel ruby-devel vagrant vagrant-libvirt httrack tuxtype2 hstr cmake rpm-build youtube-dl gnome-tweak-tool python3-ipython percol python-virtualenvwrapper

sudo dnf -y groupinstall "Development Tools"

# install go latest
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/pullgo.sh | sh

#===================================================================
# create go workspace
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/setupgopath.sh | sh

#===================================================================
# install gotools
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/install_gotools.sh | sh

#===================================================================
# pip installed softwares
echo 'source virtualenvwrapper.sh' >> ~/.bashrc


#===================================================================
# Configuration files
cd
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/configs/.vimrc
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/configs/.gitconfig

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
