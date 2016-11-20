#!/bin/bash
set -x

# vagrant in vagrant
# ref: https://ttboj.wordpress.com/2013/12/09/vagrant-on-fedora-with-libvirt/
# ref: http://nts.strzibny.name/inception-running-vagrant-inside-vagrant-with-kvm/


echo "options kvm_intel nested=1" | sudo tee -a /etc/modprobe.d/kvm.conf

echo '
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  #config.vm.box = "fed23"


  config.vm.define "fedora" do |fedora|
    fedora.vm.box = "fedora/23-cloud-base"
    config.vm.hostname = "fedora"
  end

  config.vm.provider "libvirt" do |libvirt, override|
    libvirt.nested = true
    libvirt.cpu_mode = "host-model"
    libvirt.driver = "kvm"
    libvirt.memory = 4096
    libvirt.cpus = 4
  end

end
' > Vagrantfile

vagrant up
vagrant ssh

echo 'fastestmirror=1'  | sudo tee -a /etc/dnf/dnf.conf 
sudo dnf -y update
sudo dnf -y install vagrant-libvirt

sudo -i
mkdir -p /etc/polkit-1/localauthority/50-local.d/
echo "
[Allow vagrant libvirt management permissions]
Identity=unix-user:vagrant
Action=org.libvirt.unix.manage
ResultAny=yes
ResultInactive=yes
ResultActive=yes
" | sudo tee /etc/polkit-1/localauthority/50-local.d/vagrant.pkla
logout
exit

vagrant halt
vagrant up && vagrant ssh

