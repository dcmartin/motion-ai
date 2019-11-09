###
### makefile
###

## TOP-LEVEL
MOTION_TLD := dcmartin.com
MOTION_GROUP := motion
MOTION_DEVICE := $(if ${MOTION_DEVICE},${MOTION_DEVICE},$(shell hostname))

## MQTT
MOTION_MQTT_HOST := $(if ${MOTION_MQTT_HOST},${MOTION_MQTT_HOST},mqtt.${MOTION_TLD})
MOTION_MQTT_USERNAME := $(if ${MOTION_MQTT_USERNAME},${MOTION_MQTT_USERNAME},"username")
MOTION_MQTT_PASSWORD := $(if ${MOTION_MQTT_PASSWORD},${MOTION_MQTT_PASSWORD},"password")

## COUCHDB
MOTION_COUCHDB_HOST := $(MOTION_COUCHDB_HOST:-couchdb.$(MOTION_TLD))
MOTION_COUCHDB_USERNAME := $(MOTION_COUCHDB_USERNAME:-username)
MOTION_COUCHDB_PASSWORD := $(MOTION_COUCHDB_PASSWORD:-password)

## WEBCAMS
WEBCAMS_JSON := webcams.json
WEBCAMS := $(shell jq -r '.[].name' $(WEBCAMS_JSON))

# WEBCAM components
WEBCAM_GRAPHS := $(shell for C in $(WEBCAMS); do echo history_graph/webcam-$${C}.yaml; done)
WEBCAM_GROUPS := $(shell for C in $(WEBCAMS); do echo group/webcam-$${C}.yaml; done)
WEBCAM_COUNTERS := $(shell for C in $(WEBCAMS); do echo counter/webcam-$${C}.yaml; done)
WEBCAM_SENSORS := $(shell for C in $(WEBCAMS); do echo sensor/webcam-$${C}.yaml; done)
WEBCAM_CAMERAS := $(shell for C in $(WEBCAMS); do echo camera/webcam-$${C}.yaml; done)
WEBCAM_AUTOMATIONS := $(shell for C in $(WEBCAMS); do echo automation/webcam-$${C}.yaml; done)
WEBCAM_BINARY_SENSORS := $(shell for C in $(WEBCAMS); do echo binary_sensor/webcam-$${C}.yaml; done)

# WEBCAM templates
WEBCAM_AUTOMATION_TEMPLATE := automation.webcam.yaml.tmpl
WEBCAM_BINARY_SENSOR_TEMPLATE := binary_sensor.webcam.yaml.tmpl
WEBCAM_CAMERA_TEMPLATE := camera.webcam.yaml.tmpl
WEBCAM_COUNTER_TEMPLATE := counter.webcam.yaml.tmpl
WEBCAM_GRAPH_TEMPLATE := history_graph.webcam.yaml.tmpl
WEBCAM_GROUP_TEMPLATE := group.webcam.yaml.tmpl
WEBCAM_SENSOR_TEMPLATE := sensor.webcam.yaml.tmpl

# WEBCAM yaml
WEBCAM_YAML := \
	$(WEBCAM_AUTOMATIONS) \
	$(WEBCAM_BINARY_SENSORS) \
	$(WEBCAM_CAMERAS) \
	$(WEBCAM_COUNTERS) \
	$(WEBCAM_GRAPHS) \
	$(WEBCAM_GROUPS) \
	$(WEBCAM_SENSORS)

## HIGHLOW
HIGHLOW_ITEMS := count ago

# HIGHLOW components
HIGHLOW_SENSORS := image end annotated detected detected_entity

# HIGHLOW templates
HIGHLOW_TEMPLATE := binary_sensor.highlow.yaml.tmpl

# HIGHLOW yaml
HIGHLOW_YAML := $(shell for S in $(HIGHLOW_SENSORS); do for I in $(HIGHLOW_ITEMS); do echo "binary_sensor/highlow-$${S}_$${I}.yaml"; done; done)

###
### targets
###

default: all

all:  $(WEBCAM_YAML) $(HIGHLOW_YAML) motion-addon.json

## HIGHLOW targets

