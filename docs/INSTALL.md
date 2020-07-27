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

Installation is performed in five (5) steps:

1. Install `motion-ai` software from [this](http://gitub.com/dcmartin/hassio-addons) repository
2. Configure system messaging
2. Configure cameras
2. Install _add-ons_ 
3. Start selected AI _services_ (e.g. `yolo4motion`)



#  &#10122; Install `motion-ai`
To get started flash a supported LINUX distribution image to a micro-SD card, enable `ssh` and configure WiFi; insert into device, boot, update and upgrade (n.b. see [here](DEBIAN.md) for additional information).

Access via `ssh` or console; the following commands will complete the configuration and installation of `motion-ai`

```
# 1. enable appropriate permissions for the account
for g in $(groups pi | awk -F: '{ print $2 }'); do sudo addgroup ${USER} ${g}; done
```
```
# 2. install the minimum required software (n.b. `git` and `jq`)
sudo apt install -qq -y git jq
```
```
# 3. clone the repository into location with sufficient space
mkdir motion-ai
cd motion-ai
git clone git@github.com:dcmartin/motion-ai.git .
```
```
# 4. download and install Home Assistant, Docker, NetData, and supporting components
./sh/get.hassio.sh
```
```
# 5. add current user to docker group
sudo addgroup ${USER} docker
```
```
# 6. copy template for webcams.json
cp homeassistant/motion/webcams.json.tmpl webcams.json
```
```
# 7. build YAML files based on configuration options
make
```
```
# 8. reboot
sudo reboot
```

When the system has restarted, access via `ssh` and  continue with the next step.  

## &#10123; Configure `motion-ai`
Once Home Assistant has been downloaded and starts the Web UI may be reached on the specified port; default: `8123`.

Specify options for the `motion` _add-on_, as well as the AI _services, as appropriate.  Relevant variables include:

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

These variables' values may be specified by environment variables or persistently through files of the same name; for example in the `motion-ai` installation directory:

```
# 1. specify a MQTT save device identifier
echo 'pi31' > MOTION_DEVICE
echo '+' > MOTION_CLIENT
```
```
# 2. specify credentials to access motion-ai cameras
echo 'username' > MOTIONCAM_PASSWORD
echo 'password' > MOTIONCAM_PASSWORD
```
```
# 3. specify credential to access third-party network cameras
echo 'username' > NETCAM_PASSWORD
echo 'password' > NETCAM_PASSWORD
```
```
# 4. specify MQTT options
echo '192.168.1.50' > MQTT_HOST
echo 'username' > MQTT_USERNAME
echo 'password' > MQTT_PASSWORD
```

Changes may be made for a variety of [options](OPTIONS.md); when changes are made (e.g. to the `MQTT_HOST`) the following command **must** be run for those changes to take effect:

```
make restart
```
# &#10124; Define `webcams.json`

This JSON file contains information about the cameras which will be in the generated YAML; more cameras require more computational resources.  Those details include:

+ `name` : a unique name for the camera (e.g. `kitchencam`)
+ `mjpeg_url` : location of "live" motion JPEG stream from camera
+ `username` and `password` : credentials for access via the `mjpeg_url`
+ `icon` : specified from the [Material Design Icons](https://materialdesignicons.com/) selection.

#### Copy the provided template:

```
# specify camera(s); default is one camera named `local`
cp homeassistant/motion/webcams.json.tmpl  webcams.json
```

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

# &#10125; Install _add-on(s)_
Install the requiste _add-ons_ for Home Assistant, including the `MQTT` broker and the appropriate version of `motion`.  Browse to the Home Assistant Web interface (n.b. don't forget `port` if not `80`) and visit the **Supervisor** via the icon in the lower left panel (see below).

[![example](samples/supervisor.png?raw=true "supervisor")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/supervisor.png)

Select the `Add-on Store` and type in the address of this repository, for example:

[![example](samples/add-repository.png?raw=true "add-repository")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/add-repository.png)

When the system reloads, select the **Motion Server** _add-on_ from those available; when utilizing a locally attached USB camera, select the **Motion Video0** _add-on_; for example:

[![example](samples/dcmartin-repository.png?raw=true "dcmartin-repository")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/dcmartin-repository.png)

After selecting the appropriate _add-on_, install by clicking on the `INSTALL` button, for example:

 [![example](samples/motion-server-addon.png?raw=true "motion-server-addon")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/motion-server-addon.png)

Configure the add-on using the following options:

+ `group` - the identifier for the group of cameras; default: `motion`
+ `device` - the identifier for the host of the camera; typically the _hostname_
+ `client` - the identifier for the client (single) or all `+`; default: `+`
+ `mqtt` - `host`, `port`, `username`, and `password` for MQTT server
+ `cameras` - an array of `dict` structure for each camera

For more information on configuring, please refer to the [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/DOCS.md) documentation.

# &#10126; Start AI _services_
Specify options for the AI _services_, i.e. `yolo4motion`, `face4motion`, etc.. as appropriate.  Relevant variables include:

### _service logging_
In addition to those above, the level of logging and desired output location are shared across all _services_.

+ `LOG_LEVEL` - logging level; default: `info`
+ `LOG_TO` - logging output; default: `/dev/stderr`

## `yolo4motion`
+ `YOLO_CONFIG` - may be `tiny`, `tiny-v2`, `tiny-v3`, `v2`, or `v3`; default: `tiny` _(pre-loaded)_
+ `YOLO_ENTITY` - entity to detect; default: `all`
+ `YOLO_SCALE` - size for image scaling prior to detect; default: `none`
+ `YOLO_THRESHOLD` - threshold for entity detection; default: `0.25`

The `tiny` model (aka `tiny-v2`) only detects [these](https://github.com/dcmartin/openyolo/blob/master/darknet/data/voc.names) entities; the remaining models detect [these](https://github.com/dcmartin/openyolo/blob/master/darknet/data/coco.names) entities.

**Note:** The Docker container and the model's weights must be downloaded from the Internet; there may be a considerable delay given the device Internet connection bandwidth.  The container is only downloaded one time, but the model's weights  are downloaded each time the container is started.

For example:

```
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

## `face4motion.sh`
+ `FACE_THRESHOLD` - floating point value between `0.0` and `0.99`; default: `0.5`

## `alpr4motion.sh`
+ `ALPR_COUNTRY` - designation for country specific license plates, may be `us` or `eu`; default: `us`
+ `ALPR_PATTERN` - pattern for plate recognition, may be regular expression; default: `none`
+ `ALPR_TOPN` - integer value between `1` and `20` limiting number `tag` predictions per `plate` 

#  &#9989; - COMPLETE

## Watch `MQTT` traffic (_optional_)
To monitor the `MQTT` traffic from one or more `motion` devices use the `./sh/watch.sh` script which runs a `MQTT` client to listen for various _topics_, including motion detection events, annotations, detections, and a specified detected entity (n.b. currently limited per device).  The script outputs information to `/dev/stderr` and runs in the background.  The shell script will utilize existing values for the `MQTT` host, etc.. as well as the `MOTION_CLIENT`, but those may be specified as well; for example:

```
echo motion > MOTION_GROUP
echo + > MOTION_CLIENT
./sh/watch.sh
```

