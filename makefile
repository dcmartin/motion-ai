###
### makefile for MOTION
###

MOTION_TLD := dcmartin.com
MOTION_GROUP := motion

MOTION_MQTT_HOST := ${MOTION_MQTT_HOST:-mqtt.${TLD}}
MOTION_MQTT_USERNAME := ${MOTION_MQTT_USERNAME:-mqtt.${TLD}}
MOTION_MQTT_PASSWORD := ${MOTION_MQTT_PASSWORD:-mqtt.${TLD}}

MOTION_COUCHDB_HOST := ${MOTION_COUCHDB_HOST:-couchdb.${TLD}}
MOTION_COUCHDB_USERNAME := ${MOTION_COUCHDB_USERNAME:-couchdb.${TLD}}
MOTION_COUCHDB_PASSWORD := ${MOTION_COUCHDB_PASSWORD:-couchdb.${TLD}}

CAMERAS := \
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

## default target build requisites

default: motion

motion: motion/camera motion/sensor motion/binary_sensor

motion-addon.json: motion-addon.json.tmpl makefile
	export \
	  MOTION_TLD="${MOTION_TLD}" \
	  MOTION_GROUP="${MOTION_GROUP}" \
	  MOTION_CAMERA="$${C}" \
	  MOTION_MQTT_HOST=${MOTION_MQTT_HOST} \
	  MOTION_MQTT_USERNAME=${MOTION_MQTT_USERNAME} \
	  MOTION_MQTT_PASSWORD=${MOTION_MQTT_PASSWORD} \
	  MOTION_COUCHDB_HOST=${MOTION_COUCHDB_HOST} \
	  MOTION_COUCHDB_USERNAME=${MOTION_COUCHDB_USERNAME} \
	  MOTION_COUCHDB_PASSWORD=${MOTION_COUCHDB_PASSWORD} \
	&& \
	cat motion-addon.json.tmpl | envsubst > motion-addon.json
	@for C in ${CAMERAS}; do \
	  export MOTION_GROUP="${GROUP}" MOTION_CAMERA="$${C}" \
	  && \
          jq '.|.cameras+=[ { "name": "'$${C}'", "url": "ftpd:///share/ftp/'$${C}'" } ]' motion-addon.json > motion-addon.json.$$; \
          mv motion-addon.json.$$ motion-addon.json; \
	done

motion/camera: motion/camera.yaml.tmpl makefile
	@for C in ${CAMERAS}; do \
	  echo "making motion/camera/camera-$${C}.yaml" > /dev/stderr; \
	  export MOTION_TLD="${MOTION_TLD}" MOTION_GROUP="${MOTION_GROUP}" MOTION_CAMERA="$${C}" \
	  && \
	  cat motion/camera.yaml.tmpl | envsubst > motion/camera/camera-$${C}.yaml; \
	done

motion/sensor: motion/sensor.yaml.tmpl makefile
	@for C in ${CAMERAS}; do \
	  echo "making motion/sensor/camera-$${C}.yaml" > /dev/stderr; \
	  export MOTION_TLD="${MOTION_TLD}" MOTION_GROUP="${MOTION_GROUP}" MOTION_CAMERA="$${C}" \
	  && \
	  cat motion/sensor.yaml.tmpl | envsubst > motion/sensor/camera-$${C}.yaml; \
	done

motion/binary_sensor: motion/binary_sensor.yaml.tmpl makefile
	@for C in ${CAMERAS}; do \
	  echo "making motion/binary_sensor/camera-$${C}.yaml" > /dev/stderr; \
	  export MOTION_TLD="${MOTION_TLD}" MOTION_GROUP="${MOTION_GROUP}" MOTION_CAMERA="$${C}" \
	  && \
	  cat motion/binary_sensor.yaml.tmpl | envsubst > motion/binary_sensor/camera-$${C}.yaml; \
	done

## remove dynamic files

remove:
	@for C in ${CAMERAS}; do \
	  echo "removing files for camera-$${C}" > /dev/stderr; \
	  rm -f motion/camera/camera-$${C}.yaml; \
	  rm -f motion/sensor/camera-$${C}.yaml; \
	  rm -f motion/binary_sensor/camera-$${C}.yaml; \
	done
	rm -f motion-addon.json

## make up, down, restart, logs

up: motion
	docker start homeassistant

down:
	docker stop homeassistant

restart: down up

logs:
	docker logs -f homeassistant

## clean and clean and clean ..

clean:
	docker stop homeassistant
	rm -fr home-assistant_v2.*
	rm -fr home-assistant.log
	rm -f .storage/core.restore_state

realclean: clean
	rm -fr .storage
	for i in /var/log/docker/containers/*.log ; do cp /dev/null "$i"; done

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts

.phony: up down logs clean realclean distclean motion motion/camera motion/sensor motion/binary_sensor
