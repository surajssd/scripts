#!/bin/bash

set -x

VERSION=1.9

# check if wget is installed
which wget
if [ $? -ne 0 ]; then sudo dnf -y install wget; fi

mkdir -p ~/Downloads
cd ~/Downloads

wget https://storage.googleapis.com/golang/go$VERSION.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go$VERSION.linux-amd64.tar.gz
