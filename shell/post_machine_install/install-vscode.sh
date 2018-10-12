#!/bin/bash
#
# Installing vscode


set -euo pipefail

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
" | sudo tee /etc/yum.repos.d/vscode.repo

sudo dnf check-update
sudo dnf install -y code

