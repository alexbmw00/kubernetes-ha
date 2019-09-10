#!/bin/sh

apt-get install -y haproxy vim curl
cp /vagrant/files/haproxy.cfg /etc/haproxy/haproxy.cfg
systemctl restart haproxy
