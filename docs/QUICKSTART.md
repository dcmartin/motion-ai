 `QUICKSTART.md`
This _quick start_ is suitable for the following:

+ Rasbian Buster on `armv7` (e.g. RaspberryPi models 3 & 4).
+ Ubuntu 18.04 systems on `amd64` and `aarch64` (e.g. nVidia Jetson Nano)

##### Home Assistant requirements
Not all capabilities of Home Assistant are supported on any platform other than as specified below.

```
    Docker CE >= 19.03
    Systemd >= 239
    NetworkManager >= 1.14.6
    AppArmor == 2.13.x (built into the kernel)
    Debian Linux Debian 11 aka Bullseye (no derivatives)
    Home Assistant OS-Agent (Only the latest release is supported)
```

These instructions are indended to provide guidance for installation on additional platforms, notably Rasbian, Ubuntu, and the nVidia Jetson Jetpack distributions (Ubuntu-based).

&#127919; **TL/DR** Commands to be executed for installation; see end of document for summary.

+ Home Assistant (supervised)
+ Motion Ã👁 with three (3) AI's

## Step 1: Setup device
Download OS image and flash SD card using [Balena Etcher](https://www.balena.io/etcher/)

### A. Operating Systems
These installation instructions have only been tested on the following.

+ Raspberry Pi OS [armhf-32bit](https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip)
+ Ubuntu 18.04 [`amd64`](https://releases.ubuntu.com/18.04/ubuntu-18.04.6-desktop-amd64.iso) [`aarch64`](https://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.6-server-arm64.iso)

Future:

+ Raspberry Pi OS [aarch-64bit](http://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2021-05-28/2021-05-07-raspios-buster-arm64.zip)
+ Debian 11 (Bullseye) [armhf-64bit](https://raspi.debian.net/tested/20210823_raspi_3_bullseye.img.xz)
+ Ubuntu 20.04.03 LTS [aarch-64-bit](https://cdimage.ubuntu.com/releases/20.04.3/release/ubuntu-20.04.3-preinstalled-server-arm64+raspi.img.xz)

### B. Image modifications
Modify the flashed file-system image as appropriate to the platform; not all options are available for all platforms.

#### Rasbian
Specify a WiFi SSID and pre-shared key (PSK) in the `/wpa_supplicant.conf` file, typically mounted in `/Volumes/boot` on macOS; for example:

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
network={
  ssid="<YOUR_SSID>"
  psk="<YOUR_PASSWORD>"
  key_mgmt=WPA-PSK
}
```

Create a zero-length file called `/ssh` on the flashed media to enable remote access; for example:

```
touch /Volumes/boot/ssh
```

#### Debian 11

Specify a hostname and a public `ssh` key to enable remote, headless, access to the device.  The file is typically mounted at `/Volumes/RASPIFIRM/sysconf.txt`

Uncomment the line with `root_authorized_keys` with the contents of `~/.ssh/id_rsa.pub` file.

```
root_authorized_key=ssh-rsa <YOUR KEY> you@yourhost
```
Uncomment the line with `hostname` with the desird name, for example:

```
hostname: motion-ai
```

### C. Boot and access

Eject uSD card from the host computer, insert into device, attach ethernet cord -- not required for Rasbian iff the `wpa_supplicant.conf` was created -- and provide power.
  
Access device using `ssh`

#### Raspbian (password: `raspberry`)
```
ssh <ip> -l pi
```

#### Debian 11
```
ssh <hostname>.local -l root
```

#### Ubuntu 20.04 (password: `ubuntu`)
```
ssh <ip> -l ubuntu
```

### D. Base components
Update software repositories and install base programs (as **root**).

```
sudo apt update -qq -y
sudo apt install -qq -y curl wget jq sudo git make gettext ssh
```

### E. Setup WiFi connectivity (optional)

```
SSID=<yourwifi-name>
PSK=<yourwifi-password>
nmcli dev wifi connect ${SSID} password ${PSK}
```

## Step 2: Install Docker
Install Docker-CE (community edition) with the following command:

```
curl -fsSL get.docker.com | sh
```

## Step 3: Install Home Assistant
See the [instructions](https://github.com/home-assistant/supervised-installer) to install Home Assistant in a supervised configuration; TL/DR, do the following:

### A. Pre-requisite software
To install Home Assistant there are a number of prerequisite software packages; install using the following:

```
sudo apt install -qq -y --no-install-recommends udisks2 libglib2.0-bin dbus apparmor 
```

**WARNING** Before installing `network-manager` specify that MAC address randomization should be turned off, otherwise the device will need to be power-cycled; for example (as **root**, _n.b._ `sudo -s`):

```
mkdir -p /etc/NetworkManager/conf.d
echo '[connection]' > /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf
echo 'wifi.mac-address-randomization=1' >> /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf
echo '[device]' >> /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf
echo 'wifi.scan-rand-mac-address=no' >> /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf
```

Then install `network-manager`; for example:

```
sudo apt install -qq -y --no-install-recommends network-manager
```

### B. OS Agent
The [Agent for Home Assistant OS](https://github.com/home-assistant/os-agent/tree/main#using-home-assistant-supervised-on-debian) provides services for the host OS.

Download the appropriate architecture package and install.

##### **`armv7`** (_aka_ `armhf`, e.g. Rasbian 32bit):

```
wget https://github.com/home-assistant/os-agent/releases/download/1.2.2/os-agent_1.2.2_linux_armv7.deb
sudo dpkg -i os-agent_1.2.2_linux_armv7.deb
```

##### **`aarch64`** (i.e. Rpi4 on Rasbian 64bit):

```
wget https://github.com/home-assistant/os-agent/releases/download/1.2.2/os-agent_1.2.2_linux_aarch64.deb
sudo dpkg -i os-agent_1.2.2_linux_aarch64.deb
```

##### **`amd64`** (i.e. Ubuntu):

```
wget https://github.com/home-assistant/os-agent/releases/download/1.2.2/os-agent_1.2.2_linux_x86_64.deb
sudo dpkg -i os-agent_1.2.2_linux_x86_64.deb
```

The installation will prompt for end-user specification of architecture (DAMW)

### C. Home Assistant
Install the supervised version of Home Assistant with all its friends using the Debian package; suitable for all architectures.

```
wget https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
sudo dpkg -i homeassistant-supervised.deb
```

Installation may be verified by visiting the Home Assistant server on the [host at port 8123](http://localhost:8123/).  If **AppArmor** is not enabled per the supervisor, please refer to these [instructions](https://www.home-assistant.io/more-info/unsupported/apparmor).

## Step 4: Install Add-Ons
Additional Home Assistant _add-ons_ are utilized for cameras, messaging, and uploading; these services should be installed and started prior to the next step.

#### &#9995; Parameters (FYI)

+ The _username_ and _password_ defaults are `username` and `password` and have corresponding [_options_](OPTIONS.md).
+ Any _secret_ **must** be enclosed in quotations, but literal values do not.

### A. MQTT
The standard _add-on_ is in the built-in Add-On Store catalog.  Visit the **Supervisor** panel item and view the Add-on Store.  MQTT credentials for at least one user must be provided; there is no anonymous MQTT support. For example:

```
logins:
  - username: username
    password: password
customize:
  active: false
  folder: mosquitto
certfile: fullchain.pem
keyfile: privkey.pem
require_certificate: false
```

MQTT topics are specified as _group_, _device_, and _camera_ with corresponding sub-topics, including AI services; example: any _group, device, and camera_ (`+`) end events with any annotation: `+/+/+/event/end/+`.

+ `end`
+ `image`
+ `annotated`
+ `face`
+ `alpr`

### B. Motion Classic
The [Motion Classic](https://github.com/motion-ai/addons/blob/master/motion-video0/README.md) _add-on_ is cataloged in the repository [`http://github.com/dcmartin/hassio-addons`](http://github.com/dcmartin/hassio-addons) which must be added in the Home Assistant Add-On Store.

The add-on's default [configuration](https://github.com/dcmartin/hassio-addons/blob/master/motion-video0/DOCS.md) includes _secrets_, but may override with literal values; for example:

```
group: motion
device: my-device-name
client: +
timezone: America/Los_Angeles
latitude: 32.7
longitude: -121.8
default:
  netcam_userpass: my-netcam-username:my-netcam-password
  password: '!secret motioncam-password'
  username: '!secret motioncam-username'
mqtt:
  host: core-mosquitto
  password: password
  port: 1883
  username: username
```


### C. FTP (optional)
A basic FTP server is provided in the built-in community add-on catalog.  Visit the **Supervisor** panel item and view the Add-on Store.

## Step 6: Install Motion Ã👁

### A: Copy repository
Clone the repository and copy into the Home Assistant installation directory, for example:

```
git clone http://github.com/dcmartin/motion-ai /tmp/motion-ai
cd /tmp/motion-ai
tar cvf - . | ( cd /usr/share/hassio ; sudo tar xvf - )
ln -s /usr/share/hassio ~/motion-ai
rm -fr /tmp/motion-ai
```

### B. Setup, options, and configurations

Setup is automatic, however [**options**](OPTIONS.md) are specified through environment variables and/or local files with the same name.  There is a sample script [`config.sh`](../config.sh) which can be changed to meet local conditions.  Once configured, run the `make` command to buid the initial YAML and JSON.

Configurations for both Home Assistant and the Motion Classic add-on parameters are calculated from the **options**, but may be overruled in the add-on configuration, e.g. _timezone_, _latitude_, _longitude_, etc... See the [documentation](https://github.com/dcmartin/hassio-addons/blob/master/motion-video0/DOCS.md) for more information.

#### &#9995; Home Assistant _secrets_
Secrets (e.g. `!secret motioncam-username`) are only evaluated when HA is started; consequently changes in the Motion Classic add-on may require HA restart.

### C. Start AI services

Run the installation script; it will download additional containers for the entity, face, and license plate AI's as well as model weights where appropriate.

**This process will take a long time.**

```
cd /usr/share/hassio
make
./sh/get.motion-ai.sh
```
When the script has completed there will now be three additional containers running; each listens for REST API calls with the default returning service status

+ `yolo4motion` - entity detection
+ `face4motion` - face detection
+ `alpr4motion` - license plate detection

For example:

```
curl http://localhost:4662/
```

<hr>

# &#9937; Recovery, Rebuild, and Restart (FYI)
Manual rebuilding of the YAML and JSON may be performed; there are two options:

+ **Recovery** - run `make` in the directory `/usr/share/hassio/`; this will utilize the _options_ specified or defaults.
+ **Rebuild** - run `make` in the directory `/usr/share/hassio/homeassistant/`; this will utilize the current specifications; stored in the file `/usr/share/hassio/homeassistant/setup.json`

After recovery or rebuild the `homeassistant` container must be restarted or the device rebooted; for example to rebuild the YAML and JSON using current specification:

```
cd /usr/share/hassio/homeassistant
make
docker restart homeassistant
```

Servies may also be started manually from the installation directory; scripts use the _options_ specified or defaults, notably for MQTT, including:

+ `MQTT_HOST`, `MQTT_USERNAME`,`MQTT_PASSWORD`
+ `MOTION_GROUP`, `MOTTION_DEVICE`, `MOTION_CLIENT`

Each AI service has it's own start-up script which should be executed from the HA installation directory (n.b. `/usr/share/hassio`)

+ Entity - `./sh/yolo4motion.sh`
+ Face  - `./sh/face4motion.sh`
+ License plate - `./sh/alpr4motion.sh`

<hr>

# TL/DR
Automated installation on a RaspberryPi 3B+; additional steps are required to setup the add-ons.

## Home Assistant (supervised)
For a system installation flashed with Rasbian 32bit.

```
# turn off prompt for sudo command
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/010_${USER}-nopasswd
```

```
# turn off wifi mac randomization
sudo mkdir -p /etc/NetworkManager/conf.d
sudo cat > /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf << EOF
[connection]
wifi.mac-address-randomization=1
[device]
wifi.scan-rand-mac-address=no
EOF
```
```
# update and install prerequisites
sudo apt update -qq -y
sudo apt install -qq -y --no-install-recommends \
  curl wget jq sudo git make gettext ssh \
  udisks2 libglib2.0-bin dbus apparmor network-manager
```
```
# get docker
curl -fsSL get.docker.com | sh
```
```
# install home assistant OS agent (architecture dependent)
wget https://github.com/home-assistant/os-agent/releases/download/1.2.2/os-agent_1.2.2_linux_armv7.deb
sudo dpkg -i os-agent_1.2.2_linux_armv7.deb
```
```
# install home assistant supervised container stack
wget https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
sudo dpkg -i homeassistant-supervised.deb
```
After successful completion of these steps the generic Home Assistant web UI will be available on port [8123](http://raspberrypi.local:8123/); please wait 10-15 minutes.  The _add-ons_ for MQTT and Motion Classic can be added after Home Assistant completes initial setup.

## Motion Ã👁
These steps may be peformed once Home Assistant has been installed, configured, and is operational; in addition to these commands, the _add-ons_ must be installed, configured, and started.

```
git clone http://github.com/dcmartin/motion-ai /tmp/motion-ai
cd /tmp/motion-ai
tar cf - . | ( cd /usr/share/hassio ; sudo tar xf - )
ln -s /usr/share/hassio ~/motion-ai
rm -fr /tmp/motion-ai
```
```
cd /usr/share/hassio
make
sudo ./sh/get.weights.sh
for i in yolo face alpr; do sudo ./sh/${i}4motion.sh; done
sudo docker restart homeassistant
```

The Motion Ã👁 setup script downloads and starts the AI's and replaces the default Home Assistant interface on port 8123; the Web UI will now be available on port [80](http://raspberrypi.local/).  **Reboot is recommended** after the AI's and _add-ons_ are installed, configured, and started.



