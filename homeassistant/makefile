###
### makefile
###

SETUP := setup.json
TIMESTAMP ?= $(shell date -u '%FT%TZ')
THIS_HOSTIP ?= $(shell hostname -i | awk '{ print $$1 }')

WEATHER_AMBIENT_MAC ?= $(if $(wildcard WEATHER_AMBIENT_MAC),$(shell v=$$(cat WEATHER_AMBIENT_MAC) && echo "${TG}== WEATHER_AMBIENT_MAC: $${v}${NC}" > /dev/stderr && echo "$${v}"),,$(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.WEATHER_AMBIENT_MAC' $(SETUP)) && echo "${TS}++ WEATHER_AMBIENT_MAC: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='warn' && echo "${TB}** WEATHER_AMBIENT_MAC unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")
WEATHER_AMBIENT_APPKEY ?= $(if $(wildcard WEATHER_AMBIENT_APPKEY),$(shell v=$$(cat WEATHER_AMBIENT_APPKEY) && echo "${TG}== WEATHER_AMBIENT_APPKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),,$(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.WEATHER_AMBIENT_APPKEY' $(SETUP)) && echo "${TS}++ WEATHER_AMBIENT_APPKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='warn' && echo "${TB}** WEATHER_AMBIENT_APPKEY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")
WEATHER_AMBIENT_APIKEY ?= $(if $(wildcard WEATHER_AMBIENT_APIKEY),$(shell v=$$(cat WEATHER_AMBIENT_APIKEY) && echo "${TG}== WEATHER_AMBIENT_APIKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),,$(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.WEATHER_AMBIENT_APIKEY' $(SETUP)) && echo "${TS}++ WEATHER_AMBIENT_APIKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='warn' && echo "${TB}** WEATHER_AMBIENT_APIKEY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")
LOGGER_SET_STATE ?= $(if $(wildcard LOGGER_SET_STATE),$(shell v=$$(cat LOGGER_SET_STATE) && echo "${TG}== LOGGER_SET_STATE: $${v}${NC}" > /dev/stderr && echo "$${v}"),,$(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.LOGGER_SET_STATE' $(SETUP)) && echo "${TS}++ LOGGER_SET_STATE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='warn' && echo "${TB}** LOGGER_SET_STATE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")
))

UPTIMEROBOT_RSSURL ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.UPTIMEROBOT_RSSURL' $(SETUP)) && echo "${TS}++ UPTIMEROBOT_RSSURL: $${v}${NC}" > /dev/stderr && echo "$${v}"), $(if $(wildcard UPTIMEROBOT_RSSURL),$(shell v=$$(cat UPTIMEROBOT_RSSURL) && echo "${TG}== UPTIMEROBOT_RSSURL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='https://rss.uptimerobot.com/status' && echo "${TB}** UPTIMEROBOT_RSSURL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_REPOSITORY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_REPOSITORY' $(SETUP)) && echo "${TS}++ MOTION_REPOSITORY: $${v}${NC}" > /dev/stderr && echo "$${v}"), $(if $(wildcard MOTION_REPOSITORY),$(shell v=$$(cat MOTION_REPOSITORY) && echo "${TG}== MOTION_REPOSITORY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='https://github.com/motion-ai/motion-ai.git' && echo "${TB}** MOTION_REPOSITORY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# logging
LOGGER_DEFAULT ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.LOGGER_DEFAULT' $(SETUP)) && echo "${TS}++ LOGGER_DEFAULT: $${v}${NC}" > /dev/stderr && echo "$${v}"), $(if $(wildcard LOGGER_DEFAULT),$(shell v=$$(cat LOGGER_DEFAULT) && echo "${TG}== LOGGER_DEFAULT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "${TB}** LOGGER_DEFAULT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

LOGGER_MQTT ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.LOGGER_MQTT' $(SETUP)) && echo "${TS}++ LOGGER_MQTT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard LOGGER_MQTT),$(shell v=$$(cat LOGGER_MQTT) && echo "${TG}== LOGGER_MQTT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "${TB}** LOGGER_MQTT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
LOGGER_AUTOMATION ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.LOGGER_AUTOMATION' $(SETUP)) && echo "${TS}++ LOGGER_AUTOMATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard LOGGER_AUTOMATION),$(shell v=$$(cat LOGGER_AUTOMATION) && echo "${TG}== LOGGER_AUTOMATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="warn" && echo "${TB}** LOGGER_AUTOMATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_LOG_LEVEL ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_LOG_LEVEL' $(SETUP)) && echo "${TS}++ MOTION_LOG_LEVEL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_LOG_LEVEL),$(shell v=$$(cat MOTION_LOG_LEVEL) && echo "${TG}== MOTION_LOG_LEVEL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="info" && echo "${TB}** MOTION_LOG_LEVEL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# automation(s)
AUTOMATION_INTERNET ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.AUTOMATION_INTERNET' $(SETUP)) && echo "${TS}++ AUTOMATION_INTERNET: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard AUTOMATION_INTERNET),$(shell v=$$(cat AUTOMATION_INTERNET) && echo "${TG}== AUTOMATION_INTERNET: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell echo "** AUTOMATION_INTERNET unset; default: off" > /dev/stderr && echo "off")))
AUTOMATION_INTRANET ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.AUTOMATION_INTRANET' $(SETUP)) && echo "${TS}++ AUTOMATION_INTRANET: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard AUTOMATION_INTRANET),$(shell v=$$(cat AUTOMATION_INTRANET) && echo "${TG}== AUTOMATION_INTRANET: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell echo "** AUTOMATION_INTRANET unset; default: off" > /dev/stderr && echo "off")))

# domain
DOMAIN_NAME := $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.DOMAIN_NAME' $(SETUP)) && echo "${TS}++ DOMAIN_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard DOMAIN_NAME),$(shell v=$$(cat DOMAIN_NAME) && echo "${TG}== DOMAIN_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -d) && v=$${v:-local} && echo "${TB}** DOMAIN_NAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# host
HOST_NAME ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.HOST_NAME' $(SETUP)) && echo "${TS}++ HOST_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard HOST_NAME),$(shell v=$$(cat HOST_NAME) && echo "${TG}== HOST_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(hostname -f) && v=$${v%%.*} && echo "${TB}** HOST_NAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
HOST_TIMEZONE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.HOST_TIMEZONE' $(SETUP)) && echo "${TS}++ HOST_TIMEZONE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard HOST_TIMEZONE),$(shell v=$$(cat HOST_TIMEZONE) && echo "${TG}== HOST_TIMEZONE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="GMT" && echo "${TB}** HOST_TIMEZONE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
HOST_IPADDR ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.HOST_IPADDR' $(SETUP)) && echo "${TS}++ HOST_IPADDR: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard HOST_IPADDR),$(shell v=$$(cat HOST_IPADDR) && echo "${TG}== HOST_IPADDR: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=${THIS_HOSTIP} && echo "${TB}** HOST_IPADDR unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
HOST_PORT ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.HOST_PORT' $(SETUP)) && echo "${TS}++ HOST_PORT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard HOST_PORT),$(shell v=$$(cat HOST_PORT) && echo "${TG}== HOST_PORT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="8123" && echo "${TB}** HOST_PORT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
HOST_THEME ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.HOST_THEME' $(SETUP)) && echo "${TS}++ HOST_THEME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard HOST_THEME),$(shell v=$$(cat HOST_THEME) && echo "${TG}== HOST_THEME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="default" && echo "${TB}** HOST_THEME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
HOST_NETWORK ?= $(shell export HOST_IPADDR=$(HOST_IPADDR) && echo $${HOST_IPADDR%.*}.0)
HOST_NETWORK_MASK ?= 24

HOST_LATITUDE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.HOST_LATITUDE' $(SETUP)) && echo "${TS}++ HOST_LATITUDE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard HOST_LATITUDE),$(shell v=$$(cat HOST_LATITUDE) && echo "${TG}== HOST_LATITUDE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "${TB}** HOST_LATITUDE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
HOST_LONGITUDE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.HOST_LONGITUDE' $(SETUP)) && echo "${TS}++ HOST_LONGITUDE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard HOST_LONGITUDE),$(shell v=$$(cat HOST_LONGITUDE) && echo "${TG}== HOST_LONGITUDE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="0.0" && echo "${TB}** HOST_LONGITUDE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

## MOTION
MOTION_SITE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_SITE' $(SETUP)) && echo "${TS}++ MOTION_SITE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_SITE),$(shell v=$$(cat MOTION_SITE) && echo "${TG}== MOTION_SITE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=${HOST_NAME} && echo "${TB}** MOTION_SITE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_APP ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_APP' $(SETUP)) && echo "${TS}++ MOTION_APP: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_APP),$(shell v=$$(cat MOTION_APP) && echo "${TG}== MOTION_APP: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='Motion Ã👁' && echo "${TB}** MOTION_APP unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_GROUP ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_GROUP' $(SETUP)) && echo "${TS}++ MOTION_GROUP: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_GROUP),$(shell v=$$(cat MOTION_GROUP) && echo "${TG}== MOTION_GROUP: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='motion' && echo "${TB}** MOTION_GROUP unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DEVICE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DEVICE' $(SETUP)) && echo "${TS}++ MOTION_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DEVICE),$(shell v=$$(cat MOTION_DEVICE) && echo "${TG}== MOTION_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v=$$(echo $(HOST_NAME) | sed -e "s/-//g" -e "s/ /_/g") && echo "${TB}** MOTION_DEVICE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_CLIENT ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_CLIENT' $(SETUP)) && echo "${TS}++ MOTION_CLIENT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_CLIENT),$(shell v=$$(cat MOTION_CLIENT) && echo "${TG}== MOTION_CLIENT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='$(MOTION_DEVICE)' && echo "${TB}** MOTION_CLIENT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_USER ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_USER' $(SETUP)) && echo "${TS}++ MOTION_USER: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_USER),$(shell v=$$(cat MOTION_USER) && echo "${TG}== MOTION_USER: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='unknown' && echo "${TB}** MOTION_USER unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_PRIMARY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_PRIMARY' $(SETUP)) && echo "${TS}++ MOTION_PRIMARY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_PRIMARY),$(shell v=$$(cat MOTION_PRIMARY) && echo "${TG}== MOTION_PRIMARY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='unknown' && echo "${TB}** MOTION_PRIMARY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_SECONDARY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_SECONDARY' $(SETUP)) && echo "${TS}++ MOTION_SECONDARY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_SECONDARY),$(shell v=$$(cat MOTION_SECONDARY) && echo "${TG}== MOTION_SECONDARY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='unknown' && echo "${TB}** MOTION_SECONDARY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_TERTIARY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_TERTIARY' $(SETUP)) && echo "${TS}++ MOTION_TERTIARY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_TERTIARY),$(shell v=$$(cat MOTION_TERTIARY) && echo "${TG}== MOTION_TERTIARY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='unknown' && echo "${TB}** MOTION_TERTIARY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_USER_DEVICE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_USER_DEVICE' $(SETUP)) && echo "${TS}++ MOTION_USER_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_USER_DEVICE),$(shell v=$$(cat MOTION_USER_DEVICE) && echo "${TG}== MOTION_USER_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='unknown' && echo "${TB}** MOTION_USER_DEVICE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_PRIMARY_DEVICE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_PRIMARY_DEVICE' $(SETUP)) && echo "${TS}++ MOTION_PRIMARY_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_PRIMARY_DEVICE),$(shell v=$$(cat MOTION_PRIMARY_DEVICE) && echo "${TG}== MOTION_PRIMARY_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='unknown' && echo "${TB}** MOTION_PRIMARY_DEVICE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_SECONDARY_DEVICE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_SECONDARY_DEVICE' $(SETUP)) && echo "${TS}++ MOTION_SECONDARY_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_SECONDARY_DEVICE),$(shell v=$$(cat MOTION_SECONDARY_DEVICE) && echo "${TG}== MOTION_SECONDARY_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='unknown' && echo "${TB}** MOTION_SECONDARY_DEVICE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_TERTIARY_DEVICE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_TERTIARY_DEVICE' $(SETUP)) && echo "${TS}++ MOTION_TERTIARY_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_TERTIARY_DEVICE),$(shell v=$$(cat MOTION_TERTIARY_DEVICE) && echo "${TG}== MOTION_TERTIARY_DEVICE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='unknown' && echo "${TB}** MOTION_TERTIARY_DEVICE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_NOTIFY_SMARTPHONE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_NOTIFY_SMARTPHONE' $(SETUP)) && echo "${TS}++ MOTION_NOTIFY_SMARTPHONE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_NOTIFY_SMARTPHONE),$(shell v=$$(cat MOTION_NOTIFY_SMARTPHONE) && echo "${TG}== MOTION_NOTIFY_SMARTPHONE: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_NOTIFY_SMARTPHONE unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_ROUTER_NAME ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_ROUTER_NAME' $(SETUP)) && echo "${TS}++ MOTION_ROUTER_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_ROUTER_NAME),$(shell v=$$(cat MOTION_ROUTER_NAME) && echo "${TG}== MOTION_ROUTER_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='mikrotik_router' && echo "${TB}** MOTION_ROUTER_NAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

