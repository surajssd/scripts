#!/bin/bash

set -x

mkdir -p ~/.local/bin

# install kubectl
which kubectl
if [ $? -ne 0 ]; then
	echo "Installing kubectl"
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl ~/.local/bin/kubectl
	chmod a+x ~/.local/bin/kubectl
fi

# install oc
which oc
if [ $? -ne 0 ]; then
	echo "Installing oc"
	curl -LO https://github.com/openshift/origin/releases/download/v3.6.0-alpha.2/openshift-origin-client-tools-v3.6.0-alpha.2-3c221d5-linux-64bit.tar.gz
	tar -xvzf openshift-origin-client-*
	cp openshift-origin-client-tools*/oc ./
fi

# install kubectx
which kubectx
if [ $? -ne 0 ]; then
	echo "Installing kubectx"
    mkdir ~/.local/bin/kubectx
    git clone https://github.com/ahmetb/kubectx ~/.local/bin/kubectx
    echo 'alias kubectx=~/.local/bin/kubectx/kubectx' >> ~/.bashrc
fi

# install kubens
which kubens
if [ $? -ne 0 ]; then
    echo "Installing kubens"
    mkdir ~/.local/bin/kubectx
    git clone https://github.com/ahmetb/kubectx ~/.local/bin/kubectx
    echo 'alias kubens=~/.local/bin/kubectx/kubens' >> ~/.bashrc
fi

# install kproject.sh
which kproject.sh
if [ $? -ne 0 ]; then
	echo "Installing kproject.sh"
	echo '
#!/bin/bash
set -x

kubectl create ns $1
kubectl config set-context minikube --namespace $1
	' | tee ~/.local/bin/kproject.sh
	chmod a+x ~/.local/bin/kproject.sh
fi

# install newproject.sh
which newproject.sh
if [ $? -ne 0 ]; then
	echo "Installing newproject.sh"
	echo '
#!/bin/bash
set -xe

oc login -u developer -p developer
oc new-project $1
oc login -u system:admin
oc adm policy add-scc-to-user anyuid -n $1 -z default
oc login -u developer -p developer
	' | tee ~/.local/bin/newproject.sh
	chmod a+x  ~/.local/bin/newproject.sh
fi

