#!/bin/bash

set -x

# install fastmirror
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/fastmirror.sh | sh

# install golang
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/pullgo.sh | sh

# setup gopath
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/setupgopath.sh | sh

# install bashgitprompt
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/gitprompt.sh | sh

# load all the envs
source ~/.bashrc

# install the gotools
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/install_gotools.sh | sh

# install tools
sudo dnf -y install byobu docker make gcc zip mercurial krb5-devel bsdtar bc rsync bind-utils file jq tito createrepo openssl gpgme gpgme-devel libassuan libassuan-devel

# start docker
sudo systemctl enable --now docker


# download the origin src repo
mkdir -p $GOPATH/src/github.com/openshift
cd $GOPATH/src/github.com/openshift
git clone https://github.com/openshift/origin  
cd origin
git remote add upstream git@github.com:openshift/origin.git
git remote remove origin
git remote add origin git@github.com:surajssd/origin.git


# export envs
echo '
#################################
# OpenShift specific envs

export OS_OUTPUT_GOPATH=1

#################################
' | tee -a ~/.bashrc

# install etcd
cd $GOPATH/src/github.com/openshift/origin
./hack/install-etcd.sh 
cp ./_output/tools/etcd/bin/etcd /usr/local/sbin/
cp ./_output/tools/etcd/bin/etcdctl /usr/local/sbin/

# add k8s aliases
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/install_k8s_tools/k8s-alias.sh | sh

# install fzf
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/fzfinstaller.sh | sh

# download gitconfig and gitignore
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/setup-git-config.sh | sh

# install vim
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/vimsetup/vimsetup.sh | sh

# generate ssh keys in this machine
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/ssh-key-gen.sh | sh
