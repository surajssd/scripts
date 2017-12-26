#!/bin/bash

set -x

cd /usr/local/sbin

# install diffapply script
sudo curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/diffapply.sh
sudo chmod +x diffapply.sh

# install update-oc script
sudo curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/install_k8s_tools/update-oc
sudo chmod +x update-oc

# install update-minishift script
sudo curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/install_k8s_tools/update-minishift
sudo chmod +x update-minishift

# install update-kubectl script
sudo curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/install_k8s_tools/update-kubectl
sudo chmod +x update-kubectl

# install update-minikube script
sudo curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/install_k8s_tools/update-minikube
sudo chmod +x update-minikube
