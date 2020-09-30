###
### makefile
###

SHELL := /bin/bash

THIS_HOSTIP ?= $(shell ifconfig | egrep 'inet ' | awk '{ print $$2 }' | egrep -v '^172.|^10.|^127.' | head -1)

# logging
LOGGER_DEFAULT ?= $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "** SPECIFIED: LOGGER_DEFAULT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "!! UNSPECIFIED: LOGGER_DEFAULT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
LOGGER_AUTOMATION ?= $(if $(wildcard LOGGER_AUTOMATION),$(shell v=$$(cat LOGGER_AUTOMATION) && echo "** SPECIFIED: LOGGER_AUTOMATION: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "!! UNSPECIFIED: LOGGER_AUTOMATION unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# automation(s)
AUTOMATION_INTERNET ?= $(if $(wildcard AUTOMATION_INTERNET),$(shell v=$$(cat AUTOMATION_INTERNET) && echo "** SPECIFIED: AUTOMATION_INTERNET: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "!! UNSPECIFIED: AUTOMATION_INTERNET unset; default: off" > /dev/stderr && echo "off"))
AUTOMATION_INTRANET ?= $(if $(wildcard AUTOMATION_INTRANET),$(shell v=$$(cat AUTOMATION_INTRANET) && echo "** SPECIFIED: AUTOMATION_INTRANET: $${v}" > /dev/stderr && echo "$${v}"),$(shell echo "!! UNSPECIFIED: AUTOMATION_INTRANET unset; default: off" > /dev/stderr && echo "off"))

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
MOTION_DEVICE ?= $(if $(wildcard MOTION_DEVICE),$(shell v=$$(cat MOTION_DEVICE) && echo "** SPECIFIED: MOTION_DEVICE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -s) && echo "!! UNSPECIFIED: MOTION_DEVICE unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_CLIENT ?= $(if $(wildcard MOTION_CLIENT),$(shell v=$$(cat MOTION_CLIENT) && echo "** SPECIFIED: MOTION_CLIENT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='+' && echo "!! UNSPECIFIED: MOTION_CLIENT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_DETECT_ENTITY ?= $(if $(wildcard MOTION_DETECT_ENTITY),$(shell v=$$(cat MOTION_DETECT_ENTITY) && echo "** SPECIFIED: MOTION_DETECT_ENTITY: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="person" && echo "!! UNSPECIFIED: MOTION_DETECT_ENTITY unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_EXPIRE_AFTER ?= $(if $(wildcard MOTION_EXPIRE_AFTER),$(shell v=$$(cat MOTION_EXPIRE_AFTER) && echo "** SPECIFIED: MOTION_EXPIRE_AFTER: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="1" && echo "!! UNSPECIFIED: MOTION_EXPIRE_AFTER unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# webcam
NETCAM_USERNAME ?= $(if $(wildcard NETCAM_USERNAME),$(shell v=$$(cat NETCAM_USERNAME) && echo "** SPECIFIED: NETCAM_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "!! UNSPECIFIED: NETCAM_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
NETCAM_PASSWORD ?= $(if $(wildcard NETCAM_PASSWORD),$(shell v=$$(cat NETCAM_PASSWORD) && echo "** SPECIFIED: NETCAM_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify NETCAM_PASSWORD: " && echo $${REPLY} | tee NETCAM_PASSWORD))

MOTIONCAM_USERNAME ?= $(if $(wildcard MOTIONCAM_USERNAME),$(shell v=$$(cat MOTIONCAM_USERNAME) && echo "** SPECIFIED: MOTIONCAM_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "!! UNSPECIFIED: MOTIONCAM_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTIONCAM_PASSWORD ?= $(if $(wildcard MOTIONCAM_PASSWORD),$(shell v=$$(cat MOTIONCAM_PASSWORD) && echo "** SPECIFIED: MOTIONCAM_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell read -p "Specify MOTIONCAM_PASSWORD: " && echo $${REPLY} | tee MOTIONCAM_PASSWORD))

# netdata
NETDATA_URL ?= $(if $(wildcard NETDATA_URL),$(shell v=$$(cat NETDATA_URL) && echo "** SPECIFIED: NETDATA_URL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:19999/" && echo "!! UNSPECIFIED: NETDATA_URL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# tplink
TPLINK_DISCOVERY ?= $(if $(wildcard TPLINK_DISCOVERY),$(shell v=$$(cat TPLINK_DISCOVERY) && echo "** SPECIFIED: TPLINK_DISCOVERY: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "!! UNSPECIFIED: TPLINK_DISCOVERY unset; default: $${v}" > /dev/stderr && echo "$${v}"))

# scan interval for speedtest
INTERNET_SCAN_INTERVAL ?= $(if $(wildcard INTERNET_SCAN_INTERVAL),$(shell v=$$(cat INTERNET_SCAN_INTERVAL) && echo "** SPECIFIED: INTERNET_SCAN_INTERVAL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="14400" && echo "!! UNSPECIFIED: INTERNET_SCAN_INTERVAL unset; default: $${v}" > /dev/stderr && echo "$${v}"))
INTRANET_SCAN_INTERVAL ?= $(if $(wildcard INTRANET_SCAN_INTERVAL),$(shell v=$$(cat INTRANET_SCAN_INTERVAL) && echo "** SPECIFIED: INTRANET_SCAN_INTERVAL: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="1800" && echo "!! UNSPECIFIED: INTRANET_SCAN_INTERVAL unset; default: $${v}" > /dev/stderr && echo "$${v}"))

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
	@echo "making $@"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
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

restart: stop logclean tidy run

logs:
	docker logs -f homeassistant

secrets.yaml: secrets.yaml.tmpl makefile $(PWD)
	@echo "making $@"
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
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	  INFLUXDB_HOST="$(INFLUXDB_HOST)" \
	  INFLUXDB_USERNAME="$(INFLUXDB_USERNAME)" \
	  INFLUXDB_DATABASE="$(INFLUXDB_DATABASE)" \
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
	  MOTION_EXPIRE_AFTER="$(MOTION_EXPIRE_AFTER)" \
	  LOGGER_DEFAULT="$(LOGGER_DEFAULT)" \
	  LOGGER_AUTOMATION="$(LOGGER_AUTOMATION)" \
	&& cat $< | envsubst > $@

lovelace.json: lovelace.json.tmpl
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
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="status").cards[]|select(.title=="OVERVIEW").elements)+='"$$(jq '[.[]|{"type":"icon","entity":("sensor.motion_annotated_ago_"+.name),"icon": "mdi:cctv","style":{"color":"white","left":(.left|tostring+"%"),"top":(.top|tostring+"%"),"height":"5%","width": "5%"}}]' motion/webcams.json)" \
	 > $@
	@echo "MADE $@"
	rm -f .storage/lovelace
	-mkdir -p .storage/
	ln -s ../$@ .storage/lovelace

lovelace.developer.json: lovelace.developer.json.tmpl
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
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="motion_live").cards[]|select(.title=="OVERVIEW").elements)+='"$$(jq '[.[]|{"type":"icon","entity":("camera.motion_live_"+.name),"icon": "mdi:cctv","style":{"color":"white","left":(.left|tostring+"%"),"top":(.top|tostring+"%"),"height":"5%","width": "5%"}}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_live").cards)+='"$$(jq '[.[]|{"entity":("camera.motion_live_"+.name),"type":"picture-entity"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_animated_webcams_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_annotated_when_"+.name),"image":("/local/images/motion_annotated-"+.name+".gif"),"type":"picture-entity"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_counter_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_count_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_count_stdev_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name+"_stdev")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_count_change_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name+"_change")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_percent_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_percent_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_count_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_count_mean_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_ago_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_ago_mean_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name+"_mean")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_ago_stdev_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name+"_stdev")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_detected_entity_ago_change_webcams").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name+"_change")]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_annotated_view").cards[]|select(.title=="motion_annotated_ago").entities)+='"$$(jq '[.[]|("sensor.motion_annotated_ago_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_annotated_view").cards[]|select(.title=="motion_annotated_counter").entities)+='"$$(jq '[.[]|("sensor.motion_annotated_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_annotated_view").cards[]|select(.title=="motion_annotated_count").entities)+='"$$(jq '[.[]|("sensor.motion_annotated_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_annotated_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_annotated_count_"+.name),"aspect_ratio": "0%","image": ("/local/images/motion_annotated-"+.name+".jpg"),"entities": [{"entity":("binary_sensor.motion_annotated_"+.name)},{"entity":("sensor.motion_annotated_ago_"+.name)}],"title":("Motion Annotated "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_view").cards[]|select(.title=="motion_detected_ago").entities)+='"$$(jq '[.[]|("sensor.motion_detected_ago_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_view").cards[]|select(.title=="motion_detected_counter").entities)+='"$$(jq '[.[]|("sensor.motion_detected_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_view").cards[]|select(.title=="motion_detected_count").entities)+='"$$(jq '[.[]|("sensor.motion_detected_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_detected_count_"+.name),"aspect_ratio": "0%","image": ("/local/images/motion_detected-"+.name+".jpg"),"entities": [{"entity":("binary_sensor.motion_detected_"+.name)},{"entity":("sensor.motion_detected_ago_"+.name)}],"title":("Motion Detected "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_entity_view").cards[]|select(.title=="motion_detected_entity_ago").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_ago_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_entity_view").cards[]|select(.title=="motion_detected_entity_counter").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_entity_view").cards[]|select(.title=="motion_detected_entity_count").entities)+='"$$(jq '[.[]|("sensor.motion_detected_entity_count_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_detected_entity_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_detected_entity_count_"+.name),"aspect_ratio": "0%","image": ("/local/images/motion_detected_entity-"+.name+".jpg"),"entities": [{"entity":("binary_sensor.motion_detected_entity_"+.name)},{"entity":("sensor.motion_detected_entity_ago_"+.name)}],"title":("Motion Detected Entity "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_face_detected_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_face_detected_count_"+.name),"aspect_ratio": "0%","image": ("/local/images/motion_face_detected-"+.name+".jpg"),"entities": [{"entity":("binary_sensor.motion_face_detected_"+.name)},{"entity":("sensor.motion_face_detected_ago_"+.name)}],"title":("Face "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_alpr_detected_view").cards)+='"$$(jq '[.[]|{"entity":("sensor.motion_alpr_detected_count_"+.name),"aspect_ratio": "0%","image": ("/local/images/motion_alpr_detected-"+.name+".jpg"),"entities": [{"entity":("binary_sensor.motion_alpr_detected_"+.name)},{"entity":("sensor.motion_alpr_detected_ago_"+.name)}],"title":("ALPR "+.name),"type":"picture-glance"}]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_status_camera_lost_counter").entities)+='"$$(jq '[.[]|("sensor.motion_status_camera_lost_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_status_camera_found_counter").entities)+='"$$(jq '[.[]|("sensor.motion_status_camera_found_counter_"+.name)]' motion/webcams.json)" \
	  | jq '(.data.config.views[]|select(.path=="motion_graphs_view").cards[]|select(.title=="motion_status_camera").entities)+='"$$(jq '[.[]|("sensor.motion_status_camera_"+.name)]' motion/webcams.json)" \
	 > $@
	@echo "MADE $@"
	rm -f .storage/lovelace.lovelace_developer
	-mkdir -p .storage/
	ln -s ../$@ .storage/lovelace.lovelace_developer

lovelace_dashboards.json: lovelace_dashboards.json.tmpl
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
	&& cat $< \
	  | envsubst \
	 > $@
	@echo "MADE $@"
	rm -f .storage/lovelace_dashboards
	-mkdir -p .storage/
	ln -s ../$@ .storage/lovelace_dashboards

## clean and clean and clean ..

tidy: 
	@echo "making $@"
	@rm -f lovelace.json lovelace_dashboards.json lovelace.developer.json
	@${MAKE} -C motion clean

refresh: 
	@echo "making $@"
	-rm -f www/images/motion_*.{jpg,gif}

clean: stop logclean refresh
	@echo "making $@"
	-rm -f secrets.yaml
	-rm -f .storage/lovelace
	-rm -f .storage/core.restore_state

realclean: clean
	-rm -f known_devices.yaml
	-rm -f home-assistant.log
	-rm -f home-assistant_v2.*
	-rm -f .storage/core.*

logclean:
	@export LOGPATH=$$(docker inspect --format '{{json .}}' homeassistant | jq -r '.LogPath') \
	  && echo 'Attempting to remove log file (requires sudo): '"$${LOGPATH}" \
	  && sudo LOGPATH=$${LOGPATH} /bin/rm -f $${LOGPATH}

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts .storage

.PHONY: refresh tidy all default run stop logs restart clean realclean distclean $(PACKAGES)
