#!/usr/bin/env bash

set -ex

TZ=${1:-"Asia/Shanghai"}

echo ${TZ} >/etc/timezone
ln -sfn /usr/share/zoneinfo/${TZ} /etc/localtime

apt-get update &&
    apt-get install -y --no-install-recommends tzdata &&
    apt-get clean &&
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