# MQTT
MQTT_HOST ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MQTT_HOST' $(SETUP)) && echo "${TS}++ MQTT_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"), $(if $(wildcard MQTT_HOST),$(shell v=$$(cat MQTT_HOST) && echo "${TG}== MQTT_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="core-mosquitto" && echo "${TB}** MQTT_HOST unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MQTT_PORT ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MQTT_PORT' $(SETUP)) && echo "${TS}++ MQTT_PORT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MQTT_PORT),$(shell v=$$(cat MQTT_PORT) && echo "${TG}== MQTT_PORT: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="1883" && echo "${TB}** MQTT_PORT unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MQTT_USERNAME ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MQTT_USERNAME' $(SETUP)) && echo "${TS}++ MQTT_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MQTT_USERNAME),$(shell v=$$(cat MQTT_USERNAME) && echo "${TG}== MQTT_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** MQTT_USERNAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MQTT_PASSWORD ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MQTT_PASSWORD' $(SETUP)) && echo "${TS}++ MQTT_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MQTT_PASSWORD),$(shell v=$$(cat MQTT_PASSWORD) && echo "${TG}== MQTT_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${TB}** MQTT_PASSWORD unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# MARIADB
MARIADB_PASSWORD ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MARIADB_PASSWORD' $(SETUP)) && echo "${TS}++ MARIADB_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MARIADB_PASSWORD),$(shell v=$$(cat MARIADB_PASSWORD) && echo "${TG}== MARIADB_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="HomeAssistant1234" && echo "${TB}** MARIADB_PASSWORD unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MARIADB_HOST ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MARIADB_HOST' $(SETUP)) && echo "${TS}++ MARIADB_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MARIADB_HOST),$(shell v=$$(cat MARIADB_HOST) && echo "${TG}== MARIADB_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="core-mariadb" && echo "${TB}** MARIADB_HOST unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# INFLUXDB
INFLUXDB_HOST ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.INFLUXDB_HOST' $(SETUP)) && echo "${TS}++ INFLUXDB_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard INFLUXDB_HOST),$(shell v=$$(cat INFLUXDB_HOST) && echo "${TG}== INFLUXDB_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="core-mariadb" && echo "${TB}** INFLUXDB_HOST unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
INFLUXDB_DATABASE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.INFLUXDB_DATABASE' $(SETUP)) && echo "${TS}++ INFLUXDB_DATABASE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard INFLUXDB_DATABASE),$(shell v=$$(cat INFLUXDB_DATABASE) && echo "${TG}== INFLUXDB_DATABASE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='$(HOST_NAME)' && echo "${TB}** INFLUXDB_DATABASE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
INFLUXDB_USERNAME ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.INFLUXDB_USERNAME' $(SETUP)) && echo "${TS}++ INFLUXDB_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard INFLUXDB_USERNAME),$(shell v=$$(cat INFLUXDB_USERNAME) && echo "${TG}== INFLUXDB_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="HomeAssistant1234" && echo "${TB}** INFLUXDB_USERNAME unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
INFLUXDB_PASSWORD ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.INFLUXDB_PASSWORD' $(SETUP)) && echo "${TS}++ INFLUXDB_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard INFLUXDB_PASSWORD),$(shell v=$$(cat INFLUXDB_PASSWORD) && echo "${TG}== INFLUXDB_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="HomeAssistant1234" && echo "${TB}** INFLUXDB_PASSWORD unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

