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

sudo apt purge -qq -y libopencv

sudo apt update -qq -y
sudo apt install -qq -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt install -qq -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt install -qq -y python2.7-dev python3.6-dev python-dev python-numpy python3-numpy
sudo apt install -qq -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
sudo apt install -qq -y libv4l-dev v4l-utils qv4l2 v4l2ucp
sudo apt install -qq -y curl
sudo apt install -qq -y gtk+-3.0
sudo apt upgrade -qq -y

mkdir -p /tmp/opencv
cd /tmp/opencv
VERSION=4.5.0

if [ ! -s opencv-${VERSION}.zip ]; then curl -sSL https://github.com/opencv/opencv/archive/${VERSION}.zip -o opencv-${VERSION}.zip; fi
if [ ! -s opencv_contrib-${VERSION}.zip ]; then curl -sSL https://github.com/opencv/opencv_contrib/archive/${VERSION}.zip -o opencv_contrib-${VERSION}.zip; fi

if [ ! -d opencv-${VERSION} ]; then
  unzip opencv-${VERSION}.zip
fi
if [ ! -d opencv_contrib-${VERSION} ]; then
  unzip opencv_contrib-${VERSION}.zip
fi

if [ ! -d opencv-${VERSION}/release ]; then
  mkdir -p opencv-${VERSION}/release
fi

cd opencv-${VERSION}/release

cmake \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_NEW_PYTHON_SUPPORT=ON \
        -D BUILD_opencv_python3=TRUE \
        -D BUILD_TBB=ON \
        -D BUILD_TESTS=OFF \
        -D BUILD_TIFF=ON \
	-D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr \
        -D CUDA_ARCH_BIN=5.3 \
        -D CUDA_ARCH_PTX="" \
        -D CUDA_FAST_MATH=ON \
        -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
        -D ENABLE_FAST_MATH=ON \
        -D ENABLE_NEON=ON \
        -D INSTALL_C_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D OPENCV_DNN_CUDA=ON \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${VERSION}/modules \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D WITH_CUBLAS=ON \
        -D WITH_CUDA=ON \
        -D WITH_CUDNN=ON \
        -D WITH_EIGEN=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_GSTREAMER=ON \
        -D WITH_LIBV4L=ON \
        -D WITH_OPENGL=ON \
        -D WITH_OPENMP=ON \
        -D WITH_QT=OFF \
        -D WITH_TBB=ON \
        -D WITH_V4L=ON \
   -D CMAKE_INSTALL_PREFIX=/usr/local ..

make -j$(nproc)

sudo make install

cd python_loader
sudo python3 setup.py install
