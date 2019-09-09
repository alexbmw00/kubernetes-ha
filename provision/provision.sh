#!/bin/bash

mkdir -p /root/.ssh
cp /vagrant/files/id_rsa* /root/.ssh
chmod 400 /root/.ssh/id_rsa*
cp /vagrant/files/id_rsa.pub /root/.ssh/authorized_keys

HOSTS=$(head -n5 /etc/hosts)
echo -e "$HOSTS" > /etc/hosts
cat >> /etc/hosts <<EOF
27.11.90.10 master1.example.com
27.11.90.20 master2.example.com
27.11.90.30 master3.example.com
27.11.90.101 minion1.example.com
27.11.90.102 minion2.example.com
27.11.90.103 minion3.example.com
27.11.90.200 balancer.example.com
EOF

apt-get update
exit

apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common dirmngr vim telnet curl nfs-common

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo '{
        "exec-opts": ["native.cgroupdriver=cgroupfs"]
}' > /etc/docker/daemon.json

systemctl restart docker

sed -Ei 's/(.*swap.*)/#\1/g' /etc/fstab
swapoff -a
usermod -G docker -a vagrant
