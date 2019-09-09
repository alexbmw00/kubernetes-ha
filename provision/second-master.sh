#!/bin/bash

while true; do

    ssh -o stricthostkeychecking=no 27.11.90.10 test -f /root/calico.yml
    if [ $? == "0" ]; then
        sleep 5
        continue
    fi
    
    if [ "$HOSTNAME" == 'master2' ]; then
        ssh 27.11.90.10 'scp -a /var/cache/apt/archives/* ssh -o stricthostkeychecking=no 27.11.90.20:/var/cache/apt/archives/'
    else
        ssh 27.11.90.10 'scp -a /var/cache/apt/archives/* ssh -o stricthostkeychecking=no 27.11.90.30:/var/cache/apt/archives/'
    fi

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

    if [ "$HOSTNAME" == 'master2' ]; then
        ssh 27.11.90.10 'docker images | awk -F'\'' '\'' '\''NR>1 {print $1":"$2}'\'' | while read IMAGE; do docker save $IMAGE | ssh 27.11.90.20 docker load; done'
    else
        ssh 27.11.90.10 'docker images | awk -F'\'' '\'' '\''NR>1 {print $1":"$2}'\'' | while read IMAGE; do docker save $IMAGE | ssh 27.11.90.30 docker load; done'
    fi

    CERTIFICATE_KEY="$(ssh 27.11.90.10 'kubeadm init phase upload-certs --upload-certs | tail -n1')"
    $(ssh 27.11.90.10 kubeadm token create --print-join-command) --control-plane --certificate-key "$CERTIFICATE_KEY" --apiserver-advertise-address 27.11.90.$1
    apt-get clean
    exit 0

done
