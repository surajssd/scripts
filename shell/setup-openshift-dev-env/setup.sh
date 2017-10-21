#!/bin/bash

set -x

# install fastmirror
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/fastmirror.sh | sh

# install golang
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/pullgo.sh | sh

# setup gopath
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/setupgopath.sh | sh

# load all the envs
source ~/.bashrc

# install the gotools
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/install_gotools.sh | sh

# install tools
sudo dnf -y install byobu docker make gcc zip mercurial krb5-devel bsdtar bc rsync bind-utils file jq tito createrepo openssl gpgme gpgme-devel libassuan libassuan-devel

# start docker
sudo systemctl enable --now docker

# export envs
echo 'export OS_OUTPUT_GOPATH=1' | tee -a ~/.bashrc

# download the origin src repo
mkdir -p $GOPATH/src/github.com/openshift
cd $GOPATH/src/github.com/openshift
git clone https://github.com/openshift/origin  
cd origin
git remote add upstream git@github.com:openshift/origin.git
git remote remove origin
git remote add origin git@github.com:surajssd/origin.git


# install etcd
cd $GOPATH/src/github.com/openshift/origin
./hack/install-etcd.sh 
cp ./_output/tools/etcd/bin/etcd /usr/local/sbin/
cp ./_output/tools/etcd/bin/etcdctl /usr/local/sbin/

