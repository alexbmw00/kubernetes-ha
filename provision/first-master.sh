#!/bin/bash

echo "KUBELET_EXTRA_ARGS='--node-ip=27.11.90.$1'" > /etc/default/kubelet

cp /vagrant/files/kudeadm-config.yml /root

kubeadm init --config /root/kubeadm-config.yml --upload-certs
mkdir -p ~/.kube
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant: /home/vagrant/.kube
curl -s https://docs.projectcalico.org/v3.7/manifests/calico.yaml > /root/calico.yml
sed -i 's?192.168.0.0/16?10.244.0.0/16?g' /root/calico.yml
kubectl apply -f /root/calico.yml
