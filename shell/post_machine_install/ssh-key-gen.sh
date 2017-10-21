#!/bin/bash

set -x

# Generate new key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -C "surajd.service@gmail.com"

set +x
echo "Add the key in ~/.ssh/id_rsa.pub to https://github.com/settings/keys"
set -x

cat ~/.ssh/id_rsa.pub
