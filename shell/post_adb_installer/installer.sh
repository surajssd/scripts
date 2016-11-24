#!/bin/bash

set -x

###############################
# create all the files

cd
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/configs/.gitconfig

cat > ~/.vimrc <<EOF
set nu
set expandtab
set tabstop=4
set shiftwidth=4
set clipboard=unnamed
EOF

cat > ~/list-all.sh <<EOF
kubectl get pods
kubectl get services
kubectl get replicationcontroller
EOF

cat > ~/restart.sh <<EOF
sudo systemctl restart kube-controller-manager
sudo systemctl status kube-controller-manager
sudo systemctl restart kubelet
sudo systemctl status kubelet
sudo systemctl restart kube-proxy
sudo systemctl status kube-proxy
sudo systemctl restart kube-scheduler
sudo systemctl status kube-scheduler
EOF

cat > ~/delete-all.sh <<EOF
kubectl delete replicationcontrollers --all
kubectl delete services --all
kubectl delete pods --all
EOF

cat > ~/answers.conf.apitoken <<EOF
[etherpad-app]
image = centos/etherpad
db_pass = c
db_name = c
db_user = c
db_host = mariadb
hostport = 9001
[mariadb-atomicapp]
db_pass = c
db_name = c
db_user = c
root_pass = MySQLPass
[general]
provider = openshift
providerapi = https://10.1.2.2:8443
accesstoken = eemTrbqO1JGobv-Fy10OtEmggsGZILbDzOWXwHeiX3o
namespace = test
providertlsverify = False
EOF

cat > ~/answers.conf.providerconfig <<EOF
[etherpad-app]
image = centos/etherpad
db_pass = c
db_name = c
db_user = c
db_host = mariadb
hostport = 9001
[mariadb-atomicapp]
db_pass = c
db_name = c
db_user = c
root_pass = MySQLPass
[general]
providerconfig = /home/vagrant/.kube/config
namespace = test
provider = openshift
providertlsverify = False
EOF


###############################
# install the basic required softwares

# add fastest mirror
cat /etc/dnf/dnf.conf | grep 'fastestmirror'
if [ $? -ne 0 ]; then
    echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
fi

sudo yum -y update


sudo yum -y install python-devel vim tree bash-completion epel-release python-pip python-virtualenvwrapper percol python-flake8 python-ipython



echo 'source virtualenvwrapper.sh' >> ~/.bashrc
source virtualenvwrapper.sh
mkvirtualenv atomic
pip install pytest tox ipdb
echo "alias py.test=~/.virtualenvs/atomic/bin/py.test" >> ~/.virtualenvs/atomic/bin/postactivate
echo "unalias py.test" >> ~/.virtualenvs/atomic/bin/postdeactivate

###############################
# install softwares

cd ~/git/atomicapp/
pip install -r test-requirements.txt
python setup.py develop

echo "alias atomicapp=~/.virtualenvs/atomic/bin/atomicapp" >> ~/.virtualenvs/atomic/bin/postactivate
echo "alias sudo='sudo '" >> ~/.virtualenvs/atomic/bin/postactivate
echo "unalias atomicapp && unalias sudo && unalias py.test" >> ~/.virtualenvs/atomic/bin/postdeactivate

############


cd ~/git/openshift2nulecule
python setup.py develop



#####################################
# install some other softwares


cd
git clone https://github.com/pindexis/qfc $HOME/.qfc
echo '#=================================================================' >> ~/.bashrc
echo '[[ -s "$HOME/.qfc/bin/qfc.sh" ]] && source "$HOME/.qfc/bin/qfc.sh"' >> ~/.bashrc
echo '#' >> ~/.bashrc


git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt
echo '#=================================================================' >> ~/.bashrc
echo 'source ~/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc
echo 'GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc
echo '#' >> ~/.bashrc


git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