IPERF_HOST ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.IPERF_HOST' $(SETUP)) && echo "${TS}++ IPERF_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard IPERF_HOST),$(shell v=$$(cat IPERF_HOST) && echo "${TG}== IPERF_HOST: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="127.0.0.1" && echo "${TB}** IPERF_HOST unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_DETECT_ENTITY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECT_ENTITY' $(SETUP)) && echo "${TS}++ MOTION_DETECT_ENTITY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECT_ENTITY),$(shell v=$$(cat MOTION_DETECT_ENTITY) && echo "${TG}== MOTION_DETECT_ENTITY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="none" && echo "${TB}** MOTION_DETECT_ENTITY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_EXPIRE_AFTER ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_EXPIRE_AFTER' $(SETUP)) && echo "${TS}++ MOTION_EXPIRE_AFTER: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_EXPIRE_AFTER),$(shell v=$$(cat MOTION_EXPIRE_AFTER) && echo "${TG}== MOTION_EXPIRE_AFTER: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="5" && echo "${TB}** MOTION_EXPIRE_AFTER unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_FORCE_UPDATE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_FORCE_UPDATE' $(SETUP)) && echo "${TS}++ MOTION_FORCE_UPDATE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_FORCE_UPDATE),$(shell v=$$(cat MOTION_FORCE_UPDATE) && echo "${TG}== MOTION_FORCE_UPDATE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="false" && echo "${TB}** MOTION_FORCE_UPDATE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_MEDIA_SAVE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_MEDIA_SAVE' $(SETUP)) && echo "${TS}++ MOTION_MEDIA_SAVE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_MEDIA_SAVE),$(shell v=$$(cat MOTION_MEDIA_SAVE) && echo "${TG}== MOTION_MEDIA_SAVE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="true" && echo "${TB}** MOTION_MEDIA_SAVE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_MEDIA_MASK ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_MEDIA_MASK' $(SETUP)) && echo "${TS}++ MOTION_MEDIA_MASK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_MEDIA_MASK),$(shell v=$$(cat MOTION_MEDIA_MASK) && echo "${TG}== MOTION_MEDIA_MASK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="true" && echo "${TB}** MOTION_MEDIA_MASK unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_CAMERA_RESTART ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_CAMERA_RESTART' $(SETUP)) && echo "${TS}++ MOTION_CAMERA_RESTART: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_CAMERA_RESTART),$(shell v=$$(cat MOTION_CAMERA_RESTART) && echo "${TG}== MOTION_CAMERA_RESTART: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="true" && echo "${TB}** MOTION_CAMERA_RESTART unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_CAMERA_ANY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_CAMERA_ANY' $(SETUP)) && echo "${TS}++ MOTION_CAMERA_ANY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_CAMERA_ANY),$(shell v=$$(cat MOTION_CAMERA_ANY) && echo "${TG}== MOTION_CAMERA_ANY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="false" && echo "${TB}** MOTION_CAMERA_ANY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_YOLO_IP ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_YOLO_IP' $(SETUP)) && echo "${TS}++ MOTION_YOLO_IP: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_YOLO_IP),$(shell v=$$(cat MOTION_YOLO_IP) && echo "${TG}== MOTION_YOLO_IP: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='${THIS_HOSTIP}' && echo "${TB}** MOTION_YOLO_IP unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_TWILIO_NAME ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_TWILIO_NAME' $(SETUP)) && echo "${TS}++ MOTION_TWILIO_NAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_TWILIO_NAME),$(shell v=$$(cat MOTION_TWILIO_NAME) && echo "${TG}== MOTION_TWILIO_NAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='twilio' && echo "${TB}** MOTION_TWILIO_NAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_TWILIO_NUMBER ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_TWILIO_NUMBER' $(SETUP)) && echo "${TS}++ MOTION_TWILIO_NUMBER: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_TWILIO_NUMBER),$(shell v=$$(cat MOTION_TWILIO_NUMBER) && echo "${TG}== MOTION_TWILIO_NUMBER: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${TB}** MOTION_TWILIO_NUMBER unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_TWILIO_SID ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_TWILIO_SID' $(SETUP)) && echo "${TS}++ MOTION_TWILIO_SID: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_TWILIO_SID),$(shell v=$$(cat MOTION_TWILIO_SID) && echo "${TG}== MOTION_TWILIO_SID: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${TB}** MOTION_TWILIO_SID unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_TWILIO_TOKEN ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_TWILIO_TOKEN' $(SETUP)) && echo "${TS}++ MOTION_TWILIO_TOKEN: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_TWILIO_TOKEN),$(shell v=$$(cat MOTION_TWILIO_TOKEN) && echo "${TG}== MOTION_TWILIO_TOKEN: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${TB}** MOTION_TWILIO_TOKEN unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_W3W_APIKEY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_W3W_APIKEY' $(SETUP)) && echo "${TS}++ MOTION_W3W_APIKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_W3W_APIKEY),$(shell v=$$(cat MOTION_W3W_APIKEY) && echo "${TG}== MOTION_W3W_APIKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="none" && echo "${TB}** MOTION_W3W_APIKEY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_W3W_WORDS ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_W3W_WORDS' $(SETUP)) && echo "${TS}++ MOTION_W3W_WORDS: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_W3W_WORDS),$(shell v=$$(cat MOTION_W3W_WORDS) && echo "${TG}== MOTION_W3W_WORDS: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="///what.three.words" && echo "${TB}** MOTION_W3W_WORDS unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_OVERVIEW_APIKEY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_OVERVIEW_APIKEY' $(SETUP)) && echo "${TS}++ MOTION_OVERVIEW_APIKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_OVERVIEW_APIKEY),$(shell v=$$(cat MOTION_OVERVIEW_APIKEY) && echo "${TG}== MOTION_OVERVIEW_APIKEY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="none" && echo "${TB}** MOTION_OVERVIEW_APIKEY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_OVERVIEW_MODE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_OVERVIEW_MODE' $(SETUP)) && echo "${TS}++ MOTION_OVERVIEW_MODE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_OVERVIEW_MODE),$(shell v=$$(cat MOTION_OVERVIEW_MODE) && echo "${TG}== MOTION_OVERVIEW_MODE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="local" && echo "${TB}** MOTION_OVERVIEW_MODE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_OVERVIEW_ZOOM ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_OVERVIEW_ZOOM' $(SETUP)) && echo "${TS}++ MOTION_OVERVIEW_ZOOM: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_OVERVIEW_ZOOM),$(shell v=$$(cat MOTION_OVERVIEW_ZOOM) && echo "${TG}== MOTION_OVERVIEW_ZOOM: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="20" && echo "${TB}** MOTION_OVERVIEW_ZOOM unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_OVERVIEW_IMAGE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_OVERVIEW_IMAGE' $(SETUP)) && echo "${TS}++ MOTION_OVERVIEW_IMAGE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_OVERVIEW_IMAGE),$(shell v=$$(cat MOTION_OVERVIEW_IMAGE) && echo "${TG}== MOTION_OVERVIEW_IMAGE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="overview.jpg" && echo "${TB}** MOTION_OVERVIEW_IMAGE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_DETECTED_ENTITY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ENTITY' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ENTITY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ENTITY),$(shell v=$$(cat MOTION_DETECTED_ENTITY) && echo "${TG}== MOTION_DETECTED_ENTITY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='none' && echo "${TB}** MOTION_DETECTED_ENTITY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_DETECTED_ENTITY_NOTIFY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ENTITY_NOTIFY' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ENTITY_NOTIFY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ENTITY_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_ENTITY_NOTIFY) && echo "${TG}== MOTION_DETECTED_ENTITY_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_ENTITY_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_PERSON_NOTIFY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_PERSON_NOTIFY' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_PERSON_NOTIFY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_PERSON_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_PERSON_NOTIFY) && echo "${TG}== MOTION_DETECTED_PERSON_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_PERSON_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_VEHICLE_NOTIFY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_VEHICLE_NOTIFY' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_VEHICLE_NOTIFY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_VEHICLE_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_NOTIFY) && echo "${TG}== MOTION_DETECTED_VEHICLE_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_VEHICLE_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_ANIMAL_NOTIFY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ANIMAL_NOTIFY' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ANIMAL_NOTIFY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ANIMAL_NOTIFY),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_NOTIFY) && echo "${TG}== MOTION_DETECTED_ANIMAL_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_DETECTED_ANIMAL_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_FACE_DETECTED_NOTIFY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_FACE_DETECTED_NOTIFY' $(SETUP)) && echo "${TS}++ MOTION_FACE_DETECTED_NOTIFY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_FACE_DETECTED_NOTIFY),$(shell v=$$(cat MOTION_FACE_DETECTED_NOTIFY) && echo "${TG}== MOTION_FACE_DETECTED_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_FACE_DETECTED_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_ALPR_DETECTED_NOTIFY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_ALPR_DETECTED_NOTIFY' $(SETUP)) && echo "${TS}++ MOTION_ALPR_DETECTED_NOTIFY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_ALPR_DETECTED_NOTIFY),$(shell v=$$(cat MOTION_ALPR_DETECTED_NOTIFY) && echo "${TG}== MOTION_ALPR_DETECTED_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_ALPR_DETECTED_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_POSE_DETECTED_NOTIFY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_POSE_DETECTED_NOTIFY' $(SETUP)) && echo "${TS}++ MOTION_POSE_DETECTED_NOTIFY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_POSE_DETECTED_NOTIFY),$(shell v=$$(cat MOTION_POSE_DETECTED_NOTIFY) && echo "${TG}== MOTION_POSE_DETECTED_NOTIFY: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='true' && echo "${TB}** MOTION_POSE_DETECTED_NOTIFY unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_DETECTED_ENTITY_SPEAK ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ENTITY_SPEAK' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ENTITY_SPEAK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ENTITY_SPEAK),$(shell v=$$(cat MOTION_DETECTED_ENTITY_SPEAK) && echo "${TG}== MOTION_DETECTED_ENTITY_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_ENTITY_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_PERSON_SPEAK ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_PERSON_SPEAK' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_PERSON_SPEAK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_PERSON_SPEAK),$(shell v=$$(cat MOTION_DETECTED_PERSON_SPEAK) && echo "${TG}== MOTION_DETECTED_PERSON_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_PERSON_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_VEHICLE_SPEAK ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_VEHICLE_SPEAK' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_VEHICLE_SPEAK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_VEHICLE_SPEAK),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_SPEAK) && echo "${TG}== MOTION_DETECTED_VEHICLE_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_VEHICLE_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_ANIMAL_SPEAK ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ANIMAL_SPEAK' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ANIMAL_SPEAK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ANIMAL_SPEAK),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_SPEAK) && echo "${TG}== MOTION_DETECTED_ANIMAL_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_ANIMAL_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_FACE_DETECTED_SPEAK ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_FACE_DETECTED_SPEAK' $(SETUP)) && echo "${TS}++ MOTION_FACE_DETECTED_SPEAK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_FACE_DETECTED_SPEAK),$(shell v=$$(cat MOTION_FACE_DETECTED_SPEAK) && echo "${TG}== MOTION_FACE_DETECTED_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_FACE_DETECTED_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_ALPR_DETECTED_SPEAK ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_ALPR_DETECTED_SPEAK' $(SETUP)) && echo "${TS}++ MOTION_ALPR_DETECTED_SPEAK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_ALPR_DETECTED_SPEAK),$(shell v=$$(cat MOTION_ALPR_DETECTED_SPEAK) && echo "${TG}== MOTION_ALPR_DETECTED_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_ALPR_DETECTED_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_POSE_DETECTED_SPEAK ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_POSE_DETECTED_SPEAK' $(SETUP)) && echo "${TS}++ MOTION_POSE_DETECTED_SPEAK: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_POSE_DETECTED_SPEAK),$(shell v=$$(cat MOTION_POSE_DETECTED_SPEAK) && echo "${TG}== MOTION_POSE_DETECTED_SPEAK: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_POSE_DETECTED_SPEAK unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_DETECTED_ENTITY_TUNE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ENTITY_TUNE' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ENTITY_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ENTITY_TUNE),$(shell v=$$(cat MOTION_DETECTED_ENTITY_TUNE) && echo "${TG}== MOTION_DETECTED_ENTITY_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_ENTITY_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_PERSON_TUNE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_PERSON_TUNE' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_PERSON_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_PERSON_TUNE),$(shell v=$$(cat MOTION_DETECTED_PERSON_TUNE) && echo "${TG}== MOTION_DETECTED_PERSON_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_PERSON_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_VEHICLE_TUNE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_VEHICLE_TUNE' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_VEHICLE_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_VEHICLE_TUNE),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_TUNE) && echo "${TG}== MOTION_DETECTED_VEHICLE_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_VEHICLE_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_ANIMAL_TUNE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ANIMAL_TUNE' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ANIMAL_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ANIMAL_TUNE),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_TUNE) && echo "${TG}== MOTION_DETECTED_ANIMAL_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_DETECTED_ANIMAL_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_FACE_DETECTED_TUNE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_FACE_DETECTED_TUNE' $(SETUP)) && echo "${TS}++ MOTION_FACE_DETECTED_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_FACE_DETECTED_TUNE),$(shell v=$$(cat MOTION_FACE_DETECTED_TUNE) && echo "${TG}== MOTION_FACE_DETECTED_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_FACE_DETECTED_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_ALPR_DETECTED_TUNE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_ALPR_DETECTED_TUNE' $(SETUP)) && echo "${TS}++ MOTION_ALPR_DETECTED_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_ALPR_DETECTED_TUNE),$(shell v=$$(cat MOTION_ALPR_DETECTED_TUNE) && echo "${TG}== MOTION_ALPR_DETECTED_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_ALPR_DETECTED_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_POSE_DETECTED_TUNE ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_POSE_DETECTED_TUNE' $(SETUP)) && echo "${TS}++ MOTION_POSE_DETECTED_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_POSE_DETECTED_TUNE),$(shell v=$$(cat MOTION_POSE_DETECTED_TUNE) && echo "${TG}== MOTION_POSE_DETECTED_TUNE: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** MOTION_POSE_DETECTED_TUNE unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_DETECTED_ENTITY_DEVIATION ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ENTITY_DEVIATION' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ENTITY_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ENTITY_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_ENTITY_DEVIATION) && echo "${TG}== MOTION_DETECTED_ENTITY_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_ENTITY_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_PERSON_DEVIATION ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_PERSON_DEVIATION' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_PERSON_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_PERSON_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_PERSON_DEVIATION) && echo "${TG}== MOTION_DETECTED_PERSON_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_PERSON_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_VEHICLE_DEVIATION ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_VEHICLE_DEVIATION' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_VEHICLE_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_VEHICLE_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_DEVIATION) && echo "${TG}== MOTION_DETECTED_VEHICLE_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_VEHICLE_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_ANIMAL_DEVIATION ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ANIMAL_DEVIATION' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ANIMAL_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ANIMAL_DEVIATION),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_DEVIATION) && echo "${TG}== MOTION_DETECTED_ANIMAL_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_DETECTED_ANIMAL_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_FACE_DETECTED_DEVIATION ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_FACE_DETECTED_DEVIATION' $(SETUP)) && echo "${TS}++ MOTION_FACE_DETECTED_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_FACE_DETECTED_DEVIATION),$(shell v=$$(cat MOTION_FACE_DETECTED_DEVIATION) && echo "${TG}== MOTION_FACE_DETECTED_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_FACE_DETECTED_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_ALPR_DETECTED_DEVIATION ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_ALPR_DETECTED_DEVIATION' $(SETUP)) && echo "${TS}++ MOTION_ALPR_DETECTED_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_ALPR_DETECTED_DEVIATION),$(shell v=$$(cat MOTION_ALPR_DETECTED_DEVIATION) && echo "${TG}== MOTION_ALPR_DETECTED_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_ALPR_DETECTED_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_POSE_DETECTED_DEVIATION ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_POSE_DETECTED_DEVIATION' $(SETUP)) && echo "${TS}++ MOTION_POSE_DETECTED_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_POSE_DETECTED_DEVIATION),$(shell v=$$(cat MOTION_POSE_DETECTED_DEVIATION) && echo "${TG}== MOTION_POSE_DETECTED_DEVIATION: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='5.0' && echo "${TB}** MOTION_POSE_DETECTED_DEVIATION unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# ago
MOTION_ANNOTATED_AGO ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_ANNOTATED_AGO' $(SETUP)) && echo "${TS}++ MOTION_ANNOTATED_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_ANNOTATED_AGO),$(shell v=$$(cat MOTION_ANNOTATED_AGO) && echo "${TG}== MOTION_ANNOTATED_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_ANNOTATED_AGO unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_AGO ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_AGO' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_AGO),$(shell v=$$(cat MOTION_DETECTED_AGO) && echo "${TG}== MOTION_DETECTED_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='30' && echo "${TB}** MOTION_DETECTED_AGO unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_ENTITY_AGO ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ENTITY_AGO' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ENTITY_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"), $(if $(wildcard MOTION_DETECTED_ENTITY_AGO),$(shell v=$$(cat MOTION_DETECTED_ENTITY_AGO) && echo "${TG}== MOTION_DETECTED_ENTITY_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='60' && echo "${TB}** MOTION_DETECTED_ENTITY_AGO unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTION_DETECTED_PERSON_AGO ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_PERSON_AGO' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_PERSON_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_PERSON_AGO),$(shell v=$$(cat MOTION_DETECTED_PERSON_AGO) && echo "${TG}== MOTION_DETECTED_PERSON_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='60' && echo "${TB}** MOTION_DETECTED_PERSON_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_VEHICLE_AGO ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_VEHICLE_AGO' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_VEHICLE_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_VEHICLE_AGO),$(shell v=$$(cat MOTION_DETECTED_VEHICLE_AGO) && echo "${TG}== MOTION_DETECTED_VEHICLE_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='60' && echo "${TB}** MOTION_DETECTED_VEHICLE_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_DETECTED_ANIMAL_AGO ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_DETECTED_ANIMAL_AGO' $(SETUP)) && echo "${TS}++ MOTION_DETECTED_ANIMAL_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_DETECTED_ANIMAL_AGO),$(shell v=$$(cat MOTION_DETECTED_ANIMAL_AGO) && echo "${TG}== MOTION_DETECTED_ANIMAL_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='60' && echo "${TB}** MOTION_DETECTED_ANIMAL_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_FACE_DETECTED_AGO ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_FACE_DETECTED_AGO' $(SETUP)) && echo "${TS}++ MOTION_FACE_DETECTED_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_FACE_DETECTED_AGO),$(shell v=$$(cat MOTION_FACE_DETECTED_AGO) && echo "${TG}== MOTION_FACE_DETECTED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='60' && echo "${TB}** MOTION_FACE_DETECTED_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_ALPR_DETECTED_AGO ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_ALPR_DETECTED_AGO' $(SETUP)) && echo "${TS}++ MOTION_ALPR_DETECTED_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_ALPR_DETECTED_AGO),$(shell v=$$(cat MOTION_ALPR_DETECTED_AGO) && echo "${TG}== MOTION_ALPR_DETECTED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='60' && echo "${TB}** MOTION_ALPR_DETECTED_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTION_POSE_DETECTED_AGO ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTION_POSE_DETECTED_AGO' $(SETUP)) && echo "${TS}++ MOTION_POSE_DETECTED_AGO: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTION_POSE_DETECTED_AGO),$(shell v=$$(cat MOTION_POSE_DETECTED_AGO) && echo "${TG}== MOTION_POSE_DETECTED_AGO: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='60' && echo "${TB}** MOTION_POSE_DETECTED_AGO unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

