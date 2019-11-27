#!/bin/bash

if [ $(arch) != "armv7l" ]; then
  echo "*** ERROR $0 $$ -- for RaspberryPi only"
  exit 1
fi

if [ $(whoami) != "root" ]; then
  echo "*** ERROR $0 $$ -- run as root"
  exit 1
fi

if [ -z "${DNS_NAMESERVERS:-}" ]; then
  DNS_NAMESERVERS="9.9.9.9"
  echo "$(date '+%T') INFO $0 $$ -- no DNS name-servers specified; using: ${DNS_NAMESERVERS}"
fi

if [ -z "${HW_MODE:-}" ]; then
  HW_MODE="g"
  echo "$(date '+%T') INFO $0 $$ -- no hw_mode specified; using: ${HW_MODE}"
fi
if [ -z "${CHANNEL:-}" ]; then
  case "${HW_MODE}" in
    "g")
      CHANNEL=8
      ;;
    "a")
      if [ $(arch) == "armv7l" ]; then
        echo "+++ WARN $0 $$ -- may not by supported by $(arch); hw_mode: ${HW_MODE}; run systemctl status hostapd"
      fi
      CHANNEL=38
      ;;
    *)
      CHANNEL=7
      ;;
  esac
  echo "$(date '+%T') INFO $0 $$ -- no channel specified; using: ${CHANNEL}"
fi
if [ -z "${SSID:-}" ]; then
  SSID="TEST"
  echo "$(date '+%T') INFO $0 $$ -- no ssid specified; using: ${SSID}"
fi
if [ -z "${WPA_PASSPHRASE:-}" ]; then
  WPA_PASSPHRASE="0123456789"
  echo "+++ WARN $0 $$ -- no passphrase specified; using: ${WPA_PASSPHRASE}"
fi

for pr in hostapd dnsmasq brctl nslookup; do
  if [ -z $(command -v "${pr}") ]; then
    case "${pr}" in
      "brctl")
        package="bridge-utils"
        ;;
      "nslookup")
        package="dnsutils"
        ;;
      *)
        package="${pr}"
        ;;
    esac
    echo "+++ WARN $0 $$ -- installing ${package}"
    apt install -y "${package}" &> /dev/null
  fi
done

systemctl stop dnsmasq
systemctl stop hostapd

DHCPD_CONF="/etc/dhcpcd.conf"
if [ -s "${DHCPD_CONF}" ]; then
  echo "$(date '+%T') INFO $0 $$ -- over-writing existing ${DHCPD_CONF}"
fi
echo 'denyinterfaces wlan0' > "${DHCPD_CONF}"
echo 'denyinterfaces eth0' > "${DHCPD_CONF}"
echo 'interface wlan0' > "${DHCPD_CONF}"
echo '  static ip_address=192.168.0.1/24' >> "${DHCPD_CONF}"
echo '  nohook wpa_supplicant' >> "${DHCPD_CONF}"
echo "$(date '+%T') INFO $0 $$ -- configured DHCP" $(cat ${DHCPD_CONF})

DNSMASQ_CONF="/etc/dnsmasq.conf"
if [ -s "${DNSMASQ_CONF}" ]; then
  echo "$(date '+%T') INFO $0 $$ -- over-writing existing ${DNSMASQ_CONF}"
fi
echo 'interface=wlan0' > "${DNSMASQ_CONF}"
echo '  dhcp-range=192.168.0.2,192.168.0.254,255.255.255.0,24h' >> "${DNSMASQ_CONF}"
echo "$(date '+%T') INFO $0 $$ -- configured DNSMASQ" $(cat ${DNSMASQ_CONF})

if [ $(brctl show | wc -l) -le 1 ]; then
  echo "$(date '+%T') INFO $0 $$ -- building bridge br0 to eth0"
  brctl addbr br0
  brctl addif br0 eth0
else
  echo "$(date '+%T') INFO $0 $$ -- existing bridge built" $(brctl show)
fi

NETWORK_INTERFACES="/etc/network/interfaces"
if [ -s ${NETWORK_INTERFACES} ]; then
  echo "$(date '+%T') INFO $0 $$ -- over-writing existing ${NETWORK_INTERFACES}"
