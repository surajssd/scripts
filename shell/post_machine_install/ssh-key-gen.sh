#!/bin/bash

set -euo pipefail

# Generate new key
ssh-keygen -t rsa -b 8192 -f ~/.ssh/id_rsa -N "" -C "surajd.service@gmail.com"

echo "Add the key in ~/.ssh/id_rsa.pub to https://github.com/settings/keys"
echo "After that run -> ssh -T git@github.com"
cat ~/.ssh/id_rsa.pub
