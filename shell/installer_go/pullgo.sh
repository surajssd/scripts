#!/bin/bash

set -x

sudo dnf -y install git
# check if wget is installed
which wget
if [ $? -ne 0 ]; then sudo dnf -y install wget; fi

mkdir -p /tmp/goinstall
cd /tmp/goinstall

wget -O /tmp/golangversion https://golang.org/dl/
wget $(grep -r linux /tmp/golangversion  | grep amd64 | grep "storage.googleapis.com" | head -1 | grep -Eo 'https://[^ ">]+')

sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go*
sudo ln -s /usr/local/go/bin/go /usr/local/sbin/go