# webcam
NETCAM_USERNAME ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.NETCAM_USERNAME' $(SETUP)) && echo "${TS}++ NETCAM_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard NETCAM_USERNAME),$(shell v=$$(cat NETCAM_USERNAME) && echo "${TG}== NETCAM_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** NETCAM_USERNAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
NETCAM_PASSWORD ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.NETCAM_PASSWORD' $(SETUP)) && echo "${TS}++ NETCAM_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard NETCAM_PASSWORD),$(shell v=$$(cat NETCAM_PASSWORD) && echo "${TG}== NETCAM_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${TB}** NETCAM_PASSWORD unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

MOTIONCAM_USERNAME ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTIONCAM_USERNAME' $(SETUP)) && echo "${TS}++ MOTIONCAM_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTIONCAM_USERNAME),$(shell v=$$(cat MOTIONCAM_USERNAME) && echo "${TG}== MOTIONCAM_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** MOTIONCAM_USERNAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
MOTIONCAM_PASSWORD ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.MOTIONCAM_PASSWORD' $(SETUP)) && echo "${TS}++ MOTIONCAM_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard MOTIONCAM_PASSWORD),$(shell v=$$(cat MOTIONCAM_PASSWORD) && echo "${TG}== MOTIONCAM_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${TB}** MOTIONCAM_PASSWORD unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

# netdata
NETDATA_URL ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.NETDATA_URL' $(SETUP)) && echo "${TS}++ NETDATA_URL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard NETDATA_URL),$(shell v=$$(cat NETDATA_URL) && echo "${TG}== NETDATA_URL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:19999/" && echo "${TB}** NETDATA_URL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# jupyter 
JUPYTER_URL ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.JUPYTER_URL' $(SETUP)) && echo "${TS}++ JUPYTER_URL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard JUPYTER_URL),$(shell v=$$(cat JUPYTER_URL) && echo "${TG}== JUPYTER_URL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="http://${HOST_IPADDR}:7777/" && echo "${TB}** JUPYTER_URL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# tplink
TPLINK_DISCOVERY ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.TPLINK_DISCOVERY' $(SETUP)) && echo "${TS}++ TPLINK_DISCOVERY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard TPLINK_DISCOVERY),$(shell v=$$(cat TPLINK_DISCOVERY) && echo "${TG}== TPLINK_DISCOVERY: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v='false' && echo "${TB}** TPLINK_DISCOVERY unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# scan interval for speedtest
INTERNET_SCAN_INTERVAL ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.INTERNET_SCAN_INTERVAL' $(SETUP)) && echo "${TS}++ INTERNET_SCAN_INTERVAL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard INTERNET_SCAN_INTERVAL),$(shell v=$$(cat INTERNET_SCAN_INTERVAL) && echo "${TG}== INTERNET_SCAN_INTERVAL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="3600" && echo "${TB}** INTERNET_SCAN_INTERVAL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
INTRANET_SCAN_INTERVAL ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.INTRANET_SCAN_INTERVAL' $(SETUP)) && echo "${TS}++ INTRANET_SCAN_INTERVAL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard INTRANET_SCAN_INTERVAL),$(shell v=$$(cat INTRANET_SCAN_INTERVAL) && echo "${TG}== INTRANET_SCAN_INTERVAL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="1800" && echo "${TB}** INTRANET_SCAN_INTERVAL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))

