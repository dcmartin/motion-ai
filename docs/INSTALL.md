# `INSTALL.md`

The `motion-ai` solution is composed of multiple components

+ [Home Assistant](http://home-assistant.io) - open-source home automation system
+ [Open Horizon](http://github.com/dcmartin/open-horizon) - open-source edge AI platform

Home Assistant _add-ons_:

+ `MQTT` - messaging broker for all components
+ `motion` _add-on_ for Home Assistant - captures images and video of motion (n.b. [motion-project.github.io](http://motion-project.github.io))

Open Horizon AI _services_:

+ `yolo4motion` - [YOLO](https://pjreddie.com/darknet/yolo/) object detection and classification
+ `face4motion` - [FACE](http://github.com/dcmartin/openface) detection
+ `alpr4motion` - [ALPR](http://github.com/dcmartin/openface) license plate detection and classification
+ `pose4motion` - [POSE](http://github.com/dcmartin/openpose) human pose estimation

## Installation

Installation is performed in three (3) steps:

1. Install `motion-ai` software from [this](http://gitub.com/motion-ai/home-assistant) repository
2. Configure system for cameras, messaging, and Open Horizon _services_
2. Install _add-ons_ for `MQTT` and `motion` through Home Assistant Web interface
3. Start selected Open Horizon AI agents (e.g. `yolo4motion`)

To get started flash distribution image to micro-SD card, configure for `ssh` and WiFi, insert into device, boot, update and upgrade (n.b. see [here](DEBIAN.md) for additional information).

#  &#10122; - Install `motion-ai`

Access via `ssh` or console; the following commands will complete the configuration and installation of `motion-ai`

```
# enable appropriate permissions for the account
for g in $(groups pi | awk -F: '{ print $2 }'); do sudo addgroup ${USER} ${g}; done
```
```
# install the minimum required software (n.b. `git` and `jq`)
sudo apt install -qq -y git jq
```
```
# clone the repository into location with sufficient space
mkdir motion-ai
cd motion-ai
git clone git@github.com:dcmartin/motion-ai.git .
```
```
# download and install Home Assistant, Docker, NetData, and supporting components
./sh/get.hassio.sh
# add current user to docker group
sudo addgroup ${USER} docker
```
```
# copy template for webcams.json
cp homeassistant/motion/webcams.json.tmpl webcams.json
# build YAML files based on configuration options
make
# reboot
sudo reboot
```

When the system has restarted, access via `ssh` and  continue with the next step.

## &#10123; - Configure `motion-ai`

Specify options forthe `motion` _add-on_ as well as the `yolo4motion`, `face4motion`, and `alpr4motion` as appropriate.  Relevant variables include:

### `motion` 
+ `MOTION_GROUP` - identifier for a group of devices; default: `motion`
+ `MOTION_DEVICE` - identifier for this device; default: _hostname_ without `-` and other special characters
+ `MOTION_CLIENT` - identifier for device to listen; default: `MOTION_DEVICE`; use `+` for all devices in _group_
+ `MQTT_HOST` - IPv4 address of MQTT broker; default: `127.0.0.1`
+ `MQTT_PORT` - Port number; default: `1883`
+ `MQTT_USERNAME` - credential identifier; default: `username`
+ `MQTT_PASSWORD` - credential password; default: `password`
+ `MOTIONCAM_USERNAME` - credential identifier; default: `username`
+ `MOTIONCAM_PASSWORD` - credential password; default: `password`
+ `NETCAM_USERNAME` - credential identifier; default: `username`
+ `NETCAM_PASSWORD`- credential password; default: `password`

### `yolo4motion`
+ `YOLO_CONFIG` - may be `tiny`, `tiny-v2`, `tiny-v3`, `v2`, or `v3`; default: `tiny` _(pre-loaded)_
+ `YOLO_ENTITY` - entity to detect; default: `all`
+ `YOLO_SCALE` - size for image scaling prior to detect; default: `none`
+ `YOLO_THRESHOLD` - threshold for entity detection; default: `0.25`
+ `LOG_LEVEL` - logging level; default: `info`
+ `LOG_TO` - logging output; default: `/dev/stderr`

These variables' values may be specified by environment variables or persistently through files of the same name; for example:

```
echo 'pi31' > MOTION_DEVICE
echo '+' > MOTION_CLIENT
```
```
# specify camera(s); default is one camera named `local`
cp homeassistant/motion/webcams.json.tmpl  webcams.json
```
```
# specify credentials to access motion-ai cameras
echo 'username' > MOTIONCAM_PASSWORD
echo 'password' > MOTIONCAM_PASSWORD
```
```
# specify credential to access third-party network cameras
echo 'username' > NETCAM_PASSWORD
echo 'password' > NETCAM_PASSWORD
```
```
# specify MQTT options
echo '192.168.1.50' > MQTT_HOST
echo 'username' > MQTT_USERNAME
echo 'password' > MQTT_PASSWORD
```


Once Home Assistant has been downloaded and starts the Web UI may be reached on the specified port.

Changes may be made for a variety of [options](OPTIONS.md); when changes are made (e.g. to the `MQTT_HOST`) the following command **must** be run for those changes to take effect:

```
make restart
```
### `webcams.json`

This JSON file contains information about the cameras which will be in the generated YAML; more cameras require more computational resources.  Those details include:

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

# &#10124; - Install _add-on(s)_
Install the requiste _add-ons_ for Home Assistant, including the `MQTT` broker and the appropriate version of `motion`.  Browse to the Home Assistant Web interface (n.b. don't forget `port` if not `80`) and visit the **Supervisor** via the icon in the lower left panel (see below).

[![example](samples/supervisor.png?raw=true "supervisor")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/supervisor.png)

Select the `Add-on Store` and type in the address of this repository, for example:

[![example](samples/add-repository.png?raw=true "add-repository")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/add-repository.png)

When the system reloads, select the **Motion Server** _add-on_ from those available; when utilizing a locally attached USB camera, select the **Motion Video0** _add-on_; for example:

[![example](samples/dcmartin-repository.png?raw=true "dcmartin-repository")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/dcmartin-repository.png)

After selecting the appropriate _add-on_, install by clicking on the `'INSTALL` button, for example:

 [![example](samples/motion-server-addon.png?raw=true "motion-server-addon")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/motion-server-addon.png)

Configure the add-on using the following options:

+ `group` - the identifier for the group of cameras; default: `motion`
+ `device` - the identifier for the host of the camera; typically the _hostname_
+ `client` - the identifier for the client (single) or all `+`; default: `+`
+ `mqtt` - `host`, `port`, `username`, and `password` for MQTT server
+ `cameras` - an array of `dict` structure for each camera

For more information on configuring, please refer to the [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) documentation.

#### &#9995; Naming
A `group`, `device`, or `camera` _name_ may **ONLY** include lower-case letters (`a-z`), numbers (`0-9`), and _underscore_ (`_`) as they are used in `MQTT` _topics_.

## Camera `type`

### `local` camera
The local camera is only defined to exist and be `/dev/video0` in the [Motion Video0](http://github.com/dcmartin/hassio-addons/tree/master/motion-video0/README.md) _add-on_; changing this device requires specification through the add-on [configuration](http://github.com/dcmartin/hassio-addons/tree/master/motion-video0/config.json).  The device connected to `/dev/video0` may be a [RaspberryPi v2]() camera, a Playstation3 [Eye]() camera, or any [VL42]() camera.

```
[
  {
    "name": "kitchencam",
    "type": "local",
    "netcam_url": "http://127.0.0.1:8090/1",
    "icon": "stove",
    "netcam_userpass": "username:password"
  }
]   
```

### `netcam` camera
These cameras may use the `rtsp`, `http`, or `mjpeg` protocol specifiers (n.b.  [`netcam_url`](https://motion-project.github.io/motion_config.html#netcam_url)) section of the [Motion Project](https://motion-project.github.io/motion_guide.html) documentation.

```
[
  {
    "name": "pondlive",
    "type": "netcam",
    "netcam_url": "mjpeg://192.168.1.174/img/video.mjpeg",
    "icon": "waves",
    "netcam_userpass": "!secret netcam-userpass"
  }
]
```

### `ftpd` camera
For network cameras that deposit video via FTP; the `username` and `password` apply the the `netcam_url` for access to the camera (n.b. direct, not through the `motion` port).  If using this type of camera, please install an appropriate **FTP** _add-on_, e.g.  [`addon-ftp`](https://github.com/hassio-addons/addon-ftp).


```
[
  {
    "name": "backyard",
    "type": "ftpd",
    "netcam_url": "http://192.168.1.183/img/video.mjpeg",
    "icon": "texture-box",
    "netcam_userpass": "!secret netcam-userpass"
  }
]
```

### Complete example configuration for `motion` _add-on_
```
l```
