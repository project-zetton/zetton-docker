#!/usr/bin/env bash

set -ex

apt-get update &&
    apt-get install -y --no-install-recommends openssh-server &&
    apt-get clean &&
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
mkdir /var/run/sshd
echo 'root:rsg[HQxFmRbygbZ7' | chpasswd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i "s/#Port 22/Port 2222/" /etc/ssh/sshd_config
