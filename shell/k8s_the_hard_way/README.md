## Setting up a Certificate Authority and TLS Cert Generation
## On your base machine


#### Install CFSSL

```bash
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
chmod +x cfssl_linux-amd64
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl


wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssljson_linux-amd64
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
```

#### Setting up a Certificate Authority
#### Create the CA configuration file


```json
echo '{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}' > ca-config.json
```

#### Generate the CA certificate and private key

```json
echo '{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "India",
      "L": "Bengaluru",
      "O": "Kubernetes",
      "OU": "IBC",
      "ST": "Karnataka"
    }
  ]
}' > ca-csr.json
```

```bash
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
openssl x509 -in ca.pem -text -noout
```

#### Generate the single Kubernetes TLS Cert

```json
cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "w1",
    "w2",
    "c1",
    "c2",
    "192.168.50.10",
    "192.168.50.11",
    "192.168.50.20",
    "192.168.50.21",
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "India",
      "L": "Bengaluru",
      "O": "Kubernetes",
      "OU": "IBC",
      "ST": "Karnataka"
    }
  ]
}
EOF
```

```bash
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes


openssl x509 -in kubernetes.pem -text -noout
```

#### now copy all the certs in all the hosts

#### in home directory


## all:

```ruby
cat > etcd.service <<"EOF"
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  #config.vm.box = "fed23"


  config.vm.define "c1" do |c1|
    c1.vm.box = "centos/7"
    c1.vm.hostname = "c1"
    c1.vm.network "private_network", ip: "192.168.50.10"
  end

  config.vm.define "c2" do |c2|
    c2.vm.box = "centos/7"
    c2.vm.hostname = "c2"
    c2.vm.network "private_network", ip: "192.168.50.11"
  end

  config.vm.define "w1" do |w1|
    w1.vm.box = "centos/7"
    w1.vm.hostname = "w1"
    w1.vm.network "private_network", ip: "192.168.50.20"
  end

  config.vm.define "w2" do |w2|
    w2.vm.box = "centos/7"
    w2.vm.hostname = "w2"
    w2.vm.network "private_network", ip: "192.168.50.21"
  end

  config.vm.provider "libvirt" do |libvirt, override|
    libvirt.driver = "kvm"
    libvirt.memory = 2048
    libvirt.cpus = 2
  end

end
EOF
```
```bash
vagrant up

# on all machines

sudo yum -y update && sudo yum -y install wget

echo "192.168.50.10 c1" | sudo tee -a /etc/hosts
echo "192.168.50.11 c2" | sudo tee -a /etc/hosts
echo "192.168.50.20 w1" | sudo tee -a /etc/hosts
echo "192.168.50.21 w2" | sudo tee -a /etc/hosts
```

#########################################################################################

## Bootstrapping a H/A etcd cluster
## only on controller nodes


#### TLS Certificates

```bash
cd
sudo mkdir -p /etc/etcd/
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/
```

#### Download and Install the etcd binaries

```bash
wget https://github.com/coreos/etcd/releases/download/v3.0.10/etcd-v3.0.10-linux-amd64.tar.gz
tar -xvf etcd-v3.0.10-linux-amd64.tar.gz
sudo mv etcd-v3.0.10-linux-amd64/etcd* /usr/bin/

sudo mkdir -p /var/lib/etcd

cat > etcd.service <<"EOF"
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/bin/etcd --name ETCD_NAME \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  --peer-cert-file=/etc/etcd/kubernetes.pem \
  --peer-key-file=/etc/etcd/kubernetes-key.pem \
  --trusted-ca-file=/etc/etcd/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/ca.pem \
  --initial-advertise-peer-urls https://INTERNAL_IP:2380 \
  --listen-peer-urls https://INTERNAL_IP:2380 \
  --listen-client-urls https://INTERNAL_IP:2379,http://127.0.0.1:2379 \
  --advertise-client-urls https://INTERNAL_IP:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster c1=https://192.168.50.10:2380,c2=https://192.168.50.11:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

#### Set The Internal IP Address
##### on c1

```bash
export INTERNAL_IP=192.168.50.10
export ETCD_NAME=c1
```

#### on c2

```bash
export INTERNAL_IP=192.168.50.11
export ETCD_NAME=c2
```

#### on c1 and c2

```bash
sed -i s/INTERNAL_IP/${INTERNAL_IP}/g etcd.service
sed -i s/ETCD_NAME/${ETCD_NAME}/g etcd.service

