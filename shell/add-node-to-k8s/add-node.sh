#!/bin/bash

# ./add-node.sh 192.168.199.23 /vagrant/certificates/ca.pem /vagrant/certificates/ca-key.pem /vagrant/certificates/ca-config.json
# provide the IP address to use for the kubelet
if [ -z $1 ]; then
    echo "Please provide the ip address of worker node as first arg"
    echo "Usage:"
    echo "./script IP_ADDR CA_PEM_PATH CA_KEY_PEM_PATH CA_CONFIG_JSON_PATH"
    exit 1
fi

# provide path to ca.pem
if [ -z $2 ]; then
    echo "Please provide path to ca.pem file as second arg"
    echo "Usage:"
    echo "./script IP_ADDR CA_PEM_PATH CA_KEY_PEM_PATH CA_CONFIG_JSON_PATH"
    exit 1
fi

# provide path to ca-key.pem
if [ -z $3 ]; then
    echo "Please provide path to ca-key.pem file as third arg"
    echo "Usage:"
    echo "./script IP_ADDR CA_PEM_PATH CA_KEY_PEM_PATH CA_CONFIG_JSON_PATH"
    exit 1
fi

# provide path to ca-config.json
if [ -z $4 ]; then
    echo "Please provide path to ca-config.json file as fourth arg"
    echo "Usage:"
    echo "./script IP_ADDR CA_PEM_PATH CA_KEY_PEM_PATH CA_CONFIG_JSON_PATH"
    exit 1
fi

readonly k8s_version="v1.11.2"
readonly cfssl_version="R1.2"
readonly crio_version="v1.11.2"

set -x

apt-get update
apt-get install -y socat libgpgme11

# download tools
mkdir tools
cd tools

echo "Downloading tools ..."

curl -sSL \
  -O "https://storage.googleapis.com/kubernetes-release/release/${k8s_version}/bin/linux/amd64/kube-proxy" \
  -O "https://storage.googleapis.com/kubernetes-release/release/${k8s_version}/bin/linux/amd64/kubelet" \
  -O "https://storage.googleapis.com/kubernetes-release/release/${k8s_version}/bin/linux/amd64/kubectl"


curl -sSL \
  -O "https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz" \
  -O "https://github.com/opencontainers/runc/releases/download/v1.0.0-rc4/runc.amd64" \
  -O "https://files.schu.io/pub/cri-o/crio-amd64-${crio_version}.tar.gz"

tar -xf "crio-amd64-${crio_version}.tar.gz"

mv runc.amd64 runc

chmod +x \
  kube-proxy \
  kubelet \
  kubectl \
  runc


mkdir -p \
  /etc/containers \
  /etc/cni/net.d \
  /etc/crio \
  /opt/cni/bin \
  /usr/local/libexec/crio \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes

tar -xvf cni-plugins-amd64-v0.6.0.tgz -C /opt/cni/bin/

cp runc /usr/local/bin/
cp {crio,kube-proxy,kubelet,kubectl} /usr/local/bin/
cp {conmon,pause} /usr/local/libexec/crio/
cp {crio.conf,seccomp.json} /etc/crio/
cp policy.json /etc/containers/

curl -sSL \
  -O "https://pkg.cfssl.org/${cfssl_version}/cfssl_linux-amd64" \
  -O "https://pkg.cfssl.org/${cfssl_version}/cfssljson_linux-amd64"

chmod +x cfssl_linux-amd64 cfssljson_linux-amd64

sudo mv -v cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv -v cfssljson_linux-amd64 /usr/local/bin/cfssljson

#=========================================================
# generate config

mkdir -p ~/config
cd ~/config


readonly hostname=$(hostname)
readonly ipaddr=$1
readonly capem=$2
readonly cakeypem=$3
readonly caconfig=$4

# generate the 99-loopback.conf common for all the workers, can be copied
cat > 99-loopback.conf <<EOF
{
    "cniVersion": "0.3.1",
    "type": "loopback"
}
EOF


