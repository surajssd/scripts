#!/bin/bash
set -x

# pull the latest releases
wget https://github.com/kubernetes/kubernetes/releases/download/v1.5.1/kubernetes.tar.gz
tar xvzf kubernetes.tar.gz
cd kubernetes/

export KUBERNETES_PROVIDER=vagrant

# RAM in MB for each machine
export KUBERNETES_MEMORY=2048
# Number of worker nodes
export NUM_NODES=2



./cluster/kube-up.sh

# putting kubectl in the path
mkdir -p ~/.local/bin/
cp ./platforms/linux/amd64/kubectl ~/.local/bin/

