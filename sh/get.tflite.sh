#!/bin/bash

m=$(uname -m)
if [ -z "${m:-}" ]; then
  echo "ERROR: Cannot determine machine type; exiting" &> /dev/stderr
  exit 1
else
  echo "INFO: Machine type: ${m}" &> /dev/stderr
fi

if [ -z "$(command -v python3)" ]; then
  echo "ERROR: Cannot find command python3; exiting"
  exit 1
else
  echo "INFO: python3: found" &> /dev/stderr
fi

v=$(python3 --version | awk '{ print $2 }')
if [ -z "${v:-}" ]; then
  echo "ERROR: Cannot determine Python3 version; exiting"
  exit 1
else
  echo "INFO: python3 version: ${v}" &> /dev/stderr
fi

# pip3
if [ -z "$(command -v pip3)" ]; then
  echo "ERROR: Cannot find command pip3; exiting"
  exit 1
else
  echo "INFO: pip3: found" &> /dev/stderr
fi

# https://www.tensorflow.org/lite/guide/python

p=$(echo ${v%.*} | sed 's/\.//')
if [ ${p} -le 37 ]; then
  whl="tflite_runtime-2.5.0-cp${p}-cp${p}m-linux_${m}.whl"
else
  whl="tflite_runtime-2.5.0-cp${p}-cp${p}-linux_${m}.whl"
fi

url="https://github.com/google-coral/pycoral/releases/download/release-frogfish/${whl}"
echo "INFO: Installing TFlite" &> /dev/stderr
sudo pip3 install "${url}"
if [ $? != 0 ]; then
  echo "ERROR: Failed to install TFlite runtime; exiting. URL: ${url}" &> /dev/stderr
  exit 1
else
  echo "INFO: successfully installed TFlite runtime" &> /dev/stderr
fi

echo "INFO: Installing libedgetpu1-max" &> /dev/stderr
sudo apt install -qq -y libedgetpu1-max