sudo mv etcd.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
sudo systemctl status etcd --no-pager
```

=========================================================================
### Bootstrapping an H/A Kubernetes Control Plane


#### on both c1 and c2

#### TLS Certificates
```bash
sudo mkdir -p /var/lib/kubernetes
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /var/lib/kubernetes/
```

#### Download and install the Kubernetes controller binaries
```bash
wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kube-apiserver
wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kube-controller-manager

wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kube-scheduler
wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kubectl

chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/bin/
```

#### Kubernetes API Server

#### Setup Authentication and Authorization
#### Authentication
```bash
wget https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/token.csv
sudo mv token.csv /var/lib/kubernetes/
```

#### Authorization
```bash
wget https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/authorization-policy.jsonl
cat authorization-policy.jsonl
sudo mv authorization-policy.jsonl /var/lib/kubernetes/
```

### make sure the IP addresses in these machines are of the etcd machines

```bash
cat > kube-apiserver.service <<"EOF"
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-apiserver \
  --admission-control=NamespaceLifecycle,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota \
  --advertise-address=INTERNAL_IP \
  --allow-privileged=true \
  --apiserver-count=3 \
  --authorization-mode=ABAC \
  --authorization-policy-file=/var/lib/kubernetes/authorization-policy.jsonl \
  --bind-address=0.0.0.0 \
  --enable-swagger-ui=true \
  --etcd-cafile=/var/lib/kubernetes/ca.pem \
  --insecure-bind-address=0.0.0.0 \
  --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \
  --etcd-servers=https://192.168.50.10:2379,https://192.168.50.11:2379 \
  --service-account-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --service-cluster-ip-range=10.32.0.0/24 \
  --service-node-port-range=30000-32767 \
  --tls-cert-file=/var/lib/kubernetes/kubernetes.pem \
  --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --token-auth-file=/var/lib/kubernetes/token.csv \
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```


#### on c1

```bash
export INTERNAL_IP=192.168.50.10
```

#### on c2

```bash
export INTERNAL_IP=192.168.50.11
```

#### on both machines

```bash
sed -i s/INTERNAL_IP/$INTERNAL_IP/g kube-apiserver.service
sudo mv kube-apiserver.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver
sudo systemctl start kube-apiserver
sudo systemctl status kube-apiserver --no-pager
```


#### kubernetes controller manager

```bash
cat > kube-controller-manager.service <<"EOF"
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-controller-manager \
  --allocate-node-cidrs=true \
  --cluster-cidr=10.200.0.0/16 \
  --cluster-name=kubernetes \
  --leader-elect=true \
  --master=http://INTERNAL_IP:8080 \
  --root-ca-file=/var/lib/kubernetes/ca.pem \
  --service-account-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --service-cluster-ip-range=10.32.0.0/24 \
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


sed -i s/INTERNAL_IP/$INTERNAL_IP/g kube-controller-manager.service
sudo mv kube-controller-manager.service /etc/systemd/system/
sudo systemctl daemon-reload

sudo systemctl enable kube-controller-manager
sudo systemctl start kube-controller-manager
sudo systemctl status kube-controller-manager --no-pager
```


### k8s scheduler

```bash
cat > kube-scheduler.service <<"EOF"
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-scheduler \
  --leader-elect=true \
  --master=http://INTERNAL_IP:8080 \
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


sed -i s/INTERNAL_IP/$INTERNAL_IP/g kube-scheduler.service
sudo mv kube-scheduler.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable kube-scheduler
sudo systemctl start kube-scheduler
sudo systemctl status kube-scheduler --no-pager
```


## verfication

```bash
kubectl get componentstatuses
```

################################################################################
### Bootstraping k8s workers

### Install flannel and docker


### install flannel on the workers
#### on w1 and w2

```bash
sudo yum -y install flannel
```

#### on c1 and c2

```bash
etcdctl --ca-file ca.pem set flannel/network/config '{
  "Network": "10.200.0.0/16",
  "SubnetLen": 24,
  "Backend": {
    "Type": "vxlan"
  }
}'
```

#### on w1 and w2


```bash
echo '
FLANNEL_ETCD=https://192.168.50.10:2379,https://192.168.50.11:2379
FLANNEL_ETCD_KEY="/flannel/network"
FLANNEL_OPTIONS='--etcd-cafile="/home/vagrant/ca.pem"'
' | sudo tee /etc/sysconfig/flanneld

