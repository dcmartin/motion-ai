up:
	docker start homeassistant

down:
	docker stop homeassistant

logs:
	docker logs -f homeassistant

clean:
	docker stop homeassistant
	rm -fr home-assistant_v2.*
	rm -fr home-assistant.log

realclean: clean
	rm -fr .storage

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts
