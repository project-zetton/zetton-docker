#!/usr/bin/env zsh
set -e

# setup ssh
/usr/sbin/sshd -D &

$@