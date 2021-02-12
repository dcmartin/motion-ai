#!/bin/bash

if [ $(free -m | egrep Swap | awk '{ print $2 }') -lt 2048 ]; then
  echo 'Increasing swap file' &> /dev/stderr
  if [ ! -s /etc/dphys-swapfile ]; then
    sudo apt install -qq -y dphys-swapfile
    partition=var
    if [ -d /sda ]; then
      partition=sda
    fi
    echo "CONF_SWAPFILE=/${partition}/swap" | sudo tee /etc/dphys-swapfile &> /dev/null
    echo "CONF_SWAPSIZE=4096" | sudo tee -a /etc/dphys-swapfile &> /dev/null
    echo "CONF_SWAPFACTOR=4" | sudo tee -a /etc/dphys-swapfile &> /dev/null
    echo "CONF_MAXSWAP=8192" | sudo tee -a /etc/dphys-swapfile &> /dev/null
    echo 'Updated swap; please reboot'
    exit 1
  fi
fi

sudo apt update -qq -y
sudo apt install -qq -y build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev
sudo apt upgrade -qq -y

mkdir -p /tmp/ffmpeg
cd /tmp/ffmpeg
VERSION=latest

NVCH='nv-codec-headers'
if [ ! -d ${NVCH} ]; then
  git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git ${NVCH}
fi
pushd ${NVCH}
sudo make install
popd

if [ ! -s ffmpeg-${VERSION}.tar.bz2 ]; then curl -sSL https://ffmpeg.org/releases/ffmpeg-snapshot-git.tar.bz2 -o ffmpeg-${VERSION}.tar.bz2; fi

if [ ! -d 'ffmpeg' ]; then
  tar xjvf ffmpeg-${VERSION}.tar.bz2
fi

cd ffmpeg/

./configure --enable-nonfree --enable-cuda-nvcc --extra-cflags="-I/usr/local/cuda/include" --extra-ldflags="-L/usr/local/cuda/lib64"

make -j$(nproc)

sudo make install
