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
sudo apt install -qq -y git jq curl bc gettext make git
```
## &#10123; - Clone repository; install Docker and Home Assistant
Clone this repository into a temporary location, e.g. `~/horizon.dcmartin.com/`, and use the provided shell scripts to install Docker and Home Assistant; for example:

```
cd ~/
git clone git@github.com:dcmartin/horizon.dcmartin.com.git
cd ~/horizon.dcmartin.com/
sudo ./sh/get.hassio.sh
sudo ./hassio-install.sh
sudo addgroup ${USER} docker
```
Logout to enable `docker` group; wait for 20-30 minutes for Home Assistant to configure, then connect to IP address on port `8123` and complete setup using a Web browser, for example: `http://192.168.1.36:8123`


## &#10124; - Update Home Assistant configuration
Copy the contents of the repository into the Home Assistant directory `homeassistant/`; this will over-write any existing files with the same names and is **intended for new systems**; please copy accordingly for existing systems.

```
cd ~/horizon.dcmartin.com/
sudo mv .??* * /usr/share/hassio/homeassistant
cd /usr/share/hassio/homeassistant
sudo chown -R ${USER} .
cd /usr/share/hassio/homeassistant
rm configuration.yaml
ln -s config-client.yaml.tmpl configuration.yaml
```
## &#10125; - Build configuration files
Specify options according to environment and build files using the `make` command, for example:

```
cd /usr/share/hassio/homeassistant
echo '[]' > motion/webcams.json # initially for zero motion addon-on cameras
echo '+' > MOTION_CLIENT # listen for all client cameras
echo '192.168.1.40' > MQTT_HOST # specify another device as broker
echo '80' > HOST_PORT # change host port if desired
make
```
## &#10126; - Restart Home Assistant
```
make restart
```

##  &#10127; - Start `yolo4motion` _service_

```
./sh/yolo4motion
```

## &#9989; - COMPLETE
The device is now configured and operational, with the exception of the `motion` _add-on_; please refer to the following to install and configure.

## &#9995; - Installing `motion` _add-on_
Browse to Home Assistant Web interface (n.b. don't forget `port` if not `80`) and visit the **Supervisor** via the icon in the lower left panel (see below).

[![example](samples/supervisor.png?raw=true "EXAMPLE")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/supervisor.png)

Then select the `Add-on Store` and type in the address of this repository, for example:

[![example](samples/add-repository.png?raw=true "EXAMPLE")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/add-repository.png)

When the system reloads, select the **Motion Server** _add-on_ from those available; when utilizing a locally attached USB camera, select the **Motion Video0** _add-on_; for example:

[![example](samples/dcmartin-repository.png?raw=true "EXAMPLE")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/dcmartin-repository.png)

After selecting the appropriate _add-on_, install by clicking on the `'INSTALL` button, for example:

 [![example](samples/motion-server-addon.png?raw=true "EXAMPLE")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/motion-server-addon.png)

For more information on configuring, please refer to the [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) documentation.

### Customization
Create the `motion/webcams.json` file with details on the camera(s) attached.  Those details include:

+ `name` : a unique name for the camera (e.g. `kitchencam`)
+ `mjpeg_url` : location of "live" motion JPEG stream from camera
+ `device` : _(optional)_ specifies the local V4L2 device
+ `username` and `password` : credentials for access via the `mjpeg_url`
+ `icon` : specified (mostly) from the [Material Design Icons](https://materialdesignicons.com/) selection.

### Local camera
For example for an attached camera on `/dev/video0` named `kitchencam` using the icon `stove`:

```
[
  {
    "name": "kitchencam",
    "device": "/dev/video0",
    "mjpeg_url": "http://127.0.0.1:8090/1",
    "still_image_url": "http://127.0.0.1:8090/1",
    "icon": "stove",
    "username": "username",
    "password": "password"
  }
]   
```

### Network camera
For network cameras that provide motion JPEG streaming, the `url` provides direct access; the `mjpeg_url` may be either the same, or may utilize the local streaming port (n.b. `8090`) and camera (n.b. `/1`).

```
[
  {
    "name": "pondlive",
    "url": "mjpeg://192.168.1.174/img/video.mjpeg",
    "mjpeg_url": "http://127.0.0.1:8090/1",
    "still_image_url": "",
    "icon": "waves",
    "username": "!secret webcam-username",
    "password": "!secret webcam-password"
  }
]
```

### FTP camera
For network cameras that deposit video via FTP to the local `ftp` addon, the configuration below indicates the `url` with `ftpd` specified as protocol; the `username` and `password` apply the the `mjpeg_url` for access to the camera (n.b. direct, not through the `motion` port).

```
[
  {
    "name": "backyard",
    "url": "ftpd:///share/ftp/backyard",
    "mjpeg_url": "http://192.168.1.183/img/video.mjpeg",
    "still_image_url": "http://192.168.1.183/img/snapshot.cgi",
    "icon": "texture-box",
    "username": "!secret webcam-username",
    "password": "!secret webcam-password"
  },
  ...
]
```

## OPTIONS
Then specify the variables for the `motion` _addon_ files (n.b. generated from the `motion/webcams.json` file).

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

