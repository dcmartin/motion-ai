# &#127916;  - `motion` configuration

This repository contains [Home Assistant](http://home-assistant.io) configuration files, templates, and an automated mechanism for the [`motion`](https://github.com/dcmartin/hassio-addons/blob/master/motion/README.md) _add-on_ in conjunction with the [`yolo4motion`](http://github.com/dcmartin/open-horizon/blob/master/services/yolo4motion/README.md) _service_.

After configuring an appropriate device with Home Assistant (see: [here](http://github.com/dcmartin/horizon.dcmartin.com/blob/master/HASSIO.md)) , access the device using `ssh` and perform the following steps.  This process clones this repository onto the device, specifies the operational parameters, and integrates the `motion` _add-on_ and the `yolo4motion` service.

# Introduction
The Home Assistant configuration generated is dependent on many options; the most important options are:

+ `HOST_PORT` - the port number on which Home Assistant will listen; default `8123`
+ `MQTT_HOST` - the TCP/IP address or DNS name for the message broker; defaults to `core-mosquitto`
+ `MOTION_DEVICE` - unique name; defaults to `$(hostname -s)`; **do not use `-`** or reserved `MQTT` _topic_ characters
+ `MOTION_CLIENT` - the client for message topic; defaults to `MOTION_DEVICE`; for **all** clients specify `+`

These attributes may be specified through files with equivalent names containing the preferred value (see below).

## &#10122; - Clone this repository
Install the `git` command and _clone_ this repository from `github.com/dcmartin/motion-ai`, for example:

```
sudo apt update -qq -y 
sudo apt install -qq -y git
```

Additional (optional) packages:

```
sudo apt install -qq -y jq curl bc gettext make mosquitto-clients
```

Clone this repository into the target directory for Home Assistant (n.b. `/usr/share/hassio/`); for example:

```
mkdir -p /usr/share/hassio
cd /usr/share/hassio
git clone http://github.com/dcmartin/motion-ai.git .
```

## &#10123; - Install Home Assistant
Use the provided shell script to install Docker and other pre-requisites; for example:

```
sudo ./sh/get.hassio.sh
```

Once the pre-requisites are installed, run the downloaded `hassio-install.sh` script with the indicated options; for example, on a RaspberryPi model 3B+ the `-m` flag must be specified:

```
sudo ./hassio-install.sh -m raspberrypi3
```

Wait for 20-30 minutes for Home Assistant to download the necessary Docker containers and setup default configuration. 

### _Optional_: Add `docker` group
The account used may be added to the `docker` group to enable control of Docker and the containers.  Accounts in the `docker` group may be able to assume super-user privileges.

```
sudo addgroup ${USER} docker
```
Re-login to enable group privilege.

## &#10124; - Initialize Home Assistant
When the installation from step (2) completes connect to IP address for the device on the default port, `8123`, and complete setup using a Web browser, for example:

```
http://raspberrypi.local:8123
```

Create the initial user (a.ka. the _owner_), provide a name, use auto-detection to guess your location, set other attributes and finish configuration.  The default view of the default configuration should appear, as well as a _save login_ option in the lower right of the Web page.

## &#10125; - Start Motion Classic _add-on_
The add-on must be installed through the Home Assistant UX; please refer to [`INSTALL.md`](INSTALL.md) for details on instalation and configuration of the add-on.  Visit the [`motion` _add-on_](https://github.com/dcmartin/hassio-addons/blob/master/motion-video0/DOCS.md) documentation for _add-on_ configuration information.

### Options
The `default` attributes for _cameras_ are utilized unless the _camera_ entry specifies an alternative; please note the `netcam_userpass` may be shared across cameras or specified for any.

 + `mqtt` - ensure `host`, `username`, and `password` match `MQTT` _add-on_ configuration
 + `group` - a _name_ collection of device(s), each with one or more cameras.
 + `device`- the unique _name_ used in the `MQTT` topic
 + `client` - the unique _name_ per `device` or `+` for all `group` camera(s)
 + `timezone` - for time across `group`
 + `cameras` - one or more `netcam`, `ftpd` cameras; at most one (1) `local` camera

For example:

```
log_level: info
log_motion_level: info
log_motion_type: ALL
default:
  changes: 'on'
  event_gap: 5
  framerate: 5
  minimum_motion_frames: 5
  post_pictures: best
  text_scale: 2
  threshold: 750
  lightswitch_percent: 50
  threshold_maximum: 100000
  username: '!secret motioncam-username'
  password: '!secret motioncam-password'
  netcam_userpass: '!secret netcam-userpass'
  width: 640
  height: 480
mqtt:
  host: '!secret mqtt-broker'
  port: '!secret mqtt-port'
  username: '!secret mqtt-username'
  password: '!secret mqtt-password'
group: motion
device: pi43
client: pi43
timezone: America/Los_Angeles
cameras:
  - name: pi43
    type: local
    icon: raspberry-pi
    w3w: []
    top: 75
    left: 15
```

After configuration, start the _add-on_.

#### &#9995; Naming
A `group`, `device`, or `camera` _name_ may **ONLY** include lower-case letters (`a-z`), numbers (`0-9`), and _underscore_ (`_`) as those `name` are used in `MQTT` _topics_.

## &#10126; - Configure `motion-ai` YAML
This repository provides a set of `YAML` files and templates specifically designed to consume information provided by the `motion` _add-on_.  These files provide a multi-view interface through both Lovelace and legacy user-interfaces.

Specify options for consumption of the `motion` _add-on_ as well as the `yolo4motion`, `face4motion`, and `alpr4motion` as appropriate.  Relevant variables include:

+ `HOST_PORT` - host port number for Home Assistant; default port is `8123`
+ `HOST_THEME` - color theme of `blue`, `yellow`, `red`, `green`, `purple`, `gray`; default: `default`
+ `MQTT_HOST` - the IP address or FQDN for the `MQTT` broker (e.g. `192.168.1.50`)
+ `MQTT_USERNAME` - the `username` for access to the broker
+ `MQTT_PASSWORD` - the `password` for access to the broker

These variables' values may be specified by environment variables or persistently through files of the same name; for example:

```
cd /usr/share/hassio
echo '+' > MOTION_CLIENT 			# listen for all client cameras
echo '192.168.1.40' > MQTT_HOST 	# IP address of MQTT broker
echo 'username' > MQTT_USERNAME 	# IP address of MQTT broker
echo 'password' > MQTT_PASSWORD	# IP address of MQTT broker
echo '80' > HOST_PORT 				# change host port from 8123
```

## &#10128; - Reconfigure Home Assistant
Once the default Home Assistant installation has finished, the Motion Classic _add-on_ has been configured and started run the `make` program to generate the YAML files; for example:

```
cd ~/motion-ai
make
```

##  &#10129; - Restart Home Assistant

The configuration may now be updated and controlled using the `make` command, including the following:

+ `restart` - restart the Home Assistant server
+ `tidy` - remove any automatically constructed YAML configuration files
+ `clean` - perform `tidy` and then remove any log files and `.storage/` recorder files
+ `realclean` - perform `clean` and then remove all database files
+ `logs` - show the Home Assistant logs

Whenever the contents of the `homeassistant/motion/webcams.json` file is changed, the system may be restarted to regenerate the YAML files appropriate for the cameras specified; for example:

```
cd ~/motion-ai
make restart
```

##  &#10130; - Start `yolo4motion` _service_
Start the `yolo4motion` service container by executing the provided [shell script](../sh/yolo4motion.sh); the options, which may be specified through equivalent environment variables or files:

+ `MQTT_HOST` - host for message broker; default: _hostname_
+ `MOTION_GROUP` - which clients to process; default: `motion`
+ `MOTION_DEVICE` - which clients to process; default: _hostname_
+ `MOTION_CLIENT` - which clients to process; default: `+`
+ `MOTION_CAMERA` - which camera to process; default: `+`
+ `YOLO_CONFIG` - may be `tiny`, `tiny-v2`, `tiny-v3`, `v2`, or `v3`; default: `tiny` _(pre-loaded)_
+ `YOLO_ENTITY` - entity to detect; default: `all`
+ `YOLO_SCALE` - size for image scaling prior to detect; default: `none`
+ `YOLO_THRESHOLD` - threshold for entity detection; default: `0.25`
+ `LOG_LEVEL` - logging level; default: `info`
+ `LOG_TO` - logging output; default: `/dev/stderr`

The `tiny` model (aka `tiny-v2`) only detects [these](https://github.com/dcmartin/openyolo/blob/master/darknet/data/voc.names) entities; the remaining models detect [these](https://github.com/dcmartin/openyolo/blob/master/darknet/data/coco.names) entities.

**Note:** The Docker container and the model's weights must be downloaded from the Internet; there may be a considerable delay given the device Internet connection bandwidth.  The container is only downloaded one time, but the model's weights  are downloaded each time the container is started.

For example:

```
cd /usr/share/hassio
echo debug > LOG_LEVEL
echo tiny-v3 > YOLO_CONFIG
./sh/yolo4motion.sh
... deleted ...
{
  "name": "yolo4motion",
  "id": "6d1765902d260f5b6e276f26391eb135eedef5388bf15ce77fa976adcf7a13c6",
  "service": {
    "label": "yolo4motion",
    "id": "com.github.dcmartin.open-horizon.yolo4motion",
    "tag": "0.1.2",
    "arch": "amd64",
    "ports": {
      "service": 80,
      "host": 4662
    }
  },
  "motion": {
    "group": "motion",
    "client": "+",
    "camera": "+"
  },
  "yolo": {
    "config": "tiny",
    "entity": "all",
    "scale": "none",
    "threshold": 0.25
  },
  "mqtt": {
    "host": "192.168.1.50",
    "port": 1883,
    "username": "username",
    "password": "password"
  },
  "debug": {
    "debug": false,
    "level": "info",
    "logto": "/dev/stderr"
  }
}
```

##  &#9989; - Start `face4motion`and `alpr4motion` (_optional_)
These two Open Horizon _services_ may also be started via shell scripts, namely [`alpr4motion.sh`](../sh/alpr4motion.sh) and [`face4motion`](../sh/face4motion.sh).  These scripts utilize the same environment variables for `MQTT`, `MOTION`, and `LOG` attributes as `yolo4motion.sh`, but have their own specific options rather than `YOLO`:

### `face4motion.sh`
+ `FACE_THRESHOLD` - floating point value between `0.0` and `0.99`; default: `0.5`

### `alpr4motion.sh`
+ `ALPR_COUNTRY` - designation for country specific license plates, may be `us` or `eu`; default: `us`
+ `ALPR_PATTERN` - pattern for plate recognition, may be regular expression; default: `none`
+ `ALPR_TOPN` - integer value between `1` and `20` limiting number `tag` predictions per `plate` 

##  &#9989; - Watch `MQTT` traffic (_optional_)
To monitor the `MQTT` traffic from one or more `motion` devices use the `./sh/watch.sh` script which runs a `MQTT` client to listen for various _topics_, including motion detection events, annotations, detections, and a specified detected entity (n.b. currently limited per device).  The script outputs information to `/dev/stderr` and runs in the background.  The shell script will utilize existing values for the `MQTT` host, etc.. as well as the `MOTION_CLIENT`, but those may be specified as well; for example:

```
echo motion > MOTION_GROUP
echo + > MOTION_CLIENT
./sh/watch.sh
```

# Reference

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`MOTION_GROUP`|Name for the group of device(s) |`motion`|`motion-group`
`MOTION_DEVICE`|Name of the `motion` _addon_ host|_`HOST_NAME`_|`motion-device`
`MOTION_CLIENT`|Device(s) topic for `MQTT`|`+`|`motion-client`
`HOST_PORT`|Port number for Home Assistant|`8123`|`ha-port`
`HOST_NAME`|Host name for local reference |**`hostname -f`**|`ha-name`
`HOST_IPADDR`|Host LAN IP address or FQDN|**`hostname -I`**|`ha-ip`
`MOTIONCAM_USERNAME`|`MJPEG` stream from `motion` _add-on_ |`username`|`motioncam-username`
`MOTIONCAM_PASSWORD`|`MJPEG` stream from `motion` _add-on_ |`password`|`motioncam-password`
`MQTT_HOST`|Broker LAN IP address or FQDN |`core-mosquitto`|`mqtt-broker`
`MQTT_USERNAME`|Authentication |`username`|`mqtt-username`
`MQTT_PASSWORD`|Authentication |`password`|`mqtt-password`
`NETCAM_USERNAME`|Authentication for `netcam` _type_ cameras|`username`|`netcam-username`
`NETCAM_PASSWORD`|Authentication for `netcam` _type_ cameras|`password`|`netcam-password`
