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

TLD := dcmartin.com
GROUP := motion

default: motion

motion: motion/camera motion/sensor motion/binary_sensor

motion/camera: motion/camera.yaml.tmpl makefile
	for C in ${CAMERAS}; do \
	  echo "making motion/camera/$${C}.yaml" > /dev/stderr; \
	  export MOTION_TLD="${TLD}" MOTION_GROUP="${GROUP}" MOTION_CAMERA="$${C}" \
	  && \
	  cat motion/camera.yaml.tmpl | envsubst > motion/camera/$${C}.yaml; \
	done

motion/sensor: motion/sensor.yaml.tmpl makefile
	for C in ${CAMERAS}; do \
	  echo "making motion/sensor/$${C}.yaml" > /dev/stderr; \
	  export MOTION_TLD="${TLD}" MOTION_GROUP="${GROUP}" MOTION_CAMERA="$${C}" \
	  && \
	  cat motion/sensor.yaml.tmpl | envsubst > motion/sensor/$${C}.yaml; \
	done

motion/binary_sensor: motion/binary_sensor.yaml.tmpl makefile
	for C in ${CAMERAS}; do \
	  echo "making motion/binary_sensor/$${C}.yaml" > /dev/stderr; \
	  export MOTION_TLD="${TLD}" MOTION_GROUP="${GROUP}" MOTION_CAMERA="$${C}" \
	  && \
	  cat motion/binary_sensor.yaml.tmpl | envsubst > motion/binary_sensor/$${C}.yaml; \
	done

up: motion
	docker start homeassistant

down:
	docker stop homeassistant

restart:
	docker restart homeassistant

logs:
	docker logs -f homeassistant

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
