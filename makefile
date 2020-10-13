###
### makefile
###

SHELL := /bin/bash

THIS_HOSTIP ?= $(shell ifconfig | egrep 'inet ' | awk '{ print $$2 }' | egrep -v '^172.|^10.|^127.|^169.' | head -1)

# logging
LOGGER_DEFAULT ?= $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "== LOGGER_DEFAULT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "** LOGGER_DEFAULT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
LOGGER_AUTOMATION ?= $(if $(wildcard LOGGER_AUTOMATION),$(shell v=$$(cat LOGGER_AUTOMATION) && echo "== LOGGER_AUTOMATION: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "** LOGGER_AUTOMATION unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# domain
DOMAIN_NAME ?= $(if $(wildcard DOMAIN_NAME),$(shell v=$$(cat DOMAIN_NAME) && echo "== DOMAIN_NAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(domainname -d) && v=$${v:-local} && echo "** DOMAIN_NAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# host
HOST_NAME ?= $(if $(wildcard HOST_NAME),$(shell v=$$(cat HOST_NAME) && echo "== HOST_NAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -f) && v=$${v%%.*} && echo "** HOST_NAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_IPADDR ?= $(if $(wildcard HOST_IPADDR),$(shell v=$$(cat HOST_IPADDR) && echo "== HOST_IPADDR: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=${THIS_HOSTIP} && echo "** HOST_IPADDR unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_INTERFACE ?= $(if $(wildcard HOST_INTERFACE),$(shell v=$$(cat HOST_INTERFACE) && echo "== HOST_INTERFACE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(ip addr | egrep -B2 ${HOST_IPADDR} | egrep '^[0-9]' | awk -F': ' '{ print $$2 }') && echo "** HOST_INTERFACE unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_PORT ?= $(if $(wildcard HOST_PORT),$(shell v=$$(cat HOST_PORT) && echo "== HOST_PORT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="8123" && echo "** HOST_PORT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_THEME ?= $(if $(wildcard HOST_THEME),$(shell v=$$(cat HOST_THEME) && echo "== HOST_THEME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="default" && echo "** HOST_THEME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_NETWORK ?= $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK ?= 24

HOST_LATITUDE ?= $(if $(wildcard HOST_LATITUDE),$(shell v=$$(cat HOST_LATITUDE) && echo "== HOST_LATITUDE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "** HOST_LATITUDE unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_LONGITUDE ?= $(if $(wildcard HOST_LONGITUDE),$(shell v=$$(cat HOST_LONGITUDE) && echo "== HOST_LONGITUDE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "** HOST_LONGITUDE unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# MQTT
MQTT_HOST ?= $(if $(wildcard MQTT_HOST),$(shell v=$$(cat MQTT_HOST) && echo "== MQTT_HOST: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="$(HOST_IPADDR)" && echo "** MQTT_HOST unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PORT ?= $(if $(wildcard MQTT_PORT),$(shell v=$$(cat MQTT_PORT) && echo "== MQTT_PORT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="1883" && echo "** MQTT_PORT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_USERNAME ?= $(if $(wildcard MQTT_USERNAME),$(shell v=$$(cat MQTT_USERNAME) && echo "== MQTT_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "** MQTT_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PASSWORD ?= $(if $(wildcard MQTT_PASSWORD),$(shell v=$$(cat MQTT_PASSWORD) && echo "== MQTT_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "** MQTT_PASSWORD unset; default: $${v}" > /dev/stderr && echo "$${v}"))

## MOTION
MOTION_GROUP ?= $(if $(wildcard MOTION_GROUP),$(shell v=$$(cat MOTION_GROUP) && echo "== MOTION_GROUP: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='motion' && echo "** MOTION_GROUP unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_DEVICE ?= $(if $(wildcard MOTION_DEVICE),$(shell v=$$(cat MOTION_DEVICE) && echo "== MOTION_DEVICE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(echo $(HOST_NAME) | sed -e "s/-//g" -e "s/ /_/g") && echo "** MOTION_DEVICE unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_CLIENT ?= $(if $(wildcard MOTION_CLIENT),$(shell v=$$(cat MOTION_CLIENT) && echo "== MOTION_CLIENT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$(MOTION_DEVICE) && echo "** MOTION_CLIENT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_DETECT_ENTITY ?= $(if $(wildcard MOTION_DETECT_ENTITY),$(shell v=$$(cat MOTION_DETECT_ENTITY) && echo "== MOTION_DETECT_ENTITY: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='person' && echo "** MOTION_DETECT_ENTITY unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_EXPIRE_AFTER ?= $(if $(wildcard MOTION_EXPIRE_AFTER),$(shell v=$$(cat MOTION_EXPIRE_AFTER) && echo "== MOTION_EXPIRE_AFTER: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='5' && echo "** MOTION_EXPIRE_AFTER unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_FORCE_UPDATE ?= $(if $(wildcard MOTION_FORCE_UPDATE),$(shell v=$$(cat MOTION_FORCE_UPDATE) && echo "== MOTION_FORCE_UPDATE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "** MOTION_FORCE_UPDATE unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# webcam
NETCAM_USERNAME ?= $(if $(wildcard NETCAM_USERNAME),$(shell v=$$(cat NETCAM_USERNAME) && echo "== NETCAM_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "** NETCAM_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
NETCAM_PASSWORD ?= $(if $(wildcard NETCAM_PASSWORD),$(shell v=$$(cat NETCAM_PASSWORD) && echo "== NETCAM_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify NETCAM_PASSWORD: " && echo $${REPLY} | tee NETCAM_PASSWORD))

MOTIONCAM_USERNAME ?= $(if $(wildcard MOTIONCAM_USERNAME),$(shell v=$$(cat MOTIONCAM_USERNAME) && echo "== MOTIONCAM_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "** MOTIONCAM_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTIONCAM_PASSWORD ?= $(if $(wildcard MOTIONCAM_PASSWORD),$(shell v=$$(cat MOTIONCAM_PASSWORD) && echo "== MOTIONCAM_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify MOTIONCAM_PASSWORD: " && echo $${REPLY} | tee MOTIONCAM_PASSWORD))

# netdata
NETDATA_URL ?= $(if $(wildcard NETDATA_URL),$(shell v=$$(cat NETDATA_URL) && echo "== NETDATA_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:19999/" && echo "** NETDATA_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# tplink
TPLINK_DISCOVERY ?= $(if $(wildcard TPLINK_DISCOVERY),$(shell v=$$(cat TPLINK_DISCOVERY) && echo "== TPLINK_DISCOVERY: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "** TPLINK_DISCOVERY unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# influxdb
INFLUXDB_HOST ?= $(if $(wildcard INFLUXDB_HOST),$(shell v=$$(cat INFLUXDB_HOST) && echo "== INFLUXDB_HOST: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='a0d7b954-influxdb' && echo "** INFLUXDB_HOST unset; default: $${v}" > /dev/stderr && echo "$${v}"))
INFLUXDB_DATABASE ?= $(if $(wildcard INFLUXDB_DATABASE),$(shell v=$$(cat INFLUXDB_DATABASE) && echo "== INFLUXDB_DATABASE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='$(HOST_NAME)' && echo "** INFLUXDB_DATABASE unset; default: $${v}" > /dev/stderr && echo "$${v}"))
INFLUXDB_USERNAME ?= $(if $(wildcard INFLUXDB_USERNAME),$(shell v=$$(cat INFLUXDB_USERNAME) && echo "== INFLUXDB_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='homeassistant' && echo "** INFLUXDB_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
INFLUXDB_PASSWORD ?= $(if $(wildcard INFLUXDB_PASSWORD),$(shell v=$$(cat INFLUXDB_PASSWORD) && echo "== INFLUXDB_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='homeassistant' && echo "** INFLUXDB_PASSWORD unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# scan interval for speedtest
# scan interval for speedtest
INTERNET_SCAN_INTERVAL ?= $(if $(wildcard INTERNET_SCAN_INTERVAL),$(shell v=$$(cat INTERNET_SCAN_INTERVAL) && echo "== INTERNET_SCAN_INTERVAL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="14400" && echo "** INTERNET_SCAN_INTERVAL unset; default: $${v}" > /dev/stderr && echo "$${v}"))
INTRANET_SCAN_INTERVAL ?= $(if $(wildcard INTRANET_SCAN_INTERVAL),$(shell v=$$(cat INTRANET_SCAN_INTERVAL) && echo "== INTRANET_SCAN_INTERVAL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="1800" && echo "** INTRANET_SCAN_INTERVAL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

###
### TARGETS
###

ACTIONS := all run stop logs restart refresh tidy clean realclean distclean

default: webcams.json all

$(ACTIONS):
	@echo "making $@"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
	  HOST_INTERFACE="$(HOST_INTERFACE)" \
	  HOST_NAME="$(HOST_NAME)" \
	  HOST_NETWORK="$(HOST_NETWORK)" \
	  HOST_NETWORK_MASK="$(HOST_NETWORK_MASK)" \
	  HOST_PORT="$(HOST_PORT)" \
	  HOST_THEME="$(HOST_THEME)" \
	  INTERNET_SCAN_INTERVAL="$(INTERNET_SCAN_INTERVAL)" \
	  INTRANET_SCAN_INTERVAL="$(INTRANET_SCAN_INTERVAL)" \
	  LOGGER_DEFAULT="$(LOGGER_DEFAULT)" \
	  LOGGER_AUTOMATION="$(LOGGER_AUTOMATION)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
	  MOTION_DETECT_ENTITY="$(MOTION_DETECT_ENTITY)" \
	  MOTION_EXPIRE_AFTER="$(MOTION_EXPIRE_AFTER)" \
	  MOTIONCAM_PASSWORD="$(MOTIONCAM_PASSWORD)" \
	  MOTIONCAM_USERNAME="$(MOTIONCAM_USERNAME)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	  INFLUXDB_HOST="$(INFLUXDB_HOST)" \
	  INFLUXDB_DATABASE="$(INFLUXDB_DATABASE)" \
	  INFLUXDB_USERNAME="$(INFLUXDB_USERNAME)" \
	  INFLUXDB_PASSWORD="$(INFLUXDB_PASSWORD)" \
	&& make -C homeassistant $@

.PHONY: all default run stop logs restart tidy clean realclean distclean $(PACKAGES)
