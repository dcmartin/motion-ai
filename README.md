<img src="docs/samples/example-motion-detection.gif" width="512">

# `motion`  &Atilde;&#128065;
This   repository is a demonstration and proof-of-concept for an **AI assistants** providing improved situational awareness from a collection of network accessible video cameras.

Most consumer-grade Web cameras -- or similar devices -- send notifications when _motion_ occurs.  Motion is often defined as a change in the image from one frame to the next; these changes are often influenced by light, wind, and many other environmental factors -- producing a large number of notifications (a.k.a. _false positives_).  While limitations may be set on the amount of change to indicate motion, a better solution would detect and classify entities of interest whenever motion occurs and send notifications only when specified are present.

To accomplish that objective, a combination of open source components have been integrated to provide a means to detect motion and recognize entities.  The resulting detections and recognitions may then be analyzed and used for a variety of purposes (e.g. counting over time).   Currently the system supports:

+ [object detection and classification](http://github.com/dcmartin/openyolo)
+ [automated license plate recognition](http://github.com/dcmartin/openalpr)
+ [face detection](http://github.com/dcmartin/openface) (n.b. not recognition).

All of this processing is performed on local devices; there are **no cloud services** utilized.  This pattern is known as _edge computing_.  Supported architectures include:

+ `amd64` - Intel/AMD 64-bit virtual machines and devices (e.g. VirtualBox Ubuntu18 VM)
+ `aarch64` - ARMv8 64-bit devices (e.g. nVidia Jetson Nano)
+ `armv7` - ARMv7 32-bit devices (e.g. RaspberryPi 3/4)

Currently there is **no support** for nVidia `CUDA` GPU hardware; support is in-plan for `amd64` and `aarch64`.   Support for Intel  Neural Compute Stick v2 is being considered for `armv7`.

## Status
![](https://img.shields.io/github/license/dcmartin/motion.svg?style=flat)
![](https://img.shields.io/github/release/dcmartin/motion.svg?style=flat)
![](https://img.shields.io/github/repo-size/dcmartin/motion.svg?style=flat)
![](https://img.shields.io/github/issues/dcmartin/motion.svg?style=flat)
![](https://img.shields.io/github/tag/dcmartin/motion.svg?style=flat)

![](https://img.shields.io/github/last-commit/dcmartin/motion.svg?style=flat)
![](https://img.shields.io/github/commit-activity/w/dcmartin/motion.svg?style=flat)
![](https://img.shields.io/github/contributors/dcmartin/motion.svg?style=flat)

[![Build Status](https://travis-ci.org/dcmartin/motion.svg?branch=master)](https://travis-ci.org/dcmartin/motion)
[![Coverage Status](https://coveralls.io/repos/github/dcmartin/motion/badge.svg?branch=master)](https://coveralls.io/github/dcmartin/motion?branch=master)

# Components

## 1. Home Assistant
[Home Assistant](http://home-assistant.io)  is an open source home automation software putting local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. Perfect to run on a [Raspberry Pi](https://en.wikipedia.org/wiki/Raspberry_Pi) or a local server.   HomeAssistant includes _add-on_ Docker containers  from the HomeAssistant [community](https://github.com/hassio-addons/repository/blob/master/README.md).  Please refer to the installation instructions for Home Assistant in [`HASSIO.md`](docs/HASSIO.md).

###  `motion` _add-on_
The Home Assistant _add-on_ [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) provides the capabilities of the [Motion Project](https://motion-project.github.io/) software in conjunction with a specified message broker to capture and process motion detection events.  These events are published as `MQTT`  _topics_ for consumption by Home Assistant and the supporting  _services_.

The  _add-on_ supports three _types_ of cameras:

+ `netcam` - may be any supported by the [Motion Project](https://motion-project.github.io/motion_config.html); see the *Network Cameras* section.
+ `ftpd` - cameras the transmit `3GP` videos via `FTP`; **requires** `FTP` add-on (see below)
+ `local` - video device supported by `V4L2`; **requires** `motion-video0` add-on and `/dev/video0`

**Please refer to [`MOTION.md`](docs/MOTION.md) for further information.**

In addition, the following community _add-ons_ should be configured appropriately:

+ [`MQTT`](https://github.com/home-assistant/hassio-addons/blob/master/mosquitto/README.md) - may be run privately on local device or shared on network
+ [`FTP`](https://github.com/hassio-addons/addon-ftp/blob/master/README.md) - optional, only required for `ftpd` type cameras

## 2. Open Horizon _services_
[Open Horizon](http://github.com/dcmartin/open-horizon) is an open source _edge_ fabric for microservices.  The Open Horizon microservices are run as Docker containers on a distributed network across a wide range of computing devices; from [Power9](http://openpowerfoundation.org/) servers to RaspberryPi [Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) micro-computers.  

### `yolo4motion`
![Supports amd64 Architecture][amd64-shield]
[![](https://images.microbadger.com/badges/image/dcmartin/amd64_com.github.dcmartin.open-horizon.yolo4motion.svg)](https://microbadger.com/images/dcmartin/amd64_com.github.dcmartin.open-horizon.yolo4motion)
[![](https://images.microbadger.com/badges/version/dcmartin/amd64_com.github.dcmartin.open-horizon.yolo4motion.svg)](https://microbadger.com/images/dcmartin/amd64_com.github.dcmartin.open-horizon.yolo4motion)
[![Docker Pulls][pulls-yolo4motion-amd64]][docker-yolo4motion-amd64]

[docker-yolo4motion-amd64]: https://hub.docker.com/r/dcmartin/amd64_com.github.dcmartin.open-horizon.yolo4motion
[pulls-yolo4motion-amd64]: https://img.shields.io/docker/pulls/dcmartin/amd64_com.github.dcmartin.open-horizon.yolo4motion.svg

![Supports arm Architecture][arm-shield]
[![](https://images.microbadger.com/badges/image/dcmartin/arm_com.github.dcmartin.open-horizon.yolo4motion.svg)](https://microbadger.com/images/dcmartin/arm_com.github.dcmartin.open-horizon.yolo4motion)
[![](https://images.microbadger.com/badges/version/dcmartin/arm_com.github.dcmartin.open-horizon.yolo4motion.svg)](https://microbadger.com/images/dcmartin/arm_com.github.dcmartin.open-horizon.yolo4motion)
[![Docker Pulls][pulls-yolo4motion-arm]][docker-yolo4motion-arm]

[docker-yolo4motion-arm]: https://hub.docker.com/r/dcmartin/arm_com.github.dcmartin.open-horizon.yolo4motion
[pulls-yolo4motion-arm]: https://img.shields.io/docker/pulls/dcmartin/arm_com.github.dcmartin.open-horizon.yolo4motion.svg

![Supports arm64 Architecture][arm64-shield]
[![](https://images.microbadger.com/badges/image/dcmartin/arm64_com.github.dcmartin.open-horizon.yolo4motion.svg)](https://microbadger.com/images/dcmartin/arm64_com.github.dcmartin.open-horizon.yolo4motion)
[![](https://images.microbadger.com/badges/version/dcmartin/arm64_com.github.dcmartin.open-horizon.yolo4motion.svg)](https://microbadger.com/images/dcmartin/arm64_com.github.dcmartin.open-horizon.yolo4motion)
[![Docker Pulls][pulls-yolo4motion-arm64]][docker-yolo4motion-arm64]

[docker-yolo4motion-arm64]: https://hub.docker.com/r/dcmartin/arm64_com.github.dcmartin.open-horizon.yolo4motion
[pulls-yolo4motion-arm64]: https://img.shields.io/docker/pulls/dcmartin/arm64_com.github.dcmartin.open-horizon.yolo4motion.svg

The Open Horizon _service_ [`yolo4motion`](http://github.com/dcmartin/open-horizon/tree/master/yolo4motion/README.md) provides the capabilities of the [YOLO](https://github.com/dcmartion/openyolo/) software in conjunction with a specified `MQTT` message broker.  This service subscribes to the _topic_ `{group}/{device}/{camera}/event/end` and processes the JavaScript Object Notation (JSON) payload which includes a selected `JPEG` image (n.b. `BASE64` encoded) from the motion event.  This service may be used independently of the Open Horizon service as a stand-alone Docker container; see [`yolo4motion.sh`](http://github.com/dcmartin/motion/tree/master/sh/yolo4motion.sh)

### `alpr4motion`
![Supports amd64 Architecture][amd64-shield]
[![](https://images.microbadger.com/badges/image/dcmartin/amd64_com.github.dcmartin.open-horizon.alpr4motion.svg)](https://microbadger.com/images/dcmartin/amd64_com.github.dcmartin.open-horizon.alpr4motion)
[![](https://images.microbadger.com/badges/version/dcmartin/amd64_com.github.dcmartin.open-horizon.alpr4motion.svg)](https://microbadger.com/images/dcmartin/amd64_com.github.dcmartin.open-horizon.alpr4motion)
[![Docker Pulls][pulls-alpr4motion-amd64]][docker-alpr4motion-amd64]

[docker-alpr4motion-amd64]: https://hub.docker.com/r/dcmartin/amd64_com.github.dcmartin.open-horizon.alpr4motion
[pulls-alpr4motion-amd64]: https://img.shields.io/docker/pulls/dcmartin/amd64_com.github.dcmartin.open-horizon.alpr4motion.svg

![Supports arm Architecture][arm-shield]
[![](https://images.microbadger.com/badges/image/dcmartin/arm_com.github.dcmartin.open-horizon.alpr4motion.svg)](https://microbadger.com/images/dcmartin/arm_com.github.dcmartin.open-horizon.alpr4motion)
[![](https://images.microbadger.com/badges/version/dcmartin/arm_com.github.dcmartin.open-horizon.alpr4motion.svg)](https://microbadger.com/images/dcmartin/arm_com.github.dcmartin.open-horizon.alpr4motion)
[![Docker Pulls][pulls-alpr4motion-arm]][docker-alpr4motion-arm]

[docker-alpr4motion-arm]: https://hub.docker.com/r/dcmartin/arm_com.github.dcmartin.open-horizon.alpr4motion
[pulls-alpr4motion-arm]: https://img.shields.io/docker/pulls/dcmartin/arm_com.github.dcmartin.open-horizon.alpr4motion.svg

![Supports arm64 Architecture][arm64-shield]
[![](https://images.microbadger.com/badges/image/dcmartin/arm64_com.github.dcmartin.open-horizon.alpr4motion.svg)](https://microbadger.com/images/dcmartin/arm64_com.github.dcmartin.open-horizon.alpr4motion)
[![](https://images.microbadger.com/badges/version/dcmartin/arm64_com.github.dcmartin.open-horizon.alpr4motion.svg)](https://microbadger.com/images/dcmartin/arm64_com.github.dcmartin.open-horizon.alpr4motion)
[![Docker Pulls][pulls-alpr4motion-arm64]][docker-alpr4motion-arm64]

[docker-alpr4motion-arm64]: https://hub.docker.com/r/dcmartin/arm64_com.github.dcmartin.open-horizon.alpr4motion
[pulls-alpr4motion-arm64]: https://img.shields.io/docker/pulls/dcmartin/arm64_com.github.dcmartin.open-horizon.alpr4motion.svg

The Open Horizon _service_ [`alpr4motion`](http://github.com/dcmartin/open-horizon/tree/master/alpr4motion/README.md) provides the capabilities of the [OpenALPR](https://github.com/dcmartin/openalpr/) software in conjunction with a specified `MQTT` message broker.  This service subscribes to the _topic_ `{group}/{device}/{camera}/event/end` and processes the JavaScript Object Notation (JSON) payload which includes a selected `JPEG` image (n.b. `BASE64` encoded) from the motion event.  This service may be used independently of the Open Horizon service as a stand-alone Docker container; see [`alpr4motion.sh`](http://github.com/dcmartin/motion/tree/master/sh/alpr4motion.sh)

### `face4motion`
![Supports amd64 Architecture][amd64-shield]
[![](https://images.microbadger.com/badges/image/dcmartin/amd64_com.github.dcmartin.open-horizon.face4motion.svg)](https://microbadger.com/images/dcmartin/amd64_com.github.dcmartin.open-horizon.face4motion)
[![](https://images.microbadger.com/badges/version/dcmartin/amd64_com.github.dcmartin.open-horizon.face4motion.svg)](https://microbadger.com/images/dcmartin/amd64_com.github.dcmartin.open-horizon.face4motion)
[![Docker Pulls][pulls-face4motion-amd64]][docker-face4motion-amd64]

[docker-face4motion-amd64]: https://hub.docker.com/r/dcmartin/amd64_com.github.dcmartin.open-horizon.face4motion
[pulls-face4motion-amd64]: https://img.shields.io/docker/pulls/dcmartin/amd64_com.github.dcmartin.open-horizon.face4motion.svg

![Supports arm Architecture][arm-shield]
[![](https://images.microbadger.com/badges/image/dcmartin/arm_com.github.dcmartin.open-horizon.face4motion.svg)](https://microbadger.com/images/dcmartin/arm_com.github.dcmartin.open-horizon.face4motion)
[![](https://images.microbadger.com/badges/version/dcmartin/arm_com.github.dcmartin.open-horizon.face4motion.svg)](https://microbadger.com/images/dcmartin/arm_com.github.dcmartin.open-horizon.face4motion)
[![Docker Pulls][pulls-face4motion-arm]][docker-face4motion-arm]

[docker-face4motion-arm]: https://hub.docker.com/r/dcmartin/arm_com.github.dcmartin.open-horizon.face4motion
[pulls-face4motion-arm]: https://img.shields.io/docker/pulls/dcmartin/arm_com.github.dcmartin.open-horizon.face4motion.svg

![Supports arm64 Architecture][arm64-shield]
[![](https://images.microbadger.com/badges/image/dcmartin/arm64_com.github.dcmartin.open-horizon.face4motion.svg)](https://microbadger.com/images/dcmartin/arm64_com.github.dcmartin.open-horizon.face4motion)
[![](https://images.microbadger.com/badges/version/dcmartin/arm64_com.github.dcmartin.open-horizon.face4motion.svg)](https://microbadger.com/images/dcmartin/arm64_com.github.dcmartin.open-horizon.face4motion)
[![Docker Pulls][pulls-face4motion-arm64]][docker-face4motion-arm64]

[docker-face4motion-arm64]: https://hub.docker.com/r/dcmartin/arm64_com.github.dcmartin.open-horizon.face4motion
[pulls-face4motion-arm64]: https://img.shields.io/docker/pulls/dcmartin/arm64_com.github.dcmartin.open-horizon.face4motion.svg

[arm64-shield]: https://img.shields.io/badge/arm64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[arm-shield]: https://img.shields.io/badge/arm-yes-green.svg
The Open Horizon _service_ [`face4motion`](http://github.com/dcmartin/open-horizon/tree/master/face4motion/README.md) provides the capabilities of the [OpenFACE](https://github.com/dcmartin/openface/) software in conjunction with a specified `MQTT` message broker.  This service subscribes to the _topic_ `{group}/{device}/{camera}/event/end` and processes the JavaScript Object Notation (JSON) payload which includes a selected `JPEG` image (n.b. `BASE64` encoded) from the motion event.  This service may be used independently of the Open Horizon service as a stand-alone Docker container; see [`face4motion.sh`](http://github.com/dcmartin/motion/tree/master/sh/face4motion.sh)

# Example
When combined together and operating successfully, the system automatically detects the `person` entity, as well as any faces and license plates, updating both the Home Assistant Web user-interface and providing notifications in the browser (n.b. mobile notifications require SSL and are pending).

Data may be saved locally and processed to produce historical graphs as well as exported for analysis using other tools, e.g. time-series database _InfluxDB_ and analysis front-end _Grafana_.  Data may also be processed using _Jupyter_ notebooks.

[![example](docs/samples/example.png?raw=true "EXAMPLE")](http://github.com/dcmartin/hassio-addons/tree/master/motion/docs/samples/example.png)

## Operational Scenarios
This system may be used to build solutions for various operational scenarios, e.g. monitoring the elderly to determine patterns of daily activity and alert care-givers and loved ones when aberrations occur; see the [Age-At-Home](http://www.age-at-home.com/) project for more information; example below:

<img src="docs/samples/age-at-home.png" width="512">

# What  is _edge computing_?
The edge of the network is where connectivity is lost and privacy is challenged; extending the services developed for the cloud to these scenarios requires additional considerations for microservices development, notably graceful degradation when services are lost, as well as automated recovery and restart when appropriate.  Available computing in edge scenarios may vary from a single device to multiple varying devices on a local-area-network (LAN), for example _home automation_.  Example use-cases include detecting motion and classifying entities seen and monitoring Internet connectivity.

## Further reading
+ [_Understanding AI_](https://www.linkedin.com/pulse/understanding-ai-david-c-martin)
+ [_Building a better 'bot_](https://www.linkedin.com/pulse/building-better-bot-david-c-martin)

# Changelog & Releases

Releases are based on Semantic Versioning, and use the format
of ``MAJOR.MINOR.PATCH``. In a nutshell, the version will be incremented
based on the following:

- ``MAJOR``: Incompatible or major changes.
- ``MINOR``: Backwards-compatible new features and enhancements.
- ``PATCH``: Backwards-compatible bugfixes and package updates.

## Authors & contributors

David C Martin (github@dcmartin.com)

## Stargazers
[![Stargazers over time](https://starchart.cc/dcmartin/motion.svg)](https://starchart.cc/dcmartin/motion)

