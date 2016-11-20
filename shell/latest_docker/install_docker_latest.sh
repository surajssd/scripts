#!/bin/bash
set -x
echo "Install latest docker"

echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
sudo yum -y update
curl -fsSL https://get.docker.com/  | sh
sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable --now docker
logout