# omada
OMADA_URL ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.OMADA_URL' $(SETUP)) && echo "${TS}++ OMADA_URL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard OMADA_URL),$(shell v=$$(cat OMADA_URL) && echo "${TG}== OMADA_URL: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="https://${HOST_IPADDR}:8043/" && echo "${TB}** OMADA_URL unset; default: $${v}${NC}" > /dev/stderr && echo "$${v}")))
OMADA_USERNAME ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.OMADA_USERNAME' $(SETUP)) && echo "${TS}++ OMADA_USERNAME: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard OMADA_USERNAME),$(shell v=$$(cat OMADA_USERNAME) && echo "${TG}== OMADA_USERNAME: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="username" && echo "${TB}** OMADA_USERNAME unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))
OMADA_PASSWORD ?= $(if $(wildcard $(SETUP)),$(shell v=$$(jq -r '.OMADA_PASSWORD' $(SETUP)) && echo "${TS}++ OMADA_PASSWORD: $${v}${NC}" > /dev/stderr && echo "$${v}"),$(if $(wildcard OMADA_PASSWORD),$(shell v=$$(cat OMADA_PASSWORD) && echo "${TG}== OMADA_PASSWORD: ${MC}$${v}${NC}" > /dev/stderr && echo "$${v}"),$(shell v="password" && echo "${TB}** OMADA_PASSWORD unset; default: ${DF}$${v}${NC}" > /dev/stderr && echo "$${v}")))

###
### TARGETS
###

## subdirectories containing addition makefile
PACKAGES ?= $(wildcard motion)

## directories for output files from scripts
MOTION_DIRS := \
	automation/motion \
	binary_sensor/motion \
	camera/motion \
	counter/motion \
	device_tracker/motion \
	group/motion \
	history_graph/motion \
	image_processing/motion \
	input_boolean/motion \
	input_datetime/motion \
	input_number/motion \
	input_select/motion \
	input_text/motion \
	notify/motion \
	sensor/motion \
	shell_command/motion \
	www/images/motion

# dashboards
MOTION_DASHBOARDS := owner primary developer experimental person animal vehicle
LOVELACE_DASHBOARDS := $(shell for C in $(MOTION_DASHBOARDS); do echo lovelace.$${C}.json; done)

MOTION_NOTIFY:= system devices unavailable missing activity found # weather batterylow wakeup nothomeyet awayintruder 
NOTIFY_DASHBOARDS := $(shell for C in $(MOTION_NOTIFY); do echo notify.$${C}.json; done)

default: all

all: chown $(WEBCAMS) lovelace.json lovelace_dashboards.json ${LOVELACE_DASHBOARDS} $(NOTIFY_DASHBOARDS) $(MOTION_DIRS) $(PACKAGES) secrets.yaml

chown:
	@echo "${MC}Making: $@${NC}"
	@-if [ ! -z "$${USER:-}" ]; then sudo chown -R $${USER} $$(pwd -P); fi

WEBCAMS := motion/webcams.json

$(WEBCAMS): 
	@echo "${MC}Making: $@${NC}"
	@export HOST_IPADDR=$(HOST_IPADDR) MOTION_W3W_APIKEY="$(MOTION_W3W_APIKEY)" && ./motion/sh/mkwebcams.sh > $@

CAMERAS := $(shell jq -r '.[].name' $(WEBCAMS))

$(MOTION_DIRS):
	@-mkdir -p $@
	@-if [ ! -z "${USER:-}" ]; then sudo chown -R ${USER} $@; fi

$(PACKAGES): makefile
	@echo "${MC}Making: $@${NC}"
	@export \
	  DOMAIN_NAME="$(DOMAIN_NAME)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_NAME="$(HOST_NAME)" \
	  HOST_PORT="$(HOST_PORT)" \
	  IPERF_HOST="$(IPERF_HOST)" \
	  MARIADB_HOST="$(MARIADB_HOST)" \
	  MARIADB_PASSWORD="$(MARIADB_PASSWORD)" \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	  MOTION_USER="$(MOTION_USER)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  && ${MAKE} -C $@

run: all configuration.yaml stop
	@echo "${MC}Making: $@${NC}"
	@docker start homeassistant

stop:
	@echo "${MC}Making: $@${NC}"
	-@docker stop homeassistant

restart: stop logclean tidy run

refresh: stop logclean neat run

logs:
	@echo "${MC}Making: $@${NC}"
	docker logs -f homeassistant