fi
echo 'auto br0' > ${NETWORK_INTERFACES}
echo 'iface br0 inet manual' >> ${NETWORK_INTERFACES}
echo 'bridge_ports eth0 wlan0' >> ${NETWORK_INTERFACES}
echo 'dns-nameservers' "${DNS_NAMESERVERS}" >> ${NETWORK_INTERFACES}
echo "$(date '+%T') INFO $0 $$ -- configured NETWORK" $(cat ${NETWORK_INTERFACES})

HOSTAPD_CONF="/etc/hostapd/hostapd.conf"
if [ -s ${HOSTAPD_CONF} ]; then
  echo "$(date '+%T') INFO $0 $$ -- over-writing existing ${HOSTAPD_CONF}"
fi
echo 'interface=wlan0' > ${HOSTAPD_CONF}
echo 'bridge=br0' >> ${HOSTAPD_CONF}
echo 'ssid='"${SSID}" >> ${HOSTAPD_CONF}
echo 'hw_mode='"${HW_MODE}" >> ${HOSTAPD_CONF}
echo 'channel='"${CHANNEL}" >> ${HOSTAPD_CONF}
echo 'wmm_enabled=0' >> ${HOSTAPD_CONF}
echo 'macaddr_acl=0' >> ${HOSTAPD_CONF}
echo 'auth_algs=1' >> ${HOSTAPD_CONF}
echo 'ignore_broadcast_ssid=0' >> ${HOSTAPD_CONF}
echo 'wpa=2' >> ${HOSTAPD_CONF}
echo 'wpa_passphrase='"${WPA_PASSPHRASE}" >> ${HOSTAPD_CONF}
echo 'wpa_key_mgmt=WPA-PSK' >> ${HOSTAPD_CONF}
echo 'wpa_pairwise=TKIP' >> ${HOSTAPD_CONF}
echo 'rsn_pairwise=CCMP' >> ${HOSTAPD_CONF}
echo "$(date '+%T') INFO $0 $$ -- configured hostapd: ${HOSTAPD_CONF}"

# set default for hostapd
HOSTAPD_DEFAULT="/etc/default/hostapd"
echo 'DAEMON_CONF="'"${HOSTAPD_CONF}"'"' > ${HOSTAPD_DEFAULT}
echo "$(date '+%T') INFO $0 $$ -- over-writing hostapd default:" $(cat ${HOSTAPD_DEFAULT})

# reload
echo "$(date '+%T') INFO $0 $$ -- reloading daemons"
systemctl daemon-reload

# start
echo "$(date '+%T') INFO $0 $$ -- restarting daemons"
systemctl restart hostapd
systemctl restart dnsmasq

# /etc/sysctl.conf
SYSCTL_CONF="/etc/sysctl.conf"
if [ -z "$(egrep '^net.ipv4.ip_forward=' "${SYSCTL_CONF}")" ]; then
  echo "$(date '+%T') INFO $0 $$ -- enabling IPv4 forwarding in ${SYSCTL_CONF}"
  sed -i 's|.*net.ipv4.ip_forward.*|net.ipv4.ip_forward=1|' "${SYSCTL_CONF}"
else
  echo "$(date '+%T') INFO $0 $$ -- existing IPv4 forwarding" $(egrep "^net.ipv4.ip_forward=" ${SYSCTL_CONF})
fi

# /etc/iptables
IPTABLES_NAT="/etc/iptables.ipv4.nat"
if [ ! -s "/etc/iptables.ipv4.nat" ]; then
  echo "$(date '+%T') INFO $0 $$ -- enabling POSTROUTING / MASQUERADE on eth0"
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  echo "$(date '+%T') INFO $0 $$ -- saving iptables to ${IPTABLES_NAT}"
  sh -c "iptables-save > ${IPTABLES_NAT}"
else
  echo "$(date '+%T') INFO $0 $$ -- existing ${IPTABLES_NAT}" $(cat ${IPTABLES_NAT})
fi

if [ -z "$(egrep "iptables-restore" /etc/rc.local)" ]; then
  echo "$(date '+%T') INFO $0 $$ -- adding iptables-restore to /etc/rc.local"
  egrep -v '^exit 0' /etc/rc.local > /tmp/$$.rc
  echo "if [ -s ${IPTABLES_NAT} ]; then iptables-restore < ${IPTABLES_NAT}; fi" >> /tmp/$$.rc
  echo 'exit 0' >> /tmp/$$.rc
  mv -f /tmp/$$.rc /etc/rc.local
else
  echo "$(date '+%T') INFO $0 $$ -- iptables-restore present in /etc/rc.local" $(egrep "iptables-restore" /etc/rc.local)
fi
