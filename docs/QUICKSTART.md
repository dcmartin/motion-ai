# `QUICKSTART.md`
This _quick start_ is suitable for the following:

+ Ubuntu 18.04 systems on `amd64` and `aarch64` (e.g. nVidia Jetson Nano)
+ Rasbian Buster on `armv7` (e.g. RaspberryPi models 3 & 4).

## Step 1: Setup device
Download OS image and flash SD card using [Balena Etcher](https://www.balena.io/etcher/)

### A. Operating Systems
These installation instructions have only been tested on the following.

+ Raspberry Pi OS [armhf-32bit](https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip)

Future:

+ Raspberry Pi OS [aarch-64bit](http://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2021-05-28/2021-05-07-raspios-buster-arm64.zip)
+ Debian 11 (Bullseye) [armhf-64bit](https://raspi.debian.net/tested/20210823_raspi_3_bullseye.img.xz)
+ Ubuntu 20.04.03 LTS [aarch-64-bit](https://cdimage.ubuntu.com/releases/20.04.3/release/ubuntu-20.04.3-preinstalled-server-arm64+raspi.img.xz)

##### Home Assistant requirements
Not all capabilities of Home Assistant are supported on any platform other than as specified below.  These instructions are indended to provide guidance for installation on additional platforms, notably Rasbian and Ubuntu.

```
    Docker CE >= 19.03
    Systemd >= 239
    NetworkManager >= 1.14.6
    AppArmor == 2.13.x (built into the kernel)
    Debian Linux Debian 11 aka Bullseye (no derivatives)
    Home Assistant OS-Agent (Only the latest release is supported)

```

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
apt update -qq -y
apt install -qq -y curl wget jq sudo git make gettext
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

Installation may be verified by visiting the Home Assistant server on the [host at port 8123](http://localhost:8123/).

## Step 4: Install Add-Ons
Additional Home Assistant _add-ons_ are utilized for handling cameras, routing messages, and capturing uploaded files.

### A. Motion Classic
The ([Motion Classic](https://github.com/motion-ai/addons/blob/master/motion-video0/README.md)) _add-on_ is in an external [catalog](http://github.com/dcmartin/hassio-addons) that must be added as a new **repository** in the app store.

The add-on [configuration parameters](https://github.com/dcmartin/hassio-addons/blob/master/motion-video0/DOCS.md) by default are inherited from Home Assistant _secrets_.

The add-on's configuration parameters may be modified to include both default as well as literal values; for example:

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

#### &#9937; Parameters (FYI)

+ The _username_ and _password_ defaults are `username` and `password` and have corresponding [_options_](OPTIONS.md).
+ The MQTT add-on is named `core-mosquitto`, but only for Home Assistant and add-ons; the AI services require the device's host IP address (e.g. `192.168.1.22`).
+ Any _secret_ **must** be enclosed in quotations, but literal values do not.

### B. MQTT
The standard _add-on_ is available in built-in catalog.  Visit the **Supervisor** panel item and view the app store.  Credentials for at least one user must be provided; for example:

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

MQTT topics are specified as _group_, _device_, and _camera-name_ with corresponding sub-topics for `event`, `image`, and `annotated`,`face`, and `alpr` AI services.

### C. FTP (optional)
A basic FTP server is provided in the built-in community add-on catalog.  Visit the **Supervisor** panel item and view the app store.

## Step 6: Install Motion Ã👁

### A: Copy repository
Clone the repository and copy into the Home Assistant directory, for example:

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

Home Assistant _secrets_ (e.g. `!secret motioncam-username`) are only evaluated at start-up; consequently changes in the Motion Classic add-on may require restart.

#### &#9937; Recovery, Rebuild, and Restart (FYI)
Manual rebuilding of the YAML and JSON may be performed; there are two options:

+ **Recovery** - run `make` in the `/usr/share/hassio`; this will utilize the _options_ specified or defaults.
+ **Rebuild** - run `make` in the `/usr/share/hassio/homeassistant`; this will utilize the specifications in the file `/usr/share/hassio/homeassistant/setup.json`

After recovery or rebuild the `homeassistant` container must be restarted; for example:

```
cd /usr/share/hassio/homeassistant
make
docker restart homeassistant
```

### C. Start AI services

Run the installation script; it will download additional containers for the entity, face, and license plate AI's as well as model weights where appropriate.

**This process will take a long time.**

```
./sh/get.motion-ai.sh
```
When the script has completed there will now be three additional containers running; each listens for REST API calls with the default returning service status

+ `yolo4motion` - entity detection
+ `face4motion` - face detection
+ `alpr4motion` - license plate detection

For example:

```
curl http://192.168.1.122:4662/
```

### D. Restart






