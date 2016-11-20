#!/bin/bash
set -x

# should have vagrant-libvirt installed
wget https://github.com/kubernetes/kubernetes/releases/download/v1.4.4/kubernetes.tar.gz
tar xvzf kubernetes.tar.gz 
cd kubernetes/

export KUBERNETES_PROVIDER=vagrant
export KUBERNETES_MEMORY=2048
export NUM_NODES=2



./cluster/kube-up.sh

# putting kubectl in the path
mkdir -p ~/.local/bin/
cp ./platforms/linux/amd64/kubectl ~/.local/bin/

