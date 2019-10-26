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

default: all run

TARGETS := build all

${TARGETS}: makefile
	for P in ${PACKAGES}; do ${MAKE} -C $${P} $@; done

run:
	docker start homeassistant

stop:
	docker stop homeassistant

restart: stop all run

logs:
	docker logs -f homeassistant

## clean and clean and clean ..

clean:
	docker stop homeassistant
	make -C motion clean
	rm -f .storage/core.restore_state

realclean: clean
	rm -fr home-assistant.log
	rm -fr home-assistant_v2.*
	rm -fr .storage
	for i in $(sudo echo /var/lib/docker/containers/*/*.log); do sudo cp /dev/null "$${i}"; done

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts

.phony: all default build run stop logs restart clean realclean distclean $(PACKAGES)
