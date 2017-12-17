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

# install bashaliases
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/bashaliases.sh | sh

# install all the scripts I generally use
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/install-my-scripts.sh | sh

# load all the envs
source ~/.bashrc

# install the gotools
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/installer_go/install_gotools.sh | sh

# install tools
sudo dnf -y install htop byobu docker make gcc zip mercurial krb5-devel bsdtar \
        bc rsync bind-utils file jq tito createrepo openssl gpgme gpgme-devel \
        libassuan libassuan-devel btrfs-progs-devel device-mapper-devel git \
        glib2-devel glibc-devel glibc-static libgpg-error-devel libseccomp-devel \
        libselinux-devel ostree-devel pkgconfig runc skopeo-containers

# start docker
sudo systemctl enable --now docker

# install cfssl
go get -u github.com/cloudflare/cfssl/cmd/cfssl

# download the crio code base
mkdir -p $GOPATH/src/github.com/kubernetes-incubator
cd $GOPATH/src/github.com/kubernetes-incubator/
git clone https://github.com/kubernetes-incubator/cri-o
cd cri-o
git remote add upstream git@github.com:kubernetes-incubator/cri-o.git
git remote remove origin
git remote add origin git@github.com:surajssd/cri-o.git

# download libpod code base
cd 
mkdir -p $GOPATH/src/github.com/projectatomic
cd $GOPATH/src/github.com/projectatomic
git clone https://github.com/projectatomic/libpod
cd libpod
make install.tools
git remote add upstream git@github.com:projectatomic/libpod.git
git remote remove origin
git remote add origin git@github.com:surajssd/libpod.git

# setup CNI plugins
# following steps are taken from https://github.com/kubernetes-incubator/cri-o/blob/master/tutorial.md#cni-plugins
go get -d github.com/containernetworking/plugins
cd $GOPATH/src/github.com/containernetworking/plugins
./build.sh
sudo mkdir -p /opt/cni/bin
sudo cp bin/* /opt/cni/bin/
sudo mkdir -p /etc/cni/net.d
sudo sh -c 'cat >/etc/cni/net.d/10-mynet.conf <<-EOF
{
    "cniVersion": "0.2.0",
    "name": "mynet",
    "type": "bridge",
    "bridge": "cni0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "subnet": "10.88.0.0/16",
        "routes": [
            { "dst": "0.0.0.0/0"  }
        ]
    }
}
EOF'
sudo sh -c 'cat >/etc/cni/net.d/99-loopback.conf <<-EOF
{
    "cniVersion": "0.2.0",
    "type": "loopback"
}
EOF'

# install fzf
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/fzfinstaller.sh | sh

# download gitconfig and gitignore
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/setup-git-config.sh | sh

# install vim
# curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/vimsetup/vimsetup.sh | sh

# generate ssh keys in this machine
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/ssh-key-gen.sh | sh

