#!/bin/bash

nvidia_modprobe()
{
  echo "${FUNCNAME[0]}" &> /dev/stderr

  local result

  sudo /sbin/modprobe nvidia &> /dev/null
  if [ "$?" -eq 0 ]; then
    # Count the number of NVIDIA controllers found.
    local ndevs=$(lspci | grep -i NVIDIA)
    local n3d=$(echo "$ndevs" | grep "3D controller" | wc -l)
    local nvga=$(echo "$ndevs" | grep "VGA compatible controller" | wc -l)
    local n=$((n3d + nvga -1))

    for i in $(seq 0 $n); do
      sudo mknod -m 666 "/dev/nvidia${i}" c 195 ${i} &> /dev/stderr
    done
    sudo mknod -m 666 "/dev/nvidiactl" c 195 255 &> /dev/stderr
    result='true'
  else
    echo "${FUNCNAME[0]} failed" &> /dev/stderr
  fi
  echo "${result:-false}"
}

nvidia_modprobe_uvm()
{
  echo "${FUNCNAME[0]}" &> /dev/stderr

  local result

  sudo /sbin/modprobe nvidia-uvm &> /dev/null
  if [ "$?" -eq 0 ]; then
    # Find out the major device number used by the nvidia-uvm driver
    local D=`grep nvidia-uvm /proc/devices | awk '{print $1}'`

    sudo mknod -m 666 /dev/nvidia-uvm c $D 0 &> /dev/stderr
    result='true'
  else
    echo "${FUNCNAME[0]} failed" &> /dev/stderr
  fi
  echo "${result:-false}"
}

nvidia_get_cuda()
{
  echo "${FUNCNAME[0]}" &> /dev/stderr

  local result

  pushd /tmp &> /dev/null
  if [ ! -s /etc/apt/preferences.d/cuda-repository-pin-600 ]; then
    wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin \
    && sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
  fi
  if [ ! -s cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb ]; then
    wget -q http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
  fi
  local count=$(apt list 2> /dev/null | egrep '^cuda-10-2' | wc -l)
  if [ "${count:-null}" == 'null' ] || [ ${count:-0} -eq 0 ]; then
    sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb &> /dev/stderr \
      && sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub &> /dev/stderr \
      && sudo apt-get -qq -y update &> /dev/stderr \
      && sudo apt-get -qq -y install cuda &> /dev/stderr \
      && result=true || result=false
  else
    result=true
  fi
  popd &> /dev/null

  echo "${result:-false}"
}

nvidia_blacklist_nouveau()
{
  echo "${FUNCNAME[0]}" &> /dev/stderr

  local file="/etc/modprobe.d/blacklist-nouveau.conf"

  if [ ! -s "${file}" ]; then
    echo 'blacklist nouveau' | sudo tee "${file}" &> /dev/null
    echo 'options nouveau modeset=0' | sudo tee -a "${file}" &> /dev/null
    sudo update-initramfs -u &> /dev/stderr
  fi
  echo true
}

###
### main
###

if [ $(uname -m) != 'x86_64' ]; then
  echo "Unsupported architecture: $(uname -m)" &> /dev/stderr
elif [ $(nvidia_get_cuda) != 'true' ]; then
  echo "Failed to install CUDA" &> /dev/stderr
elif [ $(nvidia_blacklist_nouveau) != 'true' ]; then
  echo "Blacklist failed" &> /dev/stderr
elif [ $(nvidia_modprobe) != 'true' ]; then
  echo "Devices failed" &> /dev/stderr
elif [ $(nvidia_modprobe_uvm) != 'true' ]; then
  echo "Probe failed" &> /dev/stderr
else
  echo "SUCCESS" &> /dev/stderr
fi

