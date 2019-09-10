#!/bin/bash

# Este script é invocado pelo master1 ao final do provisionamento

apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common dirmngr vim telnet curl nfs-common

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo -e '{\n\t"exec-opts": ["native.cgroupdriver=cgroupfs"]\n}' > /etc/docker/daemon.json

systemctl restart docker

sed -Ei 's/(.*swap.*)/#\1/g' /etc/fstab
swapoff -a
usermod -G docker -a vagrant

echo "KUBELET_EXTRA_ARGS='--node-ip=27.11.90.$1'" > /etc/default/kubelet

apt-get clean
