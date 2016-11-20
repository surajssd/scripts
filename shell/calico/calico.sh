# update the /etc/hosts

echo "$(ip a sh eth0 | grep -w inet | awk '{print $2;}' | cut -d/ -f1) centos1" | sudo tee -a /etc/hosts; cat /etc/hosts
echo "$(ip a sh eth0 | grep -w inet | awk '{print $2;}' | cut -d/ -f1) centos2" | sudo tee -a /etc/hosts; cat /etc/hosts

| sudo tee -a /etc/hosts
cat /etc/hosts

=================================================
# run only on centos1
sudo yum -y install etcd

# edit etcd config
sudo sed -i -- 's|ETCD_LISTEN_CLIENT_URLS="http://localhost:2379"|ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"|g' /etc/etcd/etcd.conf
sudo sed -i -- 's|ETCD_ADVERTISE_CLIENT_URLS="http://localhost:2379"|ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"|g' /etc/etcd/etcd.conf


=================================================

sudo yum install -y wget
sudo yum -y update
curl -fsSL https://get.docker.com/ | sh
sudo yum -y remove docker-engine
sudo yum -y install docker-engine-1.9.0-1.el7.centos.x86_64


sudo wget -qO /usr/local/bin/calicoctl https://github.com/projectcalico/calico-containers/releases/download/v0.17.0/calicoctl
sudo chmod +x /usr/local/bin/calicoctl

# make docker use the etcd
sudo echo "DOCKER_OPTS=\"--cluster-store=etcd://centos1:2379\"" > /etc/sysconfig/docker

# start etcd
sudo systemctl enable etcd; sudo systemctl start etcd; sudo systemctl status etcd

# start docker
sudo systemctl enable docker; sudo systemctl start docker; sudo systemctl status docker

# set the env for calicoctl
export ETCD_AUTHORITY=centos1:2379

# start the libnetwork
sudo /usr/local/bin/calicoctl node --libnetwork





================================================================================


sudo yum install -y git docker
sudo systemctl enable docker; sudo systemctl start docker; sudo systemctl status docker

echo 'alias docker="sudo /usr/bin/docker"' >> .bashrc
alias docker="sudo /usr/bin/docker"


git clone https://github.com/fasaxc/calico-centos-docker
cd calico-centos-docker
docker build -t calico-centos .
================================================================================
sudo calicoctl pool add 10.0.0/16
sudo docker network create --driver calico --ipam-driver calico net1
sudo docker network create --driver calico --ipam-driver calico net2
sudo docker network create --driver calico --ipam-driver calico net3



sudo docker run --net net1 --name workload-A -tid busybox
sudo docker run --net net2 --name workload-B -tid busybox
sudo docker run --net net1 --name workload-C -tid busybox

