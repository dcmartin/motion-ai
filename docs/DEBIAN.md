# `DEBIAN.md`
This document has additional information for configuration Debian-based LINUX operating systems, including Raspbian and Ubuntu.  

## Automated `sudo` & `domainname`
After installing LINUX, creating user account, and accessing device, configure the `domainname` and optionally grant privileges to enable automated `sudo`, for example:

```
echo "mydomain.com" | sudo tee /etc/domainname
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/010_${USER}-nopasswd"
```

## DNS
To setup DNS properly on Ubuntu 18.04 an additional package, `resolvconf`, needs to be installed and configured.

```
sudo apt install -qq -y resolvconf
```

Then configure by appending the desired nameservers, one per line; for example:

```
echo 'nameserver 192.168.1.50' | sudo tee -a /etc/resolvconf/resolv.conf.d/head
echo 'nameserver 1.1.1.1' | sudo tee -a /etc/resolvconf/resolv.conf.d/head
```

### `DNSmasq`
If you want to use the Home Assistant [DNS](https://www.home-assistant.io/addons/dnsmasq/) _addon_, the existing DNS resolver for Ubuntu must be disabled.  This method works on Ubuntu Releases 17.04 (Zasty), 17.10 (Artful), 18.04 (Bionic) and 18.10 (Cosmic):

Disable and stop the systemd-resolved service:

```
sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved
```

Set DNS to `default`

```
sudo echo 'dns=default' >> /etc/NetworkManager/NetworkManager.conf
```

Delete  /etc/resolv.conf

```
sudo rm /etc/resolv.conf
```

Restart network-manager

```
sudo service network-manager restart
```

### Static IP _(optional)_
To use static IP addresses, change the `/etc/network/interfaces` file, for example to configure a system with both wired (`eth0`) and wireless (`wlan0`) networking (presuming host is also running `dnsmasq` addon):

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address 192.168.1.50
gateway 192.168.1.1
netmask 24

auto wlan0 
iface wlan0 inet static
address 192.168.1.51
gateway 192.168.1.1
netmask 24

dns-nameservers 192.168.1.50 1.1.1.1 9.9.9.9 8.8.8.8 8.8.4.4
```

## Increase swap  (_Raspbian_)
To accomodate running Home Assistant and its components in addition to the `motion` and `YOLO` software, the size of the swap file should be increased.  It is recommended to increase from the default 100 Mbytes; recommended size is 256.

```
sudo systemctl stop docker
sudo dphys-swapfile swapoff
SWAPSIZE=256
sudo sed -i "s/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=${SWAPSIZE}/" /etc/dphys-swapfile
sudo dphys-swapfile swapon
sudo systemctl start docker
```

## Automatic desktop login (_Raspbian_)
If using a RaspberryPi with a connected display the device may be configured to automatically log into the device and start the graphical user interface (GUI).

The first step is installing the desktop manager:

```
sudo apt install -qq -y lightdm
```

Second step is to run the `raspi-config` program from the command-line and configure the system to boot to desktop GUI:

```
sudo raspi-config
```

Navigate through the screens; first selecting option `3. Boot Options`:

<img src="https://raw.githubusercontent.com/dcmartin/addons/master/docs/samples/raspi-config-1.png">

Then option `B1 Desktop / CLI`:

<img src="https://raw.githubusercontent.com/dcmartin/addons/master/docs/samples/raspi-config-2.png">

Finally, select option `B4 Desktop Autologin Desktop GUI` with the utilized account (e.g. `dcmartin`):

<img src="https://raw.githubusercontent.com/dcmartin/addons/master/docs/samples/raspi-config-3.png">

Select `<OK>` and exit the `rasp-config` application.  Then reboot the computer:

```
sudo reboot
```
