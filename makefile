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

# domain
DOMAIN_NAME := $(if $(wildcard DOMAIN_NAME),$(shell cat DOMAIN_NAME),$(shell echo "++ WARN: DOMAIN_NAME unset; default: local" > /dev/stderr && echo "local"))

# host
HOST_NAME := $(if ${HOST_NAME},${HOST_NAME},$(shell hostname -f))
HOST_IPADDR := $(if $(wildcard HOST_IPADDR),$(shell cat HOST_IPADDR),$(shell echo "++ WARN: HOST_IPADDR unset; default: 127.0.0.1" > /dev/stderr && echo "127.0.0.1"))
HOST_NETWORK := $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK := 24
HOST_PORT := $(if $(wildcard HOST_PORT),$(shell cat HOST_PORT),$(shell echo "-- INFO: HOST_PORT unset; default: 3092" > /dev/stderr && echo "8123"))

# MQTT
MQTT_HOST := $(if $(wildcard MQTT_HOST),$(shell cat MQTT_HOST),$(shell echo "-- INFO: MQTT_HOST unset; default: core-mosquitto" > /dev/stderr && echo "core-mosquitto"))
MQTT_PORT := $(if $(wildcard MQTT_PORT),$(shell cat MQTT_PORT),$(shell echo "-- INFO: MQTT_PORT unset; default: 1883" > /dev/stderr && echo "1883"))
MQTT_USERNAME := $(if $(wildcard MQTT_USERNAME),$(shell cat MQTT_USERNAME),$(shell echo "-- INFO: MQTT_USERNAME unset; default: username" > /dev/stderr && echo "username"))
MQTT_PASSWORD := $(if $(wildcard MQTT_PASSWORD),$(shell cat MQTT_PASSWORD),$(shell echo "-- INFO: MQTT_PASSWORD unset; default: password" > /dev/stderr && echo "password"))

# webcam
WEBCAM_USERNAME := $(if $(wildcard WEBCAM_USERNAME),$(shell cat WEBCAM_USERNAME),$(shell echo "++ WARN: WEBCAM_USERNAME unset; default: $$(whoami)" > /dev/stderr && echo "$$(whoami)"))
WEBCAM_PASSWORD := $(if $(wildcard WEBCAM_PASSWORD),$(shell cat WEBCAM_PASSWORD),$(shell read -p "Specify WEBCAM_PASSWORD: " && echo $${REPLY} | tee WEBCAM_PASSWORD))

# netdata
NETDATA_URL := $(if $(wildcard NETDATA_URL),$(shell cat NETDATA_URL),$(shell echo "-- INFO: NETDATA_URL unset; default: http://${HOST_IPADDR}:19999/" > /dev/stderr && echo "http://${HOST_IPADDR}:19999/"))

# nVidia DIGITS
DIGITS_URL := $(if $(wildcard DIGITS_URL),$(shell cat DIGITS_URL),http://digits.$(DOMAIN_NAME):5000/)

# couchdb
COUCHDB_URL := $(if $(wildcard COUCHDB_URL),$(shell cat COUCHDB_URL),http://couchdb.$(DOMAIN_NAME):5984/_utils)

# edgex
EDGEX_URL := $(if $(wildcard EDGEX_URL),$(shell cat EDGEX_URL),http://edgex.$(DOMAIN_NAME):4000)
CONSUL_URL := $(if $(wildcard CONSUL_URL),$(shell cat CONSUL_URL),http://consul.$(DOMAIN_NAME):8500/ui)

# open-horizon
EXCHANGE_URL := $(if $(wildcard EXCHANGE_URL),$(shell cat EXCHANGE_URL),http://exchange.$(DOMAIN_NAME):3090)
EXCHANGE_ORG := $(if $(wildcard EXCHANGE_ORG),$(shell cat EXCHANGE_ORG),$(shell whoami))
EXCHANGE_ORG_ADMIN := $(if $(wildcard EXCHANGE_ORG_ADMIN),$(shell cat EXCHANGE_ORG_ADMIN),${EXCHANGE_ORG})
EXCHANGE_APIKEY := $(if $(wildcard EXCHANGE_APIKEY),$(shell cat EXCHANGE_APIKEY),$(shell read -p "Specify EXCHANGE_APIKEY: " && echo $${REPLY} | tee EXCHANGE_APIKEY))
HZNMONITOR_URL := $(if $(wildcard HZNMONITOR_URL),$(shell cat HZNMONITOR_URL),http://hznmonitor.$(DOMAIN_NAME):3094)

# grafana
GRAFANA_URL := $(if $(wildcard GRAFANA_URL),$(shell cat GRAFANA_URL),http://grafana.$(DOMAIN_NAME):3000)

# influxdb
INFLUXDB_HOST := $(if $(wildcard INFLUXDB_HOST),$(shell cat INFLUXDB_HOST),influxdb.$(DOMAIN_NAME))
INFLUXDB_PASSWORD := $(if $(wildcard INFLUXDB_PASSWORD),$(shell cat INFLUXDB_PASSWORD),ask4it)

default: all run

TARGETS := build all

${TARGETS}: makefile
	@for P in ${PACKAGES}; do ${MAKE} -C $${P} $@; done

run: configuration.yaml secrets.yaml
	docker start homeassistant

stop:
	-docker stop homeassistant

restart: stop all run

logs:
	docker logs -f homeassistant

secrets.yaml: secrets.yaml.tmpl makefile
	@echo "making $@"
	@export \
	  HOST_NAME="$(HOST_NAME)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
	  HOST_NETWORK="$(HOST_NETWORK)" \
	  HOST_NETWORK_MASK="$(HOST_NETWORK_MASK)" \
	  HOST_PORT="$(HOST_PORT)" \
	  HZNMONITOR_URL="$(HZNMONITOR_URL)" \
	  CONSUL_URL="$(CONSUL_URL)" \
	  COUCHDB_URL="$(COUCHDB_URL)" \
	  DIGITS_URL="$(DIGITS_URL)" \
	  EDGEX_URL="$(EDGEX_URL)" \
	  EXCHANGE_URL="$(EXCHANGE_URL)" \
	  EXCHANGE_APIKEY="$(EXCHANGE_APIKEY)" \
	  EXCHANGE_ORG="$(EXCHANGE_ORG)" \
	  EXCHANGE_ORG_ADMIN="$(EXCHANGE_ORG_ADMIN)" \
	  GRAFANA_URL="$(GRAFANA_URL)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  INFLUXDB_HOST="$(INFLUXDB_HOST)" \
	  INFLUXDB_PASSWORD="$(INFLUXDB_PASSWORD)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  WEBCAM_USERNAME="$(WEBCAM_USERNAME)" \
	  WEBCAM_PASSWORD="$(WEBCAM_PASSWORD)" \
	&& cat secrets.yaml.tmpl | envsubst > $@

## clean and clean and clean ..

clean: stop
	make -C motion clean

realclean: clean
	rm -f known_devices.yaml
	rm -fr home-assistant.log
	rm -fr home-assistant_v2.*
	rm -f .storage/core.restore_state

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts .storage

.phony: all default build run stop logs restart clean realclean distclean $(PACKAGES)
