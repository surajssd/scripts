#!/bin/bash

set -euo pipefail

sudo dnf -y update
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/setup-rpm-fusion.sh | bash
sudo dnf -y install VirtualBox

echo "Reboot mahine? [Y/n]"
read -r permission
if [[ "${permission}" == "Y" ]]; then
  sudo systemctl reboot
fi
