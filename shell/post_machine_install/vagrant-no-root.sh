#!/bin/bash

set -xe

sudo mkdir -p /etc/polkit-1/localauthority/50-local.d
echo "
[Allow $USER libvirt management permissions]
Identity=unix-user:$USER
Action=org.libvirt.unix.manage
ResultAny=yes
ResultInactive=yes
ResultActive=yes
" | sudo tee /etc/polkit-1/localauthority/50-local.d/vagrant.pkla 

