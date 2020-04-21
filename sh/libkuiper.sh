#!/usr/bin/env bash

## STREAMS

kuiper.stream.create()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name="${1}"
  local topic="${2}"
  local schema="${3:-}"

  curl -sSL "${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/streams" -X POST -d '{ "sql": "create stream '${name}' ('"${schema}"') WITH (FORMAT=\"JSON\", DATASOURCE=\"'${topic}'\")" }'
}

kuiper.stream.describe()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name="${1:-}"
  curl -sSL ${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/streams/${name}
}

kuiper.stream.drop()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name="${1}"
  curl -sSL "${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/streams/${name}" -X DELETE
}

## RULES

kuiper.rule.create()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name=${1}
  local topic="${2}"
  local query="${3:-}"

  if [ -z "${query:-}" ]; then query='select * from '"${name}"; fi
  curl -sSL ${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/rules -X POST -d '{"id":"'${name}'","sql":"'"${query}"'","actions":[{"mqtt":{"server":"tcp://'${MQTT_USERNAME:-username}:${MQTT_PASSWORD:-password}@${MQTT_HOST:-127.0.0.1}:${MQTT_PORT:-1883}'","topic":"'${topic}'"}}]}'
}

kuiper.query.create()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name=${1}
  local topic="${2}"
}

kuiper.rule.drop()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name="${1}"
  curl -sSL "${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/rules/${name}" -X DELETE
}

kuiper.rule.start()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name="${1}"
  curl -sSL "${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/rules/${name}/start" -X POST
}

kuiper.rule.restart()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name="${1}"
  curl -sSL "${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/rules/${name}/restart" -X POST
}

kuiper.rule.stop()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name="${1}"
  curl -sSL "${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/rules/${name}/stop" -X POST
}

kuiper.rule.status()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name="${1}"
  curl -sSL "${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/rules/${name}/status"
}

kuiper.rule.describe()
{
  if [ "${DEBUG:-false}" = 'true' ]; then echo "${FUNCNAME[0]} ${*}" &> /dev/stderr; fi
  local name="${1:-}"
  curl -sSL "${KUIPER_HOST:-localhost}:${KUIPER_PORT:-9081}/rules/${name}"
}
