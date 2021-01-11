#!/bin/bash

qemu()
{
 apt update -qq -y
 apt install -qq -y binfmt-support qemu qemu-user-static
 update-binfmts --enable qemu-arm
 systemctl start systemd-binfmt
}

###
### MAIN
###

if [ $(uname -s) != 'Linux' ]; then
  echo 'Only for Ubuntu18, Rasbian Buster, or Debian 10' &> /dev/stderr
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

if [ "${USER:-null}" != 'root' ]; then
  echo "Please run as root; sudo ${0} ${*}" &> /dev/stderr
  exit 1
fi

qemu ${*}
