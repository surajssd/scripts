#!/bin/bash
set -x
echo "Install latest docker"

# add fastest mirror
cat /etc/dnf/dnf.conf | grep 'fastestmirror'
if [ $? -ne 0 ]; then
    echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
fi

sudo yum -y update
curl -fsSL https://get.docker.com/  | sh
sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable --now docker
logout
