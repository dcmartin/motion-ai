# `motion`  &Atilde;&#128065;
This   repository is a demonstration and proof-of-concept for an **AI assistatant** providing improved situational awareness from a collection of network accessible video cameras.  Most consumer-grade Web cameras -- or similar devices -- send notifications when _motion_ occurs.

Motion is often defined as a change in the video from one instance to the next; these changes are often influenced by light, wind, and many other environmental factors -- producing a large number of notifications.  While limitations may be set on the amount of change, a better solution would detect and classify movement.

To accomplish that objective, a combination of open source components have been integrated to provide a means to detect motion and recognize selected entities, e.g. a _person_, a _vehicle_, or an _animal_.  The resulting detection may then be processed for notifications as well as analysis.

<a href="http://github.com/dcmartin/hassio-addons/tree/master/motion/docs/samples/example-motion-detection.gif"><img src="docs/samples/example-motion-detection.gif" width="512"></a>

All of this processing is performed on local devices; there are **no cloud services** utilized.  This pattern is known as _edge computing_.

### What  is _edge computing_?
The edge of the network is where connectivity is lost and privacy is challenged; extending the services developed for the cloud to these scenarios requires additional considerations for microservices development, notably graceful degradation when services are lost, as well as automated recovery and restart when appropriate.  Available computing in edge scenarios may vary from a single device to multiple varying devices on a local-area-network (LAN), for example _home automation_.  Example use-cases include detecting motion and classifying entities seen and monitoring Internet connectivity.

#### Further reading
+ [_Understanding AI_](https://www.linkedin.com/pulse/understanding-ai-david-c-martin)
+ [_Building a better 'bot_](https://www.linkedin.com/pulse/building-better-bot-david-c-martin)

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
The Home Assistant _add-on_ [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) provides the capabilities of the [Motion Project](https://motion-project.github.io/) software in conjunction with a specified message broker to capture and process motion detection events.  These events are published as `MQTT`  _topics_ for consumption by Home Assistant and the supporting  _Open Horizon_ `yolo4motion` _service_.

**Please refer to [`MOTION.md`](docs/MOTION.md) for further information.**

In addition, the following community _add-ons_ should be configured appropriately:

+ [`MQTT`](https://github.com/home-assistant/hassio-addons/blob/master/mosquitto/README.md) - may be run privately on local device or shared on network
+ [`FTP`](https://github.com/hassio-addons/addon-ftp/blob/master/README.md) - optional, only required for `ftpd` type cameras

## 2. Open Horizon
[Open Horizon](http://github.com/dcmartin/open-horizon) is an open source _edge_ fabric for microservices.  The Open Horizon microservices are run as Docker containers on a distributed network across a wide range of computing devices; from [Power9](http://openpowerfoundation.org/) servers to RaspberryPi [Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) micro-computers.

### `yolo4motion` _service_
The Open Horizon _service_ [`yolo4motion`](http://github.com/dcmartin/open-horizon/tree/master/yolo4motion/README.md) provides the capabilities of the [YOLO](https://pjreddie.com/darknet/yolo/) software in conjunction with a specified `MQTT` message broker.  This service subscribes to the _topic_ `{group}/{device}/{camera}/event/end` and processes the JavaScript Object Notation (JSON) payload which includes a selected `JPEG` image (n.b. `BASE64` encoded) from the motion event.  This service may be used independently of the Open Horizon service as a stand-alone Docker container; see [`yolo4motion.sh`](http://github.com/dcmartin/motion/tree/master/sh/yolo4motion.sh)

### `alpr4motion` _service_
The Open Horizon _service_ [`alpr4motion`](http://github.com/dcmartin/open-horizon/tree/master/alpr4motion/README.md) provides the capabilities of the [OpenALPR](https://github.com/dcmartin/openalpr/) software in conjunction with a specified `MQTT` message broker.  This service subscribes to the _topic_ `{group}/{device}/{camera}/event/end` and processes the JavaScript Object Notation (JSON) payload which includes a selected `JPEG` image (n.b. `BASE64` encoded) from the motion event.  This service may be used independently of the Open Horizon service as a stand-alone Docker container; see [`alpr4motion.sh`](http://github.com/dcmartin/motion/tree/master/sh/alpr4motion.sh)

# Example
When combined together and operating successfully, the system automatically detects `person` and provides both visual update of the Web user-interface for the most recent entity, as well as most recent detection of any entity, as well as provides notifications through the Web interface (n.b. mobile notifications require SSL and are pending).

Data may be saved locally and processed to produce historical graphs as well as exported for analysis using other tools, e.g. time-series database _InfluxDB_ and analysis front-end _Grafana_.  Data may also be processed using _Jupyter_ notebooks.


[![example](samples/example.png?raw=true "EXAMPLE")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/example.png)
