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

In addition, the configuration depends on a listing of cameras, notably the file `motion/webcams.json` which must be created; there is a [template](http://github.com/dcmartin/horizon.dcmartin.com/blob/master/motion/webcams.json.tmpl) provided.

# &#11088; - Prepare device
After installing LINUX, creating user account, and accessing device, configure the `domainname` and optionally grant privileges to enable automated `sudo`, for example:

```
echo "mydomain.com" | sudo tee /etc/domainname
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/010_${USER}-nopasswd"
```

## &#10122; - Update, upgrade, and install pre-requisite software
Do the standard things and upgrade all software; older RaspberryPi devices may need firmware upgrades.

```
sudo apt update -qq -y 
sudo apt full-upgrade -qq -y 
sudo apt install -qq -y git jq curl bc gettext make mosquitto-clients
```
## &#10123; - Clone repository and install
Clone this repository into a directory in the local file-system, e.g. `~/GIT/motion/`; for example:

```
mkdir -p ~/GIT/
cd ~/GIT/
git clone http://github.com/dcmartin/motion.git
```

Cloning the repository creates a new directory, `motion/`; use the provided shell script to install Docker and other pre-requisites; for example:

```
cd ~/GIT/motion
sudo ./sh/get.hassio.sh
```

Add the account to the `docker` group; for example:

```
sudo addgroup ${USER} docker
sudo reboot
```
Reboot to enable `docker` and set group privilege.  Login again, and initiate installation of Home Assistant, for example:

```
cd ~/GIT/motion
sudo ./hassio-install.sh -m raspberrypi3
```

Wait for 20-30 minutes for Home Assistant to download the necessary Docker containers and setup default configuration. 

## &#10124; - Initialize Home Assistant
When the installation from step (2) completes connect to IP address for the device on the default port, `8123`, and complete setup using a Web browser, for example:

```
http://raspberrypi.local:8123
```

Create the initial user (a.ka. the _owner_), provide a name, use auto-detection to guess your location, set other attributes and finish configuration.  The default view of the default configuration should appear, as well as a _save login_ option in the lower right of the Web page.

## &#10125; - Install `motion` _add-on_
The add-on must be installed through the Home Assistant UX; please refer to [`INSTALL.md`](INSTALL.md) for details on instalation and configuration of the add-on.  Visit the [`motion` _add-on_](https://github.com/dcmartin/hassio-addons/blob/master/motion/CONFIGURATION.md) documentation for _add-on_ configuration information.

### Options for `motion` _add-on_
The `default` attributes for _cameras_ are utilized unless the _camera_ entry specifies an alternative; please note the `netcam_userpass` may be shared across cameras or specified for any.

 + `mqtt` - ensure `host`, `username`, and `password` match `MQTT` _add-on_ configuration
 + `group` - a _name_ collection of device(s), each with one or more cameras.
 + `device`- the unique _name_ used in the `MQTT` topic
 + `client` - the unique _name_ per `device` or `+` for all `group` camera(s)
 + `timezone` - for time across `group`
 + `cameras` - one or more `netcam`, `ftpd` cameras; at most one (1) `local` camera

After configuration, start the _add-on_.

#### &#9995; Naming
A `group`, `device`, or `camera` _name_ may **ONLY** include lower-case letters (`a-z`), numbers (`0-9`), and _underscore_ (`_`).

### Example configuration for `motion` _add-on_
```
log_level: debug
log_motion_level: error
log_motion_type: ALL
default:
  brightness: 100
  changes: 'on'
  contrast: 50
  despeckle: EedDl
  event_gap: 10
  framerate: 2
  hue: 50
  interval: 60
  lightswitch: 0
  minimum_motion_frames: 10
  movie_max: 60
  movie_output: 'off'
  movie_quality: 80
  netcam_userpass: '!secret motioncam-userpass'
  palette: 15
  picture_quality: 80
  post_pictures: best
  saturation: 0
  stream_quality: 50
  text_scale: 2
  threshold_percent: 1
  username: '!secret motioncam-username'
  password: '!secret motioncam-password'
  width: 1920
  height: 1080
mqtt:
  host: 192.168.1.50
  port: '1883'
  username: username
  password: password
group: motion
device: netcams
client: netcams
timezone: America/Los_Angeles
cameras:
  - name: poolcam
    type: netcam
    icon: water
    netcam_url: 'http://192.168.1.162/nphMotionJpeg?Resolution=640x480&Quality=Clarity'
    netcam_userpass: '!secret netcam-userpass'
    width: 640
    height: 480
    framerate: 5
  - name: road
    type: netcam
    icon: road
    netcam_url: 'http://192.168.1.36:8081/'
    netcam_userpass: '!secret netcam-userpass'
    width: 640
    height: 480
    framerate: 5
  - name: dogshed
    type: netcam
    icon: dog
    netcam_url: 'rtsp://192.168.1.221/live'
  - name: dogshedfront
    type: netcam
    icon: home-floor-1
    netcam_url: 'rtsp://192.168.1.222/live'
  - name: sheshed
    type: netcam
    icon: window-shutter-open
    netcam_url: 'rtsp://192.168.1.223/live'
  - name: dogpond
    type: netcam
    icon: waves
    netcam_url: 'rtsp://192.168.1.224/live'
  - name: pondview
    type: netcam
    icon: waves
    netcam_url: 'rtsp://192.168.1.225/live'
```


## &#10126; - Build `motion` YAML
This repository provides a set of `YAML` files and templates specifically designed to consume information provided by the `motion` _add-on_.  These files provide a multi-view interface through both Lovelace and legacy user-interfaces.

Specify options according to environment and local files; build YAML configuration files using the `make` command, for example:

```
cd ~/GIT/motion/
echo '[]' > homeassistant/motion/webcams.json # initially for zero motion addon-on cameras
echo '+' > MOTION_CLIENT 			# listen for all client cameras
echo '192.168.1.40' > MQTT_HOST 	# IP address of MQTT broker
echo 'username' > MQTT_USERNAME 	# IP address of MQTT broker
echo 'password' > MQTT_PASSWORD	# IP address of MQTT broker
echo '80' > HOST_PORT 				# change host port from 8123
make
```

The `make` command should exit successfully having produced a number of YAML files in the `homeassistant/` subdirectory.

### &#10071;  - `motion/webcams.json`
Specifications in  `homeassistant/motion/webcams.json` file contain information about the cameras which will be inclued in the generated YAML; **warning** more cameras require more computational resources.  Those details include:

+ `name` : a unique name for the camera (e.g. `kitchencam`)
+ `mjpeg_url` : location of "live" motion JPEG stream from camera
+ `username` and `password` : credentials for access via the `mjpeg_url`
+ `icon` : specified from the [Material Design Icons](https://materialdesignicons.com/) selection.

For example:

```
[
  { "name": "poolcam", "mjpeg_url": "http://192.168.1.251:8090/1", "icon": "water", "username": "!secret motioncam-username", "password": "!secret motioncam-password" },
  { "name": "road", "mjpeg_url": "http://192.168.1.251:8090/2", "icon": "road", "username": "!secret motioncam-username", "password": "!secret motioncam-password" },
  { "name": "dogshed", "mjpeg_url": "http://192.168.1.251:8090/3", "icon": "dog", "username": "!secret motioncam-username", "password": "!secret motioncam-password" },
  { "name": "dogshedfront", "mjpeg_url": "http://192.168.1.251:8090/4", "icon": "home-floor-1", "username": "!secret motioncam-username", "password": "!secret motioncam-password" },
  { "name": "sheshed", "mjpeg_url": "http://192.168.1.251:8090/5", "icon": "window-shutter-open", "username": "!secret motioncam-username", "password": "!secret motioncam-password" },
  { "name": "dogpond", "mjpeg_url": "http://192.168.1.251:8090/6", "icon": "waves", "username": "!secret motioncam-username", "password": "!secret motioncam-password" },
  { "name": "pondview", "mjpeg_url": "http://192.168.1.251:8090/7", "icon": "waves", "username": "!secret motioncam-username", "password": "!secret motioncam-password" }
]
```

The `motion` configuration installs over an existing `/usr/share/hassio/` directory contents, but only over-writes file in the `homeassistant/` subdirectory. 

To complete installation, copy the contents of  this repository into the existing installation, change ownership, and create new `configuration.yaml` file; for example:

```
cd ~/GIT/motion
tar cvf - . | ( cd /usr/share/hassio; sudo tar xvf - )
cd ~/GIT/
rm -fr motion/ && ln -s /usr/share/hassio motion
cd /usr/share/hassio/
sudo chown -R ${USER} .
cd homeassistant/
rm -f configuration.yaml
ln -s config-client.yaml.tmpl configuration.yaml
```

## &#10127; - Restart Home Assistant
The configuration may now be updated and controlled using the `make` command, including the following:

+ `restart` - restart the Home Assistant server
+ `tidy` - remove any automatically constructed YAML configuration files
+ `clean` - perform `tidy` and then remove any log files and `.storage/` recorder files
+ `realclean` - perform `clean` and then remove all database files
+ `logs` - show the Home Assistant logs

```
make restart
```

##  &#10128; - Start `yolo4motion` _service_
Start the `yolo4motion` service container by executing the provided [shell script](../sh/yolo4motion.sh); the options, which may be specified through equivalent environment variables or file.

### `yolomotion.sh`

+ `MQTT_HOST` - host for message broker; default: _hostname_
+ `MOTION_GROUP` - which clients to process; default: `motion`
+ `MOTION_CLIENT` - which clients to process; default: _hostname_
+ `MOTION_CAMERA` - which camera to process; default: `+`
+ `YOLO_CONFIG` - may be `tiny`, `tiny-v2`, `tiny-v3`, `v2`, or `v3`; default: `tiny`
+ `YOLO_ENTITY` - entity to detect; default: `all`
+ `YOLO_SCALE` - size for image scaling prior to detect; default: `none`
+ `YOLO_THRESHOLD` - threshold for entity detection; default: `0.25`
+ `LOG_LEVEL` - logging level; default: `info`
+ `LOG_TO` - logging output; default: `/dev/stderr`

For example:

```
LOG_LEVEL=debug YOLO_CONFIG=tiny-v3 ./sh/yolo4motion.sh
```

The `tiny` model (aka `tiny-v2`) only detects [these](https://github.com/dcmartin/openyolo/blob/master/darknet/data/voc.names) entities; the remaining models detect [these](https://github.com/dcmartin/openyolo/blob/master/darknet/data/coco.names) entities.

**Note:** The Docker container and the model's weights must be downloaded from the Internet; there may be a considerable delay given the device Internet connection bandwidth.  The container is only downloaded one time, but the model's weights  are downloaded each time the container is started.

##  &#10129; - Start `face4motion`and `alpr4motion` (_optional_)
These two Open Horizon _services_ may also be started via shell scripts, namely [`alpr4motion.sh`](../sh/alpr4motion.sh) and [`face4motion`](../sh/face4motion.sh).  These scripts utilize the same environment variables for `MQTT`, `MOTION`, and `LOG` attributes as `yolo4motion.sh`, but have their own specific options rather than `YOLO`:

### `face4motion.sh`
+ `FACE_THRESHOLD` - floating point value between `0.0` and `0.99`; default: `0.5`

### `alpr4motion.sh`
+ `ALPR_COUNTRY` - designation for country specific license plates, may be `us` or `eu`; default: `us`
+ `ALPR_PATTERN` - pattern for plate recognition, may be regular expression; default: `none`
+ `ALPR_TOPN` - integer value between `1` and `20` limiting number `tag` predictions per `plate` 

##  &#10130; - Watch `MQTT` traffic (_optional_)
To monitor the `MQTT` traffic from one or more `motion` devices use the `./sh/watch.sh` script which runs a `MQTT` client to listen for various _topics_, including motion detection events, annotations, detections, and a specified detected entity (n.b. currently limited per device).  The script outputs information to `/dev/stderr` and runs in the background.  The shell script will utilize existing values for the `MQTT` host, etc.. as well as the `MOTION_CLIENT`, but those may be specified as well; for example:

```
MOTION_GROUP=motion MOTION_CLIENT=+ MQTT_HOST=192.168.1.50 ./sh/watch.sh
```

# Reference

Variable|Description|Default|Info
:-------|:-------|:-------|:-------
`MOTION_GROUP`|Name for the group of device(s) |`motion`|Aggregate devices' identifier
`MOTION_DEVICE`|Name of the `motion` _addon_ host|_`HOST_NAME`_|_see above_
`MOTION_CLIENT`|Device(s) topic for `MQTT`|_`MOTION_DEVICE`_|Aggregate using: **`"+"`**
`HOST_PORT`|Port number for Home Assistant|`8123`|
`DOMAIN_NAME`|Domain for local services |**`domainname`** _output_|May be `local`
`HOST_NAME`|Host name for local reference |**`hostname -f`** _output_|May be `IP` address
`HOST_IPADDR`|Local `IP` address |**`hostname -I`** _output_|Should _not_ be `127.0.0.1`
`WEBCAM_USERNAME`|Authentication login for cameras |`username`|Credentials from `motion` addon
`WEBCAM_PASSWORD`|Authentication password for cameras |`password`|Credentials from `motion` addon
`MQTT_USERNAME`|Authentication login for cameras |`username`|Credentials from `MQTT` addon
`MQTT_PASSWORD`|Authentication password for cameras |`password`|Credentials from `MQTT` addon

