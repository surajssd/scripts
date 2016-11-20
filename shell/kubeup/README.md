## Bring up multinode kubernetes

The above script brings up two node and one master cluster in a Vagrant environment. So it is assumed that vagrant and supporting virtualization is already installed.

If virtualization is not installed just run:

```bash
$ sudo dnf -y install vagrant-libvirt
```

Each VM will be given 2GB RAM by default. You can change that by editing the environment variable in file.


### Links:

- Docs: http://kubernetes.io/docs/getting-started-guides/vagrant/
- Release: https://github.com/kubernetes/kubernetes/releases
