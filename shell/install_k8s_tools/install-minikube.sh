#!/bin/bash

set -x

curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/install_k8s_tools/setup-docker-machine-driver.sh | sh


which minikube
if [ $? -ne 0 ]; then
    mkdir -p ~/.local/bin/
    cd ~/.local/bin/
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.22.2/minikube-linux-amd64 && chmod +x minikube 
    cd
fi

