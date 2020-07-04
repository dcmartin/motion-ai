#!/bin/bash

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.107-435.17.01_1.0-1_arm64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.107-435.17.01/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
