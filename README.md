# `horizon.dcmartin.com`


# Introduction
This repository contains YAML files for the configuration of the [`horizon.dcmartin.com`](http://horizon.dcmartin.com:8123) site.

This  [HomeAssistant](http://home-assistant.io)  site is a demonstration and proof-of-concept for a variety of [Open Horizon](http://github.com/open-horizon) _edge_ microservices.  The Open Horizon microservices are run as Docker containers on a distributed network across a wide range of computing devices; from [Power9](http://openpowerfoundation.org/) servers to RaspberryPi [Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) micro-computers.

## What is the "edge"
The edge of the network is where connectivity is lost and privacy is challenged; extending the services developed for the cloud to these scenarios requires additional considerations for microservices development, notably graceful degradation when services are lost, as well as automated recovery and restart when appropriate.

Available computing in edge scenarios may vary from a single device to multiple varying devices on a local-area-network (LAN), for example _home automation_.  Example use-cases include detecting motion and classifying entities seen and monitoring Internet connectivity.

## What is Open Horizon
Open Horizon is an open source project sponsored by IBM to provide an orchestration mechanism for Docker containers in edge scenarios.  Containers are composed into _services_ which are subsequently packaged into _patterns_ that can be deployed to _nodes_ connected to the _exchange_.  The patterns run by nodes are combinations of services that are designed to interoperate.

### [`yolo2msghub`](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/README.md)
For example the `yolo2msghub` service requires the following services:

+ [`yolo`](https://github.com/dcmartin/open-horizon/blob/master/yolo/README.md) - Provide [YOLO]() image classification service
+ [`wan`](https://github.com/dcmartin/open-horizon/blob/master/wan/README.md) - Test Internet connectivity
+ [`hal`](https://github.com/dcmartin/open-horizon/blob/master/hal/README.md) - Inventory device attributes
+ [`cpu`](https://github.com/dcmartin/open-horizon/blob/master/cpu/README.md) - Calculate CPU utilization percent

Together these five (5) services provide an automated mechanism to capture pictures from a local camera, detect entities of interest (e.g. `person`), and report on presence using the Kafka messaging platform (aka _message hub_).  A sample screen capture (with development mode one) is below.

## What is HomeAssistant
Open source home automation that puts local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. Perfect to run on a Raspberry Pi or a local server.   HomeAssistant include _addon_ Docker containers  from the HomeAssistant [community](https://github.com/hassio-addons/repository/blob/master/README.md).

# Sample

![sample.png](samples/sample.png?raw=true "SAMPLE")

# Changelog & Releases

Releases are based on [Semantic Versioning][semver], and use the format
of ``MAJOR.MINOR.PATCH``. In a nutshell, the version will be incremented
based on the following:

- ``MAJOR``: Incompatible or major changes.
- ``MINOR``: Backwards-compatible new features and enhancements.
- ``PATCH``: Backwards-compatible bugfixes and package updates.
[semver]: https://semver.org/


## Authors & contributors

[David C Martin][dcmartin] (github@dcmartin.com)

[userinput]: ../yolo2msghub/userinput.json
[service-json]: ../yolo2msghub/service.json
[build-json]: ../yolo2msghub/build.json
[dockerfile]: ../yolo2msghub/Dockerfile
[dcmartin]: https://github.com/dcmartin
[edge-fabric]: https://console.test.cloud.ibm.com/docs/services/edge-fabric/getting-started.html
[edge-install]: https://console.test.cloud.ibm.com/docs/services/edge-fabric/adding-devices.html
[edge-slack]: https://ibm-appsci.slack.com/messages/edge-fabric-users/
[ibm-apikeys]: https://console.bluemix.net/iam/#/apikeys
[ibm-registration]: https://console.bluemix.net/registration/
[issue]: https://github.com/dcmartin/open-horizon/issues
[macos-install]: http://pkg.bluehorizon.network/macos
[open-horizon]: http://github.com/open-horizon/
[repository]: https://github.com/dcmartin/open-horizon
[setup]: ../setup/README.md


[amd64-layers-shield]: https://images.microbadger.com/badges/image/dcmartin/plex-amd64.svg
[amd64-microbadger]: https://microbadger.com/images/dcmartin/plex-amd64
[armhf-microbadger]: https://microbadger.com/images/dcmartin/plex-armhf
[armhf-layers-shield]: https://images.microbadger.com/badges/image/dcmartin/plex-armhf.svg

[amd64-version-shield]: https://images.microbadger.com/badges/version/dcmartin/plex-amd64.svg
[amd64-arch-shield]: https://img.shields.io/badge/architecture-amd64-blue.svg
[amd64-dockerhub]: https://hub.docker.com/r/dcmartin/plex-amd64
[amd64-pulls-shield]: https://img.shields.io/docker/pulls/dcmartin/plex-amd64.svg
[armhf-arch-shield]: https://img.shields.io/badge/architecture-armhf-blue.svg
[armhf-dockerhub]: https://hub.docker.com/r/dcmartin/plex-armhf
[armhf-pulls-shield]: https://img.shields.io/docker/pulls/dcmartin/plex-armhf.svg
[armhf-version-shield]: https://images.microbadger.com/badges/version/dcmartin/plex-armhf.svg
[i386-arch-shield]: https://img.shields.io/badge/architecture-i386-blue.svg
[i386-dockerhub]: https://hub.docker.com/r/dcmartin/plex-i386
[i386-layers-shield]: https://images.microbadger.com/badges/image/dcmartin/plex-i386.svg
[i386-microbadger]: https://microbadger.com/images/dcmartin/plex-i386
[i386-pulls-shield]: https://img.shields.io/docker/pulls/dcmartin/plex-i386.svg
[i386-version-shield]: https://images.microbadger.com/badges/version/dcmartin/plex-i386.svg
