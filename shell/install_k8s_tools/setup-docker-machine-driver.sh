#!/bin/bash

set -x

which docker-machine-driver-kvm
if [ $? -ne 0 ]; then
    sudo sh -c 'curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-centos7 > /usr/local/bin/docker-machine-driver-kvm
    chmod +x /usr/local/bin/docker-machine-driver-kvm'
fi

sudo dnf install -y libvirt qemu-kvm
sudo usermod -aG libvirt $USER
newgrp libvirt
