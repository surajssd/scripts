#!/bin/bash

set -x

cd /usr/local/sbin

# install diffapply script
sudo curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/diffapply.sh
sudo chmod +x diffapply.sh