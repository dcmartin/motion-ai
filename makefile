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
	-docker stop homeassistant

restart: stop all run

logs:
	docker logs -f homeassistant

## clean and clean and clean ..

clean: stop
	make -C motion clean

realclean: clean
	rm -fr home-assistant.log
	rm -fr home-assistant_v2.*
	rm -f .storage/core.restore_state

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts .storage

.phony: all default build run stop logs restart clean realclean distclean $(PACKAGES)