secrets.yaml: secrets.yaml.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  AUTOMATION_INTERNET="$(AUTOMATION_INTERNET)" \
	  AUTOMATION_INTRANET="$(AUTOMATION_INTRANET)" \
	  CONSUL_URL="$(CONSUL_URL)" \
	  COUCHDB_URL="$(COUCHDB_URL)" \
	  DIGITS_URL="$(DIGITS_URL)" \
	  EDGEX_URL="$(EDGEX_URL)" \
	  EXCHANGE_APIKEY="$(EXCHANGE_APIKEY)" \
	  EXCHANGE_ORG_ADMIN="$(EXCHANGE_ORG_ADMIN)" \
	  EXCHANGE_ORG="$(EXCHANGE_ORG)" \
	  EXCHANGE_URL="$(EXCHANGE_URL)" \
	  GRAFANA_URL="$(GRAFANA_URL)" \
	  HOST_IPADDR="$(HOST_IPADDR)" \
	  HOST_LATITUDE="$(HOST_LATITUDE)" \
	  HOST_LONGITUDE="$(HOST_LONGITUDE)" \
	  HOST_NAME="$(HOST_NAME)" \
	  HOST_NETWORK="$(HOST_NETWORK)" \
	  HOST_NETWORK_MASK="$(HOST_NETWORK_MASK)" \
	  HOST_PORT="$(HOST_PORT)" \
	  HOST_THEME="$(HOST_THEME)" \
	  HOST_TIMEZONE="$(HOST_TIMEZONE)" \
	  HZNMONITOR_URL="$(HZNMONITOR_URL)" \
	  INFLUXDB_DATABASE="$(INFLUXDB_DATABASE)" \
	  INFLUXDB_HOST="$(INFLUXDB_HOST)" \
	  INFLUXDB_PASSWORD="$(INFLUXDB_PASSWORD)" \
	  INFLUXDB_USERNAME="$(INFLUXDB_USERNAME)" \
	  INTERNET_SCAN_INTERVAL="$(INTERNET_SCAN_INTERVAL)" \
	  INTRANET_SCAN_INTERVAL="$(INTRANET_SCAN_INTERVAL)" \
	  IPERF_HOST="$(IPERF_HOST)" \
	  JUPYTER_URL="$(JUPYTER_URL)" \
	  LOGGER_AUTOMATION="$(LOGGER_AUTOMATION)" \
	  LOGGER_SET_STATE="$(LOGGER_SET_STATE)" \
	  LOGGER_DEFAULT="$(LOGGER_DEFAULT)" \
	  LOGGER_MQTT="$(LOGGER_MQTT)" \
	  MARIADB_HOST="$(MARIADB_HOST)" \
	  MARIADB_PASSWORD="$(MARIADB_PASSWORD)" \
          MOTION_ALPR_DETECTED_AGO="$(MOTION_ALPR_DETECTED_AGO)" \
          MOTION_ALPR_DETECTED_DEVIATION="$(MOTION_ALPR_DETECTED_DEVIATION)" \
          MOTION_ALPR_DETECTED_NOTIFY="$(MOTION_ALPR_DETECTED_NOTIFY)" \
          MOTION_ALPR_DETECTED_SPEAK="$(MOTION_ALPR_DETECTED_SPEAK)" \
          MOTION_ALPR_DETECTED_TUNE="$(MOTION_ALPR_DETECTED_TUNE)" \
          MOTION_ANNOTATED_AGO="$(MOTION_ANNOTATED_AGO)" \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_CAMERA_ANY="$(MOTION_CAMERA_ANY)" \
	  MOTION_CAMERA_RESTART="$(MOTION_CAMERA_RESTART)" \
	  MOTIONCAM_PASSWORD="$(MOTIONCAM_PASSWORD)" \
	  MOTIONCAM_USERNAME="$(MOTIONCAM_USERNAME)" \
	  MOTION_CLIENT="$(MOTION_CLIENT)" \
          MOTION_DETECTED_AGO="$(MOTION_DETECTED_AGO)" \
          MOTION_DETECTED_ANIMAL_AGO="$(MOTION_DETECTED_ANIMAL_AGO)" \
	  MOTION_DETECTED_ANIMAL_DEVIATION="$(MOTION_DETECTED_ANIMAL_DEVIATION)" \
          MOTION_DETECTED_ANIMAL_NOTIFY="$(MOTION_DETECTED_ANIMAL_NOTIFY)" \
	  MOTION_DETECTED_ANIMAL_SPEAK="$(MOTION_DETECTED_ANIMAL_SPEAK)" \
	  MOTION_DETECTED_ANIMAL_TUNE="$(MOTION_DETECTED_ANIMAL_TUNE)" \
          MOTION_DETECTED_ENTITY_AGO="$(MOTION_DETECTED_ENTITY_AGO)" \
	  MOTION_DETECTED_ENTITY_DEVIATION="$(MOTION_DETECTED_ENTITY_DEVIATION)" \
          MOTION_DETECTED_ENTITY="$(MOTION_DETECTED_ENTITY)" \
          MOTION_DETECTED_ENTITY_NOTIFY="$(MOTION_DETECTED_ENTITY_NOTIFY)" \
	  MOTION_DETECTED_ENTITY_SPEAK="$(MOTION_DETECTED_ENTITY_SPEAK)" \
	  MOTION_DETECTED_ENTITY_TUNE="$(MOTION_DETECTED_ENTITY_TUNE)" \
          MOTION_DETECTED_PERSON_AGO="$(MOTION_DETECTED_PERSON_AGO)" \
	  MOTION_DETECTED_PERSON_DEVIATION="$(MOTION_DETECTED_PERSON_DEVIATION)" \
          MOTION_DETECTED_PERSON_NOTIFY="$(MOTION_DETECTED_PERSON_NOTIFY)" \
	  MOTION_DETECTED_PERSON_SPEAK="$(MOTION_DETECTED_PERSON_SPEAK)" \
	  MOTION_DETECTED_PERSON_TUNE="$(MOTION_DETECTED_PERSON_TUNE)" \
          MOTION_DETECTED_VEHICLE_AGO="$(MOTION_DETECTED_VEHICLE_AGO)" \
	  MOTION_DETECTED_VEHICLE_DEVIATION="$(MOTION_DETECTED_VEHICLE_DEVIATION)" \
          MOTION_DETECTED_VEHICLE_NOTIFY="$(MOTION_DETECTED_VEHICLE_NOTIFY)" \
	  MOTION_DETECTED_VEHICLE_SPEAK="$(MOTION_DETECTED_VEHICLE_SPEAK)" \
	  MOTION_DETECTED_VEHICLE_TUNE="$(MOTION_DETECTED_VEHICLE_TUNE)" \
	  MOTION_DETECT_ENTITY="$(MOTION_DETECT_ENTITY)" \
	  MOTION_DEVICE="$(MOTION_DEVICE)" \
	  MOTION_EXPIRE_AFTER="$(MOTION_EXPIRE_AFTER)" \
          MOTION_FACE_DETECTED_AGO="$(MOTION_FACE_DETECTED_AGO)" \
          MOTION_FACE_DETECTED_DEVIATION="$(MOTION_FACE_DETECTED_DEVIATION)" \
          MOTION_FACE_DETECTED_NOTIFY="$(MOTION_FACE_DETECTED_NOTIFY)" \
          MOTION_FACE_DETECTED_SPEAK="$(MOTION_FACE_DETECTED_SPEAK)" \
          MOTION_FACE_DETECTED_TUNE="$(MOTION_FACE_DETECTED_TUNE)" \
	  MOTION_FORCE_UPDATE="$(MOTION_FORCE_UPDATE)" \
	  MOTION_GROUP="$(MOTION_GROUP)" \
	  MOTION_LOG_LEVEL="$(MOTION_LOG_LEVEL)" \
	  MOTION_MEDIA_MASK="$(MOTION_MEDIA_MASK)" \
	  MOTION_MEDIA_SAVE="$(MOTION_MEDIA_SAVE)" \
	  MOTION_NOTIFY_SMARTPHONE="$(MOTION_NOTIFY_SMARTPHONE)" \
	  MOTION_OVERVIEW_APIKEY="$(MOTION_OVERVIEW_APIKEY)" \
	  MOTION_OVERVIEW_IMAGE="$(MOTION_OVERVIEW_IMAGE)" \
	  MOTION_OVERVIEW_MODE="$(MOTION_OVERVIEW_MODE)" \
	  MOTION_OVERVIEW_ZOOM="$(MOTION_OVERVIEW_ZOOM)" \
          MOTION_POSE_DETECTED_AGO="$(MOTION_POSE_DETECTED_AGO)" \
          MOTION_POSE_DETECTED_DEVIATION="$(MOTION_POSE_DETECTED_DEVIATION)" \
          MOTION_POSE_DETECTED_NOTIFY="$(MOTION_POSE_DETECTED_NOTIFY)" \
          MOTION_POSE_DETECTED_SPEAK="$(MOTION_POSE_DETECTED_SPEAK)" \
          MOTION_POSE_DETECTED_TUNE="$(MOTION_POSE_DETECTED_TUNE)" \
	  MOTION_PRIMARY_DEVICE="$(MOTION_PRIMARY_DEVICE)" \
	  MOTION_PRIMARY="$(MOTION_PRIMARY)" \
	  MOTION_REPOSITORY="$(MOTION_REPOSITORY)" \
	  MOTION_ROUTER_NAME="$(MOTION_ROUTER_NAME)" \
	  MOTION_SECONDARY_DEVICE="$(MOTION_SECONDARY_DEVICE)" \
	  MOTION_SECONDARY="$(MOTION_SECONDARY)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	  MOTION_TERTIARY_DEVICE="$(MOTION_TERTIARY_DEVICE)" \
	  MOTION_TERTIARY="$(MOTION_TERTIARY)" \
          MOTION_TWILIO_NAME="$(MOTION_TWILIO_NAME)" \
          MOTION_TWILIO_NUMBER="$(MOTION_TWILIO_NUMBER)" \
          MOTION_TWILIO_SID="$(MOTION_TWILIO_SID)" \
          MOTION_TWILIO_TOKEN="$(MOTION_TWILIO_TOKEN)" \
	  MOTION_USER_DEVICE="$(MOTION_USER_DEVICE)" \
	  MOTION_USER="$(MOTION_USER)" \
	  MOTION_W3W_APIKEY="$(MOTION_W3W_APIKEY)" \
	  MOTION_W3W_WORDS="$(MOTION_W3W_WORDS)" \
	  MOTION_YOLO_IP="$(MOTION_YOLO_IP)" \
	  MQTT_HOST="$(MQTT_HOST)" \
	  MQTT_PASSWORD="$(MQTT_PASSWORD)" \
	  MQTT_PORT="$(MQTT_PORT)" \
	  MQTT_USERNAME="$(MQTT_USERNAME)" \
	  NETCAM_PASSWORD="$(NETCAM_PASSWORD)" \
	  NETCAM_USERNAME="$(NETCAM_USERNAME)" \
	  NETDATA_URL="$(NETDATA_URL)" \
	  OMADA_PASSWORD="$(OMADA_PASSWORD)" \
	  OMADA_URL="$(OMADA_URL)" \
	  OMADA_USERNAME="$(OMADA_USERNAME)" \
	  TPLINK_DISCOVERY="$(TPLINK_DISCOVERY)" \
	  UPTIMEROBOT_RSSURL="$(UPTIMEROBOT_RSSURL)" \
	  WEATHER_AMBIENT_MAC="$(WEATHER_AMBIENT_MAC)" \
	  WEATHER_AMBIENT_APIKEY="$(WEATHER_AMBIENT_APIKEY)" \
	  WEATHER_AMBIENT_APPKEY="$(WEATHER_AMBIENT_APPKEY)" \
	&& cat $< | envsubst > $@

lovelace_dashboards.json: lovelace_dashboards.json.tmpl
	@echo "${MC}Making: $@${NC}"
	@export \
	  HOST_NAME="$(HOST_NAME)" \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	  MOTION_USER="$(MOTION_USER)" \
	&& cat $< \
	  | envsubst \
	 > $@
	@rm -f .storage/lovelace_dashboards
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace_dashboards

## notifications

notify.system.json: notify.system.json.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	&& cat $< \
	  | envsubst \
	> $@
	@rm -f .storage/lovelace.notify_system
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.notify_system

notify.devices.json: notify.devices.json.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	&& cat $< \
	  | envsubst \
	> $@
	@rm -f .storage/lovelace.notify_devices
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.notify_devices

notify.unavailable.json: notify.unavailable.json.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	&& cat $< \
	  | envsubst \
	> $@
	@rm -f .storage/lovelace.notify_unavailable
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.notify_unavailable

notify.found.json: notify.found.json.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	&& cat $< \
	  | envsubst \
	> $@
	@rm -f .storage/lovelace.notify_found
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.notify_found

notify.missing.json: notify.missing.json.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	&& cat $< \
	  | envsubst \
	> $@
	@rm -f .storage/lovelace.notify_missing
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.notify_missing

notify.activity.json: notify.activity.json.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	&& cat $< \
	  | envsubst \
	> $@
	@rm -f .storage/lovelace.notify_activity
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.notify_activity

## lovelace panels

lovelace.json: lovelace.json.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	&& cat $< \
	  | envsubst \
	> $@
	@rm -f .storage/lovelace
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace

lovelace.owner.json: lovelace.owner.json.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	&& cat $< \
	  | envsubst \
	> $@
	@rm -f .storage/lovelace.lovelace_owner
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.lovelace_owner

lovelace.primary.json: lovelace.primary.json.tmpl setup.json
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_SITE="$(MOTION_SITE)" \
	&& cat $< \
	  | envsubst \
	> $@
	@rm -f .storage/lovelace.lovelace_primary
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.lovelace_primary

# legacy not deprecated

lovelace.developer.json: lovelace.developer.json.tmpl setup.json $(WEBCAMS)
	@echo "${MC}Making: $@${NC}"
	@export \
	  MOTION_APP="$(MOTION_APP)" \
	  HOST_NAME="$(HOST_NAME)" \
	  MOTION_USER="$(MOTION_USER)" \
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="notify").cards[].cards[]|select(.title=="Camera alerts").cards)+='"$$(jq '[.[]|{"type":"vertical-stack","cards":[{"entities":[{"name":.name,"entity":("input_boolean.motion_"+.name+"_detect_entity_notify")}],"show_header_toggle":false,"title":"","type":"entities"},{"type":"conditional","conditions":[{"entity":("input_boolean.motion_"+.name+"_detect_entity_notify"),"state":"on"}],"card":{"entities":[{"name":("Select entity to detect at "+.name+" camera"),"entity":("input_select.motion_"+.name+"_detect_entity")},{"name":"Notify speaker(s)","entity":("input_boolean.motion_"+.name+"_detect_entity_speak")},{"name":"Confirmed only","entity":("input_boolean.motion_"+.name+"_detect_entity_confirmed")},{"name":"Notify smartphone(s)","entity":("input_boolean.motion_"+.name+"_detect_entity_alert")},{"name":"Critical","entity":("input_boolean.motion_"+.name+"_detect_entity_alert_critical")}],"show_header_toggle":false,"title":"","type":"entities"}}]}]' $(WEBCAMS))" \
	 > $@
	@rm -f .storage/lovelace.lovelace_developer
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.lovelace_developer

lovelace.person.json: lovelace.person.json.tmpl setup.json $(WEBCAMS)
	@echo "${MC}Making: $@${NC}"
	@export \
	  HOST_NAME="$(HOST_NAME)" \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_USER="$(MOTION_USER)" \
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="person").cards[]|select(.title=="Person count mean (Σμ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_person_count_mean")]' $(WEBCAMS))" \
	  | jq '(.data.config.views[]|select(.path=="person").cards[]|select(.title=="Person ago mean (⧖μ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_person_ago_mean")]' $(WEBCAMS))" \
	  | jq '(.data.config.views[]|select(.path=="vehicle").cards[]|select(.title=="Vehicle count mean (Σμ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_vehicle_count_mean")]' $(WEBCAMS))" \
	  | jq '(.data.config.views[]|select(.path=="vehicle").cards[]|select(.title=="Vehicle ago mean (⧖μ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_vehicle_ago_mean")]' $(WEBCAMS))" \
	  | jq '(.data.config.views[]|select(.path=="animal").cards[]|select(.title=="Animal count mean (Σμ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_animal_count_mean")]' $(WEBCAMS))" \
	  | jq '(.data.config.views[]|select(.path=="animal").cards[]|select(.title=="Animal ago mean (⧖μ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_animal_ago_mean")]' $(WEBCAMS))" \
         | jq '(.data.config.views[]|select(.path=="map").cards[]?.cards[]?.cards[]?|select(.type=="map").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_person_status")}]' $(WEBCAMS))" \
         | jq '(.data.config.views[]|select(.path=="map").cards[]?.cards[]?.cards[]?|select(.title=="Level").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_person_level")}]' $(WEBCAMS))" \
         | jq '(.data.config.views[]|select(.path=="map").cards[]?.cards[]?.cards[]?|select(.title=="Rank").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_person_rank")}]' $(WEBCAMS))" \
	 > $@
	@rm -f .storage/lovelace.lovelace_person
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.lovelace_person

lovelace.vehicle.json: lovelace.vehicle.json.tmpl setup.json $(WEBCAMS)
	@echo "${MC}Making: $@${NC}"
	@export \
	  HOST_NAME="$(HOST_NAME)" \
	  MOTION_USER="$(MOTION_USER)" \
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="vehicle").cards[]|select(.title=="Vehicle count mean (Σμ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_vehicle_count_mean")]' $(WEBCAMS))" \
	  | jq '(.data.config.views[]|select(.path=="vehicle").cards[]|select(.title=="Vehicle ago mean (⧖μ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_vehicle_ago_mean")]' $(WEBCAMS))" \
         | jq '(.data.config.views[]|select(.path=="map").cards[]?.cards[]?.cards[]?|select(.type=="map").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_vehicle_status")}]' $(WEBCAMS))" \
         | jq '(.data.config.views[]|select(.path=="map").cards[]?.cards[]?.cards[]?|select(.title=="Level").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_vehicle_level")}]' $(WEBCAMS))" \
         | jq '(.data.config.views[]|select(.path=="map").cards[]?.cards[]?.cards[]?|select(.title=="Rank").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_vehicle_rank")}]' $(WEBCAMS))" \
	 > $@
	@rm -f .storage/lovelace.lovelace_vehicle
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.lovelace_vehicle

lovelace.animal.json: lovelace.animal.json.tmpl setup.json $(WEBCAMS)
	@echo "${MC}Making: $@${NC}"
	@export \
	  HOST_NAME="$(HOST_NAME)" \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_USER="$(MOTION_USER)" \
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="animal").cards[]|select(.title=="Animal count mean (Σμ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_animal_count_mean")]' $(WEBCAMS))" \
	  | jq '(.data.config.views[]|select(.path=="animal").cards[]|select(.title=="Animal ago mean (⧖μ) (24h)").entities)+='"$$(jq '[.[]|("sensor.motion_"+.name+"_detected_animal_ago_mean")]' $(WEBCAMS))" \
         | jq '(.data.config.views[]|select(.path=="map").cards[]?.cards[]?.cards[]?|select(.type=="map").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_animal_status")}]' $(WEBCAMS))" \
         | jq '(.data.config.views[]|select(.path=="map").cards[]?.cards[]?.cards[]?|select(.title=="Level").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_animal_level")}]' $(WEBCAMS))" \
         | jq '(.data.config.views[]|select(.path=="map").cards[]?.cards[]?.cards[]?|select(.title=="Rank").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_animal_rank")}]' $(WEBCAMS))" \
	 > $@
	@rm -f .storage/lovelace.lovelace_animal
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.lovelace_animal


#
# removed from experimental template below
#
#	  | jq '(.data.config.views[]|select(.path=="motion_live").cards[].cards[]|select(.title=="AGO").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_detected_ago_mean")}]' $(WEBCAMS))" \
#	  | jq '(.data.config.views[]|select(.path=="motion_live").cards[].cards[]|select(.card.title=="COMPLETE").card.entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_complete_mean")}]' $(WEBCAMS))" \
#	  | jq '(.data.config.views[]|select(.path=="motion_live").cards[].cards[]|select(.card.title=="RATIO").card.entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_complete_ratio")}]' $(WEBCAMS))" \

