#!/bin/bash

set -x

which docker-machine-driver-kvm2
if [ $? -ne 0 ]; then
    sudo sh -c 'curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 && 
                chmod +x docker-machine-driver-kvm2 && 
                sudo mv docker-machine-driver-kvm2 /usr/bin/'
fi

sudo dnf install -y libvirt qemu-kvm
sudo usermod -aG libvirt $USER
newgrp libvirt
