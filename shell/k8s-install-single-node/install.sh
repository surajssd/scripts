#!/bin/bash

# enable fastmirror
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/post_machine_install/fastmirror.sh | sh

# install and start docker
yum install -y docker
systemctl enable docker && systemctl start docker

# install kubelet and start it
echo "
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
" | tee /etc/yum.repos.d/kubernetes.repo

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet && systemctl start kubelet


# set SELinux context
mkdir -p /etc/kubernetes/
chcon -R -t svirt_sandbox_file_t /etc/kubernetes/

mkdir -p /var/lib/etcd
chcon -R -t svirt_sandbox_file_t /var/lib/etcd


# start kubeadm
kubeadm init

# set the kubectl context
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# install network
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# make master usable
kubectl taint nodes --all node-role.kubernetes.io/master-

# list nodes available
kubectl get nodes


# https://kubernetes.io/docs/setup/independent/install-kubeadm/
# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/