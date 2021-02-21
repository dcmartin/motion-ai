###
### makefile
###

THIS_HOSTIP := $(shell hostname -I | awk '{ print $$1 }')

# logging
LOGGER_DEFAULT ?= $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "${TG}== LOGGER_DEFAULT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="error" && echo "${TB}** LOGGER_DEFAULT unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
LOGGER_MQTT ?= $(if $(wildcard LOGGER_MQTT),$(shell v=$$(cat LOGGER_MQTT) && echo "${TG}== LOGGER_MQTT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="error" && echo "${TB}** LOGGER_MQTT unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
LOGGER_AUTOMATION ?= $(if $(wildcard LOGGER_AUTOMATION),$(shell v=$$(cat LOGGER_AUTOMATION) && echo "${TG}== LOGGER_AUTOMATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "${TB}** LOGGER_AUTOMATION unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# domain
DOMAIN_NAME ?= $(if $(wildcard DOMAIN_NAME),$(shell v=$$(cat DOMAIN_NAME) && echo "${TG}== DOMAIN_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(domainname -d) && v=$${v:-local} && echo "${TB}** DOMAIN_NAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# host
HOST_NAME ?= $(if $(wildcard HOST_NAME),$(shell v=$$(cat HOST_NAME) && echo "${TG}== HOST_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -f) && v=$${v%%.*} && echo "${TB}** HOST_NAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_TIMEZONE ?= $(if $(wildcard HOST_TIMEZONE),$(shell v=$$(cat HOST_TIMEZONE) && echo "${TG}== HOST_TIMEZONE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(cat /etc/timezone) && echo "${TB}** HOST_TIMEZONE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_IPADDR ?= $(if $(wildcard HOST_IPADDR),$(shell v=$$(cat HOST_IPADDR) && echo "${TG}== HOST_IPADDR: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=${THIS_HOSTIP} && echo "${TB}** HOST_IPADDR unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_INTERFACE ?= $(if $(wildcard HOST_INTERFACE),$(shell v=$$(cat HOST_INTERFACE) && echo "${TG}== HOST_INTERFACE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(ip addr | egrep -B2 ${HOST_IPADDR} | egrep '^[0-9]' | awk -F': ' '{ print $$2 }') && echo "${TB}** HOST_INTERFACE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_PORT ?= $(if $(wildcard HOST_PORT),$(shell v=$$(cat HOST_PORT) && echo "${TG}== HOST_PORT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="8123" && echo "${TB}** HOST_PORT unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_THEME ?= $(if $(wildcard HOST_THEME),$(shell v=$$(cat HOST_THEME) && echo "${TG}== HOST_THEME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="default" && echo "${TB}** HOST_THEME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_NETWORK ?= $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK ?= 24

MOTION_ROUTER_NAME ?= $(if $(wildcard MOTION_ROUTER_NAME),$(shell v=$$(cat MOTION_ROUTER_NAME) && echo "${TG}== MOTION_ROUTER_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='mikrotik' && echo "${TB}** MOTION_ROUTER_NAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

HOST_LATITUDE ?= $(if $(wildcard HOST_LATITUDE),$(shell v=$$(cat HOST_LATITUDE) && echo "${TG}== HOST_LATITUDE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "${TB}** HOST_LATITUDE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_LONGITUDE ?= $(if $(wildcard HOST_LONGITUDE),$(shell v=$$(cat HOST_LONGITUDE) && echo "${TG}== HOST_LONGITUDE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "${TB}** HOST_LONGITUDE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# MQTT
MQTT_HOST ?= $(if $(wildcard MQTT_HOST),$(shell v=$$(cat MQTT_HOST) && echo "${TG}== MQTT_HOST: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="$(HOST_IPADDR)" && echo "${TB}** MQTT_HOST unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MQTT_PORT ?= $(if $(wildcard MQTT_PORT),$(shell v=$$(cat MQTT_PORT) && echo "${TG}== MQTT_PORT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="1883" && echo "${TB}** MQTT_PORT unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MQTT_USERNAME ?= $(if $(wildcard MQTT_USERNAME),$(shell v=$$(cat MQTT_USERNAME) && echo "${TG}== MQTT_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** MQTT_USERNAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MQTT_PASSWORD ?= $(if $(wildcard MQTT_PASSWORD),$(shell v=$$(cat MQTT_PASSWORD) && echo "${TG}== MQTT_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${TB}** MQTT_PASSWORD unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MARIADB_PASSWORD ?= $(if $(wildcard MARIADB_PASSWORD),$(shell v=$$(cat MARIADB_PASSWORD) && echo "${TG}== MARIADB_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="HomeAssistant1234" && echo "${TB}** MARIADB_PASSWORD unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MARIADB_HOST ?= $(if $(wildcard MARIADB_HOST),$(shell v=$$(cat MARIADB_HOST) && echo "${TG}== MARIADB_HOST: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="core-mariadb" && echo "${TB}** MARIADB_HOST unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

IPERF_HOST ?= $(if $(wildcard IPERF_HOST),$(shell v=$$(cat IPERF_HOST) && echo "${TG}== IPERF_HOST: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="$(MQTT_HOST)" && echo "${TB}** IPERF_HOST unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

## MOTION
MOTION_GROUP ?= $(if $(wildcard MOTION_GROUP),$(shell v=$$(cat MOTION_GROUP) && echo "${TG}== MOTION_GROUP: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='motion' && echo "${TB}** MOTION_GROUP unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DEVICE ?= $(if $(wildcard MOTION_DEVICE),$(shell v=$$(cat MOTION_DEVICE) && echo "${TG}== MOTION_DEVICE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(echo $(HOST_NAME) | sed -e "s/-//g" -e "s/ /_/g") && echo "${TB}** MOTION_DEVICE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_CLIENT ?= $(if $(wildcard MOTION_CLIENT),$(shell v=$$(cat MOTION_CLIENT) && echo "${TG}== MOTION_CLIENT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='+' && echo "${TB}** MOTION_CLIENT unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_USER ?= $(if $(wildcard MOTION_USER),$(shell v=$$(cat MOTION_USER) && echo "${TG}== MOTION_USER: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$(shell whoami) && echo "${TB}** MOTION_USER unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECT_ENTITY ?= $(if $(wildcard MOTION_DETECT_ENTITY),$(shell v=$$(cat MOTION_DETECT_ENTITY) && echo "${TG}== MOTION_DETECT_ENTITY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='all' && echo "${TB}** MOTION_DETECT_ENTITY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_MEDIA_SAVE ?= $(if $(wildcard MOTION_MEDIA_SAVE),$(shell v=$$(cat MOTION_MEDIA_SAVE) && echo "${TG}== MOTION_MEDIA_SAVE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_MEDIA_SAVE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_MEDIA_MASK ?= $(if $(wildcard MOTION_MEDIA_MASK),$(shell v=$$(cat MOTION_MEDIA_MASK) && echo "${TG}== MOTION_MEDIA_MASK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_MEDIA_MASK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_CAMERA_RESTART ?= $(if $(wildcard MOTION_CAMERA_RESTART),$(shell v=$$(cat MOTION_CAMERA_RESTART) && echo "${TG}== MOTION_CAMERA_RESTART: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_CAMERA_RESTART unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_YOLO_IP ?= $(if $(wildcard MOTION_YOLO_IP),$(shell v=$$(cat MOTION_YOLO_IP) && echo "${TG}== MOTION_YOLO_IP: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='${THIS_HOSTIP}' && echo "${TB}** MOTION_YOLO_IP unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_TWILIO_NAME ?= $(if $(wildcard MOTION_TWILIO_NAME),$(shell v=$$(cat MOTION_TWILIO_NAME) && echo "${TG}== MOTION_TWILIO_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$(HOST_NAME) && echo "${TB}** MOTION_TWILIO_NAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_TWILIO_NUMBER ?= $(if $(wildcard MOTION_TWILIO_NUMBER),$(shell v=$$(cat MOTION_TWILIO_NUMBER) && echo "${TG}== MOTION_TWILIO_NUMBER: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${TB}** MOTION_TWILIO_NUMBER unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_TWILIO_SID ?= $(if $(wildcard MOTION_TWILIO_SID),$(shell v=$$(cat MOTION_TWILIO_SID) && echo "${TG}== MOTION_TWILIO_SID: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${TB}** MOTION_TWILIO_SID unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_TWILIO_TOKEN ?= $(if $(wildcard MOTION_TWILIO_TOKEN),$(shell v=$$(cat MOTION_TWILIO_TOKEN) && echo "${TG}== MOTION_TWILIO_TOKEN: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${TB}** MOTION_TWILIO_TOKEN unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_OVERVIEW_APIKEY ?= $(if $(wildcard MOTION_OVERVIEW_APIKEY),$(shell v=$$(cat MOTION_OVERVIEW_APIKEY) && echo "${TG}== MOTION_OVERVIEW_APIKEY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${TB}** MOTION_OVERVIEW_APIKEY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_MODE ?= $(if $(wildcard MOTION_OVERVIEW_MODE),$(shell v=$$(cat MOTION_OVERVIEW_MODE) && echo "${TG}== MOTION_OVERVIEW_MODE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='local' && echo "${TB}** MOTION_OVERVIEW_MODE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_ZOOM ?= $(if $(wildcard MOTION_OVERVIEW_ZOOM),$(shell v=$$(cat MOTION_OVERVIEW_ZOOM) && echo "${TG}== MOTION_OVERVIEW_ZOOM: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='20' && echo "${TB}** MOTION_OVERVIEW_ZOOM unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_IMAGE ?= $(if $(wildcard MOTION_OVERVIEW_IMAGE),$(shell v=$$(cat MOTION_OVERVIEW_IMAGE) && echo "${TG}== MOTION_OVERVIEW_IMAGE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='overview.jpg' && echo "${TB}** MOTION_OVERVIEW_IMAGE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY_NOTIFY ?= $(if $(wildcard MOTION_DETECTED_ENTITY_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_ENTITY_NOTIFY) && echo "${TG}== MOTION_DETECTED_ENTITY_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_ENTITY_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_NOTIFY ?= $(if $(wildcard MOTION_DETECTED_PERSON_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_PERSON_NOTIFY) && echo "${TG}== MOTION_DETECTED_PERSON_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_PERSON_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_NOTIFY ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_NOTIFY) && echo "${TG}== MOTION_DETECTED_VEHICLE_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_VEHICLE_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_NOTIFY ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_NOTIFY) && echo "${TG}== MOTION_DETECTED_ANIMAL_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_ANIMAL_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY_SPEAK ?= $(if $(wildcard MOTION_DETECTED_ENTITY_SPEAK),$(shell v=$$(cat MOTION_DETECTED_ENTITY_SPEAK) && echo "${TG}== MOTION_DETECTED_ENTITY_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_ENTITY_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_SPEAK ?= $(if $(wildcard MOTION_DETECTED_PERSON_SPEAK),$(shell v=$$(cat MOTION_DETECTED_PERSON_SPEAK) && echo "${TG}== MOTION_DETECTED_PERSON_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_PERSON_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_SPEAK ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_SPEAK),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_SPEAK) && echo "${TG}== MOTION_DETECTED_VEHICLE_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_VEHICLE_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_SPEAK ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_SPEAK),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_SPEAK) && echo "${TG}== MOTION_DETECTED_ANIMAL_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_ANIMAL_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY_TUNE ?= $(if $(wildcard MOTION_DETECTED_ENTITY_TUNE),$(shell v=$$(cat MOTION_DETECTED_ENTITY_TUNE) && echo "${TG}== MOTION_DETECTED_ENTITY_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_ENTITY_TUNE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_TUNE ?= $(if $(wildcard MOTION_DETECTED_PERSON_TUNE),$(shell v=$$(cat MOTION_DETECTED_PERSON_TUNE) && echo "${TG}== MOTION_DETECTED_PERSON_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_PERSON_TUNE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_TUNE ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_TUNE),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_TUNE) && echo "${TG}== MOTION_DETECTED_VEHICLE_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_VEHICLE_TUNE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_TUNE ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_TUNE),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_TUNE) && echo "${TG}== MOTION_DETECTED_ANIMAL_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_ANIMAL_TUNE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_ENTITY_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_ENTITY_DEVIATION) && echo "${TG}== MOTION_DETECTED_ENTITY_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_ENTITY_DEVIATION unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_PERSON_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_PERSON_DEVIATION) && echo "${TG}== MOTION_DETECTED_PERSON_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_PERSON_DEVIATION unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_DEVIATION) && echo "${TG}== MOTION_DETECTED_VEHICLE_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_VEHICLE_DEVIATION unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_DEVIATION) && echo "${TG}== MOTION_DETECTED_ANIMAL_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_ANIMAL_DEVIATION unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# ago
MOTION_EXPIRE_AFTER ?= $(if $(wildcard MOTION_EXPIRE_AFTER),$(shell v=$$(cat MOTION_EXPIRE_AFTER) && echo "${TG}== MOTION_EXPIRE_AFTER: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='60' && echo "${TB}** MOTION_EXPIRE_AFTER unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_FORCE_UPDATE ?= $(if $(wildcard MOTION_FORCE_UPDATE),$(shell v=$$(cat MOTION_FORCE_UPDATE) && echo "${TG}== MOTION_FORCE_UPDATE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_FORCE_UPDATE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_ANNOTATED_AGO ?= $(if $(wildcard MOTION_ANNOTATED_AGO),$(shell v=$$(cat MOTION_ANNOTATED_AGO) && echo "${TG}== MOTION_ANNOTATED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_ANNOTATED_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_AGO ?= $(if $(wildcard MOTION_DETECTED_AGO),$(shell v=$$(cat MOTION_DETECTED_AGO) && echo "${TG}== MOTION_DETECTED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_DETECTED_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ENTITY_AGO ?= $(if $(wildcard MOTION_DETECTED_ENTITY_AGO),$(shell v=$$(cat MOTION_DETECTED_ENTITY_AGO) && echo "${TG}== MOTION_DETECTED_ENTITY_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_DETECTED_ENTITY_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY_AGO ?= $(if $(wildcard MOTION_DETECTED_ENTITY_AGO),$(shell v=$$(cat MOTION_DETECTED_ENTITY_AGO) && echo "${TG}== MOTION_DETECTED_ENTITY_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='300' && echo "${TB}** MOTION_DETECTED_ENTITY_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_AGO ?= $(if $(wildcard MOTION_DETECTED_PERSON_AGO),$(shell v=$$(cat MOTION_DETECTED_PERSON_AGO) && echo "${TG}== MOTION_DETECTED_PERSON_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='300' && echo "${TB}** MOTION_DETECTED_PERSON_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_AGO ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_AGO),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_AGO) && echo "${TG}== MOTION_DETECTED_VEHICLE_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_DETECTED_VEHICLE_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_AGO ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_AGO),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_AGO) && echo "${TG}== MOTION_DETECTED_ANIMAL_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_DETECTED_ANIMAL_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# webcam
NETCAM_USERNAME ?= $(if $(wildcard NETCAM_USERNAME),$(shell v=$$(cat NETCAM_USERNAME) && echo "${TG}== NETCAM_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** NETCAM_USERNAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
NETCAM_PASSWORD ?= $(if $(wildcard NETCAM_PASSWORD),$(shell v=$$(cat NETCAM_PASSWORD) && echo "${TG}== NETCAM_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${TB}** NETCAM_PASSWORD unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTIONCAM_USERNAME ?= $(if $(wildcard MOTIONCAM_USERNAME),$(shell v=$$(cat MOTIONCAM_USERNAME) && echo "${TG}== MOTIONCAM_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** MOTIONCAM_USERNAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTIONCAM_PASSWORD ?= $(if $(wildcard MOTIONCAM_PASSWORD),$(shell v=$$(cat MOTIONCAM_PASSWORD) && echo "${TG}== MOTIONCAM_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${TB}** MOTIONCAM_PASSWORD unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# netdata
NETDATA_URL ?= $(if $(wildcard NETDATA_URL),$(shell v=$$(cat NETDATA_URL) && echo "${TG}== NETDATA_URL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:19999/" && echo "${TB}** NETDATA_URL unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# jupyter
JUPYTER_URL ?= $(if $(wildcard JUPYTER_URL),$(shell v=$$(cat JUPYTER_URL) && echo "${TG}== JUPYTER_URL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:7777/" && echo "${TB}** JUPYTER_URL unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# tplink
TPLINK_DISCOVERY ?= $(if $(wildcard TPLINK_DISCOVERY),$(shell v=$$(cat TPLINK_DISCOVERY) && echo "${TG}== TPLINK_DISCOVERY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** TPLINK_DISCOVERY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# influxdb
INFLUXDB_HOST ?= $(if $(wildcard INFLUXDB_HOST),$(shell v=$$(cat INFLUXDB_HOST) && echo "${TG}== INFLUXDB_HOST: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='a0d7b954-influxdb' && echo "${TB}** INFLUXDB_HOST unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
INFLUXDB_DATABASE ?= $(if $(wildcard INFLUXDB_DATABASE),$(shell v=$$(cat INFLUXDB_DATABASE) && echo "${TG}== INFLUXDB_DATABASE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='$(HOST_NAME)' && echo "${TB}** INFLUXDB_DATABASE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
INFLUXDB_USERNAME ?= $(if $(wildcard INFLUXDB_USERNAME),$(shell v=$$(cat INFLUXDB_USERNAME) && echo "${TG}== INFLUXDB_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='homeassistant' && echo "${TB}** INFLUXDB_USERNAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
INFLUXDB_PASSWORD ?= $(if $(wildcard INFLUXDB_PASSWORD),$(shell v=$$(cat INFLUXDB_PASSWORD) && echo "${TG}== INFLUXDB_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='homeassistant' && echo "${TB}** INFLUXDB_PASSWORD unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# scan interval for speedtest
# scan interval for speedtest
INTERNET_SCAN_INTERVAL ?= $(if $(wildcard INTERNET_SCAN_INTERVAL),$(shell v=$$(cat INTERNET_SCAN_INTERVAL) && echo "${TG}== INTERNET_SCAN_INTERVAL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="14400" && echo "${TB}** INTERNET_SCAN_INTERVAL unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
INTRANET_SCAN_INTERVAL ?= $(if $(wildcard INTRANET_SCAN_INTERVAL),$(shell v=$$(cat INTRANET_SCAN_INTERVAL) && echo "${TG}== INTRANET_SCAN_INTERVAL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="1800" && echo "${TB}** INTRANET_SCAN_INTERVAL unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

###
### TARGETS
###

MEDIA := media/Motion-Ã👁/ homeassistant/www/images/motion/

ACTIONS := all run stop logs restart refresh tidy neat clean realclean distclean

default: necessary all

necessary: homeassistant/setup.json ${MEDIA}

${MEDIA}:
	@echo "${MC}Making: MEDIA $@${NC}"
	@-if [ ! -e $@ ]; then sudo mkdir -p $@; fi

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
	  LOGGER_MQTT="$(LOGGER_MQTT)" \
	  LOGGER_AUTOMATION="$(LOGGER_AUTOMATION)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
	  MOTION_USER="$(MOTION_USER)" \
	  MOTION_ROUTER_NAME="$(MOTION_ROUTER_NAME)" \
	  MOTION_DETECT_ENTITY="$(MOTION_DETECT_ENTITY)" \
	  MOTION_EXPIRE_AFTER="$(MOTION_EXPIRE_AFTER)" \
	  MOTION_FORCE_UPDATE="$(MOTION_FORCE_UPDATE)" \
	  MOTION_MEDIA_SAVE="$(MOTION_MEDIA_SAVE)" \
	  MOTION_MEDIA_MASK="$(MOTION_MEDIA_MASK)" \
	  MOTION_CAMERA_RESTART="$(MOTION_CAMERA_RESTART)" \
	  MOTION_YOLO_IP="$(MOTION_YOLO_IP)" \
	  MOTION_TWILIO_NAME="$(MOTION_TWILIO_NAME)" \
	  MOTION_TWILIO_NUMBER="$(MOTION_TWILIO_NUMBER)" \
	  MOTION_TWILIO_SID="$(MOTION_TWILIO_SID)" \
	  MOTION_TWILIO_TOKEN="$(MOTION_TWILIO_TOKEN)" \
	  MOTION_OVERVIEW_APIKEY="$(MOTION_OVERVIEW_APIKEY)" \
	  MOTION_OVERVIEW_MODE="$(MOTION_OVERVIEW_MODE)" \
	  MOTION_OVERVIEW_ZOOM="$(MOTION_OVERVIEW_ZOOM)" \
	  MOTION_OVERVIEW_IMAGE="$(MOTION_OVERVIEW_IMAGE)" \
	  MOTION_ANNOTATED_AGO="$(MOTION_ANNOTATED_AGO)" \
	  MOTION_DETECTED_AGO="$(MOTION_DETECTED_AGO)" \
	  MOTION_DETECTED_ENTITY_AGO="$(MOTION_DETECTED_ENTITY_AGO)" \
	  MOTION_DETECTED_PERSON_AGO="$(MOTION_DETECTED_PERSON_AGO)" \
	  MOTION_DETECTED_VEHICLE_AGO="$(MOTION_DETECTED_VEHICLE_AGO)" \
	  MOTION_DETECTED_ANIMAL_AGO="$(MOTION_DETECTED_ANIMAL_AGO)" \
	  MOTION_DETECTED_ENTITY_NOTIFY="$(MOTION_DETECTED_ENTITY_NOTIFY)" \
	  MOTION_DETECTED_PERSON_NOTIFY="$(MOTION_DETECTED_PERSON_NOTIFY)" \
	  MOTION_DETECTED_VEHICLE_NOTIFY="$(MOTION_DETECTED_VEHICLE_NOTIFY)" \
	  MOTION_DETECTED_ANIMAL_NOTIFY="$(MOTION_DETECTED_ANIMAL_NOTIFY)" \
	  MOTION_DETECTED_ENTITY_SPEAK="$(MOTION_DETECTED_ENTITY_SPEAK)" \
	  MOTION_DETECTED_PERSON_SPEAK="$(MOTION_DETECTED_PERSON_SPEAK)" \
	  MOTION_DETECTED_VEHICLE_SPEAK="$(MOTION_DETECTED_VEHICLE_SPEAK)" \
	  MOTION_DETECTED_ANIMAL_SPEAK="$(MOTION_DETECTED_ANIMAL_SPEAK)" \
	  MOTION_DETECTED_ENTITY_TUNE="$(MOTION_DETECTED_ENTITY_TUNE)" \
	  MOTION_DETECTED_PERSON_TUNE="$(MOTION_DETECTED_PERSON_TUNE)" \
	  MOTION_DETECTED_VEHICLE_TUNE="$(MOTION_DETECTED_VEHICLE_TUNE)" \
	  MOTION_DETECTED_ANIMAL_TUNE="$(MOTION_DETECTED_ANIMAL_TUNE)" \
	  MOTION_DETECTED_ENTITY_DEVIATION="$(MOTION_DETECTED_ENTITY_DEVIATION)" \
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


homeassistant/setup.json: setup.json.tmpl
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
	  LOGGER_MQTT="$(LOGGER_MQTT)" \
	  LOGGER_AUTOMATION="$(LOGGER_AUTOMATION)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
	  MOTION_USER="$(MOTION_USER)" \
	  MOTION_ROUTER_NAME="$(MOTION_ROUTER_NAME)" \
	  MOTION_DETECT_ENTITY="$(MOTION_DETECT_ENTITY)" \
	  MOTION_EXPIRE_AFTER="$(MOTION_EXPIRE_AFTER)" \
	  MOTION_FORCE_UPDATE="$(MOTION_FORCE_UPDATE)" \
	  MOTION_MEDIA_SAVE="$(MOTION_MEDIA_SAVE)" \
	  MOTION_MEDIA_MASK="$(MOTION_MEDIA_MASK)" \
	  MOTION_CAMERA_RESTART="$(MOTION_CAMERA_RESTART)" \
	  MOTION_YOLO_IP="$(MOTION_YOLO_IP)" \
	  MOTION_TWILIO_NAME="$(MOTION_TWILIO_NAME)" \
	  MOTION_TWILIO_NUMBER="$(MOTION_TWILIO_NUMBER)" \
	  MOTION_TWILIO_SID="$(MOTION_TWILIO_SID)" \
	  MOTION_TWILIO_TOKEN="$(MOTION_TWILIO_TOKEN)" \
	  MOTION_OVERVIEW_APIKEY="$(MOTION_OVERVIEW_APIKEY)" \
	  MOTION_OVERVIEW_MODE="$(MOTION_OVERVIEW_MODE)" \
	  MOTION_OVERVIEW_ZOOM="$(MOTION_OVERVIEW_ZOOM)" \
	  MOTION_OVERVIEW_IMAGE="$(MOTION_OVERVIEW_IMAGE)" \
	  MOTION_ANNOTATED_AGO="$(MOTION_ANNOTATED_AGO)" \
	  MOTION_DETECTED_AGO="$(MOTION_DETECTED_AGO)" \
	  MOTION_DETECTED_ENTITY_AGO="$(MOTION_DETECTED_ENTITY_AGO)" \
	  MOTION_DETECTED_PERSON_AGO="$(MOTION_DETECTED_PERSON_AGO)" \
	  MOTION_DETECTED_VEHICLE_AGO="$(MOTION_DETECTED_VEHICLE_AGO)" \
	  MOTION_DETECTED_ANIMAL_AGO="$(MOTION_DETECTED_ANIMAL_AGO)" \
	  MOTION_DETECTED_ENTITY_NOTIFY="$(MOTION_DETECTED_ENTITY_NOTIFY)" \
	  MOTION_DETECTED_PERSON_NOTIFY="$(MOTION_DETECTED_PERSON_NOTIFY)" \
	  MOTION_DETECTED_VEHICLE_NOTIFY="$(MOTION_DETECTED_VEHICLE_NOTIFY)" \
	  MOTION_DETECTED_ANIMAL_NOTIFY="$(MOTION_DETECTED_ANIMAL_NOTIFY)" \
	  MOTION_DETECTED_ENTITY_SPEAK="$(MOTION_DETECTED_ENTITY_SPEAK)" \
	  MOTION_DETECTED_PERSON_SPEAK="$(MOTION_DETECTED_PERSON_SPEAK)" \
	  MOTION_DETECTED_VEHICLE_SPEAK="$(MOTION_DETECTED_VEHICLE_SPEAK)" \
	  MOTION_DETECTED_ANIMAL_SPEAK="$(MOTION_DETECTED_ANIMAL_SPEAK)" \
	  MOTION_DETECTED_ENTITY_TUNE="$(MOTION_DETECTED_ENTITY_TUNE)" \
	  MOTION_DETECTED_PERSON_TUNE="$(MOTION_DETECTED_PERSON_TUNE)" \
	  MOTION_DETECTED_VEHICLE_TUNE="$(MOTION_DETECTED_VEHICLE_TUNE)" \
	  MOTION_DETECTED_ANIMAL_TUNE="$(MOTION_DETECTED_ANIMAL_TUNE)" \
	  MOTION_DETECTED_ENTITY_DEVIATION="$(MOTION_DETECTED_ENTITY_DEVIATION)" \
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
	&& cat $< | envsubst > $@

.PHONY: ${MEDIA} necessary all default run stop logs restart tidy clean realclean distclean $(PACKAGES) homeassistant/motion/webcams.json

##
## COLORS
##
MC=${LIGHT_CYAN}
DF=${YELLOW}
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