# generate the kube-proxy cert common for all the workers, can be copied
cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=${capem} \
  -ca-key=${cakeypem} \
  -config=${caconfig} \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${capem} \
  --embed-certs=true \
  --server=https://192.168.199.10:6443 \
  --kubeconfig="kube-proxy.kubeconfig"

kubectl config set-credentials kube-proxy \
  --client-certificate="kube-proxy.pem" \
  --client-key="kube-proxy-key.pem" \
  --embed-certs=true \
  --kubeconfig="kube-proxy.kubeconfig"

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=kube-proxy \
  --kubeconfig="kube-proxy.kubeconfig"

kubectl config use-context default --kubeconfig="kube-proxy.kubeconfig"

# generate the kube-proxy.service common for all the workers, can be copied
cat > kube-proxy.service <<EOF
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --cluster-cidr=10.200.0.0/16 \\
  --kubeconfig=/var/lib/kube-proxy/kubeconfig \\
  --proxy-mode=iptables \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# generate the service file for the crio daemon, specific to node
cat > ${hostname}-crio.service <<EOF
[Unit]
Description=CRI-O daemon
Documentation=https://github.com/kubernetes-incubator/cri-o

[Service]
ExecStart=/usr/local/bin/crio --stream-address ${ipaddr} --runtime /usr/local/bin/runc --registry docker.io
Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF


# generate the worker certs, specific to node
cat > ${hostname}-csr.json <<EOF
{
  "CN": "system:node:${hostname}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=${capem} \
  -ca-key=${cakeypem} \
  -config=${caconfig} \
  -hostname="${hostname},${ipaddr}" \
  -profile=kubernetes \
  "${hostname}-csr.json" | cfssljson -bare "${hostname}"

# generate kubeconfig specific to the node
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${capem} \
  --embed-certs=true \
  --server=https://192.168.199.40:6443 \
  --kubeconfig="${hostname}.kubeconfig"

kubectl config set-credentials system:node:${hostname} \
  --client-certificate="${hostname}.pem" \
  --client-key="${hostname}-key.pem" \
  --embed-certs=true \
  --kubeconfig="${hostname}.kubeconfig"

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:node:${hostname} \
  --kubeconfig="${hostname}.kubeconfig"

kubectl config use-context default --kubeconfig="${hostname}.kubeconfig"

# generate the kubelet service specific to the node
cat > ${hostname}-kubelet.service <<EOF
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=crio.service
Requires=crio.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --anonymous-auth=false \\
  --authorization-mode=Webhook \\
  --client-ca-file=/var/lib/kubernetes/ca.pem \\
  --allow-privileged=true \\
  --cluster-dns=10.32.0.10 \\
  --cluster-domain=cluster.local \\
  --container-runtime=remote \\
  --container-runtime-endpoint=unix:///var/run/crio/crio.sock \\
  --image-pull-progress-deadline=2m \\
  --image-service-endpoint=unix:///var/run/crio/crio.sock \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --network-plugin=cni \\
  --register-node=true \\
  --runtime-request-timeout=10m \\
  --tls-cert-file=/var/lib/kubelet/${hostname}.pem \\
  --tls-private-key-file=/var/lib/kubelet/${hostname}-key.pem \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


# install above generated config
cp 99-loopback.conf /etc/cni/net.d
cp kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
cp kube-proxy.service /etc/systemd/system/

cp "${hostname}-crio.service" /etc/systemd/system/crio.service
cp ${capem} /var/lib/kubernetes/
cp "${hostname}.pem" "${hostname}-key.pem" /var/lib/kubelet
cp "${hostname}.kubeconfig" /var/lib/kubelet/kubeconfig
cp "${hostname}-kubelet.service" /etc/systemd/system/kubelet.service

systemctl daemon-reload
systemctl enable crio kubelet kube-proxy
systemctl start crio kubelet kube-proxy
