# Home Assistant Installation

This document provides instructions for installation of Home Assistant as a Docker container using the HA control system, aka **HASSIO** identifier and `hassio_supervisor` container).  This method provides the ability to both control the Home Assistant system as well as install additional _addons_ as Docker containers.

For additional information on installing Home Assistant, please refer to the [documentation](https://www.home-assistant.io/hassio/installation/).

<hr>

## Step 1
 Download and flash (e.g. using [Balena Etcher](https://www.balena.io/etcher/)) an appropriate operating system for the target device (e.g. [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/) for RaspberryPi) and  _don't unmount or eject after flashing_.

Then specify the wireless and enable `ssh` access; for example, using the provided script `sh/add-wpa.sh`:

```
% NETWORK_SSID=WIFINAME NETWORK_PASSWORD=MyP@S$WoRd ./sh/add-wpa.sh
```
When completed, eject the SD card, insert into target device and power-on.  Please refer to [`DEBIAN.md`](DEBIAN.md) for further information on Debian/Ubuntu/Raspbian systems.

## Step 2
When the system has completed booting, it will automatically join the indicated wireless network.  To find the device on the network, search for it using the `nmap` program, for example:

```
% sudo nmap -sn -T5 192.168.1.0/24 | egrep -B2 -i raspberry
```
Select the results the new RaspberryPi device found:

```
Nmap scan report for 192.168.1.37
Host is up (0.0053s latency).
MAC Address: XX:XX:XX:XX:XX:XX (Raspberry Pi Foundation)
```

## Step 3
Copy your `ssh` credentials to the target device, for example:

```
% ssh-copy-id pi@192.168.1.37
```
and enter the default password `raspberry` -- resulting (hopefully) with indication of success:

```
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Volumes/user/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
pi@192.168.1.37's password: 

Number of key(s) added:        1

Now try logging into the machine, with:   "ssh 'pi@192.168.1.37'"
and check to make sure that only the key(s) you wanted were added.
```

## Step 4
Access the target device using `ssh` and install pre-requisites for Home Assistant, including:

+ `software-properties-common`
+ `apparmor-utils`
+ `apt-transport-https`
+ `avahi-daemon`
+ `ca-certificates`
+ `curl`
+ `dbus`
+ `jq`
+ `socat`
+ `network-manager` _(optional)_

```
sudo apt update -qq -y
sudo apt upgrade -qq -y
sudo apt install -y software-properties-common apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq socat network-manager
```

If `network-manager` is installed, disable the MAC address randomization; create the file:

```
/etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf
```

With the following content:

```
[connection]
wifi.mac-address-randomization=1
[device]
wifi.scan-rand-mac-address=no
```

## Step 5
Install [Docker](http://docker.com) using the script from `get.docker.com`:

```
curl -sL get.docker.com > getdocker.sh
chmod 755 getdocker.sh 
sudo ./getdocker.sh 
```

## Step 6
Download the installation script (`hassio_install.sh`) and save it, and enable execution; for example:

```
curl -sL "https://raw.githubusercontent.com/home-assistant/hassio-installer/master/hassio_install.sh" -o hassio_install.sh
chmod 755 hassio_install.sh
```

## Step 7
Install using the downloaded script; run script as root and provide a `MACHINE` option for non-x86 devices.  See the table below to help identify the proper machine.

Device|Architecture|MACHINE|comment
:-------|:-------:|-------|:-------
RaspberryPi3|ARM Cortex-A53 |`raspberrypi3`|
RaspberryPi4| ARM Cortex-A72|`raspberrypi4`|
nVidia Jetson Nano|ARM Cortex-A57|`qemuarm-64`|

**For example**:

```
sudo ./hassio_install.sh -m raspberrypi3
```

Resulting (hopefully) successfully, for example:

```
[Warning] No NetworkManager support on host.
[Info] Install supervisor Docker container
[Info] Install supervisor startup scripts
Created symlink /etc/systemd/system/multi-user.target.wants/hassio-supervisor.service → /etc/systemd/system/hassio-supervisor.service.
[Info] Install AppArmor scripts
Created symlink /etc/systemd/system/multi-user.target.wants/hassio-apparmor.service → /etc/systemd/system/hassio-apparmor.service.
[Info] Run Hass.io
```

<hr>

# &#9989; All done 
The download and installation of the `hassio_supervisor` and `homeassistant` Docker containers may require up to twenty (20) minutes, depending on network connection and host performance.

The default configuration will setup on the localhost using port `8123`.   While the system is starting, the Web site will display the following:

<img src="samples/hassio-starting-up.png" width="50%">

For more information refer to the [installation instructions](https://www.home-assistant.io/hassio/installation/#alternative-install-on-a-generic-linux-host).
