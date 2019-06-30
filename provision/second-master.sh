#!/bin/bash

echo "KUBELET_EXTRA_ARGS='--node-ip=27.11.90.$1'" > /etc/default/kubelet
#kubeadm  alpha certs certificate-key
#$(ssh -o stricthostkeychecking=no 27.11.90.10 kubeadm token create --print-join-command)
