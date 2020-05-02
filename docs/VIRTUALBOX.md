

## virtualbox

```
echo 'deb https://download.virtualbox.org/virtualbox/debian bionic contrib' >> /etc/apt/sources.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
apt update -qq -y
apt --fix-broken install
apt install -qq -y virtualbox-6.0
```

## nvidia

```
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |   sudo apt-key add -
apt update -qq -y
apt upgrade -qq -y
```
