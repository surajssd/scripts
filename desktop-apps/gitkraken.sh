#!/bin/bash

set -x

mkdir ~/softwares
cd ~/softwares
wget https://release.gitkraken.com/linux/gitkraken-amd64.tar.gz
sudo ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4

cd ~/softwares/gitkraken
curl -o ico.png http://img.informer.com/icons_mac/png/128/422/422255.png 


echo "
[Desktop Entry]
Name=GitKraken
Comment=Git Flow
Exec=/home/hummer/softwares/gitkraken/gitkraken
Icon=/home/hummer/softwares/gitkraken/ico.png
Terminal=false
Type=Application
Encoding=UTF-8
Categories=Utility;Development;
" | tee /home/hummer/.local/share/applications/gitkraken.desktop

