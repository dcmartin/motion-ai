# `horizon.dcmartin.com`


# Introduction
This repository contains YAML files for the configuration of the [`horizon.dcmartin.com`](http://horizon.dcmartin.com:8123) site.

This  [HomeAssistant](http://home-assistant.io)  site is a demonstration and proof-of-concept for a variety of [Open Horizon](http://github.com/open-horizon) _edge_ microservices.  The Open Horizon microservices are run as Docker containers on a distributed network across a wide range of computing devices; from [Power9](http://openpowerfoundation.org/) servers to RaspberryPi [Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) micro-computers.

## What is the "edge"
The edge of the network is where connectivity is lost and privacy is challenged; extending the services developed for the cloud to these scenarios requires additional considerations for microservices development, notably graceful degradation when services are lost, as well as automated recovery and restart when appropriate.

Available computing in edge scenarios may vary from a single device to multiple varying devices on a local-area-network (LAN), for example _home automation_.  Example use-cases include detecting motion and classifying entities seen and monitoring Internet connectivity.

<hr>

# What is Open Horizon
Open Horizon is an open source project sponsored by IBM to provide an orchestration mechanism for Docker containers in edge scenarios.  Containers are composed into _services_ which are subsequently packaged into _patterns_ that can be deployed to _nodes_ connected to the _exchange_.  The patterns run by nodes are combinations of services that are designed to interoperate.

## Install Open Horizon
Installation instructions can be found [here](https://github.com/dcmartin/open-horizon/blob/master/setup/README.md).

### `exchange-api`
Once installation is complete, the _services_ and _patterns_ can be built and _published_ using the Open Horizon [`exchange-api`](https://github.com/open-horizon/exchange-api/blob/master/README.md) to an _exchange_ -- a server running a specified set of Docker containers, e.g. `http://alpha.edge-fabric.com/v1/`.  Those containers include both  PostgreSQL and MongoDB databases.

### `edge-sync-service`
The [`edge-sync-service`](https://github.com/open-horizon/edge-sync-service/blob/master/README.md) provides for bi-directional synchonization of binary objects between the server and the devices using the _node_ information in the _exchange_.  The client component is called the `ESS` and the service component is called the `CSS`.  Client and server poll for new objects and data; object data consumers indicate receipt.  A sample service, `esstest`, is available in another [repository](https://github.com/dcmartin/open-horizon/blob/master/esstest/README.md).

### `anax`
The [`anax`](https://github.com/open-horizon/anax/blob/master/README.md) control application runs on both the client and the server (n.b. as an _agbot_); the client version is installed on a supported device, for example the Raspberry Pi Model 3B+ (n.b. [instructions](https://github.com/dcmartin/open-horizon/blob/master/doc/RPI.md)), and then attempts to reach an _agreement_ with an _agbot_ on the server for the client's requested _pattern_ (e.g. [`yolo2mshubg`](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/README.md).

## Use Open Horizon
After client software installation, the device may be _registered_ to run a specific _pattern_ of services from the exchange.  The pattern specifies one or more services to be deployed to the device and registration records the device as a _node_ in the exchange requesting that pattern of services.

### Example: `yolo2msghub`
The [`yolo2msghub`](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/README.md) [_service_](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/service.json) is also defined as a [_pattern_](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/pattern.json).  The _service_ is composed of one Docker container deployed as `yolo2msghub`, and four (4) dependencies on `requiredServices`:

+ [`yolo`](https://github.com/dcmartin/open-horizon/blob/master/yolo/README.md) - Provide [YOLO]() image classification service
+ [`wan`](https://github.com/dcmartin/open-horizon/blob/master/wan/README.md) - Test Internet connectivity
+ [`hal`](https://github.com/dcmartin/open-horizon/blob/master/hal/README.md) - Inventory device attributes
+ [`cpu`](https://github.com/dcmartin/open-horizon/blob/master/cpu/README.md) - Calculate CPU utilization percent

Together these five (5) services provide an automated mechanism to capture pictures from a local camera, detect entities of interest (e.g. `person`), and report on presence using the Kafka messaging platform (aka _message hub_).  A sample screen capture (with development mode `on`) is below.

# Sample

![sample.png](samples/sample.png?raw=true "SAMPLE")

<hr>

# What is Home Assistant
Open source home automation that puts local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. Perfect to run on a Raspberry Pi or a local server.   HomeAssistant include _addon_ Docker containers  from the HomeAssistant [community](https://github.com/hassio-addons/repository/blob/master/README.md).

## Install Home Assistant
For details information on installing Home Assistant, please refer to the [documentation](https://www.home-assistant.io/hassio/installation/).

A quick-start method for Ubuntu and most Debian systems is listed below and available [here](https://github.com/dcmartin/open-horizon/blob/master/setup/hassio-install.sh)

```
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install -y apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat
```

Download the installation script and run it as root, for example:

```
curl -sL "https://raw.githubusercontent.com/home-assistant/hassio-installer/master/hassio_install.sh" | sudo bash -s
```

&#9995; For **RaspberryPi Model 4** machines, please edit the `hassio_install.sh` script prior to execution and change the parameters for `armv7l`, for example:

```
"armv7l")
        HOMEASSISTANT_DOCKER="$DOCKER_REPO/raspberrypi3-homeassistant"
        HASSIO_DOCKER="$DOCKER_REPO/armhf-hassio-supervisor"
    ;;
```
## Use Home Assistant
The default configuration will setup on the localhost using port `8123`; the initial download and installation of the `hassio_supervisor` and `homeassistant` Docker containers may require up to twenty (20) minutes, depending on network connection and host performance.

Once completed, there are several _addons_ which are useful in configuration, management, and functionality.  These include the following:

+ `mqtt` - provides a local MQTT broker
+ `configurator` - provide a Web interface to edit configuration files
+ `dnsmasq` - provide a DNS server to local devices

## Addons

## `mqtt`
Set up [Mosquitto](https://mosquitto.org/) as MQTT [broker](https://www.home-assistant.io/addons/mosquitto/) known as `core-mosquitto` in Home Assistant.

## `configutator`
Configure Home Assistant through an integrated Web user-interface; more instructions [here](https://www.home-assistant.io/addons/configurator)

## `dnsmasq`
If you want to use the Home Assistant [DNS](https://www.home-assistant.io/addons/dnsmasq/) _addon_, the existing DNS resolver for Ubuntu must be disabled.  This method works on Ubuntu Releases 17.04 (Zasty), 17.10 (Artful), 18.04 (Bionic) and 18.10 (Cosmic):

Disable and stop the systemd-resolved service:

```
sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved
```

Set DNS to `default`

```
sudo echo 'dns=default' >> /etc/NetworkManager/NetworkManager.conf
```

Delete  /etc/resolv.conf

```
sudo rm /etc/resolv.conf
```

Restart network-manager

```
sudo service network-manager restart
```

## Open Horizon for Hassio `addons`
Integration between Home Assistant and Open Horizon utilizes both the Home Assistant MQTT broker as well as several custom _addons_, available in another [repository](https://github.com/dcmartin/hassio-addons/blob/master/README.md), which may be installed using the **Hassio** control panel in the Home Assistant Web UI.

These addons are available by specifying the repository in the Hassio "ADD-ON STORE" section, for example:

<img src="samples/addonstore-entry.png" width="50%">

And when successful the following should appear at the end of the page:

<img src="samples/addonstore-after.png">


## Kafka to MQTT relay for YOLO
This addon is designed to consume Kafka messages on the topic `yolo2msghub` and produce MQTT messages for consumption by the Home Assistant MQTT broker _addon_.  Visit  [`kafka2mqtt4yolo`](https://github.com/dcmartin/hassio-addons/tree/master/kafka2mqtt4yolo) page for details. 

## Open Horizon Shared GPU and GPS
Collects Kafka messages on topic: `cpu2msghub` and produces MQTT messages for consumption by Home Assistant MQTT `sensor` on `cpu2msghub` topic as `events`.  Visit  [`cpu2msghub`](https://github.com/dcmartin/hassio-addons/tree/master/cpu2msghub) page for details. 

## Open Horizon Shared SDR
Collects Kafka messages on topic: `sdr/audio` and produces MQTT messages for consumption by Home Assistant MQTT `sensor` on `sdr2msghub` as `events`;  processes spoken audio through IBM Watson Speech-to-text (STT) and Natual Language Understanding (NLU) to produce sentiment and other AI predictions.  Visit  [`sdr2msghub`](https://github.com/dcmartin/hassio-addons/tree/master/sdr2msghub) page for details. 

## Motion
Processes video information into motion detection JSON events, multi-frame GIF animations, and one representative frame with entities detected, classified, and annotated (n.b. requires Open Horizon `yolo4motion` service).  This addon is designed to work with a variety of sources, including:

+ `3GP` - motion-detecting WebCams (e.g. Linksys WCV80n); received via the `FTP` _addon_
+ `MJPEG` - network accessible cameras providing Motion-JPEG real-time feed
+ `V4L2` - video for LINUX (v2) for direct attach cameras, e.g. Sony Playstation3 Eye camera or RaspberryPi v2

Visit  [`motion`](https://github.com/dcmartin/hassio-addons/tree/master/motion) page for details. 

<hr>

# Open Horizon _services_ and _patterns_
A set of Open Horizon _services_ and _patterns_ is available in another [repository](http://github.com/dcmartin/open-horizon).  Some of the patterns are specified to interoperate with the Home Assistant _addons_, notably the **MQTT broker**, to process messages between services.

+ `startup` - device, Docker, and node status; produce JSON on port: 3093; Kafka topic: `startup`
+ `hznsetup` - automate setup of new devices as _nodes_; also available as _pattern_ with `hznmonitor`
+ `hznmonitor` - process JSON `startup` messages via Kafka; summarize JSON; publish MQTT topic: `startup`
+ `yolo4motion` - process image using `yolo`; pub/sub MQTT topics to/from `motion` _addon_
+ `motion2mqtt` - process video from LINUX (V4L2), direct-attach, cameras; pub/sub MQTT topic: multiple

## `startup`
Visit  [`startup`](https://github.com/dcmartin/open-horizon/blob/master/startup/README.md) page for details. 

## `hznsetup`
Visit  [`hznsetup`](https://github.com/dcmartin/open-horizon/blob/master/hznsetup/README.md) page for details. 

## `hznmonitor`
Visit  [`hznmonitor`](https://github.com/dcmartin/open-horizon/blob/master/hznmonitor/README.md) page for details. 

## `yolo4motion`
Visit  [`yolo4motion`](https://github.com/dcmartin/open-horizon/blob/master/yolo4motion/README.md) page for details. 

## `motion2mqtt`
Using the open source [`motion`](https://motion-project.github.io/) package, process camera output and produce motion detection _events_ indicating the start (optional) and end of motion.  **Notice**: there are a wide variety of options to the `motion` package; not all are necessarily supported or exploited in this service.  Visit  [`motion2mqtt`](https://github.com/dcmartin/open-horizon/blob/master/motion2mqtt/README.md) page for details. 

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
