###
### makefile
###

SHELL := /bin/bash

# logging
LOGGER_DEFAULT := $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "** SPECIFIED: LOGGER_DEFAULT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "!! UNSPECIFIED: LOGGER_DEFAULT unset; default: $${v}" > /dev/stderr && echo "$${v}"))

#
AUTOMATION_startup := $(if $(wildcard AUTOMATION_startup),$(shell v=$$(cat AUTOMATION_startup) && echo "** SPECIFIED: AUTOMATION_startup: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "!! UNSPECIFIED: AUTOMATION_startup unset; default: off" > /dev/stderr && echo "off"))
AUTOMATION_sdr2msghub := $(if $(wildcard AUTOMATION_sdr2msghub),$(shell v=$$(cat AUTOMATION_sdr2msghub) &&  echo "** SPECIFIED: AUTOMATION_sdr2msghub: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "!! UNSPECIFIED: AUTOMATION_sdr2msghub unset; default: off" > /dev/stderr && echo "off"))
AUTOMATION_yolo2msghub := $(if $(wildcard AUTOMATION_yolo2msghub),$(shell v=$$(cat AUTOMATION_yolo2msghub) && echo "** SPECIFIED: AUTOMATION_yolo2msghub: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "!! UNSPECIFIED: AUTOMATION_yolo2msghub unset; default: off" > /dev/stderr && echo "off"))
AUTOMATION_highlow := $(if $(wildcard AUTOMATION_highlow),$(shell v=$$(cat AUTOMATION_highlow) && echo "** SPECIFIED: AUTOMATION_highlow: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "!! UNSPECIFIED: AUTOMATION_highlow unset; default: off" > /dev/stderr && echo "off"))

# domain
DOMAIN_NAME := $(if $(wildcard DOMAIN_NAME),$(shell v=$$(cat DOMAIN_NAME) && echo "** SPECIFIED: DOMAIN_NAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(domainname) && v=$${v:-local} && echo "!! UNSPECIFIED: DOMAIN_NAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# host
HOST_NAME := $(if $(wildcard HOST_NAME),$(shell v=$$(cat HOST_NAME) && echo "** SPECIFIED: HOST_NAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -f) && v=$${v%%.*} && echo "!! UNSPECIFIED: HOST_NAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_IPADDR := $(if $(wildcard HOST_IPADDR),$(shell v=$$(cat HOST_IPADDR) && echo "** SPECIFIED: HOST_IPADDR: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -I | awk '{ print $$1 }') && echo "!! UNSPECIFIED: HOST_IPADDR unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_PORT := $(if $(wildcard HOST_PORT),$(shell v=$$(cat HOST_PORT) && echo "** SPECIFIED: HOST_PORT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="8123" && echo "!! UNSPECIFIED: HOST_PORT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_THEME := $(if $(wildcard HOST_THEME),$(shell v=$$(cat HOST_THEME) && echo "** SPECIFIED: HOST_THEME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="default" && echo "!! UNSPECIFIED: HOST_THEME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_NETWORK := $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK := 24

# MQTT
MQTT_HOST := $(if $(wildcard MQTT_HOST),$(shell v=$$(cat MQTT_HOST) && echo "** SPECIFIED: MQTT_HOST: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="$(HOST_IPADDR)" && echo "!! UNSPECIFIED: MQTT_HOST unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PORT := $(if $(wildcard MQTT_PORT),$(shell v=$$(cat MQTT_PORT) && echo "** SPECIFIED: MQTT_PORT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="1883" && echo "!! UNSPECIFIED: MQTT_PORT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_USERNAME := $(if $(wildcard MQTT_USERNAME),$(shell v=$$(cat MQTT_USERNAME) && echo "** SPECIFIED: MQTT_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "!! UNSPECIFIED: MQTT_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PASSWORD := $(if $(wildcard MQTT_PASSWORD),$(shell v=$$(cat MQTT_PASSWORD) && echo "** SPECIFIED: MQTT_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "!! UNSPECIFIED: MQTT_PASSWORD unset; default: $${v}" > /dev/stderr && echo "$${v}"))

## MOTION
MOTION_GROUP := $(if $(wildcard MOTION_GROUP),$(shell v=$$(cat MOTION_GROUP) && echo "** SPECIFIED: MOTION_GROUP: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='motion' && echo "!! UNSPECIFIED: MOTION_GROUP unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_DEVICE := $(if $(wildcard MOTION_DEVICE),$(shell v=$$(cat MOTION_DEVICE) && echo "** SPECIFIED: MOTION_DEVICE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -s) && echo "!! UNSPECIFIED: MOTION_DEVICE unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_CLIENT := $(if $(wildcard MOTION_CLIENT),$(shell v=$$(cat MOTION_CLIENT) && echo "** SPECIFIED: MOTION_CLIENT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=${MOTION_DEVICE} && echo "!! UNSPECIFIED: MOTION_CLIENT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_DETECT_ENTITY := $(if $(wildcard MOTION_DETECT_ENTITY),$(shell v=$$(cat MOTION_DETECT_ENTITY) && echo "** SPECIFIED: MOTION_DETECT_ENTITY: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="person" && echo "!! UNSPECIFIED: MOTION_DETECT_ENTITY unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# webcam
NETCAM_USERNAME := $(if $(wildcard NETCAM_USERNAME),$(shell v=$$(cat NETCAM_USERNAME) && echo "** SPECIFIED: NETCAM_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "!! UNSPECIFIED: NETCAM_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
NETCAM_PASSWORD := $(if $(wildcard NETCAM_PASSWORD),$(shell v=$$(cat NETCAM_PASSWORD) && echo "** SPECIFIED: NETCAM_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify NETCAM_PASSWORD: " && echo $${REPLY} | tee NETCAM_PASSWORD))

MOTIONCAM_USERNAME := $(if $(wildcard MOTIONCAM_USERNAME),$(shell v=$$(cat MOTIONCAM_USERNAME) && echo "** SPECIFIED: MOTIONCAM_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "!! UNSPECIFIED: MOTIONCAM_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTIONCAM_PASSWORD := $(if $(wildcard MOTIONCAM_PASSWORD),$(shell v=$$(cat MOTIONCAM_PASSWORD) && echo "** SPECIFIED: MOTIONCAM_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify MOTIONCAM_PASSWORD: " && echo $${REPLY} | tee MOTIONCAM_PASSWORD))

# netdata
NETDATA_URL := $(if $(wildcard NETDATA_URL),$(shell v=$$(cat NETDATA_URL) && echo "** SPECIFIED: NETDATA_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:19999/" && echo "!! UNSPECIFIED: NETDATA_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# nVidia DIGITS
DIGITS_URL := $(if $(wildcard DIGITS_URL),$(shell v=$$(cat DIGITS_URL) && echo "** SPECIFIED: DIGITS_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://digits.$(DOMAIN_NAME):5000/" && echo "!! UNSPECIFIED: DIGITS_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# couchdb
COUCHDB_URL := $(if $(wildcard COUCHDB_URL),$(shell v=$$(cat COUCHDB_URL) && echo "** SPECIFIED: COUCHDB_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://couchdb.$(DOMAIN_NAME):5984/_utils" && echo "!! UNSPECIFIED: COUCHDB_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# edgex
EDGEX_URL := $(if $(wildcard EDGEX_URL),$(shell v=$$(cat EDGEX_URL) && echo "** SPECIFIED: EDGEX_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://edgex.$(DOMAIN_NAME):4000" && echo "!! UNSPECIFIED: EDGEX_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))
CONSUL_URL := $(if $(wildcard CONSUL_URL),$(shell v=$$(cat CONSUL_URL) && echo "** SPECIFIED: CONSUL_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://consul.$(DOMAIN_NAME):8500/ui" && echo "!! UNSPECIFIED: CONSUL_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

## open-horizon
EXCHANGE_URL := $(if $(wildcard EXCHANGE_URL),$(shell v=$$(cat EXCHANGE_URL) && echo "** SPECIFIED: EXCHANGE_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://exchange.$(DOMAIN_NAME):3090" && echo "!! UNSPECIFIED: EXCHANGE_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))
EXCHANGE_ORG := $(if $(wildcard EXCHANGE_ORG),$(shell v=$$(cat EXCHANGE_ORG) && echo "** SPECIFIED: EXCHANGE_ORG: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(whoami) && echo "!! UNSPECIFIED: EXCHANGE_ORG unset; default: $${v}" > /dev/stderr && echo "$${v}"))
EXCHANGE_ORG_ADMIN := $(if $(wildcard EXCHANGE_ORG_ADMIN),$(shell v=$$(cat EXCHANGE_ORG_ADMIN) && echo "** SPECIFIED: EXCHANGE_ORG_ADMIN: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="${EXCHANGE_ORG}" && echo "!! UNSPECIFIED: EXCHANGE_ORG_ADMIN unset; default: $${v}" > /dev/stderr && echo "$${v}"))
EXCHANGE_APIKEY := $(if $(wildcard EXCHANGE_APIKEY),$(shell v=$$(cat EXCHANGE_APIKEY) && echo "** SPECIFIED: EXCHANGE_APIKEY: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify EXCHANGE_APIKEY: " > /dev/stderr && echo $${REPLY} | tee EXCHANGE_APIKEY))

# hznmonitor
HZNMONITOR_URL := $(if $(wildcard HZNMONITOR_URL),$(shell v=$$(cat HZNMONITOR_URL) && echo "** SPECIFIED: HZNMONITOR_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://hznmonitor.$(DOMAIN_NAME):3094" && echo "!! UNSPECIFIED: HZNMONITOR_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# grafana
GRAFANA_URL := $(if $(wildcard GRAFANA_URL),$(shell v=$$(cat GRAFANA_URL) && echo "** SPECIFIED: GRAFANA_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://grafana.$(DOMAIN_NAME):3000" && echo "!! UNSPECIFIED: GRAFANA_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# influxdb
INFLUXDB_HOST := $(if $(wildcard INFLUXDB_HOST),$(shell v=$$(cat INFLUXDB_HOST) && echo "** SPECIFIED: INFLUXDB_HOST: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="influxdb.$(DOMAIN_NAME)" && echo "!! UNSPECIFIED: INFLUXDB_HOST unset; default: $${v}" > /dev/stderr && echo "$${v}"))
INFLUXDB_PASSWORD := $(if $(wildcard INFLUXDB_PASSWORD),$(shell v=$$(cat INFLUXDB_PASSWORD) && echo "** SPECIFIED: INFLUXDB_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify INFLUXDB_PASSWORD: " && echo "$${REPLY}" | tee INFLUXDB_PASSWORD))

# scan interval for speedtest
INTERNET_SCAN_INTERVAL := $(if $(wildcard INTERNET_SCAN_INTERVAL),$(shell v=$$(cat INTERNET_SCAN_INTERVAL) && echo "** SPECIFIED: INTERNET_SCAN_INTERVAL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="14400" && echo "!! UNSPECIFIED: INTERNET_SCAN_INTERVAL unset; default: $${v}" > /dev/stderr && echo "$${v}"))
INTRANET_SCAN_INTERVAL := $(if $(wildcard INTRANET_SCAN_INTERVAL),$(shell v=$$(cat INTRANET_SCAN_INTERVAL) && echo "** SPECIFIED: INTRANET_SCAN_INTERVAL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="1800" && echo "!! UNSPECIFIED: INTRANET_SCAN_INTERVAL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

###
### TARGETS
###

## subdirectories containing addition makefile
# internet sdr2msghub startup yolo2msghub exchange hznmonitor hznsetup 
PACKAGES := motion

## directories for output files from scripts
MOTION_DIRS := camera/motion group/motion counter/motion sensor/motion automation/motion device_tracker/motion history_graph/motion

default: all

all: motion/webcams.json $(MOTION_DIRS) $(PACKAGES) secrets.yaml

motion/webcams.json:
	@echo "Please create $(PWD)/$@ from example template: $(PWD)/$@.tmpl"

$(MOTION_DIRS):
	-mkdir -p $@

$(PACKAGES): makefile
	@echo "making $@"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_NAME="$(HOST_NAME)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
	  && ${MAKE} -C $@

run: all configuration.yaml 
	docker start homeassistant

stop:
	-docker stop homeassistant

restart: stop tidy logclean run

logs:
	docker logs -f homeassistant

secrets.yaml: secrets.yaml.tmpl makefile $(PWD)
	@echo "making $@"
	@export \
	  AUTOMATION_startup="$(AUTOMATION_startup)" \
	  AUTOMATION_sdr2msghub="$(AUTOMATION_sdr2msghub)" \
	  AUTOMATION_yolo2msghub="$(AUTOMATION_yolo2msghub)" \
	  AUTOMATION_highlow="$(AUTOMATION_highlow)" \
	  HOST_NAME="$(HOST_NAME)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
	  HOST_NETWORK="$(HOST_NETWORK)" \
	  HOST_NETWORK_MASK="$(HOST_NETWORK_MASK)" \
	  HOST_PORT="$(HOST_PORT)" \
	  HOST_THEME="$(HOST_THEME)" \
	  HZNMONITOR_URL="$(HZNMONITOR_URL)" \
	  CONSUL_URL="$(CONSUL_URL)" \
	  COUCHDB_URL="$(COUCHDB_URL)" \
	  DIGITS_URL="$(DIGITS_URL)" \
	  EDGEX_URL="$(EDGEX_URL)" \
	  EXCHANGE_URL="$(EXCHANGE_URL)" \
	  EXCHANGE_APIKEY="$(EXCHANGE_APIKEY)" \
	  EXCHANGE_ORG="$(EXCHANGE_ORG)" \
	  EXCHANGE_ORG_ADMIN="$(EXCHANGE_ORG_ADMIN)" \
	  GRAFANA_URL="$(GRAFANA_URL)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  INFLUXDB_HOST="$(INFLUXDB_HOST)" \
	  INFLUXDB_PASSWORD="$(INFLUXDB_PASSWORD)" \
	  INTERNET_SCAN_INTERVAL="$(INTERNET_SCAN_INTERVAL)" \
	  INTRANET_SCAN_INTERVAL="$(INTRANET_SCAN_INTERVAL)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  MOTIONCAM_USERNAME="$(MOTIONCAM_USERNAME)" \
	  MOTIONCAM_PASSWORD="$(MOTIONCAM_PASSWORD)" \
	  MOTION_DETECT_ENTITY="$(MOTION_DETECT_ENTITY)" \
	  LOGGER_DEFAULT="$(LOGGER_DEFAULT)" \
	&& cat secrets.yaml.tmpl | envsubst > $@

## clean and clean and clean ..

tidy: 
	@echo "making $@"
	@${MAKE} -C motion clean

clean: stop logclean tidy
	@echo "making $@"
	-rm -f www/images/motion_*.jpg
	-rm -f secrets.yaml
	-rm -f .storage/lovelace 
	-rm -f .storage/core.restore_state

realclean: clean
	rm -f known_devices.yaml
	rm -fr home-assistant.log
	rm -fr home-assistant_v2.*

logclean:
	@for i in $$(sudo find "/var/lib/docker/containers" -name "*.log" -print); do echo "Cleaning $${i}" && sudo cp /dev/null $${i}; done

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts .storage

.PHONY: tidy all default run stop logs restart clean realclean distclean $(PACKAGES)
