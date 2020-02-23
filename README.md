# &#128679; - `README.md`
This   repository is a demonstration and proof-of-concept for [Open Horizon](http://github.com/dcmartin/open-horizon) _edge_ microservices.  The Open Horizon microservices are run as Docker containers on a distributed network across a wide range of computing devices; from [Power9](http://openpowerfoundation.org/) servers to RaspberryPi [Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) micro-computers.

## What is the _edge_?
The edge of the network is where connectivity is lost and privacy is challenged; extending the services developed for the cloud to these scenarios requires additional considerations for microservices development, notably graceful degradation when services are lost, as well as automated recovery and restart when appropriate.  Available computing in edge scenarios may vary from a single device to multiple varying devices on a local-area-network (LAN), for example _home automation_.  Example use-cases include detecting motion and classifying entities seen and monitoring Internet connectivity.

## Home Assistant
This software depends on the  [Home Assistant](http://home-assistant.io)  open source home automation software putting local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. Perfect to run on a [Raspberry Pi](https://en.wikipedia.org/wiki/Raspberry_Pi) or a local server.   HomeAssistant includes _add-on_ Docker containers  from the HomeAssistant [community](https://github.com/hassio-addons/repository/blob/master/README.md).  Please refer to the installation instructions for Home Assistant in [`HASSIO.md`](HASSIO.md).

## Home Assistant `motion` _add-on_
The Home Assistant _add-on_ [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) provides the capabilities of the [Motion Project](https://motion-project.github.io/) software in conjunction with a specified message broker to capture and process motion detection events.  These events are published as `MQTT`  _topics_ for consumption by Home Assistant and the supporting  _Open Horizon_ `yolo4motion` _service_.

**Please refer to [`MOTION.md`](MOTION.md) for further information.**

In addition, the following community _add-ons_ should be configured appropriately:

+ [`MQTT`](https://github.com/home-assistant/hassio-addons/blob/master/mosquitto/README.md) - may be run privately on local device or shared on network
+ [`FTP`](https://github.com/hassio-addons/addon-ftp/blob/master/README.md) - optional, only required for `ftpd` type cameras

## Open Horizon `yolo4motion` _service_
The Open Horizon _service_ [`yolo4motion`](http://github.com/dcmartin/open-horizon/tree/master/yolo4motion/README.md) provides the capabilities of the [YOLO](https://pjreddie.com/darknet/yolo/) software in conjunction with a specified `MQTT` message broker.  This service subscribes to the _topic_ `{group}/{device}/{camera}/event/end` and processes the JavaScript Object Notation (JSON) payload which includes a selected `JPEG` image (n.b. `BASE64` encoded) from the motion event.  This service may be used independently of the Open Horizon service as a stand-alone Docker container; see [`yolo4motion.sh`](http://github.com/dcmartin/horizon.dcmartin.com/tree/master/sh/yolo4motion.sh)

# Example

[![example](samples/example.png?raw=true "EXAMPLE")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/example.png)
