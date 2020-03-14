# &#127916;  - `motion` configuration

This repository contains [Home Assistant](http://home-assistant.io) configuration files, templates, and an automated mechanism for the [`motion`](https://github.com/dcmartin/hassio-addons/blob/master/motion/README.md) _add-on_ in conjunction with the [`yolo4motion`](http://github.com/dcmartin/open-horizon/blob/master/yolo4motion/README.md) _service_.

After configuring an appropriate device with Home Assistant (see: [here](http://github.com/dcmartin/horizon.dcmartin.com/blob/master/HASSIO.md)) , access the device using `ssh` and perform the following steps.  This process clones this repository onto the device, specifies the operational parameters, and integrates the `motion` _add-on_ and the `yolo4motion` service.

# Introduction
The Home Assistant configuration generated is dependent on many options; the most important options are:

+ `HOST_PORT` - the port number on which Home Assistant will listen; default `8123`
+ `MQTT_HOST` - the identifier for the message broker; defaults to `core-mosquitto`
+ `MOTION_CLIENT` - the client for message topic; defaults to `<hostname>`; for **all** clients specify `+`

These attributes may be specified through files with equivalent names containing the preferred value (see below).

In addition, the configuration depends on a listing of cameras, notably the file `motion/webcams.json` which must be created; there is a [template](http://github.com/dcmartin/horizon.dcmartin.com/blob/master/motion/webcams.json.tmpl) provided.

# &#11088; - Prepare device
After installing LINUX, creating user account, and accessing device, configure the `domainname` and optionally grant privileges to enable automated `sudo`, for example:

```
sudo domainname mydomain.com
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/010_${USER}-nopasswd"
```

## &#10122; - Update, upgrade, and install pre-requisite software
Do the standard things and upgrade all software; older RaspberryPi devices may need firmware upgrades.

```
sudo apt update -qq -y 
sudo apt upgrade -qq -y 
sudo apt install -qq -y git jq curl bc gettext make git mosquitto-clients
```
## &#10123; - Clone repository; install Docker and Home Assistant
Clone this repository into a temporary location, e.g. `~/horizon.dcmartin.com/`, and use the provided shell scripts to install Docker and Home Assistant; for example:

```
cd ~/
mkdir -p ~/GIT/motion
cd ~/GIT/motion
git clone http://github.com/dcmartin/motion.git .
sudo ./sh/get.hassio.sh
sudo addgroup ${USER} docker
sudo reboot
```
Reboot to enable `docker` and set group privilege.  Login again, and initiate installation of Home Assistant, for example:

```
cd ~/GIT/motion
sudo ./hassio-install.sh -m raspberrypi3
```

Wait for 20-30 minutes for Home Assistant to download the necessary Docker containers and setup default configuration.  Then connect to IP address on the default port, `8123`, and complete setup using a Web browser, for example:

```
http://127.0.0.1:8123
```

## &#10124; - Home Assistant configuration
The `motion` configuration overwrites the existing `/usr/share/hassio/` directory contents.  Copy the contents of  this repository into the existing installation, change ownership, and create new `configuration.yaml` file; for example:

```
cd ~/GIT/motion
tar cvf - . | ( cd /usr/share/hassio; sudo tar xvf - )
rm -fr motion/ && ln -s /usr/share/hassio motion
cd /usr/share/hassio/
sudo chown -R ${USER} .
cd homeassistant/
rm -f configuration.yaml
ln -s config-client.yaml.tmpl configuration.yaml
```
## &#10125; - Build configuration files
Specify options according to environment and local files; build YAML configuration files using the `make` command, for example:

```
cd /usr/share/hassio/homeassistant
echo '[]' > motion/webcams.json 	# initially for zero motion addon-on cameras
echo '+' > MOTION_CLIENT 			# listen for all client cameras
echo '192.168.1.40' > MQTT_HOST 	# to specify another device as broker
echo '80' > HOST_PORT 				# change host port from 8123
make
```

## &#10126; - Restart Home Assistant

```
make restart
```

##  &#10127; - Start `yolo4motion` _service_
Start the `yolo4motion` service container by executing the provided [shell script](../sh/yolo4motion.sh); the options, which may be specified through equivalent environment variables or file, are:

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
+ `DEBUG` - turn debugging on; default: `false`

For example:

```
DEBUG=true LOG_LEVEL=debug YOLO_CONFIG=tiny-v3 ./sh/yolo4motion.sh
```

## &#10128; - Install `motion` _add-on_
The device is now configured and operational, with the exception of the `motion` _add-on_ itself.  The add-on must be installed through the Home Assistant UX; please refer to [`INSTALL.md`](INSTALL.md) for information on instalation and configuration of the add-on.  Visit the [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) documentation for details.  

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

## &#10071;  - `motion/webcams.json`
 Once the add-on is configured and operational create the `homeassistant/motion/webcams.json` file with details on the camera(s) specified for the local `motion` add-on.  Those details include:

+ `name` : a unique name for the camera (e.g. `kitchencam`)
+ `mjpeg_url` : location of "live" motion JPEG stream from camera
+ `username` and `password` : credentials for access via the `mjpeg_url`
+ `icon` : specified from the [Material Design Icons](https://materialdesignicons.com/) selection.

For example:

```
[
  {
    "name": "localcam",
    "mjpeg_url": "http://127.0.0.1:8090/1",
    "icon": "webcam",
    "username": "username",
    "password": "password"
  }
]
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