sudo systemctl start flanneld
sudo systemctl enable flanneld
sudo systemctl status flanneld
```


### install docker on workers

```bash
wget https://get.docker.com/builds/Linux/x86_64/docker-1.12.1.tgz
tar -xvf docker-1.12.1.tgz
sudo cp docker/docker* /usr/bin/

echo "[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
ExecStart=/usr/bin/docker daemon \
  --iptables=false \
  --ip-masq=false \
  --host=unix:///var/run/docker.sock \
  --log-level=error \
  --storage-driver=overlay \
  --bip=FLANNEL_SUBNET \
  --mtu=FLANNEL_MTU
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" > docker.service


export $(cat /run/flannel/subnet.env)


sed -i "s|FLANNEL_SUBNET|$FLANNEL_SUBNET|g" docker.service
sed -i s/FLANNEL_MTU/${FLANNEL_MTU}/g docker.service

sudo mv docker.service /etc/systemd/system/docker.service


sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker
sudo docker version
sudo systemctl status docker

sudo groupadd docker
sudo usermod -aG docker vagrant
```


#### on w1 w2

##### Move the TLS certificates in place
```bash
sudo mkdir -p /var/lib/kubernetes
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /var/lib/kubernetes/
```

#### install kubelet

#### on w1 w2

```bash
sudo mkdir -p /opt/cni
wget https://storage.googleapis.com/kubernetes-release/network-plugins/cni-07a8a28637e97b22eb8dfe710eeae1344f69d16e.tar.gz
sudo tar -xvf cni-07a8a28637e97b22eb8dfe710eeae1344f69d16e.tar.gz -C /opt/cni
```

#### k8s worker binaries

```bash
wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kubectl
wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kube-proxy
wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kubelet

chmod +x kubectl kube-proxy kubelet
sudo mv kubectl kube-proxy kubelet /usr/bin/
sudo mkdir -p /var/lib/kubelet/


sudo sh -c 'echo "apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /var/lib/kubernetes/ca.pem
    server: https://192.168.50.10:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubelet
  name: kubelet
current-context: kubelet
users:
- name: kubelet
  user:
    token: chAng3m3" > /var/lib/kubelet/kubeconfig'
```

#### kubelet systemd unit file

```bash
sudo sh -c 'echo "[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
ExecStart=/usr/bin/kubelet \
  --allow-privileged=true \
  --api-servers=https://192.168.50.10:6443,https://192.168.50.11:6443 \
  --cloud-provider= \
  --cluster-dns=10.32.0.10 \
  --cluster-domain=cluster.local \
  --configure-cbr0=true \
  --container-runtime=docker \
  --docker=unix:///var/run/docker.sock \
  --network-plugin=kubenet \
  --kubeconfig=/var/lib/kubelet/kubeconfig \
  --reconcile-cidr=true \
  --serialize-image-pulls=false \
  --tls-cert-file=/var/lib/kubernetes/kubernetes.pem \
  --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --v=2

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/kubelet.service'

sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl status kubelet --no-pager
```



#### kube-proxy

```bash
sudo sh -c 'echo "[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-proxy \
  --master=https://192.168.50.10:6443 \
  --kubeconfig=/var/lib/kubelet/kubeconfig \
  --proxy-mode=iptables \
  --v=2

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/kube-proxy.service'

sudo systemctl daemon-reload
sudo systemctl enable kube-proxy
sudo systemctl start kube-proxy


sudo systemctl status kube-proxy --no-pager
```

################################################################################
### configure clients on base machine

```
wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin


kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://192.168.50.10:6443

kubectl config set-credentials admin --token chAng3m3

kubectl config set-context default-context \
  --cluster=kubernetes-the-hard-way \
  --user=admin

kubectl config use-context default-context
kubectl get componentstatuses
```
################################################################################


