#!/bin/sh

apt-get install -y ha-proxy
cp /vagrant/files/haproxy.cfg /etc/haproxy/haproxy.cfg
