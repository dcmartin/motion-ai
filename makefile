###
### makefile
###

PACKAGES := motion 
#	exchange \
#	internet \
#	hznmonitor \
#	hznsetup \
#	sdr2msghub \
#	startup \
#	yolo2msghub 

default: ${PACKAGES} run

all: ${PACKAGES} run

build: $(PACKAGES)

$(PACKAGES): makefile
	${MAKE} -C $@ all

run: build
	docker start homeassistant

stop:
	docker stop homeassistant

restart:
	${MAKE} stop
	${MAKE} all

logs:
	docker logs -f homeassistant

## clean and clean and clean ..

clean:
	make -C motion clean
	docker stop homeassistant
	rm -fr home-assistant_v2.*
	rm -fr home-assistant.log
	rm -f .storage/core.restore_state
	for i in $(sudo echo /var/lib/docker/containers/*/*.log); do sudo cp /dev/null "$${i}"; done

realclean: clean
	rm -fr .storage

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts

.phony: all default build run stop logs restart clean realclean distclean $(PACKAGES)
