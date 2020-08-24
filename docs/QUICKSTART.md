# `QUICKSTART.md`
This _quick start_ is suitable for the following:

+ Ubuntu 18.04 systems on `amd64` and `aarch64` (e.g. nVidia Jetson Nano)
+ Rasbian Buster on `armv7` (e.g. RaspberryPi models 3 & 4).

## Step 1 - Install
There are two scripts used for installation:

+ [`get.hassio.sh`](https://raw.githubusercontent.com/dcmartin/motion-ai/master/sh/get.hassio.sh) - Update, upgrade, and install all packages required
+ [`hassio-install.sh`](https://raw.githubusercontent.com/dcmartin/motion-ai/master/sh/hassio-install.sh) - Download and start Home-Assistant supervisor and friends

The `get.hassio.sh` script is idempotent, so it can be run again without issue.  The script will automatically call `hassio-install.sh` (n.b. also idempotent) providing the
appropriate _machine_ and using the current working directory.

```
sudo apt update -qq -y
sudo apt install -qq -y git curl jq
git clone http://github.com/dcmartin/motion-ai
cd motion-ai
sudo ./sh/get.hassio.sh
reboot
```

## Step 2 - Configure
The configuration of the system is controlled by the `webcams.json` file in the top-level directory, for example:

```
~/motion-ai/webcams.json
```

A default [template](https://raw.githubusercontent.com/dcmartin/motion-ai/master/homeassistant/motion/webcams.json.tmpl) is provided and should be copied to create the file.
[Options](OPTIONS.md) may be specified through environment variables and/or local files with the same name. Whenever the `webcams.json` file or the _options_ have changed, run `make restart` in the top-level directory to rebuild and restart, for example:

```
cd ~/motion-ai
cp homeassistant/motion/webcams.json.tmpl webcams.json
echo 80 > HOST_PORT
echo username > MOTIONCAM_USERNAME
echo password > MOTIONCAM_PASSWORD
echo username > NETCAM_USERNAME
echo password > NETCAM_PASSWORD
echo 192.168.1.50 > MQTT_HOST
make restart
```

