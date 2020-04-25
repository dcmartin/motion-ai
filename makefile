###
### makefile
###

SHELL := /bin/bash

THIS_HOSTIP ?= $(shell ifconfig | egrep 'inet ' | awk '{ print $$2 }' | egrep -v '^172.|^10.|^127.|^169.' | head -1)

# logging
LOGGER_DEFAULT ?= $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "** SPECIFIED: LOGGER_DEFAULT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "!! UNSPECIFIED: LOGGER_DEFAULT unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# domain
DOMAIN_NAME ?= $(if $(wildcard DOMAIN_NAME),$(shell v=$$(cat DOMAIN_NAME) && echo "** SPECIFIED: DOMAIN_NAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(domainname -d) && v=$${v:-local} && echo "!! UNSPECIFIED: DOMAIN_NAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# host
HOST_NAME ?= $(if $(wildcard HOST_NAME),$(shell v=$$(cat HOST_NAME) && echo "** SPECIFIED: HOST_NAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -f) && v=$${v%%.*} && echo "!! UNSPECIFIED: HOST_NAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_IPADDR ?= $(if $(wildcard HOST_IPADDR),$(shell v=$$(cat HOST_IPADDR) && echo "** SPECIFIED: HOST_IPADDR: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=${THIS_HOSTIP} && echo "!! UNSPECIFIED: HOST_IPADDR unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_PORT ?= $(if $(wildcard HOST_PORT),$(shell v=$$(cat HOST_PORT) && echo "** SPECIFIED: HOST_PORT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="8123" && echo "!! UNSPECIFIED: HOST_PORT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_THEME ?= $(if $(wildcard HOST_THEME),$(shell v=$$(cat HOST_THEME) && echo "** SPECIFIED: HOST_THEME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="default" && echo "!! UNSPECIFIED: HOST_THEME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_NETWORK ?= $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK ?= 24

# MQTT
MQTT_HOST ?= $(if $(wildcard MQTT_HOST),$(shell v=$$(cat MQTT_HOST) && echo "** SPECIFIED: MQTT_HOST: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="$(HOST_IPADDR)" && echo "!! UNSPECIFIED: MQTT_HOST unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PORT ?= $(if $(wildcard MQTT_PORT),$(shell v=$$(cat MQTT_PORT) && echo "** SPECIFIED: MQTT_PORT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="1883" && echo "!! UNSPECIFIED: MQTT_PORT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_USERNAME ?= $(if $(wildcard MQTT_USERNAME),$(shell v=$$(cat MQTT_USERNAME) && echo "** SPECIFIED: MQTT_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "!! UNSPECIFIED: MQTT_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PASSWORD ?= $(if $(wildcard MQTT_PASSWORD),$(shell v=$$(cat MQTT_PASSWORD) && echo "** SPECIFIED: MQTT_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "!! UNSPECIFIED: MQTT_PASSWORD unset; default: $${v}" > /dev/stderr && echo "$${v}"))

## MOTION
MOTION_GROUP ?= $(if $(wildcard MOTION_GROUP),$(shell v=$$(cat MOTION_GROUP) && echo "** SPECIFIED: MOTION_GROUP: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='motion' && echo "!! UNSPECIFIED: MOTION_GROUP unset; default: $${v}" > /dev/stderr && echo "$${v}"))

MOTION_DEVICE ?= $(if $(wildcard MOTION_DEVICE),$(shell v=$$(cat MOTION_DEVICE) && echo "** SPECIFIED: MOTION_DEVICE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$(HOST_NAME) && echo "!! UNSPECIFIED: MOTION_DEVICE unset; default: $${v}" > /dev/stderr && echo "$${v}"))

MOTION_CLIENT ?= $(if $(wildcard MOTION_CLIENT),$(shell v=$$(cat MOTION_CLIENT) && echo "** SPECIFIED: MOTION_CLIENT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='+' && echo "!! UNSPECIFIED: MOTION_CLIENT unset; default: $${v}" > /dev/stderr && echo "$${v}"))

MOTION_DETECT_ENTITY ?= $(if $(wildcard MOTION_DETECT_ENTITY),$(shell v=$$(cat MOTION_DETECT_ENTITY) && echo "** SPECIFIED: MOTION_DETECT_ENTITY: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='person' && echo "!! UNSPECIFIED: MOTION_DETECT_ENTITY unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# webcam
NETCAM_USERNAME ?= $(if $(wildcard NETCAM_USERNAME),$(shell v=$$(cat NETCAM_USERNAME) && echo "** SPECIFIED: NETCAM_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "!! UNSPECIFIED: NETCAM_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
NETCAM_PASSWORD ?= $(if $(wildcard NETCAM_PASSWORD),$(shell v=$$(cat NETCAM_PASSWORD) && echo "** SPECIFIED: NETCAM_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify NETCAM_PASSWORD: " && echo $${REPLY} | tee NETCAM_PASSWORD))

MOTIONCAM_USERNAME ?= $(if $(wildcard MOTIONCAM_USERNAME),$(shell v=$$(cat MOTIONCAM_USERNAME) && echo "** SPECIFIED: MOTIONCAM_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "!! UNSPECIFIED: MOTIONCAM_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTIONCAM_PASSWORD ?= $(if $(wildcard MOTIONCAM_PASSWORD),$(shell v=$$(cat MOTIONCAM_PASSWORD) && echo "** SPECIFIED: MOTIONCAM_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify MOTIONCAM_PASSWORD: " && echo $${REPLY} | tee MOTIONCAM_PASSWORD))

# netdata
NETDATA_URL ?= $(if $(wildcard NETDATA_URL),$(shell v=$$(cat NETDATA_URL) && echo "** SPECIFIED: NETDATA_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:19999/" && echo "!! UNSPECIFIED: NETDATA_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# scan interval for speedtest
INTERNET_SCAN_INTERVAL ?= $(if $(wildcard INTERNET_SCAN_INTERVAL),$(shell v=$$(cat INTERNET_SCAN_INTERVAL) && echo "** SPECIFIED: INTERNET_SCAN_INTERVAL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="14400" && echo "!! UNSPECIFIED: INTERNET_SCAN_INTERVAL unset; default: $${v}" > /dev/stderr && echo "$${v}"))
INTRANET_SCAN_INTERVAL ?= $(if $(wildcard INTRANET_SCAN_INTERVAL),$(shell v=$$(cat INTRANET_SCAN_INTERVAL) && echo "** SPECIFIED: INTRANET_SCAN_INTERVAL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="1800" && echo "!! UNSPECIFIED: INTRANET_SCAN_INTERVAL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

###
### TARGETS
###

ACTIONS := all run stop logs restart tidy clean realclean distclean

default: homeassistant/motion/webcams.json all

$(ACTIONS):
	@echo "making $@"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
	  HOST_NAME="$(HOST_NAME)" \
	  HOST_NETWORK="$(HOST_NETWORK)" \
	  HOST_NETWORK_MASK="$(HOST_NETWORK_MASK)" \
	  HOST_PORT="$(HOST_PORT)" \
	  HOST_THEME="$(HOST_THEME)" \
	  INTERNET_SCAN_INTERVAL="$(INTERNET_SCAN_INTERVAL)" \
	  INTRANET_SCAN_INTERVAL="$(INTRANET_SCAN_INTERVAL)" \
	  LOGGER_DEFAULT="$(LOGGER_DEFAULT)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
	  MOTION_DETECT_ENTITY="$(MOTION_DETECT_ENTITY)" \
	  MOTIONCAM_PASSWORD="$(MOTIONCAM_PASSWORD)" \
	  MOTIONCAM_USERNAME="$(MOTIONCAM_USERNAME)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	&& make -C homeassistant $@

.PHONY: all default run stop logs restart tidy clean realclean distclean $(PACKAGES)
