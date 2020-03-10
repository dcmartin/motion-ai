ACTIONS := all run stop logs restart tidy clean realclean distclean

default:
	make -C homeassistant

$(ACTIONS):
	make -C homeassistant $@

.PHONY: all default run stop logs restart tidy clean realclean distclean $(PACKAGES)

