###
### makefile
###

SHELL := /bin/bash

## TOP-LEVEL
DOMAIN_NAME ?= $(if $(DOMAIN_NAME),$(shell v=$(DOMAIN_NAME) && echo "-- INFO: DOMAIN_NAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(domainname -d) && v=$${v:-local}  && echo "++ WARN: DOMAIN_NAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_GROUP ?= $(if $(MOTION_GROUP),$(shell v=$(MOTION_GROUP) && echo "-- INFO: MOTION_GROUP: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(echo "motion") && echo "++ WARN: MOTION_GROUP unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_DEVICE ?= $(if $(MOTION_DEVICE),$(shell v=$(MOTION_DEVICE) && echo "-- INFO: MOTION_DEVICE: $${v}" > /dev/stderr && echo "$${v}"),$(shell v=$$(echo "$${HOST_NAME:-$$(hostname)}" | sed 's/[\#+ \/]/_/g') && echo "++ WARN: MOTION_DEVICE unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MOTION_CLIENT ?= $(if $(MOTION_CLIENT),$(shell v=$(MOTION_CLIENT) && echo "-- INFO: MOTION_CLIENT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='+' && echo "++ WARN: MOTION_CLIENT unset; default: $${v}" > /dev/stderr && echo "$${v}"))

## MQTT
MQTT_HOST ?= $(if $(MQTT_HOST),$(shell v=$(MQTT_HOST) && echo "-- INFO: MQTT_HOST: $${v}" > /dev/stderr && echo "$${v}"),$(shell v="mqtt.$(DOMAIN_NAME)" && echo "++ WARN: MQTT_HOST unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PORT ?= $(if $(MQTT_PORT),$(shell v=$(MQTT_PORT) && echo "-- INFO: MQTT_PORT: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='1883' && echo "++ WARN: MQTT_PORT unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_USERNAME ?= $(if $(MQTT_USERNAME),$(shell v=$(MQTT_USERNAME) && echo "-- INFO: MQTT_USERNAME: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='username' && echo "++ WARN: MQTT_USERNAME unset; default: $${v}" > /dev/stderr && echo "$${v}"))
MQTT_PASSWORD ?= $(if $(MQTT_PASSWORD),$(shell v=$(MQTT_PASSWORD) && echo "-- INFO: MQTT_PASSWORD: $${v}" > /dev/stderr && echo "$${v}"),$(shell v='password' && echo "++ WARN: MQTT_PASSWORD unset; default: $${v}" > /dev/stderr && echo "$${v}"))

## COUCHDB
MOTION_COUCHDB_HOST := $(MOTION_COUCHDB_HOST:-couchdb.$(DOMAIN_NAME))
MOTION_COUCHDB_USERNAME := $(MOTION_COUCHDB_USERNAME:-username)
MOTION_COUCHDB_PASSWORD := $(MOTION_COUCHDB_PASSWORD:-password)

##
## WEBCAM
##

WEBCAMS_JSON := webcams.json
WEBCAMS := $(shell jq -r '.[].name' $(WEBCAMS_JSON))

# WEBCAM components
WEBCAM_AUTOMATIONS := $(shell for C in $(WEBCAMS); do echo automation/webcam-$${C}.yaml; done)
WEBCAM_BINARY_SENSORS := $(shell for C in $(WEBCAMS); do echo binary_sensor/webcam-$${C}.yaml; done)
WEBCAM_CAMERAS := $(shell for C in $(WEBCAMS); do echo camera/webcam-$${C}.yaml; done)
WEBCAM_COUNTERS := $(shell for C in $(WEBCAMS); do echo counter/webcam-$${C}.yaml; done)
WEBCAM_DEVICE_TRACKERS := $(shell for C in $(WEBCAMS); do echo device_tracker/webcam-$${C}.yaml; done)
WEBCAM_GRAPHS := $(shell for C in $(WEBCAMS); do echo history_graph/webcam-$${C}.yaml; done)
WEBCAM_GROUPS := $(shell for C in $(WEBCAMS); do echo group/webcam-$${C}.yaml; done)
WEBCAM_SENSORS := $(shell for C in $(WEBCAMS); do echo sensor/webcam-$${C}.yaml; done)
WEBCAM_INPUT_SELECTS := $(shell for C in $(WEBCAMS); do echo input_select/webcam-$${C}.yaml; done)
WEBCAM_INPUT_BOOLEANS := $(shell for C in $(WEBCAMS); do echo input_boolean/webcam-$${C}.yaml; done)
WEBCAM_SHELL_COMMANDS := $(shell for C in $(WEBCAMS); do echo shell_command/webcam-$${C}.yaml; done)
WEBCAM_IMAGE_PROCESSINGS := $(shell for C in $(WEBCAMS); do echo image_processing/webcam-$${C}.yaml; done)

# WEBCAM templates
WEBCAM_AUTOMATION_TEMPLATE := automation.webcam.yaml.tmpl
WEBCAM_BINARY_SENSOR_TEMPLATE := binary_sensor.webcam.yaml.tmpl
WEBCAM_CAMERA_TEMPLATE := camera.webcam.yaml.tmpl
WEBCAM_COUNTER_TEMPLATE := counter.webcam.yaml.tmpl
WEBCAM_DEVICE_TRACKER_TEMPLATE := device_tracker.webcam.yaml.tmpl
WEBCAM_GRAPH_TEMPLATE := history_graph.webcam.yaml.tmpl
WEBCAM_GROUP_TEMPLATE := group.webcam.yaml.tmpl
WEBCAM_SENSOR_TEMPLATE := sensor.webcam.yaml.tmpl
WEBCAM_INPUT_SELECT_TEMPLATE := input_select.webcam.yaml.tmpl
WEBCAM_INPUT_BOOLEAN_TEMPLATE := input_boolean.webcam.yaml.tmpl
WEBCAM_SHELL_COMMAND_TEMPLATE := shell_command.webcam.yaml.tmpl
WEBCAM_IMAGE_PROCESSING_TEMPLATE := image_processing.webcam.yaml.tmpl

# WEBCAM yaml
WEBCAM_YAML := \
	$(WEBCAM_AUTOMATIONS) \
	$(WEBCAM_BINARY_SENSORS) \
	$(WEBCAM_CAMERAS) \
	$(WEBCAM_COUNTERS) \
	$(WEBCAM_SENSORS) \
	$(WEBCAM_INPUT_SELECTS) \
	$(WEBCAM_INPUT_BOOLEANS) \
	$(WEBCAM_SHELL_COMMANDS) \
	$(WEBCAM_IMAGE_PROCESSINGS)

#	$(WEBCAM_GROUPS) \
#	$(WEBCAM_GRAPHS) \
#	$(WEBCAM_DEVICE_TRACKERS) \

##
## HIGHLOW
##

# entity's items to track
HIGHLOW_ENTITYS := annotated # detected # detected_entity # detected_person detected_vehicle detected_animal # image end annotated 
HIGHLOW_ITEMS := count ago

# HIGHLOW templates
HIGHLOW_BINARY_SENSOR_TEMPLATE := binary_sensor.highlow.yaml.tmpl
HIGHLOW_AUTOMATION_TEMPLATE := automation.highlow.yaml.tmpl

# HIGHLOW yaml
HIGHLOW_BINARY_SENSORS := $(shell for S in $(HIGHLOW_ENTITYS); do for I in $(HIGHLOW_ITEMS); do echo "binary_sensor/highlow-$${S}_$${I}.yaml"; done; done)
HIGHLOW_AUTOMATIONS := $(shell for S in $(HIGHLOW_ENTITYS); do for I in $(HIGHLOW_ITEMS); do echo "automation/highlow-$${S}_$${I}.yaml"; done; done)

HIGHLOW_YAML := ${HIGHLOW_BINARY_SENSORS} # ${HIGHLOW_AUTOMATIONS}

# TEMPLATES

MOTION_YAML := \
	input_text/config.yaml \
	automation/storage.yaml \
	automation/mqtt_attributes.yaml \
	automation/internet_publish.yaml \
	automation/intranet_publish.yaml \
	automation/camera_notify.yaml \
	sensor/event_start.yaml \
	sensor/event_image.yaml \
	sensor/event_end.yaml \
	sensor/event_face.yaml \
	sensor/event_alpr.yaml \
	sensor/event_annotated.yaml \
	sensor/device_start.yaml \
	sensor/lost.yaml \
	sensor/found.yaml \
	camera/event_image.yaml \
	camera/event_end.yaml \
	camera/event_animated.yaml \
	camera/event_face.yaml \
	camera/event_alpr.yaml \
	camera/event_annotated.yaml

###
### targets
###

default: all

all:  $(MOTION_YAML) $(WEBCAM_YAML) $(HIGHLOW_BINARY_SENSORS) group/webcams.yaml # history_graph/webcams.yaml

# TEMPLATES

input_text/%.yaml : input_text.%.yaml.tmpl
	@echo "Making $@"
	@export \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="${MOTION_CLIENT}" \
	  && cat $< | envsubst > $@

automation/%.yaml : automation.%.yaml.tmpl
	@echo "Making $@"
	@export \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="${MOTION_CLIENT}" \
	  && cat $< | envsubst > $@

camera/%.yaml : camera.%.yaml.tmpl
	@echo "Making $@"
	@export \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="${MOTION_CLIENT}" \
	  && cat $< | envsubst > $@

sensor/%.yaml : sensor.%.yaml.tmpl
	@echo "Making $@"
	@export \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="${MOTION_CLIENT}" \
	  && cat $< | envsubst > $@

binary_sensor/%.yaml : binary_sensor.%.yaml.tmpl
	@echo "Making $@"
	@export \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_CLIENT="${MOTION_CLIENT}" \
	  && cat $< | envsubst > $@

## HIGHLOW targets

$(HIGHLOW_BINARY_SENSORS): $(HIGHLOW_BINARY_SENSOR_TEMPLATE) makefile
	@export TARGET="$@" PKG="motion"; \
	export ITEM=$${TARGET##*_}; \
	export ITEM=$${ITEM%%.*}; \
	export SENSOR=$${TARGET%%_$${TARGET##*_}}; \
	export SENSOR=$${SENSOR##*-}; \
	cat $(HIGHLOW_BINARY_SENSOR_TEMPLATE) | envsubst > $@

$(HIGHLOW_AUTOMATIONS): $(HIGHLOW_AUTOMATION_TEMPLATE) makefile
	@export TARGET="$@" PKG="motion"; \
	export ITEM=$${TARGET##*_}; \
	export ITEM=$${ITEM%%.*}; \
	export SENSOR=$${TARGET%%_$${TARGET##*_}}; \
	export SENSOR=$${SENSOR##*-}; \
	cat $(HIGHLOW_AUTOMATION_TEMPLATE) | envsubst > $@

## WEBCAM targets

$(WEBCAM_CAMERAS): $(WEBCAM_CAMERA_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA="$${TARGET%%.*}"; \
	  export MOTION_CAMERA="$${MOTION_CAMERA##*-}"; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  export MOTION_CAMERA_MJPEG=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.mjpeg_url" $(WEBCAMS_JSON)); \
	  export MOTION_CAMERA_STILL=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.still_image_url" $(WEBCAMS_JSON)); \
	  VAL=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.username" $(WEBCAMS_JSON)); \
	  export MOTION_CAMERA_USERNAME="$${VAL}"; \
	  VAL=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.password" $(WEBCAMS_JSON)); \
	  export MOTION_CAMERA_PASSWORD="$${VAL}"; \
	  cat $(WEBCAM_CAMERA_TEMPLATE) | envsubst > $@

$(WEBCAM_AUTOMATIONS): $(WEBCAM_AUTOMATION_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA="$${TARGET%%.*}"; \
	  export MOTION_CAMERA="$${MOTION_CAMERA##*-}"; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  cat $(WEBCAM_AUTOMATION_TEMPLATE) | envsubst > $@

$(WEBCAM_BINARY_SENSORS): $(WEBCAM_BINARY_SENSOR_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA="$${TARGET%%.*}"; \
	  export MOTION_CAMERA="$${MOTION_CAMERA##*-}"; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  cat $(WEBCAM_BINARY_SENSOR_TEMPLATE) | envsubst > $@

$(WEBCAM_COUNTERS): $(WEBCAM_COUNTER_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  cat $(WEBCAM_COUNTER_TEMPLATE) | envsubst > $@

$(WEBCAM_DEVICE_TRACKERS): $(WEBCAM_DEVICE_TRACKER_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  cat $(WEBCAM_DEVICE_TRACKER_TEMPLATE) | envsubst > $@

$(WEBCAM_GRAPHS): $(WEBCAM_GRAPH_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  cat $(WEBCAM_GRAPH_TEMPLATE) | envsubst > $@

$(WEBCAM_GROUPS): $(WEBCAM_GROUP_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  cat $(WEBCAM_GROUP_TEMPLATE) | envsubst > $@

$(WEBCAM_SENSORS): $(WEBCAM_SENSOR_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  cat $(WEBCAM_SENSOR_TEMPLATE) | envsubst > $@

$(WEBCAM_INPUT_BOOLEANS): $(WEBCAM_INPUT_BOOLEAN_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  cat $(WEBCAM_INPUT_BOOLEAN_TEMPLATE) | envsubst > $@

$(WEBCAM_INPUT_SELECTS): $(WEBCAM_INPUT_SELECT_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  cat $(WEBCAM_INPUT_SELECT_TEMPLATE) | envsubst > $@

$(WEBCAM_SHELL_COMMANDS): $(WEBCAM_SHELL_COMMAND_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  cat $(WEBCAM_SHELL_COMMAND_TEMPLATE) | envsubst > $@

$(WEBCAM_IMAGE_PROCESSINGS): $(WEBCAM_IMAGE_PROCESSING_TEMPLATE) makefile ${WEBCAMS_JSON}
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_DEVICE="$(MOTION_DEVICE)"; \
	  export MOTION_CLIENT="$(MOTION_CLIENT)"; \
	  cat $(WEBCAM_IMAGE_PROCESSING_TEMPLATE) | envsubst > $@

## motion-addon.json

motion-addon.json: motion-addon.json.tmpl makefile ${WEBCAMS_JSON}
	@export \
	   DOMAIN_NAME="${DOMAIN_NAME}" \
	   MOTION_GROUP="${MOTION_GROUP}" \
	   MOTION_DEVICE="${MOTION_DEVICE}" \
	   MOTION_CLIENT="${MOTION_CLIENT}" \
	   MQTT_HOST=${MQTT_HOST} \
	   MQTT_PORT=${MQTT_PORT} \
	   MQTT_USERNAME=${MQTT_USERNAME} \
	   MQTT_PASSWORD=${MQTT_PASSWORD} \
	   MOTION_COUCHDB_HOST=${MOTION_COUCHDB_HOST} \
	   MOTION_COUCHDB_USERNAME=${MOTION_COUCHDB_USERNAME} \
	   MOTION_COUCHDB_PASSWORD=${MOTION_COUCHDB_PASSWORD} \
	&& cat motion-addon.json.tmpl | envsubst > motion-addon.json
	@for C in $(WEBCAMS); do \
	  export \
	    MOTION_CAMERA_URL=$$(jq -r ".[]|select(.name==\"$${C}\")|.mjpeg_url" $(WEBCAMS_JSON)) \
	  && \
          jq '.|.cameras+=[ { "name": "'$${C}'", "url": "'$${MOTION_CAMERA_URL}'" } ]' motion-addon.json > motion-addon.json.$$; \
          mv motion-addon.json.$$ motion-addon.json; \
	done

## group/webcams.yaml 

group/webcams.yaml: ${WEBCAMS_JSON} makefile ./sh/mkwebcam-group.sh
	@./sh/mkwebcam-group.sh ${WEBCAMS_JSON} > $@

## history_graph/webcams.yaml

history_graph/webcams.yaml: ${WEBCAMS_JSON} makefile ./sh/mkwebcam-history_graph.sh
	@./sh/mkwebcam-history_graph.sh ${WEBCAMS_JSON} > $@

## clean and clean and clean ..

tidy:
	-@rm -f $(WEBCAM_YAML) */webcam-*
	-@rm -f $(HIGHLOW_YAML) */highlow-*
	-@rm -f $(MOTION_YAML)

clean: tidy
	-rm -f motion-addon.json
	-rm -f group/webcams.yaml

realclean: clean

distclean: realclean

.phony: start stop restart up down logs tidy clean realclean distclean 