$(HIGHLOW_YAML): $(HIGHLOW_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@" PKG="motion"; \
	export ITEM=$${TARGET##*_}; \
	export ITEM=$${ITEM%%.*}; \
	export SENSOR=$${TARGET%%_$${TARGET##*_}}; \
	export SENSOR=$${SENSOR##*-}; \
	cat $(HIGHLOW_TEMPLATE) | envsubst > $@

## WEBCAM targets

$(WEBCAM_CAMERAS): $(WEBCAM_CAMERA_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  export MOTION_CAMERA_MJPEG=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.mjpeg_url" $(WEBCAMS_JSON)); \
	  export MOTION_CAMERA_STILL=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.still_image_url" $(WEBCAMS_JSON)); \
	  VAL=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.username" $(WEBCAMS_JSON)); \
	  export MOTION_CAMERA_USERNAME="$${VAL}"; \
	  VAL=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.password" $(WEBCAMS_JSON)); \
	  export MOTION_CAMERA_PASSWORD="$${VAL}"; \
	  cat $(WEBCAM_CAMERA_TEMPLATE) | envsubst > $@

$(WEBCAM_GROUPS): $(WEBCAM_GROUP_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  export MOTION_CAMERA_ICON=$$(jq -r ".[]|select(.name==\"$${MOTION_CAMERA}\")|.icon" $(WEBCAMS_JSON)); \
	  cat $(WEBCAM_GROUP_TEMPLATE) | envsubst > $@

$(WEBCAM_AUTOMATIONS): $(WEBCAM_AUTOMATION_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  cat $(WEBCAM_AUTOMATION_TEMPLATE) | envsubst > $@

$(WEBCAM_SENSORS): $(WEBCAM_SENSOR_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  cat $(WEBCAM_SENSOR_TEMPLATE) | envsubst > $@

$(WEBCAM_COUNTERS): $(WEBCAM_COUNTER_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  cat $(WEBCAM_COUNTER_TEMPLATE) | envsubst > $@

$(WEBCAM_BINARY_SENSORS): $(WEBCAM_BINARY_SENSOR_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  cat $(WEBCAM_BINARY_SENSOR_TEMPLATE) | envsubst > $@

$(WEBCAM_GRAPHS): $(WEBCAM_GRAPH_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@"; \
	  export MOTION_CAMERA=$${TARGET%%.*}; \
	  export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	  export MOTION_GROUP="$(MOTION_GROUP)"; \
	  cat $(WEBCAM_GRAPH_TEMPLATE) | envsubst > $@

## motion-addon.json

motion-addon.json: motion-addon.json.tmpl makefile
	@echo "making $@"
	@export \
	   MOTION_TLD="${MOTION_TLD}" \
	   MOTION_GROUP="${MOTION_GROUP}" \
	   MOTION_DEVICE="${MOTION_DEVICE}" \
	   MOTION_MQTT_HOST=${MOTION_MQTT_HOST} \
	   MOTION_MQTT_USERNAME=${MOTION_MQTT_USERNAME} \
	   MOTION_MQTT_PASSWORD=${MOTION_MQTT_PASSWORD} \
	   MOTION_COUCHDB_HOST=${MOTION_COUCHDB_HOST} \
	   MOTION_COUCHDB_USERNAME=${MOTION_COUCHDB_USERNAME} \
	   MOTION_COUCHDB_PASSWORD=${MOTION_COUCHDB_PASSWORD} \
	&& cat motion-addon.json.tmpl | envsubst > motion-addon.json
	@for C in $(WEBCAMS); do \
	  export \
	    MOTION_CAMERA_URL=$$(jq -r ".[]|select(.name==\"$${C}\")|.url" $(WEBCAMS_JSON)) \
	  && \
          jq '.|.cameras+=[ { "name": "'$${C}'", "url": "'$${MOTION_CAMERA_URL}'" } ]' motion-addon.json > motion-addon.json.$$; \
          mv motion-addon.json.$$ motion-addon.json; \
	done

## clean and clean and clean ..

tidy:
	@rm -f $(WEBCAM_YAML)
	@rm -f $(HIGHLOW_YAML)

clean: tidy
	rm -f motion-addon.json

realclean: clean

distclean: realclean

.phony: start stop restart up down logs tidy clean realclean distclean 
