###
### makefile
###

THIS_HOSTIP ?= $(shell hostname -i | awk '{ print $$1 }')

# logging
LOGGER_DEFAULT ?= $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "${TG}== LOGGER_DEFAULT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "${TB}** LOGGER_DEFAULT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
LOGGER_AUTOMATION ?= $(if $(wildcard LOGGER_AUTOMATION),$(shell v=$$(cat LOGGER_AUTOMATION) && echo "${TG}== LOGGER_AUTOMATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "${TB}** LOGGER_AUTOMATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# automation(s)
AUTOMATION_INTERNET ?= $(if $(wildcard AUTOMATION_INTERNET),$(shell v=$$(cat AUTOMATION_INTERNET) && echo "${TG}== AUTOMATION_INTERNET: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell echo "** AUTOMATION_INTERNET unset; default: off" > /dev/stderr && echo "off"))
AUTOMATION_INTRANET ?= $(if $(wildcard AUTOMATION_INTRANET),$(shell v=$$(cat AUTOMATION_INTRANET) && echo "${TG}== AUTOMATION_INTRANET: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell echo "** AUTOMATION_INTRANET unset; default: off" > /dev/stderr && echo "off"))

# domain
DOMAIN_NAME ?= $(if $(wildcard DOMAIN_NAME),$(shell v=$$(cat DOMAIN_NAME) && echo "${TG}== DOMAIN_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostnamee-d) && v=$${v:-local} && echo "${TB}** DOMAIN_NAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# host
HOST_NAME ?= $(if $(wildcard HOST_NAME),$(shell v=$$(cat HOST_NAME) && echo "${TG}== HOST_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -f) && v=$${v%%.*} && echo "${TB}** HOST_NAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_IPADDR ?= $(if $(wildcard HOST_IPADDR),$(shell v=$$(cat HOST_IPADDR) && echo "${TG}== HOST_IPADDR: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=${THIS_HOSTIP} && echo "${TB}** HOST_IPADDR unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_PORT ?= $(if $(wildcard HOST_PORT),$(shell v=$$(cat HOST_PORT) && echo "${TG}== HOST_PORT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="8123" && echo "${TB}** HOST_PORT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_THEME ?= $(if $(wildcard HOST_THEME),$(shell v=$$(cat HOST_THEME) && echo "${TG}== HOST_THEME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="default" && echo "${TB}** HOST_THEME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_NETWORK ?= $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK ?= 24

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
MOTION_DEVICE ?= $(if $(wildcard MOTION_DEVICE),$(shell v=$$(cat MOTION_DEVICE) && echo "${TG}== MOTION_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -s) && echo "${TB}** MOTION_DEVICE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_CLIENT ?= $(if $(wildcard MOTION_CLIENT),$(shell v=$$(cat MOTION_CLIENT) && echo "${TG}== MOTION_CLIENT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='+' && echo "${TB}** MOTION_CLIENT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_USER ?= $(if $(wildcard MOTION_USER),$(shell v=$$(cat MOTION_USER) && echo "${TG}== MOTION_USER: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$(shell whoami) && echo "${TB}** MOTION_USER unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECT_ENTITY ?= $(if $(wildcard MOTION_DETECT_ENTITY),$(shell v=$$(cat MOTION_DETECT_ENTITY) && echo "${TG}== MOTION_DETECT_ENTITY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="person" && echo "${TB}** MOTION_DETECT_ENTITY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_EXPIRE_AFTER ?= $(if $(wildcard MOTION_EXPIRE_AFTER),$(shell v=$$(cat MOTION_EXPIRE_AFTER) && echo "${TG}== MOTION_EXPIRE_AFTER: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="5" && echo "${TB}** MOTION_EXPIRE_AFTER unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_FORCE_UPDATE ?= $(if $(wildcard MOTION_FORCE_UPDATE),$(shell v=$$(cat MOTION_FORCE_UPDATE) && echo "${TG}== MOTION_FORCE_UPDATE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="false" && echo "${TB}** MOTION_FORCE_UPDATE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_MEDIA_SAVE ?= $(if $(wildcard MOTION_MEDIA_SAVE),$(shell v=$$(cat MOTION_MEDIA_SAVE) && echo "${TG}== MOTION_MEDIA_SAVE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="true" && echo "${TB}** MOTION_MEDIA_SAVE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_MEDIA_MASK ?= $(if $(wildcard MOTION_MEDIA_MASK),$(shell v=$$(cat MOTION_MEDIA_MASK) && echo "${TG}== MOTION_MEDIA_MASK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="true" && echo "${TB}** MOTION_MEDIA_MASK unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_YOLO_IP ?= $(if $(wildcard MOTION_YOLO_IP),$(shell v=$$(cat MOTION_YOLO_IP) && echo "${TG}== MOTION_YOLO_IP: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='${THIS_HOSTIP}' && echo "${TB}** MOTION_YOLO_IP unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_OVERVIEW_APIKEY ?= $(if $(wildcard MOTION_OVERVIEW_APIKEY),$(shell v=$$(cat MOTION_OVERVIEW_APIKEY) && echo "${TG}== MOTION_OVERVIEW_APIKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="none" && echo "${TB}** MOTION_OVERVIEW_APIKEY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_MODE ?= $(if $(wildcard MOTION_OVERVIEW_MODE),$(shell v=$$(cat MOTION_OVERVIEW_MODE) && echo "${TG}== MOTION_OVERVIEW_MODE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="local" && echo "${TB}** MOTION_OVERVIEW_MODE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_ZOOM ?= $(if $(wildcard MOTION_OVERVIEW_ZOOM),$(shell v=$$(cat MOTION_OVERVIEW_ZOOM) && echo "${TG}== MOTION_OVERVIEW_ZOOM: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="20" && echo "${TB}** MOTION_OVERVIEW_ZOOM unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_IMAGE ?= $(if $(wildcard MOTION_OVERVIEW_IMAGE),$(shell v=$$(cat MOTION_OVERVIEW_IMAGE) && echo "${TG}== MOTION_OVERVIEW_IMAGE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="overview.jpg" && echo "${TB}** MOTION_OVERVIEW_IMAGE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_PERSON_TUNE ?= $(if $(wildcard MOTION_DETECTED_PERSON_TUNE),$(shell v=$$(cat MOTION_DETECTED_PERSON_TUNE) && echo "${TG}== MOTION_DETECTED_PERSON_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_PERSON_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_TUNE ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_TUNE),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_TUNE) && echo "${TG}== MOTION_DETECTED_VEHICLE_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_VEHICLE_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_TUNE ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_TUNE),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_TUNE) && echo "${TG}== MOTION_DETECTED_ANIMAL_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_ANIMAL_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_PERSON_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_PERSON_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_PERSON_DEVIATION) && echo "${TG}== MOTION_DETECTED_PERSON_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_PERSON_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_DEVIATION) && echo "${TG}== MOTION_DETECTED_VEHICLE_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_VEHICLE_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_DEVIATION) && echo "${TG}== MOTION_DETECTED_ANIMAL_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_ANIMAL_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# ago
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
TPLINK_DISCOVERY ?= $(if $(wildcard TPLINK_DISCOVERY),$(shell v=$$(cat TPLINK_DISCOVERY) && echo "${TG}== TPLINK_DISCOVERY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** TPLINK_DISCOVERY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

# scan interval for speedtest
INTERNET_SCAN_INTERVAL ?= $(if $(wildcard INTERNET_SCAN_INTERVAL),$(shell v=$$(cat INTERNET_SCAN_INTERVAL) && echo "${TG}== INTERNET_SCAN_INTERVAL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="14400" && echo "${TB}** INTERNET_SCAN_INTERVAL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))
INTRANET_SCAN_INTERVAL ?= $(if $(wildcard INTRANET_SCAN_INTERVAL),$(shell v=$$(cat INTRANET_SCAN_INTERVAL) && echo "${TG}== INTRANET_SCAN_INTERVAL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="1800" && echo "${TB}** INTRANET_SCAN_INTERVAL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}"))

###
### TARGETS
###

## subdirectories containing addition makefile
PACKAGES := motion

## directories for output files from scripts
MOTION_DIRS := camera/motion group/motion counter/motion sensor/motion automation/motion device_tracker/motion history_graph/motion

default: all

all: motion/webcams.json lovelace.json lovelace_dashboards.json lovelace.developer.json $(MOTION_DIRS) $(PACKAGES) secrets.yaml

motion/webcams.json:
	@echo "MISSING: please create $(PWD)/$@ from example template: $(PWD)/$@.tmpl"

$(MOTION_DIRS):
	-mkdir -p $@

$(PACKAGES): makefile
	@echo "${MC}Making: $@${NC}"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_NAME="$(HOST_NAME)" \
	  IPERF_HOST="$(IPERF_HOST)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MARIADB_HOST="$(MARIADB_HOST)" \
	  MARIADB_PASSWORD="$(MARIADB_PASSWORD)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
	  MOTION_USER="$(MOTION_USER)" \
	  && ${MAKE} -C $@

run: all configuration.yaml 
	docker start homeassistant

stop:
	-docker stop homeassistant

restart: stop logclean tidy run

refresh: stop logclean neat run

logs:
	docker logs -f homeassistant

secrets.yaml: secrets.yaml.tmpl makefile $(PWD)
	@echo "${MC}Making: $@${NC}"
	@export \
	  AUTOMATION_INTERNET="$(AUTOMATION_INTERNET)" \
	  AUTOMATION_INTRANET="$(AUTOMATION_INTRANET)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
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
	  JUPYTER_URL="$(JUPYTER_URL)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	  INFLUXDB_HOST="$(INFLUXDB_HOST)" \
	  INFLUXDB_USERNAME="$(INFLUXDB_USERNAME)" \
	  INFLUXDB_DATABASE="$(INFLUXDB_DATABASE)" \
	  INFLUXDB_PASSWORD="$(INFLUXDB_PASSWORD)" \
	  INTERNET_SCAN_INTERVAL="$(INTERNET_SCAN_INTERVAL)" \
	  INTRANET_SCAN_INTERVAL="$(INTRANET_SCAN_INTERVAL)" \
	  IPERF_HOST="$(IPERF_HOST)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MARIADB_PASSWORD="$(MARIADB_PASSWORD)" \
	  MARIADB_HOST="$(MARIADB_HOST)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  MOTIONCAM_USERNAME="$(MOTIONCAM_USERNAME)" \
	  MOTIONCAM_PASSWORD="$(MOTIONCAM_PASSWORD)" \
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
          MOTION_DETECTED_PERSON_NOTIFY="$(MOTION_DETECTED_PERSON_NOTIFY)" \
          MOTION_DETECTED_VEHICLE_NOTIFY="$(MOTION_DETECTED_VEHICLE_NOTIFY)" \
          MOTION_DETECTED_ANIMAL_NOTIFY="$(MOTION_DETECTED_ANIMAL_NOTIFY)" \
	  MOTION_DETECTED_PERSON_SPEAK="$(MOTION_DETECTED_PERSON_SPEAK)" \
	  MOTION_DETECTED_VEHICLE_SPEAK="$(MOTION_DETECTED_VEHICLE_SPEAK)" \
	  MOTION_DETECTED_ANIMAL_SPEAK="$(MOTION_DETECTED_ANIMAL_SPEAK)" \
	  MOTION_DETECTED_PERSON_TUNE="$(MOTION_DETECTED_PERSON_TUNE)" \
	  MOTION_DETECTED_VEHICLE_TUNE="$(MOTION_DETECTED_VEHICLE_TUNE)" \
	  MOTION_DETECTED_ANIMAL_TUNE="$(MOTION_DETECTED_ANIMAL_TUNE)" \
	  MOTION_DETECTED_PERSON_DEVIATION="$(MOTION_DETECTED_PERSON_DEVIATION)" \
	  MOTION_DETECTED_VEHICLE_DEVIATION="$(MOTION_DETECTED_VEHICLE_DEVIATION)" \
	  MOTION_DETECTED_ANIMAL_DEVIATION="$(MOTION_DETECTED_ANIMAL_DEVIATION)" \
	  LOGGER_DEFAULT="$(LOGGER_DEFAULT)" \
	  LOGGER_AUTOMATION="$(LOGGER_AUTOMATION)" \
	&& cat $< | envsubst > $@

lovelace.json: lovelace.json.tmpl motion/webcams.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
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
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  JUPYTER_URL="$(JUPYTER_URL)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="home").cards[].cards[].cards[]|select(.camera_image=="camera.motion_overview").elements)+='"$$(jq '[.[]|{"type":"icon","entity":("sensor.motion_detected_person_ago_"+.name),"icon": ("mdi:"+.icon),"style":{"color":"red","left":(.left|tostring+"%"),"top":(.top|tostring+"%"),"height":"5%","width": "5%"}}]' motion/webcams.json)" \
	 > $@
	@rm -f .storage/lovelace
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace

#	  | jq '(.data.config.views[]|select(.path=="motion_live").cards)+='"$$(jq '[.[]|{"entity":("camera.motion_live_"+.name),"type":"picture-entity"}]' motion/webcams.json)" \

lovelace.developer.json: lovelace.developer.json.tmpl motion/webcams.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
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
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  JUPYTER_URL="$(JUPYTER_URL)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="motion_live").cards[]|select(.title=="OVERVIEW").elements)+='"$$(jq '[.[]|{"type":"icon","entity":("camera.motion_live_"+.name),"icon": ("mdi:"+.icon),"style":{"color":"red","left":(.left|tostring+"%"),"top":(.top|tostring+"%"),"height":"5%","width": "5%"}}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="settings_view").cards[]|select(.title=="Detect entity").entities)+='"$$(jq '[.[]|{"name":("Detect at "+.name),"entity":("input_select.motion_detect_entity_"+.name)},{"name":("Notify at "+.name),"entity":("input_boolean.motion_detected_entity_notify_"+.name)}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="person").cards[]|select(.title=="Person count mean (μ)").entities)+='"$$(jq '[.[]|("sensor.motion_detected_person_count_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="person").cards[]|select(.title=="Person ago mean (μ)").entities)+='"$$(jq '[.[]|("sensor.motion_detected_person_ago_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="vehicle").cards[]|select(.title=="Vehicle count mean (μ)").entities)+='"$$(jq '[.[]|("sensor.motion_detected_vehicle_count_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="vehicle").cards[]|select(.title=="Vehicle ago mean (μ)").entities)+='"$$(jq '[.[]|("sensor.motion_detected_vehicle_ago_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="animal").cards[]|select(.title=="Animal count mean (μ)").entities)+='"$$(jq '[.[]|("sensor.motion_detected_animal_count_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="animal").cards[]|select(.title=="Animal ago mean (μ)").entities)+='"$$(jq '[.[]|("sensor.motion_detected_animal_ago_"+.name+"_mean")]' motion/webcams.json)" \
	 > $@
	@rm -f .storage/lovelace.lovelace_developer
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.lovelace_developer

lovelace.experimental.json: lovelace.experimental.json.tmpl motion/webcams.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
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
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  JUPYTER_URL="$(JUPYTER_URL)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="motion_live").cards[]|select(.title=="OVERVIEW").elements)+='"$$(jq '[.[]|{"type":"icon","entity":("camera.motion_live_"+.name),"icon": ("mdi:"+.icon),"style":{"color":"red","left":(.left|tostring+"%"),"top":(.top|tostring+"%"),"height":"5%","width": "5%"}}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_animated_webcams_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_annotated_when_"+.name),"name":.name,"image":("/local/images/motion_end_animated-"+.name+".gif"),"camera_image":("camera.motion_end_animated_"+.name),"type":"picture-entity"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_counter_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_count_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_count_mean_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_count_stdev_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name+"_stdev")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_count_change_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name+"_change")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_percent_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_percent_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_count_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_count_mean_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_ago_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_ago_mean_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_ago_stdev_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name+"_stdev")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="entity_ago_change_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name+"_change")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_annotated_view").cards[]|select(.title=="motion_annotated_ago").entities)+='"$$(jq '[.[]|("sensor.motion_annotated_ago_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_annotated_view").cards[]|select(.title=="motion_annotated_counter").entities)+='"$$(jq '[.[]|("sensor.motion_annotated_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_annotated_view").cards[]|select(.title=="motion_annotated_count").entities)+='"$$(jq '[.[]|("sensor.motion_annotated_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_annotated_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_annotated_count_"+.name),"aspect_ratio": "0%","camera_image": ("camera.motion_annotated_"+.name),"entities": [{"entity":("binary_sensor.motion_annotated_"+.name)},{"entity":("sensor.motion_annotated_ago_"+.name)}],"title":("Motion Annotated "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_view").cards[]|select(.title=="motion_detected_ago").entities)+='"$$(jq '[.[]|("sensor.motion_detected_ago_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_view").cards[]|select(.title=="motion_detected_counter").entities)+='"$$(jq '[.[]|("sensor.motion_detected_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_view").cards[]|select(.title=="motion_detected_count").entities)+='"$$(jq '[.[]|("sensor.motion_detected_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_detected_count_"+.name),"aspect_ratio": "0%","camera_image": ("camera.motion_detected_"+.name),"entities": [{"entity":("binary_sensor.motion_detected_"+.name)},{"entity":("sensor.motion_detected_ago_"+.name)}],"title":("Motion Detected "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_entity_view").cards[]|select(.title=="motion_detected_entity_ago").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_entity_view").cards[]|select(.title=="motion_detected_entity_counter").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_entity_view").cards[]|select(.title=="motion_detected_entity_count").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_entity_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_detected_entity_count_"+.name),"aspect_ratio": "0%","camera_image": ("camera.motion_detected_entity_"+.name),"entities": [{"entity":("binary_sensor.motion_detected_entity_"+.name)},{"entity":("sensor.motion_detected_entity_ago_"+.name)}],"title":("Motion Detected Entity "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_face_detected_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_face_detected_count_"+.name),"aspect_ratio": "0%","camera_image": ("camera.motion_face_detected_"+.name),"entities": [{"entity":("binary_sensor.motion_face_detected_"+.name)},{"entity":("sensor.motion_face_detected_ago_"+.name)}],"title":("Face "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_alpr_detected_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_alpr_detected_count_"+.name),"aspect_ratio": "0%","camera_image": ("camera.motion_alpr_detected_"+.name),"entities": [{"entity":("binary_sensor.motion_alpr_detected_"+.name)},{"entity":("sensor.motion_alpr_detected_ago_"+.name)}],"title":("ALPR "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="Camera Status").entities)+='"$$(jq '[.[]|("sensor.motion_status_camera_"+.name)]' motion/webcams.json)" \
          | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="Camera Status Counter").entities)+='"$$(jq '[.[]|("sensor.motion_status_camera_counter_"+.name)]' motion/webcams.json)" \
	 > $@
	@rm -f .storage/lovelace.lovelace_experimental
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.lovelace_experimental

lovelace_dashboards.json: lovelace_dashboards.json.tmpl
	@echo "${MC}Making: $@${NC}"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
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
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  JUPYTER_URL="$(JUPYTER_URL)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	&& cat $< \
	  | envsubst \
	 > $@
	@rm -f .storage/lovelace_dashboards
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace_dashboards

## clean and clean and clean ..

tidy: 
	@echo "${MC}Making: $@${NC}"
	@rm -f secrets.yaml
	-@sudo rm -f .storage/core.restore_state
	@${MAKE} -C motion clean

neat: tidy
	@echo "${MC}Making: $@${NC}"
	@rm -f motion/webcams.json
	@rm -f lovelace.json lovelace_dashboards.json lovelace.developer.json

clean: stop logclean neat
	@echo "${MC}Making: $@${NC}"
	-@rm -f .storage/lovelace*
	-@sudo rm -f .storage/core.entity_registry

realclean: clean 
	-@sudo rm -f home-assistant_v2.*
	-@sudo rm -f known_devices.yaml
	-@sudo rm -f home-assistant.log
	-@sudo rm -f www/images/motion/

distclean: realclean
	-@sudo rm -f .storage
	-@suro rm -fr .uuid .HA_VERSION .cloud deps tts .storage
	-@sudo rm -fr "../media/Motion-Ã👁"

logclean:
	-@sudo journalctl --vacuum-time 1
	@export LOGPATH=$$(docker inspect --format '{{json .}}' homeassistant | jq -r '.LogPath') \
	  && echo 'Attempting to remove log file (requires sudo): '"$${LOGPATH}" \
	  && sudo LOGPATH=$${LOGPATH} /bin/rm -f $${LOGPATH}

.PHONY: refresh neat tidy all default run stop logs restart clean realclean distclean $(PACKAGES)

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