lovelace.experimental.json: lovelace.experimental.json.tmpl setup.json $(WEBCAMS)
	@echo "${MC}Making: $@${NC}"
	@export \
	  HOST_NAME="$(HOST_NAME)" \
	  MOTION_APP="$(MOTION_APP)" \
	  MOTION_USER="$(MOTION_USER)" \
	&& cat $< \
	  | envsubst \
	  | jq '(.data.config.views[]|select(.path=="motion_live").cards[].cards[].card|select(.title=="OVERVIEW").elements)+='"$$(jq '[.[]|{"type":"icon","entity":("camera.motion_"+.name+"_live"),"tap_action":{"action":"navigate","navigation_path":("/lovelace-experimental/"+.name)},"icon":("mdi:"+.icon),"style":{"color":"red","left":(.left|tostring+"%"),"top":(.top|tostring+"%"),"height":"5%","width": "5%"}}]' $(WEBCAMS))" \
	  | jq '(.data.config.views[]|select(.path=="motion_live").cards[].cards[].card|select(.title=="MAP").entities)+='"$$(jq '[.[]|{"entity":("sensor.motion_"+.name+"_camera_detected_person_status"),"hold_action":{"action":"more-info"},"tap_action":{"action":"navigate","navigation_path":("/lovelace/experimental/"+.name)}}]' $(WEBCAMS))" \
	  | jq '(.data.config.views)+=$$views[0]' --slurpfile views "$$(jq '[.[]|{"badges":[],"panel":false,"icon":("mdi:"+.icon),"path":.name,"title":.name,"cards":[{"cards":[{"type":"picture-elements","camera_image":("camera.motion_"+.name+"_detected_person"),"elements":[{"type":"conditional","conditions":[{"entity":("sensor.motion_"+.name+"_detected_person_when"),"state":"Pending"}],"elements":[{"type":"image","camera_image":"camera.motion_nosignal_animated","style":{"position":null,"opacity":1,"top":"50%","left":"50%","width":"100%","height":"100%"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_person_when"),"prefix":"Person:","style":{"top":"50%","left":"50%","font-size":"200%","color":"cyan"}}]},{"type":"conditional","conditions":[{"entity":("sensor.motion_"+.name+"_detected_person_when"),"state_not":"Pending"}],"elements":[{"type":"state-label","entity":("sensor.motion_"+.name+"_camera_name"),"prefix":"Person at ","style":{"top":"75%","left":"50%","font-size":"200%","color":"cyan"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_person_ago_relative"),"prefix":"Ago:","style":{"top":"10%","left":"80%","font-size":"150%","color":"cyan"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_person_when"),"style":{"top":"90%","left":"50%","font-size":"100%","color":"cyan"}},{"type":"image","camera_image":("camera.motion_"+.name+"_detected_person_animated"),"style":{"position":null,"opacity":0.4,"top":"50%","left":"50%","width":"100%","height":"100%"}}]}]},{"type":"picture-elements","camera_image":("camera.motion_"+.name+"_detected"),"elements":[{"type":"conditional","conditions":[{"entity":("sensor.motion_"+.name+"_detected_when"),"state":"Pending"}],"elements":[{"type":"image","camera_image":"camera.motion_nosignal_animated","style":{"position":null,"opacity":1,"top":"50%","left":"50%","width":"100%","height":"100%"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_when"),"prefix":"Detected:","style":{"top":"50%","left":"50%","font-size":"200%","color":"magenta"}}]},{"type":"conditional","conditions":[{"entity":("sensor.motion_"+.name+"_detected_when"),"state_not":"Pending"}],"elements":[{"type":"state-label","entity":("sensor.motion_"+.name+"_camera_name"),"prefix":"Detected at ","style":{"top":"75%","left":"50%","font-size":"200%","color":"magenta"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_ago_relative"),"prefix":"Ago:","style":{"top":"10%","left":"80%","font-size":"150%","color":"magenta"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_when"),"style":{"top":"90%","left":"50%","font-size":"100%","color":"magenta"}},{"type":"image","camera_image":("camera.motion_"+.name+"_detected_animated"),"style":{"position":null,"opacity":0.4,"top":"50%","left":"50%","width":"100%","height":"100%"}}]}]}],"type":"vertical-stack"},{"cards":[{"entities":[{"icon":"mdi:eye","entity":("sensor.motion_"+.name+"_detected_status")}],"show_header_toggle":false,"title":("Status "+.name),"type":"entities"},{"type":"picture-elements","elements":[{"type":"state-label","entity":"sensor.time","prefix":"LIVE:","style":{"top":"10%","left":"15%","font-size":"125%","color":"yellow"}},{"type":"state-label","entity":"sensor.date","style":{"top":"10%","left":"85%","font-size":"125%","color":"yellow"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_camera_name"),"style":{"top":"90%","left":"50%","font-size":"200%","color":"yellow"}},{"type":"image","style":{"position":null,"opacity":0.0,"top":"50%","left":"50%","width":"100%","height":"100%"},"tap_action":{"action":"more-info"},"camera_view":"live","camera_image":("camera.motion_"+.name+"_live")}],"camera_view":"live","camera_image":("camera.motion_"+.name+"_live")},{"type":"glance","entities":[{"name":"Person ago","icon":"mdi:account","entity":("sensor.motion_"+.name+"_detected_person_ago_relative")},{"name":"Vehicle ago","icon":"mdi:car","entity":("sensor.motion_"+.name+"_detected_vehicle_ago_relative")},{"name":"Animal ago","icon":"mdi:cow","entity":("sensor.motion_"+.name+"_detected_animal_ago_relative")},{"name":"Entity ago","icon":"mdi:motion-sensor","entity":("sensor.motion_"+.name+"_detected_entity_ago_relative")},{"name":"Entity ∀βμ","icon":"mdi:beta","entity":("sensor.motion_"+.name+"_detected_entity_confidence_mean")}],"show_icon":true,"show_name":true},{"entities":[{"name":("Notify if entity detected at "+.name+" camera"),"entity":("input_boolean.motion_"+.name+"_detect_entity_notify")}],"show_header_toggle":false,"title":"","type":"entities"},{"type":"conditional","conditions":[{"entity":("input_boolean.motion_"+.name+"_detect_entity_notify"),"state":"on"}],"card":{"entities":[{"name":("Entity to detect at "+.name+" camera"),"entity":("input_select.motion_"+.name+"_detect_entity")},{"name":("Speak detection"),"entity":("input_boolean.motion_"+.name+"_detect_entity_speak")},{"name":("Confirmed only"),"entity":("input_boolean.motion_"+.name+"_detect_entity_confirmed")},{"name":("Alert smartphone"),"entity":("input_boolean.motion_"+.name+"_detect_entity_alert")},{"name":("Critical alert"),"entity":("input_boolean.motion_"+.name+"_detect_entity_alert_critical")}],"show_header_toggle":false,"title":"","type":"entities"}},{"type":"vertical-stack","cards":[{"type":"history-graph","entities":[{"entity":("sensor.motion_"+.name+"_complete")},{"entity":("sensor.motion_"+.name+"_complete_mean")},{"entity":("sensor.motion_"+.name+"_complete_ratio")}],"hours_to_show":24,"refresh_interval":60}]}],"type":"vertical-stack"},{"cards":[{"type":"picture-elements","camera_image":("camera.motion_"+.name+"_detected_vehicle"),"elements":[{"type":"conditional","conditions":[{"entity":("sensor.motion_"+.name+"_detected_vehicle_when"),"state":"Pending"}],"elements":[{"type":"image","camera_image":"camera.motion_nosignal_animated","style":{"position":null,"opacity":1,"top":"50%","left":"50%","width":"100%","height":"100%"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_vehicle_when"),"prefix":"Vehicle:","style":{"top":"50%","left":"50%","font-size":"200%","color":"gold"}}]},{"type":"conditional","conditions":[{"entity":("sensor.motion_"+.name+"_detected_vehicle_when"),"state_not":"Pending"}],"elements":[{"type":"state-label","entity":("sensor.motion_"+.name+"_camera_name"),"prefix":"Vehicle at ","style":{"top":"75%","left":"50%","font-size":"200%","color":"gold"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_vehicle_ago_relative"),"prefix":"Ago:","style":{"top":"10%","left":"80%","font-size":"150%","color":"gold"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_vehicle_when"),"style":{"top":"90%","left":"50%","font-size":"100%","color":"gold"}},{"type":"image","camera_image":("camera.motion_"+.name+"_detected_vehicle_animated"),"style":{"position":null,"opacity":0.4,"top":"50%","left":"50%","width":"100%","height":"100%"}}]}]},{"type":"picture-elements","camera_image":("camera.motion_"+.name+"_detected_animal"),"elements":[{"type":"conditional","conditions":[{"entity":("sensor.motion_"+.name+"_detected_animal_when"),"state":"Pending"}],"elements":[{"type":"image","camera_image":"camera.motion_nosignal_animated","style":{"position":null,"opacity":1,"top":"50%","left":"50%","width":"100%","height":"100%"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_animal_when"),"prefix":"Animal:","style":{"top":"50%","left":"50%","font-size":"200%","color":"chartreuse"}}]},{"type":"conditional","conditions":[{"entity":("sensor.motion_"+.name+"_detected_animal_when"),"state_not":"Pending"}],"elements":[{"type":"state-label","entity":("sensor.motion_"+.name+"_camera_name"),"prefix":"Animal at ","style":{"top":"75%","left":"50%","font-size":"200%","color":"chartreuse"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_animal_ago_relative"),"prefix":"Ago:","style":{"top":"10%","left":"80%","font-size":"150%","color":"chartreuse"}},{"type":"state-label","entity":("sensor.motion_"+.name+"_detected_animal_when"),"style":{"top":"90%","left":"50%","font-size":"100%","color":"chartreuse"}},{"type":"image","camera_image":("camera.motion_"+.name+"_detected_animal_animated"),"style":{"position":null,"opacity":0.4,"top":"50%","left":"50%","width":"100%","height":"100%"}}]}]}],"type":"vertical-stack"}]}]' $(WEBCAMS) > /tmp/cards.$$$$.json; echo /tmp/cards.$$$$.json)" \
	> $@
	@rm -f .storage/lovelace.lovelace_experimental
	-@mkdir -p .storage/
	@ln -s ../$@ .storage/lovelace.lovelace_experimental

## clean and clean and clean ..

tidy: 
	@echo "${MC}Making: $@${NC}"
	@${MAKE} -C motion clean

neat: tidy
	@echo "${MC}Making: $@${NC}"
	-@sudo rm -fr www/images/motion/*
	-@sudo rm -f .storage/core.restore_state

clean: stop logclean neat
	@echo "${MC}Making: $@${NC}"
	@rm -f $(WEBCAMS)
	@rm -f secrets.yaml
	-@rm -f .storage/lovelace*
	-@sudo rm -f .storage/core.entity_registry
	-@sudo rm -f .storage/core.restore_state

realclean: clean 
	-@sudo rm -f home-assistant_v2.*
	-@sudo rm -f known_devices.yaml
	-@sudo rm -f home-assistant.log
	-@sudo rm -fr .storare/core.{config_entries,device_registry}

distclean: realclean
	-@sudo rm -fr .storage
	-@sudo rm -fr .uuid .HA_VERSION .cloud deps tts .storage
	-@sudo rm -fr "../media/Motion-Ã👁"
	-@sudo rm -fr $(MAGIC_AREAS)

logclean:
	-@sudo journalctl --rotate
	-@sudo journalctl --vacuum-time=1
	-@export LOGPATH=$$(docker inspect --format '{{json .}}' homeassistant | jq -r '.LogPath') \
	  && if [ ! -z "$${LOGPATH}" ]; then echo 'Attempting to remove log file: '"$${LOGPATH}" \
	  && sudo LOGPATH=$${LOGPATH} /bin/rm -f $${LOGPATH}; fi

.PHONY: chown refresh neat tidy all default run stop logs restart clean realclean distclean $(PACKAGES) $(WEBCAMS) images lovelace*.json $(MOTION_DIRS) secrets.yaml

##
## COLORS
##
MC=${LIGHT_CYAN}
TB=${RED}
TG=${GREEN}
TS=${BLUE}
NC=${NO_COLOR}

NO_COLOR=\033[0m
BLACK=\033[0;30m
RED=\033[0;31m
GREEN=\033[0;32m
BROWN_ORANGE=\033[0;33m
BLUE=\033[0;34m
PURPLE=\033[0;35m
CYAN=\033[0;36m
LIGHT_GRAY=\033[0;37m

DARK_GRAY=\033[1;30m
LIGHT_RED=\033[1;31m
LIGHT_GREEN=\033[1;32m
YELLOW=\033[1;33m
LIGHT_BLUE=\033[1;34m
LIGHT_PURPLE=\033[1;35m
LIGHT_CYAN=\033[1;36m
WHITE=\034[1;37m
