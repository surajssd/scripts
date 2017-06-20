#!/bin/bash
set -x

# add fastest mirror
cat /etc/dnf/dnf.conf | grep 'fastestmirror'
if [ $? -ne 0 ]; then
    echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
fi

echo '127.0.0.1 localhost' | cat - /etc/hosts > temp && sudo mv temp /etc/hosts

sudo dnf -y install docker
sudo groupadd docker
sudo usermod -aG docker vagrant

sudo systemctl start docker
sudo systemctl enable docker
logout

#######################################################


sudo mkdir -p /var/lib/kubelet/
sudo chcon -R -t svirt_sandbox_file_t /var/lib/kubelet/
sudo chcon -R -t svirt_sandbox_file_t /var/lib/docker/


export K8S_VERSION=$(curl -sS https://storage.googleapis.com/kubernetes-release/release/latest.txt)
export ARCH=amd64


docker run -d \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:rw \
    --volume=/var/lib/docker/:/var/lib/docker:rw \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged \
    gcr.io/google_containers/hyperkube-${ARCH}:${K8S_VERSION} \
    /hyperkube kubelet \
        --containerized \
        --hostname-override=127.0.0.1 \
        --api-servers=http://localhost:8080 \
        --config=/etc/kubernetes/manifests \
        --cluster-dns=10.0.0.10 \
        --cluster-domain=cluster.local \
        --allow-privileged --v=2



curl -sSL "https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl" > /home/vagrant/kubectl
# OR do it this way
# wget https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl
# OR 
# curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl



sudo mv /home/vagrant/kubectl /usr/bin/
sudo chmod a+x /usr/bin/kubectl

until curl 127.0.0.1:8080 &>/dev/null;
do
  echo ...
  sleep 1
done

kubectl config set-cluster test-doc --server=http://localhost:8080
kubectl config set-context test-doc --cluster=test-doc
kubectl config use-context test-doc

