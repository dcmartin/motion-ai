# &#128064; `horizon.dcmartin.com/motion`

This directory contains YAML and templates to generate YAML for the `motion` [addon](https://github.com/dcmartin/hassio-addons/blob/master/motion/README.md).  

# Configuration

## 1) Setup device
```
sudo apt update -qq -y 
sudo apt upgrade -qq -y 
sudo apt install -qq -y git jq curl bc gettext make
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/010_${USER}-nopasswd"
```
## 2) Install Home Assistant
```
cd ~/
git clone git@github.com:dcmartin/horizon.dcmartin.com.git
cd ~/horizon.dcmartin.com/
sudo ./sh/get.hassio.sh
sudo ./hassio-install.sh
sudo addgroup ${USER} docker
```
Wait ... connect to IP address of device on port `8123` and complete setup.

## 3) Install configuration
```
cd ~/horizon.dcmartin.com/
sudo mv .??* * /usr/share/hassio/homeassistant
cd /usr/share/hassio/homeassistant
sudo chown -R ${USER} .
rm configuration.yaml
ln -s config-client.yaml.tmpl configuration.yaml
```
## 4) Update Home Assistant
```
cd /usr/share/hassio/homeassistant
echo '[]' > motion/webcams.json
echo '+' > MOTION_CLIENT
echo '192.168.1.40' > MQTT_HOST
echo '80' > HOST_PORT
make restart
make logs
```

# Customization
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

## Step 3
Then specify the variables for the `motion` _addon_ files (n.b. generated from the `motion/webcams.json` file).

Variable|Description|Default|Info
:-------|:-------|:-------|:-------
`MOTION_GROUP`|Name for the group of device(s) |`motion`|Aggregate devices' identifier
`MOTION_DEVICE`|Name of the `motion` _addon_ host|_`HOST_NAME`_|_see above_
`MOTION_CLIENT`|Device(s) topic for `MQTT`|_`MOTION_DEVICE`_|Aggregate using: **`"+"`**



