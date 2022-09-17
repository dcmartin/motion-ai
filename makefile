###
### makefile
###

TIMESTAMP := $(shell date -u +'%FT%TZ')
THIS_HOSTIP := $(shell hostname -I | awk '{ print $$1 }')

# repository
MOTION_REPOSITORY ?= $(if $(wildcard MOTION_REPOSITORY),$(shell v=$$(cat MOTION_REPOSITORY) && echo "${TG}== MOTION_REPOSITORY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='http://github.com/motion-ai/motion-ai.git' && echo "${DF}** MOTION_REPOSITORY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

UPTIMEROBOT_RSSURL ?= $(if $(wildcard UPTIMEROBOT_RSSURL),$(shell v=$$(cat UPTIMEROBOT_RSSURL) && echo "${TG}== UPTIMEROBOT_RSSURL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='https://rss.uptimerobot.com/status' && echo "${DF}** UPTIMEROBOT_RSSURL${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# logging
LOGGER_DEFAULT ?= $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "${TG}== LOGGER_DEFAULT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="error" && echo "${DF}** LOGGER_DEFAULT${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
LOGGER_MQTT ?= $(if $(wildcard LOGGER_MQTT),$(shell v=$$(cat LOGGER_MQTT) && echo "${TG}== LOGGER_MQTT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="fatal" && echo "${DF}** LOGGER_MQTT${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
LOGGER_AUTOMATION ?= $(if $(wildcard LOGGER_AUTOMATION),$(shell v=$$(cat LOGGER_AUTOMATION) && echo "${TG}== LOGGER_AUTOMATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "${DF}** LOGGER_AUTOMATION${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_LOG_LEVEL ?= $(if $(wildcard MOTION_LOG_LEVEL),$(shell v=$$(cat MOTION_LOG_LEVEL) && echo "${TG}== MOTION_LOG_LEVEL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="info" && echo "${DF}** MOTION_LOG_LEVEL${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# domain
DOMAIN_NAME ?= $(if $(wildcard DOMAIN_NAME),$(shell v=$$(cat DOMAIN_NAME) && echo "${TG}== DOMAIN_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -d) && v=$${v:-local} && echo "${DF}** DOMAIN_NAME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# host
HOST_NAME ?= $(if $(wildcard HOST_NAME),$(shell v=$$(cat HOST_NAME) && echo "${TG}== HOST_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -s) && v=$${v%%.*} && echo "${DF}** HOST_NAME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_TIMEZONE ?= $(if $(wildcard HOST_TIMEZONE),$(shell v=$$(cat HOST_TIMEZONE) && echo "${TG}== HOST_TIMEZONE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(cat /etc/timezone) && echo "${DF}** HOST_TIMEZONE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_IPADDR ?= $(if $(wildcard HOST_IPADDR),$(shell v=$$(cat HOST_IPADDR) && echo "${TG}== HOST_IPADDR: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=${THIS_HOSTIP} && echo "${DF}** HOST_IPADDR${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_INTERFACE ?= $(if $(wildcard HOST_INTERFACE),$(shell v=$$(cat HOST_INTERFACE) && echo "${TG}== HOST_INTERFACE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(ip addr | egrep -B2 ${HOST_IPADDR} | egrep '^[0-9]' | awk -F': ' '{ print $$2 }') && echo "${DF}** HOST_INTERFACE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_PORT ?= $(if $(wildcard HOST_PORT),$(shell v=$$(cat HOST_PORT) && echo "${TG}== HOST_PORT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="80" && echo "${DF}** HOST_PORT${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_THEME ?= $(if $(wildcard HOST_THEME),$(shell v=$$(cat HOST_THEME) && echo "${TG}== HOST_THEME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="default" && echo "${DF}** HOST_THEME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_NETWORK ?= $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK ?= 24

MOTION_NOTIFY_SMARTPHONE ?= $(if $(wildcard MOTION_NOTIFY_SMARTPHONE),$(shell v=$$(cat MOTION_NOTIFY_SMARTPHONE) && echo "${TG}== MOTION_NOTIFY_SMARTPHONE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_NOTIFY_SMARTPHONE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_ROUTER_NAME ?= $(if $(wildcard MOTION_ROUTER_NAME),$(shell v=$$(cat MOTION_ROUTER_NAME) && echo "${TG}== MOTION_ROUTER_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='mikrotik_router' && echo "${DF}** MOTION_ROUTER_NAME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

HOST_LATITUDE ?= $(if $(wildcard HOST_LATITUDE),$(shell v=$$(cat HOST_LATITUDE) && echo "${TG}== HOST_LATITUDE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "${DF}** HOST_LATITUDE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
HOST_LONGITUDE ?= $(if $(wildcard HOST_LONGITUDE),$(shell v=$$(cat HOST_LONGITUDE) && echo "${TG}== HOST_LONGITUDE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "${DF}** HOST_LONGITUDE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# MQTT
MQTT_HOST ?= $(if $(wildcard MQTT_HOST),$(shell v=$$(cat MQTT_HOST) && echo "${TG}== MQTT_HOST: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="$(HOST_IPADDR)" && echo "${DF}** MQTT_HOST${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MQTT_PORT ?= $(if $(wildcard MQTT_PORT),$(shell v=$$(cat MQTT_PORT) && echo "${TG}== MQTT_PORT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="1883" && echo "${DF}** MQTT_PORT${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MQTT_USERNAME ?= $(if $(wildcard MQTT_USERNAME),$(shell v=$$(cat MQTT_USERNAME) && echo "${TG}== MQTT_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${DF}** MQTT_USERNAME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MQTT_PASSWORD ?= $(if $(wildcard MQTT_PASSWORD),$(shell v=$$(cat MQTT_PASSWORD) && echo "${TG}== MQTT_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${DF}** MQTT_PASSWORD${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MARIADB_PASSWORD ?= $(if $(wildcard MARIADB_PASSWORD),$(shell v=$$(cat MARIADB_PASSWORD) && echo "${TG}== MARIADB_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="HomeAssistant1234" && echo "${DF}** MARIADB_PASSWORD${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MARIADB_HOST ?= $(if $(wildcard MARIADB_HOST),$(shell v=$$(cat MARIADB_HOST) && echo "${TG}== MARIADB_HOST: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="core-mariadb" && echo "${DF}** MARIADB_HOST${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

IPERF_HOST ?= $(if $(wildcard IPERF_HOST),$(shell v=$$(cat IPERF_HOST) && echo "${TG}== IPERF_HOST: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="127.0.0.1" && echo "${DF}** IPERF_HOST${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

## MOTION
MOTION_SITE ?= $(if $(wildcard MOTION_SITE),$(shell v=$$(cat MOTION_SITE) && echo "${TG}== MOTION_SITE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=${HOST_NAME} && echo "${DF}** MOTION_SITE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_APP ?= $(if $(wildcard MOTION_APP),$(shell v=$$(cat MOTION_APP) && echo "${TG}== MOTION_APP: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='Motion Ã👁' && echo "${DF}** MOTION_APP${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_GROUP ?= $(if $(wildcard MOTION_GROUP),$(shell v=$$(cat MOTION_GROUP) && echo "${TG}== MOTION_GROUP: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='motion' && echo "${DF}** MOTION_GROUP${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DEVICE ?= $(if $(wildcard MOTION_DEVICE),$(shell v=$$(cat MOTION_DEVICE) && echo "${TG}== MOTION_DEVICE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(echo $(HOST_NAME) | sed -e "s/-//g" -e "s/ /_/g") && echo "${DF}** MOTION_DEVICE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_CLIENT ?= $(if $(wildcard MOTION_CLIENT),$(shell v=$$(cat MOTION_CLIENT) && echo "${TG}== MOTION_CLIENT: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='$(MOTION_DEVICE)' && echo "${DF}** MOTION_CLIENT${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_USER ?= $(if $(wildcard MOTION_USER),$(shell v=$$(cat MOTION_USER) && echo "${TG}== MOTION_USER: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_USER${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_PRIMARY ?= $(if $(wildcard MOTION_PRIMARY),$(shell v=$$(cat MOTION_PRIMARY) && echo "${TG}== MOTION_PRIMARY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_PRIMARY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_SECONDARY ?= $(if $(wildcard MOTION_SECONDARY),$(shell v=$$(cat MOTION_SECONDARY) && echo "${TG}== MOTION_SECONDARY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_SECONDARY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_TERTIARY ?= $(if $(wildcard MOTION_TERTIARY),$(shell v=$$(cat MOTION_TERTIARY) && echo "${TG}== MOTION_TERTIARY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_TERTIARY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_USER_DEVICE ?= $(if $(wildcard MOTION_USER_DEVICE),$(shell v=$$(cat MOTION_USER_DEVICE) && echo "${TG}== MOTION_USER_DEVICE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_USER_DEVICE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_PRIMARY_DEVICE ?= $(if $(wildcard MOTION_PRIMARY_DEVICE),$(shell v=$$(cat MOTION_PRIMARY_DEVICE) && echo "${TG}== MOTION_PRIMARY_DEVICE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_PRIMARY_DEVICE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_SECONDARY_DEVICE ?= $(if $(wildcard MOTION_SECONDARY_DEVICE),$(shell v=$$(cat MOTION_SECONDARY_DEVICE) && echo "${TG}== MOTION_SECONDARY_DEVICE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_SECONDARY_DEVICE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_TERTIARY_DEVICE ?= $(if $(wildcard MOTION_TERTIARY_DEVICE),$(shell v=$$(cat MOTION_TERTIARY_DEVICE) && echo "${TG}== MOTION_TERTIARY_DEVICE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_TERTIARY_DEVICE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECT_ENTITY ?= $(if $(wildcard MOTION_DETECT_ENTITY),$(shell v=$$(cat MOTION_DETECT_ENTITY) && echo "${TG}== MOTION_DETECT_ENTITY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_DETECT_ENTITY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_MEDIA_SAVE ?= $(if $(wildcard MOTION_MEDIA_SAVE),$(shell v=$$(cat MOTION_MEDIA_SAVE) && echo "${TG}== MOTION_MEDIA_SAVE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_MEDIA_SAVE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_MEDIA_MASK ?= $(if $(wildcard MOTION_MEDIA_MASK),$(shell v=$$(cat MOTION_MEDIA_MASK) && echo "${TG}== MOTION_MEDIA_MASK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_MEDIA_MASK${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_CAMERA_RESTART ?= $(if $(wildcard MOTION_CAMERA_RESTART),$(shell v=$$(cat MOTION_CAMERA_RESTART) && echo "${TG}== MOTION_CAMERA_RESTART: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_CAMERA_RESTART${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_CAMERA_ANY ?= $(if $(wildcard MOTION_CAMERA_ANY),$(shell v=$$(cat MOTION_CAMERA_ANY) && echo "${TG}== MOTION_CAMERA_ANY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_CAMERA_ANY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_YOLO_IP ?= $(if $(wildcard MOTION_YOLO_IP),$(shell v=$$(cat MOTION_YOLO_IP) && echo "${TG}== MOTION_YOLO_IP: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='${THIS_HOSTIP}' && echo "${DF}** MOTION_YOLO_IP${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_YOLO_CONFIG ?= $(if $(wildcard MOTION_YOLO_CONFIG),$(shell v=$$(cat MOTION_YOLO_CONFIG) && echo "${TG}== MOTION_YOLO_CONFIG: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='tiny-v2' && echo "${DF}** MOTION_YOLO_CONFIG${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_TWILIO_NAME ?= $(if $(wildcard MOTION_TWILIO_NAME),$(shell v=$$(cat MOTION_TWILIO_NAME) && echo "${TG}== MOTION_TWILIO_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$(HOST_NAME) && echo "${DF}** MOTION_TWILIO_NAME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_TWILIO_NUMBER ?= $(if $(wildcard MOTION_TWILIO_NUMBER),$(shell v=$$(cat MOTION_TWILIO_NUMBER) && echo "${TG}== MOTION_TWILIO_NUMBER: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_TWILIO_NUMBER${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_TWILIO_SID ?= $(if $(wildcard MOTION_TWILIO_SID),$(shell v=$$(cat MOTION_TWILIO_SID) && echo "${TG}== MOTION_TWILIO_SID: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_TWILIO_SID${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_TWILIO_TOKEN ?= $(if $(wildcard MOTION_TWILIO_TOKEN),$(shell v=$$(cat MOTION_TWILIO_TOKEN) && echo "${TG}== MOTION_TWILIO_TOKEN: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_TWILIO_TOKEN${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_W3W_APIKEY ?= $(if $(wildcard MOTION_W3W_APIKEY),$(shell v=$$(cat MOTION_W3W_APIKEY) && echo "${TG}== MOTION_W3W_APIKEY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_W3W_APIKEY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_W3W_WORDS ?= $(if $(wildcard MOTION_W3W_WORDS),$(shell v=$$(cat MOTION_W3W_WORDS) && echo "${TG}== MOTION_W3W_WORDS: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='///what.three.words' && echo "${DF}** MOTION_W3W_WORDS${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_OVERVIEW_APIKEY ?= $(if $(wildcard MOTION_OVERVIEW_APIKEY),$(shell v=$$(cat MOTION_OVERVIEW_APIKEY) && echo "${TG}== MOTION_OVERVIEW_APIKEY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${DF}** MOTION_OVERVIEW_APIKEY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_MODE ?= $(if $(wildcard MOTION_OVERVIEW_MODE),$(shell v=$$(cat MOTION_OVERVIEW_MODE) && echo "${TG}== MOTION_OVERVIEW_MODE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='local' && echo "${DF}** MOTION_OVERVIEW_MODE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_ZOOM ?= $(if $(wildcard MOTION_OVERVIEW_ZOOM),$(shell v=$$(cat MOTION_OVERVIEW_ZOOM) && echo "${TG}== MOTION_OVERVIEW_ZOOM: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='20' && echo "${DF}** MOTION_OVERVIEW_ZOOM${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_OVERVIEW_IMAGE ?= $(if $(wildcard MOTION_OVERVIEW_IMAGE),$(shell v=$$(cat MOTION_OVERVIEW_IMAGE) && echo "${TG}== MOTION_OVERVIEW_IMAGE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='overview.jpg' && echo "${DF}** MOTION_OVERVIEW_IMAGE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY ?= $(if $(wildcard MOTION_DETECTED_ENTITY),$(shell v=$$(cat MOTION_DETECTED_ENTITY) && echo "${TG}== MOTION_DETECTED_ENTITY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='all' && echo "${DF}** MOTION_DETECTED_ENTITY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ENTITY_NOTIFY ?= $(if $(wildcard MOTION_DETECTED_ENTITY_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_ENTITY_NOTIFY) && echo "${TG}== MOTION_DETECTED_ENTITY_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_DETECTED_ENTITY_NOTIFY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_NOTIFY ?= $(if $(wildcard MOTION_DETECTED_PERSON_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_PERSON_NOTIFY) && echo "${TG}== MOTION_DETECTED_PERSON_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_DETECTED_PERSON_NOTIFY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_NOTIFY ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_NOTIFY) && echo "${TG}== MOTION_DETECTED_VEHICLE_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_DETECTED_VEHICLE_NOTIFY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_NOTIFY ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_NOTIFY) && echo "${TG}== MOTION_DETECTED_ANIMAL_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_DETECTED_ANIMAL_NOTIFY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_FACE_DETECTED_NOTIFY ?= $(if $(wildcard MOTION_FACE_DETECTED_NOTIFY),$(shell v=$$(cat MOTION_FACE_DETECTED_NOTIFY) && echo "${TG}== MOTION_FACE_DETECTED_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_FACE_DETECTED_NOTIFY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_ALPR_DETECTED_NOTIFY ?= $(if $(wildcard MOTION_ALPR_DETECTED_NOTIFY),$(shell v=$$(cat MOTION_ALPR_DETECTED_NOTIFY) && echo "${TG}== MOTION_ALPR_DETECTED_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_ALPR_DETECTED_NOTIFY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_POSE_DETECTED_NOTIFY ?= $(if $(wildcard MOTION_POSE_DETECTED_NOTIFY),$(shell v=$$(cat MOTION_POSE_DETECTED_NOTIFY) && echo "${TG}== MOTION_POSE_DETECTED_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_POSE_DETECTED_NOTIFY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_ALPR_DETECTED ?= $(if $(wildcard MOTION_ALPR_DETECTED),$(shell v=$$(cat MOTION_ALPR_DETECTED) && echo "${TG}== MOTION_ALPR_DETECTED: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_ALPR_DETECTED${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_POSE_DETECTED ?= $(if $(wildcard MOTION_POSE_DETECTED),$(shell v=$$(cat MOTION_POSE_DETECTED) && echo "${TG}== MOTION_POSE_DETECTED: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_POSE_DETECTED${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY_SPEAK ?= $(if $(wildcard MOTION_DETECTED_ENTITY_SPEAK),$(shell v=$$(cat MOTION_DETECTED_ENTITY_SPEAK) && echo "${TG}== MOTION_DETECTED_ENTITY_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_DETECTED_ENTITY_SPEAK${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_SPEAK ?= $(if $(wildcard MOTION_DETECTED_PERSON_SPEAK),$(shell v=$$(cat MOTION_DETECTED_PERSON_SPEAK) && echo "${TG}== MOTION_DETECTED_PERSON_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_DETECTED_PERSON_SPEAK${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_SPEAK ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_SPEAK),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_SPEAK) && echo "${TG}== MOTION_DETECTED_VEHICLE_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_DETECTED_VEHICLE_SPEAK${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_SPEAK ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_SPEAK),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_SPEAK) && echo "${TG}== MOTION_DETECTED_ANIMAL_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_DETECTED_ANIMAL_SPEAK${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_FACE_DETECTED_SPEAK ?= $(if $(wildcard MOTION_FACE_DETECTED_SPEAK),$(shell v=$$(cat MOTION_FACE_DETECTED_SPEAK) && echo "${TG}== MOTION_FACE_DETECTED_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_FACE_DETECTED_SPEAK${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_ALPR_DETECTED_SPEAK ?= $(if $(wildcard MOTION_ALPR_DETECTED_SPEAK),$(shell v=$$(cat MOTION_ALPR_DETECTED_SPEAK) && echo "${TG}== MOTION_ALPR_DETECTED_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_ALPR_DETECTED_SPEAK${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_POSE_DETECTED_SPEAK ?= $(if $(wildcard MOTION_POSE_DETECTED_SPEAK),$(shell v=$$(cat MOTION_POSE_DETECTED_SPEAK) && echo "${TG}== MOTION_POSE_DETECTED_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_POSE_DETECTED_SPEAK${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY_TUNE ?= $(if $(wildcard MOTION_DETECTED_ENTITY_TUNE),$(shell v=$$(cat MOTION_DETECTED_ENTITY_TUNE) && echo "${TG}== MOTION_DETECTED_ENTITY_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_DETECTED_ENTITY_TUNE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_TUNE ?= $(if $(wildcard MOTION_DETECTED_PERSON_TUNE),$(shell v=$$(cat MOTION_DETECTED_PERSON_TUNE) && echo "${TG}== MOTION_DETECTED_PERSON_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_DETECTED_PERSON_TUNE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_TUNE ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_TUNE),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_TUNE) && echo "${TG}== MOTION_DETECTED_VEHICLE_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_DETECTED_VEHICLE_TUNE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_TUNE ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_TUNE),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_TUNE) && echo "${TG}== MOTION_DETECTED_ANIMAL_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_DETECTED_ANIMAL_TUNE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_FACE_DETECTED_TUNE ?= $(if $(wildcard MOTION_FACE_DETECTED_TUNE),$(shell v=$$(cat MOTION_FACE_DETECTED_TUNE) && echo "${TG}== MOTION_FACE_DETECTED_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_FACE_DETECTED_TUNE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_ALPR_DETECTED_TUNE ?= $(if $(wildcard MOTION_ALPR_DETECTED_TUNE),$(shell v=$$(cat MOTION_ALPR_DETECTED_TUNE) && echo "${TG}== MOTION_ALPR_DETECTED_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_ALPR_DETECTED_TUNE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_POSE_DETECTED_TUNE ?= $(if $(wildcard MOTION_POSE_DETECTED_TUNE),$(shell v=$$(cat MOTION_POSE_DETECTED_TUNE) && echo "${TG}== MOTION_POSE_DETECTED_TUNE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** MOTION_POSE_DETECTED_TUNE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_ENTITY_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_ENTITY_DEVIATION) && echo "${TG}== MOTION_DETECTED_ENTITY_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${DF}** MOTION_DETECTED_ENTITY_DEVIATION${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_PERSON_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_PERSON_DEVIATION) && echo "${TG}== MOTION_DETECTED_PERSON_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${DF}** MOTION_DETECTED_PERSON_DEVIATION${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_DEVIATION) && echo "${TG}== MOTION_DETECTED_VEHICLE_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${DF}** MOTION_DETECTED_VEHICLE_DEVIATION${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_DEVIATION ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_DEVIATION) && echo "${TG}== MOTION_DETECTED_ANIMAL_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${DF}** MOTION_DETECTED_ANIMAL_DEVIATION${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_FACE_DETECTED_DEVIATION ?= $(if $(wildcard MOTION_FACE_DETECTED_DEVIATION),$(shell v=$$(cat MOTION_FACE_DETECTED_DEVIATION) && echo "${TG}== MOTION_FACE_DETECTED_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${DF}** MOTION_FACE_DETECTED_DEVIATION${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_ALPR_DETECTED_DEVIATION ?= $(if $(wildcard MOTION_ALPR_DETECTED_DEVIATION),$(shell v=$$(cat MOTION_ALPR_DETECTED_DEVIATION) && echo "${TG}== MOTION_ALPR_DETECTED_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${DF}** MOTION_ALPR_DETECTED_DEVIATION${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_POSE_DETECTED_DEVIATION ?= $(if $(wildcard MOTION_POSE_DETECTED_DEVIATION),$(shell v=$$(cat MOTION_POSE_DETECTED_DEVIATION) && echo "${TG}== MOTION_POSE_DETECTED_DEVIATION: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${DF}** MOTION_POSE_DETECTED_DEVIATION${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_DETECTED_ENTITY_AGO ?= $(if $(wildcard MOTION_DETECTED_ENTITY_AGO),$(shell v=$$(cat MOTION_DETECTED_ENTITY_AGO) && echo "${TG}== MOTION_DETECTED_ENTITY_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_DETECTED_ENTITY_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_PERSON_AGO ?= $(if $(wildcard MOTION_DETECTED_PERSON_AGO),$(shell v=$$(cat MOTION_DETECTED_PERSON_AGO) && echo "${TG}== MOTION_DETECTED_PERSON_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_DETECTED_PERSON_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_VEHICLE_AGO ?= $(if $(wildcard MOTION_DETECTED_VEHICLE_AGO),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_AGO) && echo "${TG}== MOTION_DETECTED_VEHICLE_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_DETECTED_VEHICLE_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_ANIMAL_AGO ?= $(if $(wildcard MOTION_DETECTED_ANIMAL_AGO),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_AGO) && echo "${TG}== MOTION_DETECTED_ANIMAL_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_DETECTED_ANIMAL_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_FACE_DETECTED_AGO ?= $(if $(wildcard MOTION_FACE_DETECTED_AGO),$(shell v=$$(cat MOTION_FACE_DETECTED_AGO) && echo "${TG}== MOTION_FACE_DETECTED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_FACE_DETECTED_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_ALPR_DETECTED_AGO ?= $(if $(wildcard MOTION_ALPR_DETECTED_AGO),$(shell v=$$(cat MOTION_ALPR_DETECTED_AGO) && echo "${TG}== MOTION_ALPR_DETECTED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_ALPR_DETECTED_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_POSE_DETECTED_AGO ?= $(if $(wildcard MOTION_POSE_DETECTED_AGO),$(shell v=$$(cat MOTION_POSE_DETECTED_AGO) && echo "${TG}== MOTION_POSE_DETECTED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_POSE_DETECTED_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTION_ANNOTATED_AGO ?= $(if $(wildcard MOTION_ANNOTATED_AGO),$(shell v=$$(cat MOTION_ANNOTATED_AGO) && echo "${TG}== MOTION_ANNOTATED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_ANNOTATED_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_AGO ?= $(if $(wildcard MOTION_DETECTED_AGO),$(shell v=$$(cat MOTION_DETECTED_AGO) && echo "${TG}== MOTION_DETECTED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_DETECTED_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_DETECTED_AGO ?= $(if $(wildcard MOTION_DETECTED_AGO),$(shell v=$$(cat MOTION_DETECTED_AGO) && echo "${TG}== MOTION_DETECTED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_DETECTED_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_FACE_AGO ?= $(if $(wildcard MOTION_FACE_AGO),$(shell v=$$(cat MOTION_FACE_AGO) && echo "${TG}== MOTION_FACE_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_FACE_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_ALPR_AGO ?= $(if $(wildcard MOTION_ALPR_AGO),$(shell v=$$(cat MOTION_ALPR_AGO) && echo "${TG}== MOTION_ALPR_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_ALPR_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_POSE_AGO ?= $(if $(wildcard MOTION_POSE_AGO),$(shell v=$$(cat MOTION_POSE_AGO) && echo "${TG}== MOTION_POSE_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${DF}** MOTION_POSE_AGO${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# expire and update
MOTION_EXPIRE_AFTER ?= $(if $(wildcard MOTION_EXPIRE_AFTER),$(shell v=$$(cat MOTION_EXPIRE_AFTER) && echo "${TG}== MOTION_EXPIRE_AFTER: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='60' && echo "${DF}** MOTION_EXPIRE_AFTER${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTION_FORCE_UPDATE ?= $(if $(wildcard MOTION_FORCE_UPDATE),$(shell v=$$(cat MOTION_FORCE_UPDATE) && echo "${TG}== MOTION_FORCE_UPDATE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${DF}** MOTION_FORCE_UPDATE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# webcam
NETCAM_USERNAME ?= $(if $(wildcard NETCAM_USERNAME),$(shell v=$$(cat NETCAM_USERNAME) && echo "${TG}== NETCAM_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${DF}** NETCAM_USERNAME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
NETCAM_PASSWORD ?= $(if $(wildcard NETCAM_PASSWORD),$(shell v=$$(cat NETCAM_PASSWORD) && echo "${TG}== NETCAM_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${DF}** NETCAM_PASSWORD${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

MOTIONCAM_USERNAME ?= $(if $(wildcard MOTIONCAM_USERNAME),$(shell v=$$(cat MOTIONCAM_USERNAME) && echo "${TG}== MOTIONCAM_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${DF}** MOTIONCAM_USERNAME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
MOTIONCAM_PASSWORD ?= $(if $(wildcard MOTIONCAM_PASSWORD),$(shell v=$$(cat MOTIONCAM_PASSWORD) && echo "${TG}== MOTIONCAM_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${DF}** MOTIONCAM_PASSWORD${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# netdata
NETDATA_URL ?= $(if $(wildcard NETDATA_URL),$(shell v=$$(cat NETDATA_URL) && echo "${TG}== NETDATA_URL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:19999/" && echo "${DF}** NETDATA_URL${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# omada
OMADA_URL ?= $(if $(wildcard OMADA_URL),$(shell v=$$(cat OMADA_URL) && echo "${TG}== OMADA_URL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="https://${HOST_IPADDR}:8043/" && echo "${DF}** OMADA_URL${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
OMADA_USERNAME ?= $(if $(wildcard OMADA_USERNAME),$(shell v=$$(cat OMADA_USERNAME) && echo "${TG}== OMADA_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='admin' && echo "${DF}** OMADA_USERNAME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
OMADA_PASSWORD ?= $(if $(wildcard OMADA_PASSWORD),$(shell v=$$(cat OMADA_PASSWORD) && echo "${TG}== OMADA_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='admin' && echo "${DF}** OMADA_PASSWORD${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# jupyter
JUPYTER_URL ?= $(if $(wildcard JUPYTER_URL),$(shell v=$$(cat JUPYTER_URL) && echo "${TG}== JUPYTER_URL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:7777/" && echo "${DF}** JUPYTER_URL${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# tplink
TPLINK_DISCOVERY ?= $(if $(wildcard TPLINK_DISCOVERY),$(shell v=$$(cat TPLINK_DISCOVERY) && echo "${TG}== TPLINK_DISCOVERY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${DF}** TPLINK_DISCOVERY${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# influxdb
INFLUXDB_HOST ?= $(if $(wildcard INFLUXDB_HOST),$(shell v=$$(cat INFLUXDB_HOST) && echo "${TG}== INFLUXDB_HOST: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='a0d7b954-influxdb' && echo "${DF}** INFLUXDB_HOST${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
INFLUXDB_DATABASE ?= $(if $(wildcard INFLUXDB_DATABASE),$(shell v=$$(cat INFLUXDB_DATABASE) && echo "${TG}== INFLUXDB_DATABASE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='$(HOST_NAME)' && echo "${DF}** INFLUXDB_DATABASE${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
INFLUXDB_USERNAME ?= $(if $(wildcard INFLUXDB_USERNAME),$(shell v=$$(cat INFLUXDB_USERNAME) && echo "${TG}== INFLUXDB_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='homeassistant' && echo "${DF}** INFLUXDB_USERNAME${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
INFLUXDB_PASSWORD ?= $(if $(wildcard INFLUXDB_PASSWORD),$(shell v=$$(cat INFLUXDB_PASSWORD) && echo "${TG}== INFLUXDB_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='homeassistant' && echo "${DF}** INFLUXDB_PASSWORD${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

# scan interval for speedtest
# scan interval for speedtest
INTERNET_SCAN_INTERVAL ?= $(if $(wildcard INTERNET_SCAN_INTERVAL),$(shell v=$$(cat INTERNET_SCAN_INTERVAL) && echo "${TG}== INTERNET_SCAN_INTERVAL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="14400" && echo "${DF}** INTERNET_SCAN_INTERVAL${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))
INTRANET_SCAN_INTERVAL ?= $(if $(wildcard INTRANET_SCAN_INTERVAL),$(shell v=$$(cat INTRANET_SCAN_INTERVAL) && echo "${TG}== INTRANET_SCAN_INTERVAL: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="1800" && echo "${DF}** INTRANET_SCAN_INTERVAL${TB} unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}"))

###
### TARGETS
###

MEDIA := media/Motion-Ã👁/

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
	  HOST_INTERFACE="$(HOST_INTERFACE)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_NAME="$(HOST_NAME)" \
	  HOST_NETWORK="$(HOST_NETWORK)" \
	  HOST_NETWORK_MASK="$(HOST_NETWORK_MASK)" \
	  HOST_PORT="$(HOST_PORT)" \
	  HOST_THEME="$(HOST_THEME)" \
	  HOST_TIMEZONE="$(HOST_TIMEZONE)" \
	  INFLUXDB_DATABASE="$(INFLUXDB_DATABASE)" \
	  INFLUXDB_HOST="$(INFLUXDB_HOST)" \
	  INFLUXDB_PASSWORD="$(INFLUXDB_PASSWORD)" \
	  INFLUXDB_USERNAME="$(INFLUXDB_USERNAME)" \
	  INTERNET_SCAN_INTERVAL="$(INTERNET_SCAN_INTERVAL)" \
	  INTRANET_SCAN_INTERVAL="$(INTRANET_SCAN_INTERVAL)" \
	  IPERF_HOST="$(IPERF_HOST)" \
	  JUPYTER_URL="$(JUPYTER_URL)" \
	  LOGGER_AUTOMATION="$(LOGGER_AUTOMATION)" \
	  LOGGER_DEFAULT="$(LOGGER_DEFAULT)" \
	  LOGGER_MQTT="$(LOGGER_MQTT)" \
	  MARIADB_HOST="$(MARIADB_HOST)" \
	  MARIADB_PASSWORD="$(MARIADB_PASSWORD)" \
	  MOTION_ALPR_DETECTED_AGO="$(MOTION_ALPR_DETECTED_AGO)" \
	  MOTION_ALPR_DETECTED_DEVIATION="$(MOTION_ALPR_DETECTED_DEVIATION)" \
	  MOTION_ALPR_DETECTED_NOTIFY="$(MOTION_ALPR_DETECTED_NOTIFY)" \
	  MOTION_ALPR_DETECTED_SPEAK="$(MOTION_ALPR_DETECTED_SPEAK)" \
	  MOTION_ALPR_DETECTED_TUNE="$(MOTION_ALPR_DETECTED_TUNE)" \
	  MOTION_ANNOTATED_AGO="$(MOTION_ANNOTATED_AGO)" \
	  MOTION_CAMERA_RESTART="$(MOTION_CAMERA_RESTART)" \
	  MOTION_CAMERA_ANY="$(MOTION_CAMERA_ANY)" \
	  MOTIONCAM_PASSWORD="$(MOTIONCAM_PASSWORD)" \
	  MOTIONCAM_USERNAME="$(MOTIONCAM_USERNAME)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
	  MOTION_DETECTED_AGO="$(MOTION_DETECTED_AGO)" \
	  MOTION_DETECTED_ANIMAL_AGO="$(MOTION_DETECTED_ANIMAL_AGO)" \
	  MOTION_DETECTED_ANIMAL_DEVIATION="$(MOTION_DETECTED_ANIMAL_DEVIATION)" \
	  MOTION_DETECTED_ANIMAL_NOTIFY="$(MOTION_DETECTED_ANIMAL_NOTIFY)" \
	  MOTION_DETECTED_ANIMAL_SPEAK="$(MOTION_DETECTED_ANIMAL_SPEAK)" \
	  MOTION_DETECTED_ANIMAL_TUNE="$(MOTION_DETECTED_ANIMAL_TUNE)" \
	  MOTION_DETECTED_ENTITY_AGO="$(MOTION_DETECTED_ENTITY_AGO)" \
	  MOTION_DETECTED_ENTITY_DEVIATION="$(MOTION_DETECTED_ENTITY_DEVIATION)" \
	  MOTION_DETECTED_ENTITY="$(MOTION_DETECTED_ENTITY)" \
	  MOTION_DETECTED_ENTITY_NOTIFY="$(MOTION_DETECTED_ENTITY_NOTIFY)" \
	  MOTION_DETECTED_ENTITY_SPEAK="$(MOTION_DETECTED_ENTITY_SPEAK)" \
	  MOTION_DETECTED_ENTITY_TUNE="$(MOTION_DETECTED_ENTITY_TUNE)" \
	  MOTION_DETECTED_PERSON_AGO="$(MOTION_DETECTED_PERSON_AGO)" \
	  MOTION_DETECTED_PERSON_DEVIATION="$(MOTION_DETECTED_PERSON_DEVIATION)" \
	  MOTION_DETECTED_PERSON_NOTIFY="$(MOTION_DETECTED_PERSON_NOTIFY)" \
	  MOTION_DETECTED_PERSON_SPEAK="$(MOTION_DETECTED_PERSON_SPEAK)" \
	  MOTION_DETECTED_PERSON_TUNE="$(MOTION_DETECTED_PERSON_TUNE)" \
	  MOTION_DETECTED_VEHICLE_AGO="$(MOTION_DETECTED_VEHICLE_AGO)" \
	  MOTION_DETECTED_VEHICLE_DEVIATION="$(MOTION_DETECTED_VEHICLE_DEVIATION)" \
	  MOTION_DETECTED_VEHICLE_NOTIFY="$(MOTION_DETECTED_VEHICLE_NOTIFY)" \
	  MOTION_DETECTED_VEHICLE_SPEAK="$(MOTION_DETECTED_VEHICLE_SPEAK)" \
	  MOTION_DETECTED_VEHICLE_TUNE="$(MOTION_DETECTED_VEHICLE_TUNE)" \
	  MOTION_DETECT_ENTITY="$(MOTION_DETECT_ENTITY)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_EXPIRE_AFTER="$(MOTION_EXPIRE_AFTER)" \
	  MOTION_FACE_DETECTED_AGO="$(MOTION_FACE_DETECTED_AGO)" \
	  MOTION_FACE_DETECTED_DEVIATION="$(MOTION_FACE_DETECTED_DEVIATION)" \
	  MOTION_FACE_DETECTED_SPEAK="$(MOTION_FACE_DETECTED_SPEAK)" \
	  MOTION_FACE_DETECTED_TUNE="$(MOTION_FACE_DETECTED_TUNE)" \
	  MOTION_FORCE_UPDATE="$(MOTION_FORCE_UPDATE)" \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_LOG_LEVEL="$(MOTION_LOG_LEVEL)" \
	  MOTION_NOTIFY_SMARTPHONE="$(MOTION_NOTIFY_SMARTPHONE)" \
	  MOTION_MEDIA_MASK="$(MOTION_MEDIA_MASK)" \
	  MOTION_MEDIA_SAVE="$(MOTION_MEDIA_SAVE)" \
	  MOTION_W3W_APIKEY="$(MOTION_W3W_APIKEY)" \
	  MOTION_W3W_WORDS="$(MOTION_W3W_WORDS)" \
	  MOTION_OVERVIEW_APIKEY="$(MOTION_OVERVIEW_APIKEY)" \
	  MOTION_OVERVIEW_IMAGE="$(MOTION_OVERVIEW_IMAGE)" \
	  MOTION_OVERVIEW_MODE="$(MOTION_OVERVIEW_MODE)" \
	  MOTION_OVERVIEW_ZOOM="$(MOTION_OVERVIEW_ZOOM)" \
	  MOTION_POSE_DETECTED_AGO="$(MOTION_POSE_DETECTED_AGO)" \
	  MOTION_POSE_DETECTED_DEVIATION="$(MOTION_POSE_DETECTED_DEVIATION)" \
	  MOTION_POSE_DETECTED_NOTIFY="$(MOTION_POSE_DETECTED_NOTIFY)" \
	  MOTION_POSE_DETECTED_SPEAK="$(MOTION_POSE_DETECTED_SPEAK)" \
	  MOTION_POSE_DETECTED_TUNE="$(MOTION_POSE_DETECTED_TUNE)" \
	  MOTION_REPOSITORY="$(MOTION_REPOSITORY)" \
	  MOTION_ROUTER_NAME="$(MOTION_ROUTER_NAME)" \
	  MOTION_TWILIO_NAME="$(MOTION_TWILIO_NAME)" \
	  MOTION_TWILIO_NUMBER="$(MOTION_TWILIO_NUMBER)" \
	  MOTION_TWILIO_SID="$(MOTION_TWILIO_SID)" \
	  MOTION_TWILIO_TOKEN="$(MOTION_TWILIO_TOKEN)" \
	  MOTION_USER="$(MOTION_USER)" \
	  MOTION_USER_DEVICE="$(MOTION_USER_DEVICE)" \
	  MOTION_PRIMARY="$(MOTION_PRIMARY)" \
	  MOTION_PRIMARY_DEVICE="$(MOTION_PRIMARY_DEVICE)" \
	  MOTION_SECONDARY="$(MOTION_SECONDARY)" \
	  MOTION_SECONDARY_DEVICE="$(MOTION_SECONDARY_DEVICE)" \
	  MOTION_TERTIARY="$(MOTION_TERTIARY)" \
	  MOTION_TERTIARY_DEVICE="$(MOTION_TERTIARY_DEVICE)" \
	  MOTION_YOLO_CONFIG="$(MOTION_YOLO_CONFIG)" \
	  MOTION_YOLO_IP="$(MOTION_YOLO_IP)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	  UPTIMEROBOT_RSSURL="$(UPTIMEROBOT_RSSURL)" \
	&& make -C homeassistant $@


homeassistant/setup.json: setup.json.tmpl
	@echo "${MC}Making: $@${NC}"
	-@rm -f $@
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_INTERFACE="$(HOST_INTERFACE)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_NAME="$(HOST_NAME)" \
	  HOST_NETWORK="$(HOST_NETWORK)" \
	  HOST_NETWORK_MASK="$(HOST_NETWORK_MASK)" \
	  HOST_PORT="$(HOST_PORT)" \
	  HOST_THEME="$(HOST_THEME)" \
	  HOST_TIMEZONE="$(HOST_TIMEZONE)" \
	  INFLUXDB_DATABASE="$(INFLUXDB_DATABASE)" \
	  INFLUXDB_HOST="$(INFLUXDB_HOST)" \
	  INFLUXDB_PASSWORD="$(INFLUXDB_PASSWORD)" \
	  INFLUXDB_USERNAME="$(INFLUXDB_USERNAME)" \
	  INTERNET_SCAN_INTERVAL="$(INTERNET_SCAN_INTERVAL)" \
	  INTRANET_SCAN_INTERVAL="$(INTRANET_SCAN_INTERVAL)" \
	  IPERF_HOST="$(IPERF_HOST)" \
	  JUPYTER_URL="$(JUPYTER_URL)" \
	  LOGGER_AUTOMATION="$(LOGGER_AUTOMATION)" \
	  LOGGER_DEFAULT="$(LOGGER_DEFAULT)" \
	  LOGGER_MQTT="$(LOGGER_MQTT)" \
	  MARIADB_HOST="$(MARIADB_HOST)" \
	  MARIADB_PASSWORD="$(MARIADB_PASSWORD)" \
	  MOTION_ALPR_DETECTED_AGO="$(MOTION_ALPR_DETECTED_AGO)" \
	  MOTION_ALPR_DETECTED_DEVIATION="$(MOTION_ALPR_DETECTED_DEVIATION)" \
	  MOTION_ALPR_DETECTED_NOTIFY="$(MOTION_ALPR_DETECTED_NOTIFY)" \
	  MOTION_ALPR_DETECTED_SPEAK="$(MOTION_ALPR_DETECTED_SPEAK)" \
	  MOTION_ALPR_DETECTED_TUNE="$(MOTION_ALPR_DETECTED_TUNE)" \
	  MOTION_ANNOTATED_AGO="$(MOTION_ANNOTATED_AGO)" \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_CAMERA_ANY="$(MOTION_CAMERA_ANY)" \
	  MOTION_CAMERA_RESTART="$(MOTION_CAMERA_RESTART)" \
	  MOTIONCAM_PASSWORD="$(MOTIONCAM_PASSWORD)" \
	  MOTIONCAM_USERNAME="$(MOTIONCAM_USERNAME)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
	  MOTION_DETECTED_AGO="$(MOTION_DETECTED_AGO)" \
	  MOTION_DETECTED_ANIMAL_AGO="$(MOTION_DETECTED_ANIMAL_AGO)" \
	  MOTION_DETECTED_ANIMAL_DEVIATION="$(MOTION_DETECTED_ANIMAL_DEVIATION)" \
	  MOTION_DETECTED_ANIMAL_NOTIFY="$(MOTION_DETECTED_ANIMAL_NOTIFY)" \
	  MOTION_DETECTED_ANIMAL_SPEAK="$(MOTION_DETECTED_ANIMAL_SPEAK)" \
	  MOTION_DETECTED_ANIMAL_TUNE="$(MOTION_DETECTED_ANIMAL_TUNE)" \
	  MOTION_DETECTED_ENTITY_AGO="$(MOTION_DETECTED_ENTITY_AGO)" \
	  MOTION_DETECTED_ENTITY_DEVIATION="$(MOTION_DETECTED_ENTITY_DEVIATION)" \
	  MOTION_DETECTED_ENTITY="$(MOTION_DETECTED_ENTITY)" \
	  MOTION_DETECTED_ENTITY_NOTIFY="$(MOTION_DETECTED_ENTITY_NOTIFY)" \
	  MOTION_DETECTED_ENTITY_SPEAK="$(MOTION_DETECTED_ENTITY_SPEAK)" \
	  MOTION_DETECTED_ENTITY_TUNE="$(MOTION_DETECTED_ENTITY_TUNE)" \
	  MOTION_DETECTED_PERSON_AGO="$(MOTION_DETECTED_PERSON_AGO)" \
	  MOTION_DETECTED_PERSON_DEVIATION="$(MOTION_DETECTED_PERSON_DEVIATION)" \
	  MOTION_DETECTED_PERSON_NOTIFY="$(MOTION_DETECTED_PERSON_NOTIFY)" \
	  MOTION_DETECTED_PERSON_SPEAK="$(MOTION_DETECTED_PERSON_SPEAK)" \
	  MOTION_DETECTED_PERSON_TUNE="$(MOTION_DETECTED_PERSON_TUNE)" \
	  MOTION_DETECTED_VEHICLE_AGO="$(MOTION_DETECTED_VEHICLE_AGO)" \
	  MOTION_DETECTED_VEHICLE_DEVIATION="$(MOTION_DETECTED_VEHICLE_DEVIATION)" \
	  MOTION_DETECTED_VEHICLE_NOTIFY="$(MOTION_DETECTED_VEHICLE_NOTIFY)" \
	  MOTION_DETECTED_VEHICLE_SPEAK="$(MOTION_DETECTED_VEHICLE_SPEAK)" \
	  MOTION_DETECTED_VEHICLE_TUNE="$(MOTION_DETECTED_VEHICLE_TUNE)" \
	  MOTION_DETECT_ENTITY="$(MOTION_DETECT_ENTITY)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_EXPIRE_AFTER="$(MOTION_EXPIRE_AFTER)" \
	  MOTION_FACE_DETECTED_AGO="$(MOTION_FACE_DETECTED_AGO)" \
	  MOTION_FACE_DETECTED_DEVIATION="$(MOTION_FACE_DETECTED_DEVIATION)" \
	  MOTION_FACE_DETECTED_NOTIFY="$(MOTION_FACE_DETECTED_NOTIFY)" \
	  MOTION_FACE_DETECTED_SPEAK="$(MOTION_FACE_DETECTED_SPEAK)" \
	  MOTION_FACE_DETECTED_TUNE="$(MOTION_FACE_DETECTED_TUNE)" \
	  MOTION_FORCE_UPDATE="$(MOTION_FORCE_UPDATE)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_LOG_LEVEL="$(MOTION_LOG_LEVEL)" \
	  MOTION_MEDIA_MASK="$(MOTION_MEDIA_MASK)" \
	  MOTION_MEDIA_SAVE="$(MOTION_MEDIA_SAVE)" \
	  MOTION_NOTIFY_SMARTPHONE="$(MOTION_NOTIFY_SMARTPHONE)" \
	  MOTION_OVERVIEW_APIKEY="$(MOTION_OVERVIEW_APIKEY)" \
	  MOTION_OVERVIEW_IMAGE="$(MOTION_OVERVIEW_IMAGE)" \
	  MOTION_OVERVIEW_MODE="$(MOTION_OVERVIEW_MODE)" \
	  MOTION_OVERVIEW_ZOOM="$(MOTION_OVERVIEW_ZOOM)" \
	  MOTION_POSE_DETECTED_AGO="$(MOTION_POSE_DETECTED_AGO)" \
	  MOTION_POSE_DETECTED_DEVIATION="$(MOTION_POSE_DETECTED_DEVIATION)" \
	  MOTION_POSE_DETECTED_NOTIFY="$(MOTION_POSE_DETECTED_NOTIFY)" \
	  MOTION_POSE_DETECTED_SPEAK="$(MOTION_POSE_DETECTED_SPEAK)" \
	  MOTION_POSE_DETECTED_TUNE="$(MOTION_POSE_DETECTED_TUNE)" \
	  MOTION_REPOSITORY="$(MOTION_REPOSITORY)" \
	  MOTION_ROUTER_NAME="$(MOTION_ROUTER_NAME)" \
	  MOTION_TWILIO_NAME="$(MOTION_TWILIO_NAME)" \
	  MOTION_TWILIO_NUMBER="$(MOTION_TWILIO_NUMBER)" \
	  MOTION_TWILIO_SID="$(MOTION_TWILIO_SID)" \
	  MOTION_TWILIO_TOKEN="$(MOTION_TWILIO_TOKEN)" \
	  MOTION_USER="$(MOTION_USER)" \
	  MOTION_USER_DEVICE="$(MOTION_USER_DEVICE)" \
	  MOTION_PRIMARY="$(MOTION_PRIMARY)" \
	  MOTION_PRIMARY_DEVICE="$(MOTION_PRIMARY_DEVICE)" \
	  MOTION_SECONDARY="$(MOTION_SECONDARY)" \
	  MOTION_SECONDARY_DEVICE="$(MOTION_SECONDARY_DEVICE)" \
	  MOTION_TERTIARY="$(MOTION_TERTIARY)" \
	  MOTION_TERTIARY_DEVICE="$(MOTION_TERTIARY_DEVICE)" \
	  MOTION_W3W_APIKEY="$(MOTION_W3W_APIKEY)" \
	  MOTION_W3W_WORDS="$(MOTION_W3W_WORDS)" \
	  MOTION_YOLO_CONFIG="$(MOTION_YOLO_CONFIG)" \
	  MOTION_YOLO_IP="$(MOTION_YOLO_IP)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  OMADA_PASSWORD="$(OMADA_PASSWORD)" \
	  OMADA_URL="$(OMADA_URL)" \
	  OMADA_USERNAME="$(OMADA_USERNAME)" \
	  TIMESTAMP="$(TIMESTAMP)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	  UPTIMEROBOT_RSSURL="$(UPTIMEROBOT_RSSURL)" \
	&& cat $< | envsubst | jq -S -c . > $@

.PHONY: ${MEDIA} necessary all default run stop logs restart tidy clean realclean distclean $(PACKAGES) homeassistant/motion/webcams.json homeassistant/setup.json allclean

allclean: distclean
	@echo "${MC}Making: $@${NC}"
	@-sudo rm -fr MOTIONCAM_* NETCAM_* MOTION_* LOGGER_* MQTT_* YOLO_* LOG_LEVEL DEBUG
	@-sudo rm -fr *.sh.json
	@-sudo rm -fr \
	  addons \
	  addons.json \
	  apparmor \
	  audio \
	  audio.json \
	  backup \
	  cli.json \
	  config.json \
	  discovery.json \
	  dns \
	  dns.json \
	  get.docker.sh \
	  homeassistant.json \
	  ingress.json \
	  media \
	  multicast.json \
	  observer.json \
	  services.json \
	  share \
	  ssl \
	  tmp \
	  updater.json \
	  install.log

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
