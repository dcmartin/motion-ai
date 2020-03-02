# &#127863; - `OPENVINO.md` - Intel Neural Compute Stick

This document provides a process to setup a RaspberryPi model 4 with an Intel Neural Compute Stick version 2.  The required system:

+ RaspberryPi Model 4
+ Raspian version 10 (aka `Buster`)

The RaspberryPi must have the required operating system installed and configured; for more [information](https://software.intel.com/en-us/articles/ARM-sbc-and-NCS2).

Software to be installed:

+ `OpenCV` [toolkit](https://opencv.org/)
+ `OpenVINO` [toolkit](http://software.intel.com/en-us/articles/intel-neural-compute-stick-2-and-open-source-openvino-toolkit)

## Step 1
Build and test the installation of OpenCV for the RaspberryPi4; **this step will take approximately one (1) hour.**

+ Create directory, copy required version of OpenCV, unpack
+ Build using `make` command with four (4) concurrent jobs
+ Define environment variable `OpenCV_DIR`
+ Test installation using Python

```
mkdir -p ~/GIT/
cd ~/GIT/
wget https://github.com/opencv/opencv/archive/4.1.0.zip
unzip 4.1.0.zip
cd opencv-4.1.0
mkdir build && cd build
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr/local/ \
  -DPYTHON3_EXECUTABLE=/usr/lib/python3.7 \
  –DPYTHON_INCLUDE_DIR=/usr/include/python3.7 \
  –DPYTHON_INCLUDE_DIR2=/usr/include/arm-linux-gnueabihf/python3.7m \
  –DPYTHON_LIBRARY=/usr/lib/arm-linux-gnueabihf/libpython3.7m.so \
  ..
make -j4
make install
export OpenCV_DIR=/usr/local/share/opencv4
python3 << EOF
import cv2
cv2.__VERSION__
EOF
```

## Step 2
Download, build and test the Deep Learning Development Toolkit (`dldt`); **this step will take approximately thirty (30) minutes.**

+ Clone `opencv/dldt` repository, and pull all submodules recursively.
+ Install all dependecies
+ Create a build directory, configure the `make` files, and build
+ Test installation with provided `benchmark_app`

```
cd ~/GIT
git clone https://github.com/opencv/dldt.git
cd ~/GIT/dldt/inference-engine
git submodule init
git submodule update –-recursive
sudo ./install_dependencies.sh
mkdir build && cd build
export OpenCV_DIR=/usr/local/share/opencv4
cmake -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_MKL_DNN=OFF \
  -DENABLE_CLDNN=OFF \
  -DENABLE_GNA=OFF \
  -DENABLE_SSE42=OFF \
  -DTHREADING=SEQ \
  -DCMAKE_CXX_FLAGS='-march=armv7-a' \
  ..
make
./bin/armv7/Release/benchmark_app –h
```


## Step 3
Configure the NCS2 USB Driver by defining additional `udev` rules, restarting, and loading the driver.

```
cat > /etc/udev/rules.d/97-myriad-usbboot.rules << EOF
SUBSYSTEM=="usb", ATTRS{idProduct}=="2150", ATTRS{idVendor}=="03e7", GROUP="users", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
SUBSYSTEM=="usb", ATTRS{idProduct}=="2485", ATTRS{idVendor}=="03e7", GROUP="users", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
SUBSYSTEM=="usb", ATTRS{idProduct}=="f63b", ATTRS{idVendor}=="03e7", GROUP="users", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
EOF
udevadm control --reload-rules
udevadm trigger
ldconfig
```

## Step 4
Download models

```
cd ~/GIT/dldt
mkdir models
cd models
curl -sL https://download.01.org/opencv/2019/open_model_zoo/R1/models_bin/age-gender-recognition-retail-0013/FP16/age-gender-recognition-retail-0013.xml
curl -sL https://download.01.org/opencv/2019/open_model_zoo/R1/models_bin/age-gender-recognition-retail-0013/FP16/age-gender-recognition-retail-0013.bin
curl -sL https://software.intel.com/sites/default/files/managed/4e/7d/Setup%20Additional%20Files%20Package.tar.gz -o additional.tar.gz
tar xzvf additional.tar.gz
```

## Step X
Test installation; possible architectures:

+ `armv7`
+ `intel64`

```
cd ~/GIT/dldt/inference-engine
./bin/armv7/Release/benchmark_ap –I ~/GIT/dldt/models/president_reagan-62x62.png –m ~/GIT/dldt/models/age-gender-recognition-retail-0013.xml –pp ./lib –api async –d MYRIAD
```
