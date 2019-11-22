###
### makefile
###

SHELL := /bin/bash

PACKAGES := motion 
#	internet \
#	sdr2msghub \
#	startup \
#	yolo2msghub \
#	exchange \
#	hznmonitor \
#	hznsetup

# logging
LOGGER_DEFAULT := $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "-- INFO: LOGGER_DEFAULT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="info" && echo "++ WARN: LOGGER_DEFAULT unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# automation(s)
AUTOMATION_internet := $(if $(wildcard AUTOMATION_internet),$(shell v=$$(cat AUTOMATION_internet) && echo "-- INFO: AUTOMATION_internet: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "++ WARN: AUTOMATION_internet unset; default: off" > /dev/stderr && echo "off"))
AUTOMATION_startup := $(if $(wildcard AUTOMATION_startup),$(shell v=$$(cat AUTOMATION_startup) && echo "-- INFO: AUTOMATION_startup: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "++ WARN: AUTOMATION_startup unset; default: off" > /dev/stderr && echo "off"))
AUTOMATION_sdr2msghub := $(if $(wildcard AUTOMATION_sdr2msghub),$(shell v=$$(cat AUTOMATION_sdr2msghub) &&  echo "-- INFO: AUTOMATION_sdr2msghub: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "++ WARN: AUTOMATION_sdr2msghub unset; default: off" > /dev/stderr && echo "off"))
AUTOMATION_yolo2msghub := $(if $(wildcard AUTOMATION_yolo2msghub),$(shell v=$$(cat AUTOMATION_yolo2msghub) && echo "-- INFO: AUTOMATION_yolo2msghub: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "++ WARN: AUTOMATION_yolo2msghub unset; default: off" > /dev/stderr && echo "off"))

# domain
DOMAIN_NAME := $(if $(wildcard DOMAIN_NAME),$(shell v=$$(cat DOMAIN_NAME) && echo "-- INFO: DOMAIN_NAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="local" && echo "++ WARN: DOMAIN_NAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# host
HOST_NAME := $(if $(wildcard HOST_NAME),$(shell v=$$(cat HOST_NAME) && echo "-- INFO: HOST_NAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -f) && echo "++ WARN: HOST_NAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_IPADDR := $(if $(wildcard HOST_IPADDR),$(shell v=$$(cat HOST_IPADDR) && echo "-- INFO: HOST_IPADDR: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="127.0.0.1" && echo "++ WARN: HOST_IPADDR unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_PORT := $(if $(wildcard HOST_PORT),$(shell v=$$(cat HOST_PORT) && echo "-- INFO: HOST_PORT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="8123" && echo "++ WARN: HOST_PORT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_THEME := $(if $(wildcard HOST_THEME),$(shell v=$$(cat HOST_THEME) && echo "-- INFO: HOST_THEME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="default" && echo "++ WARN: HOST_THEME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
HOST_NETWORK := $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK := 24

# MQTT
MQTT_HOST := $(if $(wildcard MQTT_HOST),$(shell v=$$(cat MQTT_HOST) && echo "-- INFO: MQTT_HOST: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="core-mosquitto" && echo "++ WARN: MQTT_HOST unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PORT := $(if $(wildcard MQTT_PORT),$(shell v=$$(cat MQTT_PORT) && echo "-- INFO: MQTT_PORT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="1883" && echo "++ WARN: MQTT_PORT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_USERNAME := $(if $(wildcard MQTT_USERNAME),$(shell v=$$(cat MQTT_USERNAME) && echo "-- INFO: MQTT_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "++ WARN: MQTT_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PASSWORD := $(if $(wildcard MQTT_PASSWORD),$(shell v=$$(cat MQTT_PASSWORD) && echo "-- INFO: MQTT_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "++ WARN: MQTT_PASSWORD unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# webcam
WEBCAM_USERNAME := $(if $(wildcard WEBCAM_USERNAME),$(shell v=$$(cat WEBCAM_USERNAME) && echo "-- INFO: WEBCAM_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(whoami) && echo "++ WARN: WEBCAM_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
WEBCAM_PASSWORD := $(if $(wildcard WEBCAM_PASSWORD),$(shell v=$$(cat WEBCAM_PASSWORD) && echo "-- INFO: WEBCAM_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify WEBCAM_PASSWORD: " && echo $${REPLY} | tee WEBCAM_PASSWORD))

# netdata
NETDATA_URL := $(if $(wildcard NETDATA_URL),$(shell v=$$(cat NETDATA_URL) && echo "-- INFO: NETDATA_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:19999/" && echo "++ WARN: NETDATA_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# nVidia DIGITS
DIGITS_URL := $(if $(wildcard DIGITS_URL),$(shell v=$$(cat DIGITS_URL) && echo "-- INFO: DIGITS_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://digits.$(DOMAIN_NAME):5000/" && echo "++ WARN: DIGITS_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# couchdb
COUCHDB_URL := $(if $(wildcard COUCHDB_URL),$(shell v=$$(cat COUCHDB_URL) && echo "-- INFO: COUCHDB_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://couchdb.$(DOMAIN_NAME):5984/_utils" && echo "++ WARN: COUCHDB_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# edgex
EDGEX_URL := $(if $(wildcard EDGEX_URL),$(shell v=$$(cat EDGEX_URL) && echo "-- INFO: EDGEX_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://edgex.$(DOMAIN_NAME):4000" && echo "++ WARN: EDGEX_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))
CONSUL_URL := $(if $(wildcard CONSUL_URL),$(shell v=$$(cat CONSUL_URL) && echo "-- INFO: CONSUL_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://consul.$(DOMAIN_NAME):8500/ui" && echo "++ WARN: CONSUL_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

## open-horizon
EXCHANGE_URL := $(if $(wildcard EXCHANGE_URL),$(shell v=$$(cat EXCHANGE_URL) && echo "-- INFO: EXCHANGE_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://exchange.$(DOMAIN_NAME):3090" && echo "++ WARN: EXCHANGE_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))
EXCHANGE_ORG := $(if $(wildcard EXCHANGE_ORG),$(shell v=$$(cat EXCHANGE_ORG) && echo "-- INFO: EXCHANGE_ORG: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(whoami) && echo "++ WARN: EXCHANGE_ORG unset; default: $${v}" > /dev/stderr && echo "$${v}"))
EXCHANGE_ORG_ADMIN := $(if $(wildcard EXCHANGE_ORG_ADMIN),$(shell v=$$(cat EXCHANGE_ORG_ADMIN) && echo "-- INFO: EXCHANGE_ORG_ADMIN: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="${EXCHANGE_ORG}" && echo "++ WARN: EXCHANGE_ORG_ADMIN unset; default: $${v}" > /dev/stderr && echo "$${v}"))
EXCHANGE_APIKEY := $(if $(wildcard EXCHANGE_APIKEY),$(shell v=$$(cat EXCHANGE_APIKEY) && echo "-- INFO: EXCHANGE_APIKEY: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify EXCHANGE_APIKEY: " > /dev/stderr && echo $${REPLY} | tee EXCHANGE_APIKEY))

# hznmonitor
HZNMONITOR_URL := $(if $(wildcard HZNMONITOR_URL),$(shell v=$$(cat HZNMONITOR_URL) && echo "-- INFO: HZNMONITOR_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://hznmonitor.$(DOMAIN_NAME):3094" && echo "++ WARN: HZNMONITOR_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# grafana
GRAFANA_URL := $(if $(wildcard GRAFANA_URL),$(shell v=$$(cat GRAFANA_URL) && echo "-- INFO: GRAFANA_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://grafana.$(DOMAIN_NAME):3000" && echo "++ WARN: GRAFANA_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# influxdb
INFLUXDB_HOST := $(if $(wildcard INFLUXDB_HOST),$(shell v=$$(cat INFLUXDB_HOST) && echo "-- INFO: INFLUXDB_HOST: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="influxdb.$(DOMAIN_NAME)" && echo "++ WARN: INFLUXDB_HOST unset; default: $${v}" > /dev/stderr && echo "$${v}"))
INFLUXDB_PASSWORD := $(if $(wildcard INFLUXDB_PASSWORD),$(shell v=$$(cat INFLUXDB_PASSWORD) && echo "-- INFO: INFLUXDB_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify INFLUXDB_PASSWORD: " && echo "$${REPLY}" | tee INFLUXDB_PASSWORD))

## directories for output files from scripts
MOTION_DIRS := camera/motion group/motion counter/motion sensor/motion automation/motion device_tracker/motion history_graph/motion

###
### TARGETS
###

default: $(MOTION_DIRS) all run

$(MOTION_DIRS):
	-mkdir -p $@

TARGETS := build all

${TARGETS}: makefile
	@for P in ${PACKAGES}; do ${MAKE} -C $${P} $@; done

run: configuration.yaml secrets.yaml
	docker start homeassistant

stop:
	-docker stop homeassistant

restart: stop all run

logs:
	docker logs -f homeassistant

secrets.yaml: secrets.yaml.tmpl makefile $(PWD)
	@echo "making $@"
	@export \
	  AUTOMATION_internet="$(AUTOMATION_internet)" \
	  AUTOMATION_startup="$(AUTOMATION_startup)" \
	  AUTOMATION_sdr2msghub="$(AUTOMATION_sdr2msghub)" \
	  AUTOMATION_yolo2msghub="$(AUTOMATION_yolo2msghub)" \
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
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  WEBCAM_USERNAME="$(WEBCAM_USERNAME)" \
	  WEBCAM_PASSWORD="$(WEBCAM_PASSWORD)" \
	  LOGGER_DEFAULT="$(LOGGER_DEFAULT)" \
	&& cat secrets.yaml.tmpl | envsubst > $@

## clean and clean and clean ..

clean: stop
	make -C motion clean
	-rm -f secrets.yaml

realclean: clean
	rm -f known_devices.yaml
	rm -fr home-assistant.log
	rm -fr home-assistant_v2.*
	rm -f .storage/core.restore_state

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts .storage

.phony: all default build run stop logs restart clean realclean distclean $(PACKAGES)
