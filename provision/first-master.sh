#!/bin/bash

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

echo "KUBELET_EXTRA_ARGS='--node-ip=27.11.90.$1'" > /etc/default/kubelet

cp /vagrant/files/kubeadm-config.yml /root

kubeadm init --config /root/kubeadm-config.yml --upload-certs
mkdir -p ~/.kube
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant: /home/vagrant/.kube
curl -s https://docs.projectcalico.org/v3.7/manifests/calico.yaml > /root/calico.yml
sed -i 's?192.168.0.0/16?10.244.0.0/16?g' /root/calico.yml
kubectl apply -f /root/calico.yml

#ssh -o stricthostkeychecking=no 27.11.90.20 hostname
#ssh -o stricthostkeychecking=no 27.11.90.30 hostname

#scp /var/cache/apt/archives/* ssh 27.11.90.20:/var/cache/apt/archives/
#ssh 27.11.90.20 '> /tmp/done'
#scp /var/cache/apt/archives/* ssh 27.11.90.30:/var/cache/apt/archives/
