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
