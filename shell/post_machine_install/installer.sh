#!/bin/bash

set -x

sudo dnf -y update
sudo dnf -y install python-pip gcc-c++ hexchat @virtualization golang \
    vlc unzip qbittorrent vim python-devel ruby-devel vagrant \
    vagrant-libvirt httrack tuxtype2 hstr cmake rpm-build youtube-dl \
    gnome-tweak-tool python3-ipython percol python-virtualenvwrapper \
    docker git hg gcc make byobu nload htop libvirt-client xsel tig \
    pass gstreamer1-libav

sudo dnf -y groupinstall "Development Tools"

curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/setupgopath.sh | sh

===================================================================
# install gotools
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/install_gotools.sh | sh


#==================================================================
# url shortner
mkdir -p ~/.local/bin
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/shorturl.sh
chmod a+x ./shorturl.sh
mv ./shorturl.sh ~/.local/bin/

