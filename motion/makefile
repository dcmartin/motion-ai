###
### makefile
###

MOTION_TLD := dcmartin.com
MOTION_GROUP := motion

MOTION_MQTT_HOST := $(MOTION_MQTT_HOST:-mqtt.$(TLD))
MOTION_MQTT_USERNAME := $(MOTION_MQTT_USERNAME:-username)
MOTION_MQTT_PASSWORD := $(MOTION_MQTT_PASSWORD:-password)

MOTION_COUCHDB_HOST := $(MOTION_COUCHDB_HOST:-couchdb.$(TLD))
MOTION_COUCHDB_USERNAME := $(MOTION_COUCHDB_USERNAME:-username)
MOTION_COUCHDB_PASSWORD := $(MOTION_COUCHDB_PASSWORD:-password)

## FTP webcams

WEBCAMS := \
	backyard \
	diningroom \
	dogpond \
	dogshedfront \
	dogshedmiddle \
	dogshed \
	dogyard \
	fireplace \
	foyer \
	frontdoor \
	frontwalk \
	gravelpad \
	laundry \
	livingroom \
	phexterior \
	pondview \
	sideyard \
	upperpathgate \
	woodshed

WEBCAM_COUNTERS := $(shell for C in $(WEBCAMS); do echo counter/webcam-$${C}.yaml; done)
WEBCAM_SENSORS := $(shell for C in $(WEBCAMS); do echo sensor/webcam-$${C}.yaml; done)
WEBCAM_CAMERAS := $(shell for C in $(WEBCAMS); do echo camera/webcam-$${C}.yaml; done)
WEBCAM_AUTOMATIONS := $(shell for C in $(WEBCAMS); do echo automation/webcam-$${C}.yaml; done)
WEBCAM_BINARY_SENSORS := $(shell for C in $(WEBCAMS); do echo binary_sensor/webcam-$${C}.yaml; done)
WEBCAM_YAML := $(WEBCAM_AUTOMATIONS) $(WEBCAM_CAMERAS) $(WEBCAM_COUNTERS) $(WEBCAM_SENSORS) $(WEBCAM_BINARY_SENSORS) 

WEBCAM_COUNTER_TEMPLATE := counter.webcam.yaml.tmpl
WEBCAM_SENSOR_TEMPLATE := sensor.webcam.yaml.tmpl
WEBCAM_CAMERA_TEMPLATE := camera.webcam.yaml.tmpl
WEBCAM_AUTOMATION_TEMPLATE := automation.webcam.yaml.tmpl
WEBCAM_BINARY_SENSOR_TEMPLATE := binary_sensor.webcam.yaml.tmpl

## template(s)

HIGHLOW_TEMPLATE := binary_sensor.highlow.yaml.tmpl
HIGHLOW_SENSORS := image end annotated detected detected_entity
HIGHLOW_ITEMS := count ago
HIGHLOW_YAML := $(shell for SENSOR in $(HIGHLOW_SENSORS); do for ITEM in $(HIGHLOW_ITEMS); do echo "binary_sensor/highlow-$${SENSOR}_$${ITEM}.yaml"; done; done)

## default target build requisites

default: all

all:  $(WEBCAM_YAML) $(HIGHLOW_YAML) motion-addon.json

## templates

$(HIGHLOW_YAML): $(HIGHLOW_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@" PKG="motion"; \
	export ITEM=$${TARGET##*_}; \
	export ITEM=$${ITEM%%.*}; \
	export SENSOR=$${TARGET%%_$${TARGET##*_}}; \
	export SENSOR=$${SENSOR##*-}; \
	cat $(HIGHLOW_TEMPLATE) | envsubst > $@

## webcams

$(WEBCAM_AUTOMATIONS): $(WEBCAM_AUTOMATION_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@" PKG="motion"; \
	export MOTION_CAMERA=$${TARGET%%.*}; \
	export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	export MOTION_TLD="$(MOTION_TLD)" MOTION_GROUP="$(MOTION_GROUP)"; \
	cat $(WEBCAM_AUTOMATION_TEMPLATE) | envsubst > $@

$(WEBCAM_CAMERAS): $(WEBCAM_CAMERA_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@" PKG="motion"; \
	export MOTION_CAMERA=$${TARGET%%.*}; \
	export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	export MOTION_TLD="$(MOTION_TLD)" MOTION_GROUP="$(MOTION_GROUP)"; \
	cat $(WEBCAM_CAMERA_TEMPLATE) | envsubst > $@

$(WEBCAM_SENSORS): $(WEBCAM_SENSOR_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@" PKG="motion"; \
	export MOTION_CAMERA=$${TARGET%%.*}; \
	export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	export MOTION_TLD="$(MOTION_TLD)" MOTION_GROUP="$(MOTION_GROUP)"; \
	cat $(WEBCAM_SENSOR_TEMPLATE) | envsubst > $@

$(WEBCAM_COUNTERS): $(WEBCAM_COUNTER_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@" PKG="motion"; \
	export MOTION_CAMERA=$${TARGET%%.*}; \
	export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	export MOTION_TLD="$(MOTION_TLD)" MOTION_GROUP="$(MOTION_GROUP)"; \
	cat $(WEBCAM_COUNTER_TEMPLATE) | envsubst > $@

$(WEBCAM_BINARY_SENSORS): $(WEBCAM_BINARY_SENSOR_TEMPLATE) makefile
	@echo "making $@"
	@export TARGET="$@" PKG="motion"; \
	export MOTION_CAMERA=$${TARGET%%.*}; \
	export MOTION_CAMERA=$${MOTION_CAMERA##*-}; \
	export MOTION_TLD="$(MOTION_TLD)" MOTION_GROUP="$(MOTION_GROUP)"; \
	cat $(WEBCAM_BINARY_SENSOR_TEMPLATE) | envsubst > $@
 
## motion-addon.json

motion-addon.json: motion-addon.json.tmpl makefile
	@echo "making $@"
	@export \
	  MOTION_TLD="$(MOTION_TLD)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_MQTT_HOST=$(MOTION_MQTT_HOST) \
	  MOTION_MQTT_USERNAME=$(MOTION_MQTT_USERNAME) \
	  MOTION_MQTT_PASSWORD=$(MOTION_MQTT_PASSWORD) \
	  MOTION_COUCHDB_HOST=$(MOTION_COUCHDB_HOST) \
	  MOTION_COUCHDB_USERNAME=$(MOTION_COUCHDB_USERNAME) \
	  MOTION_COUCHDB_PASSWORD=$(MOTION_COUCHDB_PASSWORD) \
	&& \
	cat motion-addon.json.tmpl | envsubst > motion-addon.json; \
	for C in $(WEBCAMS); do \
	  export MOTION_GROUP="$(MOTION_GROUP)" MOTION_CAMERA="$${C}" \
	  && \
          jq '.|.cameras+=[ { "name": "'$${C}'", "url": "ftpd:///share/ftp/'$${C}'" } ]' motion-addon.json > motion-addon.json.$$; \
          mv motion-addon.json.$$ motion-addon.json; \
	done


## make up, down, restart, logs

start up: motion
	docker start homeassistant

stop down:
	docker stop homeassistant

restart: down up

logs:
	docker logs -f homeassistant

## clean and clean and clean ..

tidy:
	@rm -f $(WEBCAM_YAML)
	@rm -f $(HIGHLOW_YAML)

clean: tidy
	rm -f motion-addon.json

realclean: clean

distclean: realclean

.phony: start stop restart up down logs tidy clean realclean distclean 
