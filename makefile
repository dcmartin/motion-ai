###
### makefile
###

THIS_HOSTIP := $(shell hostname -I | awk '{ print $$1 }')

# logging
LOGGER_DEFAULT ?= $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "${TG}== LOGGER_DEFAULT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="error" && echo "${TB}** LOGGER_DEFAULT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
LOGGER_AUTOMATION ?= $(if $(wildcard LOGGER_AUTOMATION),$(shell v=$$(cat LOGGER_AUTOMATION) && echo "${TG}== LOGGER_AUTOMATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "${TB}** LOGGER_AUTOMATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# domain
DOMAIN_NAME ?= $(if $(wildcard DOMAIN_NAME),$(shell v=$$(cat DOMAIN_NAME) && echo "${TG}== DOMAIN_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(domainname -d) && v=$${v:-local} && echo "${TB}** DOMAIN_NAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# host
HOST_NAME ?= $(if $(wildcard HOST_NAME),$(shell v=$$(cat HOST_NAME) && echo "${TG}== HOST_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -f) && v=$${v%%.*} && echo "${TB}** HOST_NAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_TIMEZONE ?= $(if $(wildcard HOST_TIMEZONE),$(shell v=$$(cat HOST_TIMEZONE) && echo "${TG}== HOST_TIMEZONE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(cat /etc/timezone) && echo "${TB}** HOST_TIMEZONE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_IPADDR ?= $(if $(wildcard HOST_IPADDR),$(shell v=$$(cat HOST_IPADDR) && echo "${TG}== HOST_IPADDR: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=${THIS_HOSTIP} && echo "${TB}** HOST_IPADDR unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_INTERFACE ?= $(if $(wildcard HOST_INTERFACE),$(shell v=$$(cat HOST_INTERFACE) && echo "${TG}== HOST_INTERFACE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(ip addr | egrep -B2 ${HOST_IPADDR} | egrep '^[0-9]' | awk -F': ' '{ print $$2 }') && echo "${TB}** HOST_INTERFACE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_PORT ?= $(if $(wildcard HOST_PORT),$(shell v=$$(cat HOST_PORT) && echo "${TG}== HOST_PORT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="8123" && echo "${TB}** HOST_PORT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_THEME ?= $(if $(wildcard HOST_THEME),$(shell v=$$(cat HOST_THEME) && echo "${TG}== HOST_THEME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="default" && echo "${TB}** HOST_THEME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_NETWORK ?= $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK ?= 24

HOST_LATITUDE ?= $(if $(wildcard HOST_LATITUDE),$(shell v=$$(cat HOST_LATITUDE) && echo "${TG}== HOST_LATITUDE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "${TB}** HOST_LATITUDE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_LONGITUDE ?= $(if $(wildcard HOST_LONGITUDE),$(shell v=$$(cat HOST_LONGITUDE) && echo "${TG}== HOST_LONGITUDE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "${TB}** HOST_LONGITUDE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# MQTT
MQTT_HOST ?= $(if $(wildcard MQTT_HOST),$(shell v=$$(cat MQTT_HOST) && echo "${TG}== MQTT_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="$(HOST_IPADDR)" && echo "${TB}** MQTT_HOST unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MQTT_PORT ?= $(if $(wildcard MQTT_PORT),$(shell v=$$(cat MQTT_PORT) && echo "${TG}== MQTT_PORT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="1883" && echo "${TB}** MQTT_PORT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MQTT_USERNAME ?= $(if $(wildcard MQTT_USERNAME),$(shell v=$$(cat MQTT_USERNAME) && echo "${TG}== MQTT_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** MQTT_USERNAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MQTT_PASSWORD ?= $(if $(wildcard MQTT_PASSWORD),$(shell v=$$(cat MQTT_PASSWORD) && echo "${TG}== MQTT_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${TB}** MQTT_PASSWORD unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MARIADB_PASSWORD ?= $(if $(wildcard MARIADB_PASSWORD),$(shell v=$$(cat MARIADB_PASSWORD) && echo "${TG}== MARIADB_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="HomeAssistant1234" && echo "${TB}** MARIADB_PASSWORD unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MARIADB_HOST ?= $(if $(wildcard MARIADB_HOST),$(shell v=$$(cat MARIADB_HOST) && echo "${TG}== MARIADB_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="core-mariadb" && echo "${TB}** MARIADB_HOST unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

IPERF_HOST ?= $(if $(wildcard IPERF_HOST),$(shell v=$$(cat IPERF_HOST) && echo "${TG}== IPERF_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="$(MQTT_HOST)" && echo "${TB}** IPERF_HOST unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

## MOTION
MOTION_GROUP ?= $(if $(wildcard MOTION_GROUP),$(shell v=$$(cat MOTION_GROUP) && echo "${TG}== MOTION_GROUP: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='motion' && echo "${TB}** MOTION_GROUP unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DEVICE ?= $(if $(wildcard MOTION_DEVICE),$(shell v=$$(cat MOTION_DEVICE) && echo "${TG}== MOTION_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(echo $(HOST_NAME) | sed -e "s/-//g" -e "s/ /_/g") && echo "${TB}** MOTION_DEVICE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_CLIENT ?= $(if $(wildcard MOTION_CLIENT),$(shell v=$$(cat MOTION_CLIENT) && echo "${TG}== MOTION_CLIENT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$(MOTION_DEVICE) && echo "${TB}** MOTION_CLIENT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_USER ?= $(if $(wildcard MOTION_USER),$(shell v=$$(cat MOTION_USER) && echo "${TG}== MOTION_USER: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$(shell whoami) && echo "${TB}** MOTION_USER unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECT_ENTITY ?= $(if $(wildcard MOTION_DETECT_ENTITY),$(shell v=$$(cat MOTION_DETECT_ENTITY) && echo "${TG}== MOTION_DETECT_ENTITY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='person' && echo "${TB}** MOTION_DETECT_ENTITY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_MEDIA_SAVE ?= $(if $(wildcard MOTION_MEDIA_SAVE),$(shell v=$$(cat MOTION_MEDIA_SAVE) && echo "${TG}== MOTION_MEDIA_SAVE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_MEDIA_SAVE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_MEDIA_MASK ?= $(if $(wildcard MOTION_MEDIA_MASK),$(shell v=$$(cat MOTION_MEDIA_MASK) && echo "${TG}== MOTION_MEDIA_MASK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_MEDIA_MASK unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_YOLO_IP ?= $(if $(wildcard MOTION_YOLO_IP),$(shell v=$$(cat MOTION_YOLO_IP) && echo "${TG}== MOTION_YOLO_IP: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='${THIS_HOSTIP}' && echo "${TB}** MOTION_YOLO_IP unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_OVERVIEW_APIKEY ?= $(if $(wildcard MOTION_OVERVIEW_APIKEY),$(shell v=$$(cat MOTION_OVERVIEW_APIKEY) && echo "${TG}== MOTION_OVERVIEW_APIKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${TB}** MOTION_OVERVIEW_APIKEY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_MODE ?= $(if $(wildcard MOTION_OVERVIEW_MODE),$(shell v=$$(cat MOTION_OVERVIEW_MODE) && echo "${TG}== MOTION_OVERVIEW_MODE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='local' && echo "${TB}** MOTION_OVERVIEW_MODE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_ZOOM ?= $(if $(wildcard MOTION_OVERVIEW_ZOOM),$(shell v=$$(cat MOTION_OVERVIEW_ZOOM) && echo "${TG}== MOTION_OVERVIEW_ZOOM: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='20' && echo "${TB}** MOTION_OVERVIEW_ZOOM unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_IMAGE ?= $(if $(wildcard MOTION_OVERVIEW_IMAGE),$(shell v=$$(cat MOTION_OVERVIEW_IMAGE) && echo "${TG}== MOTION_OVERVIEW_IMAGE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='overview.jpg' && echo "${TB}** MOTION_OVERVIEW_IMAGE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_PERSON_TUNE ?= $(if $(wildcard MOTION_DETECTED_PERSON_TUNE),$(shell v=$$(cat MOTION_DETECTED_PERSON_TUNE) && echo "${TG}== MOTION_DETECTED_PERSON_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_PERSON_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_TUNE ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_TUNE),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_TUNE) && echo "${TG}== MOTION_DETECTED_VEHICLE_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_VEHICLE_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_TUNE ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_TUNE),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_TUNE) && echo "${TG}== MOTION_DETECTED_ANIMAL_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_ANIMAL_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_PERSON_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_PERSON_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_PERSON_DEVIATION) && echo "${TG}== MOTION_DETECTED_PERSON_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_PERSON_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_DEVIATION) && echo "${TG}== MOTION_DETECTED_VEHICLE_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_VEHICLE_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_DEVIATION) && echo "${TG}== MOTION_DETECTED_ANIMAL_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_ANIMAL_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# ago
MOTION_EXPIRE_AFTER ?= $(if $(wildcard MOTION_EXPIRE_AFTER),$(shell v=$$(cat MOTION_EXPIRE_AFTER) && echo "${TG}== MOTION_EXPIRE_AFTER: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_EXPIRE_AFTER unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_FORCE_UPDATE ?= $(if $(wildcard MOTION_FORCE_UPDATE),$(shell v=$$(cat MOTION_FORCE_UPDATE) && echo "${TG}== MOTION_FORCE_UPDATE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_FORCE_UPDATE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_ANNOTATED_AGO ?= $(if $(wildcard MOTION_ANNOTATED_AGO),$(shell v=$$(cat MOTION_ANNOTATED_AGO) && echo "${TG}== MOTION_ANNOTATED_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_ANNOTATED_AGO unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_AGO ?= $(if $(wildcard MOTION_DETECTED_AGO),$(shell v=$$(cat MOTION_DETECTED_AGO) && echo "${TG}== MOTION_DETECTED_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_DETECTED_AGO unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ENTITY_AGO ?= $(if $(wildcard MOTION_DETECTED_ENTITY_AGO),$(shell v=$$(cat MOTION_DETECTED_ENTITY_AGO) && echo "${TG}== MOTION_DETECTED_ENTITY_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_DETECTED_ENTITY_AGO unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# webcam
NETCAM_USERNAME ?= $(if $(wildcard NETCAM_USERNAME),$(shell v=$$(cat NETCAM_USERNAME) && echo "${TG}== NETCAM_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** NETCAM_USERNAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
NETCAM_PASSWORD ?= $(if $(wildcard NETCAM_PASSWORD),$(shell v=$$(cat NETCAM_PASSWORD) && echo "${TG}== NETCAM_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify NETCAM_PASSWORD: " && echo $${REPLY} | tee NETCAM_PASSWORD))

MOTIONCAM_USERNAME ?= $(if $(wildcard MOTIONCAM_USERNAME),$(shell v=$$(cat MOTIONCAM_USERNAME) && echo "${TG}== MOTIONCAM_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** MOTIONCAM_USERNAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTIONCAM_PASSWORD ?= $(if $(wildcard MOTIONCAM_PASSWORD),$(shell v=$$(cat MOTIONCAM_PASSWORD) && echo "${TG}== MOTIONCAM_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify MOTIONCAM_PASSWORD: " && echo $${REPLY} | tee MOTIONCAM_PASSWORD))

# netdata
NETDATA_URL ?= $(if $(wildcard NETDATA_URL),$(shell v=$$(cat NETDATA_URL) && echo "${TG}== NETDATA_URL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:19999/" && echo "${TB}** NETDATA_URL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# jupyter
JUPYTER_URL ?= $(if $(wildcard JUPYTER_URL),$(shell v=$$(cat JUPYTER_URL) && echo "${TG}== JUPYTER_URL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:7777/" && echo "${TB}** JUPYTER_URL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# tplink
TPLINK_DISCOVERY ?= $(if $(wildcard TPLINK_DISCOVERY),$(shell v=$$(cat TPLINK_DISCOVERY) && echo "${TG}== TPLINK_DISCOVERY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** TPLINK_DISCOVERY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# influxdb
INFLUXDB_HOST ?= $(if $(wildcard INFLUXDB_HOST),$(shell v=$$(cat INFLUXDB_HOST) && echo "${TG}== INFLUXDB_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='a0d7b954-influxdb' && echo "${TB}** INFLUXDB_HOST unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
INFLUXDB_DATABASE ?= $(if $(wildcard INFLUXDB_DATABASE),$(shell v=$$(cat INFLUXDB_DATABASE) && echo "${TG}== INFLUXDB_DATABASE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='$(HOST_NAME)' && echo "${TB}** INFLUXDB_DATABASE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
INFLUXDB_USERNAME ?= $(if $(wildcard INFLUXDB_USERNAME),$(shell v=$$(cat INFLUXDB_USERNAME) && echo "${TG}== INFLUXDB_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='homeassistant' && echo "${TB}** INFLUXDB_USERNAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
INFLUXDB_PASSWORD ?= $(if $(wildcard INFLUXDB_PASSWORD),$(shell v=$$(cat INFLUXDB_PASSWORD) && echo "${TG}== INFLUXDB_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='homeassistant' && echo "${TB}** INFLUXDB_PASSWORD unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# scan interval for speedtest
# scan interval for speedtest
INTERNET_SCAN_INTERVAL ?= $(if $(wildcard INTERNET_SCAN_INTERVAL),$(shell v=$$(cat INTERNET_SCAN_INTERVAL) && echo "${TG}== INTERNET_SCAN_INTERVAL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="14400" && echo "${TB}** INTERNET_SCAN_INTERVAL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
INTRANET_SCAN_INTERVAL ?= $(if $(wildcard INTRANET_SCAN_INTERVAL),$(shell v=$$(cat INTRANET_SCAN_INTERVAL) && echo "${TG}== INTRANET_SCAN_INTERVAL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="1800" && echo "${TB}** INTRANET_SCAN_INTERVAL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

###
### TARGETS
###

MEDIA := media/Motion-Ã👁/ homeassistant/www/images/motion/

ACTIONS := all run stop logs restart refresh tidy neat clean realclean distclean

default: necessary all

necessary: homeassistant/motion/webcams.json ${MEDIA}

homeassistant/motion/webcams.json:
	@-./sh/mkwebcams.sh > homeassistant/motion/webcams.json

${MEDIA}:
	@echo "${MC}Making: MEDIA $@${NC}"
	@-sudo mkdir -p $@

$(ACTIONS): necessary
	@echo "${MC}Making: $@${NC}"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
	  HOST_INTERFACE="$(HOST_INTERFACE)" \
	  HOST_NAME="$(HOST_NAME)" \
	  HOST_TIMEZONE="$(HOST_TIMEZONE)" \
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
	  MOTION_USER="$(MOTION_USER)" \
	  MOTION_DETECT_ENTITY="$(MOTION_DETECT_ENTITY)" \
	  MOTION_EXPIRE_AFTER="$(MOTION_EXPIRE_AFTER)" \
	  MOTION_FORCE_UPDATE="$(MOTION_FORCE_UPDATE)" \
	  MOTION_MEDIA_SAVE="$(MOTION_MEDIA_SAVE)" \
	  MOTION_MEDIA_MASK="$(MOTION_MEDIA_MASK)" \
	  MOTION_YOLO_IP="$(MOTION_YOLO_IP)" \
	  MOTION_OVERVIEW_APIKEY="$(MOTION_OVERVIEW_APIKEY)" \
	  MOTION_OVERVIEW_MODE="$(MOTION_OVERVIEW_MODE)" \
	  MOTION_OVERVIEW_ZOOM="$(MOTION_OVERVIEW_ZOOM)" \
	  MOTION_OVERVIEW_IMAGE="$(MOTION_OVERVIEW_IMAGE)" \
	  MOTION_ANNOTATED_AGO="$(MOTION_ANNOTATED_AGO)" \
	  MOTION_DETECTED_AGO="$(MOTION_DETECTED_AGO)" \
	  MOTION_DETECTED_ENTITY_AGO="$(MOTION_DETECTED_ENTITY_AGO)" \
	  MOTION_DETECTED_PERSON_TUNE="$(MOTION_DETECTED_PERSON_TUNE)" \
	  MOTION_DETECTED_VEHICLE_TUNE="$(MOTION_DETECTED_VEHICLE_TUNE)" \
	  MOTION_DETECTED_ANIMAL_TUNE="$(MOTION_DETECTED_ANIMAL_TUNE)" \
	  MOTION_DETECTED_PERSON_DEVIATION="$(MOTION_DETECTED_PERSON_DEVIATION)" \
	  MOTION_DETECTED_VEHICLE_DEVIATION="$(MOTION_DETECTED_VEHICLE_DEVIATION)" \
	  MOTION_DETECTED_ANIMAL_DEVIATION="$(MOTION_DETECTED_ANIMAL_DEVIATION)" \
	  MOTIONCAM_PASSWORD="$(MOTIONCAM_PASSWORD)" \
	  MOTIONCAM_USERNAME="$(MOTIONCAM_USERNAME)" \
	  IPERF_HOST="$(IPERF_HOST)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  MARIADB_HOST="$(MARIADB_HOST)" \
	  MARIADB_PASSWORD="$(MARIADB_PASSWORD)" \
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  JUPYTER_URL="$(JUPYTER_URL)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	  INFLUXDB_HOST="$(INFLUXDB_HOST)" \
	  INFLUXDB_DATABASE="$(INFLUXDB_DATABASE)" \
	  INFLUXDB_USERNAME="$(INFLUXDB_USERNAME)" \
	  INFLUXDB_PASSWORD="$(INFLUXDB_PASSWORD)" \
	&& make -C homeassistant $@

.PHONY: ${MEDIA} necessary all default run stop logs restart tidy clean realclean distclean $(PACKAGES) homeassistant/motion/webcams.json

##
## COLORS
##
MC=${LIGHT_CYAN}
TB=${RED}
TG=${GREEN}
NC=${NO_COLOR}

NO_COLOR=\033[0m
BLACK=\033[0;30m
RED=\033[0;31m
GREEN=\033[0;32m
BROWN_ORANGE=\033[0;33m
BLUE=\033[0;34m
PURPLE=\033[0;35m
CYAN=\033[0;36m
LIGHT_GRAY=\033[0;37m

DARK_GRAY=\033[1;30m
LIGHT_RED=\033[1;31m
LIGHT_GREEN=\033[1;32m
YELLOW=\033[1;33m
LIGHT_BLUE=\033[1;34m
LIGHT_PURPLE=\033[1;35m
LIGHT_CYAN=\033[1;36m
WHITE=\034[1;37m
