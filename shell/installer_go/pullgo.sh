#!/bin/bash

if [ -z $version ]; then
    echo "Please provide the go version, by exporting variable 'version',
    export version=\"go1.10.2\""
    exit 1
fi

# check if git is installed, if not install it
if ! [ -x "$(command -v git)" ]; then
    echo "Installing git..."
    sudo dnf -y install git
fi


# check if wget is installed
if ! [ -x "$(command -v wget)" ]; then
    echo "Installing wget..."
    sudo dnf -y install wget
fi

mkdir -p /tmp/goinstall
cd /tmp/goinstall

url=https://dl.google.com/go/$version.linux-amd64.tar.gz

echo "Downloading from $url"
wget $url
if [ $? -ne 0 ]; then
    echo "Go downloading failed"
    exit 1
fi

echo "Uninstalling $(go version)"
sudo rm -rf /usr/local/go

echo "Installing new $version"
sudo tar -C /usr/local -xzf go*
sudo ln -s /usr/local/go/bin/go /usr/local/sbin/go
