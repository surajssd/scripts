# Setting up dev environment for OpenShift contribution

Create a Fedora based Vagrant VM for that follow these steps:

```bash
curl -O https://raw.githubusercontent.com/surajssd/scripts/master/shell/setup-openshift-dev-env/Vagrantfile
vagrant up && vagrant ssh
```

Once inside the VM, become root `sudo -i` and then run following script:

```bash
curl https://raw.githubusercontent.com/surajssd/scripts/master/shell/setup-openshift-dev-env/setup.sh | sh
```

## Setting up Kubernetes

```
working_dir=$GOPATH/src/k8s.io
user=surajssd
mkdir -p $working_dir
cd $working_dir
git clone https://github.com/kubernetes/kubernetes
cd kubernetes

git remote add upstream git@github.com:kubernetes/kubernetes.git
git remote set-url --push upstream no_push

git remote remove origin
git remote add origin git@github.com:$user/kubernetes.git

git remote -v
```
