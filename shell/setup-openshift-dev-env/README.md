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
