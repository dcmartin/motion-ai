# `README.md`
This   repository is a demonstration and proof-of-concept for a variety of [Open Horizon](http://github.com/dcmartin/open-horizon) _edge_ microservices.  The Open Horizon microservices are run as Docker containers on a distributed network across a wide range of computing devices; from [Power9](http://openpowerfoundation.org/) servers to RaspberryPi [Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) micro-computers.

## What is the _edge_?
The edge of the network is where connectivity is lost and privacy is challenged; extending the services developed for the cloud to these scenarios requires additional considerations for microservices development, notably graceful degradation when services are lost, as well as automated recovery and restart when appropriate.  Available computing in edge scenarios may vary from a single device to multiple varying devices on a local-area-network (LAN), for example _home automation_.  Example use-cases include detecting motion and classifying entities seen and monitoring Internet connectivity.

## Home Assistant
This system depends on the  [Home Assistant](http://home-assistant.io)  open source home automation software putting local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. Perfect to run on a [Raspberry Pi](https://en.wikipedia.org/wiki/Raspberry_Pi) or a local server.   HomeAssistant include _add-on_ Docker containers  from the HomeAssistant [community](https://github.com/hassio-addons/repository/blob/master/README.md).  Please refer to the installation instructions for Home Assistant are in the [`HASSIO.md`](HASSIO.md) document in this repository.

In addition, the following community _add-ons_ should be configured appropriately:

+ [`MQTT`]() - may be run privately on local device or shared on network
+ [`FTP`]() - optional, only required for `ftpd` type cameras

## Home Assistant `motion` _add-on_
The Home Assistant _add-on_ [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) provides the capabilities of the [Motion Project](https://motion-project.github.io/) software in conjunction with a specified `MQTT` message broker to capture and process motion detection events.  These events are published as _topics_ on the message broker for consumption by Home Assistant and the `yolo4motion` _service_.

## Open Horizon `yolo4motion` _service_
The Open Horizon _service_ [`yolo4motion`](http://github.com/dcmartin/open-horizon/tree/master/yolo4motion/README.md) provides the capabilities of the [YOLO](https://pjreddie.com/darknet/yolo/) software in conjunction with a specified `MQTT` message broker.  This service subscribes to the _topic_ `{group}/{device}/{camera}/event/end` and processes the JavaScript Object Notation (JSON) payload which includes a selected `JPEG` image (n.b. `BASE64` encoded) from the motion event.  This service may be used independently of the Open Horizon service as a stand-alone Docker container; see [`yolo4motion.sh`](http://github.com/dcmartin/horizon.dcmartin.com/tree/master/sh/yolo4motion.sh)

# Example

[![example](samples/example.png?raw=true "EXAMPLE")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/example.png)


# Using this repository

## Step 1
To utilize additional capabilities in this repository there are some additional applications required:

```
sudo apt install -qq -y git make build-essential jq bc curl
```

## Step 2
Copy the contents of this repository into a temporary directory, e.g. `/tmp/config`:

```
git clone http://github.com/dcmartin/horizon.dcmartin.com /tmp/config
cd /tmp/config
```

## Step 3
Move the contents of the repository into the HomeAssistant configuration directory:

```
sudo mv .??* * /usr/share/hassio/homeassistant
sudo chown -R $(whoami) /usr/share/hassio/homeassistant
```

## Step 4
There are a set of control variables that may be specified through local (n.b. `git` ignored) files; these variables are used to generate YAML, including the `secrets.yaml` file for Home Assistant.

Variable|Description|Default|Info
:-------|:-------|:-------|:-------
`DOMAIN_NAME`|Domain for local services |**`domainname`** _output_|May be `local`
`HOST_NAME`|Host name for local reference |**`hostname -f`** _output_|May be `IP` address
`HOST_IPADDR`|Local `IP` address |**`hostname -I`** _output_|Should _not_ be `127.0.0.1`
`WEBCAM_USERNAME`|Authentication login for cameras |`username`|Credentials from `motion` addon
`WEBCAM_PASSWORD`|Authentication password for cameras |`password`|Credentials from `motion` addon
`MQTT_USERNAME`|Authentication login for cameras |`username`|Credentials from `MQTT` addon
`MQTT_PASSWORD`|Authentication password for cameras |`password`|Credentials from `MQTT` addon

Change directory to the standard location for installation of Home Assistant, and specify control variables, for example:

```
cd /usr/share/hassio/homeassistant
echo '$(domainname)' > DOMAIN_NAME
echo $(hostname -I | awk '{ print $1 }') > HOST_IPADDR
echo $(hostname -f) > HOST_NAME
echo 'whocares' > EXCHANGE_APIKEY
echo $(whoami) > EXCHANGE_ORG
echo 'username' > WEBCAM_USERNAME
echo 'password' > WEBCAM_PASSWORD
echo 'username' > MQTT_USERNAME
echo 'password' > MQTT_PASSWORD
```

## Step 5
Configure the `motion` _addon_ camera(s) by creating `motion/webcams.json`; see the [`MOTION.md`](MOTION.md) instructions.

## Step 6
Remove the default `configuration.yaml` and link (or copy) the template provided:

```
rm configuration.yaml
ln -s config-server.yaml.tmpl configuration.yaml
```

## Step 5
Build the YAML configuration files based on the environment and the `motion/webcams.json` file and restart the Home Assistant server:

```
make clean
make all
make restart
```

The results include both `WARN` and `INFO` for environment specified; check these values to ensure that values are set as desired.

```
++ WARN: LOGGER_DEFAULT unset; default: warn
++ WARN: AUTOMATION_internet unset; default: off
++ WARN: AUTOMATION_startup unset; default: off
++ WARN: AUTOMATION_sdr2msghub unset; default: off
++ WARN: AUTOMATION_yolo2msghub unset; default: off
-- INFO: DOMAIN_NAME: dcmartin.com
++ WARN: HOST_NAME unset; default: pi3-2
-- INFO: HOST_IPADDR: 192.168.1.72
-- INFO: HOST_PORT: 80
-- INFO: HOST_THEME: green
++ WARN: MQTT_HOST unset; default: core-mosquitto
++ WARN: MQTT_PORT unset; default: 1883
++ WARN: MQTT_USERNAME unset; default: username
++ WARN: MQTT_PASSWORD unset; default: password
++ WARN: WEBCAM_USERNAME unset; default: dcmartin
-- INFO: WEBCAM_PASSWORD: username
++ WARN: NETDATA_URL unset; default: http://192.168.1.72:19999/
++ WARN: DIGITS_URL unset; default: http://digits.dcmartin.com:5000/
++ WARN: COUCHDB_URL unset; default: http://couchdb.dcmartin.com:5984/_utils
++ WARN: EDGEX_URL unset; default: http://edgex.dcmartin.com:4000
++ WARN: CONSUL_URL unset; default: http://consul.dcmartin.com:8500/ui
++ WARN: EXCHANGE_URL unset; default: http://exchange.dcmartin.com:3090
++ WARN: EXCHANGE_ORG unset; default: dcmartin
++ WARN: EXCHANGE_ORG_ADMIN unset; default: dcmartin
-- INFO: EXCHANGE_APIKEY: whocares
++ WARN: HZNMONITOR_URL unset; default: http://hznmonitor.dcmartin.com:3094
++ WARN: GRAFANA_URL unset; default: http://grafana.dcmartin.com:3000
++ WARN: INFLUXDB_HOST unset; default: influxdb.dcmartin.com
-- INFO: INFLUXDB_PASSWORD: ask4it
making motion
make[1]: Entering directory '/usr/share/hassio/homeassistant/motion'
make[1]: Nothing to be done for 'default'.
make[1]: Leaving directory '/usr/share/hassio/homeassistant/motion'
making secrets.yaml
```

Optionally inspect the `secrets.yaml` file to check that all values are specified as expected, for example:

```
cd /usr/share/hassio/homeassistant
cat secrets.yaml
```
