#!/bin/bash

if [ -z "${MARIADB_PASSWORD:-}" ] && [ -s MARIADB_PASSWORD ]; then MARIADB_PASSWORD=$(cat MARIADB_PASSWORD); fi; MARIADB_PASSWORD=${MARIADB_PASSWORD:-HomeAssistant1234}
if [ -z "${MARIADB_DATADIR:-}" ] && [ -s MARIADB_DATADIR ]; then MARIADB_DATADIR=$(cat MARIADB_DATADIR); fi; MARIADB_DATADIR=${MARIADB_DATADIR:-${HOME}/.mariadb/data}

LABEL='mariadb'
IMAGE='mariadb:10.5'

mkdir -p ${MARIADB_DATADIR}

# cleanup
echo "Removing any existing container: ${LABEL}" &> /dev/stderr
docker rm -f ${LABEL} &> /dev/null

# start up
echo "Starting new container: ${LABEL}; image: ${IMAGE}" &> /dev/stderr

docker run \
  --name ${LABEL} \
  --restart=unless-stopped \
  -d \
  -p 3306:3306\
  -e MYSQL_ROOT_PASSWORD="${MARIADB_PASSWORD}" \
  --mount "type=bind,source=${MARIADB_DATADIR},target=/var/lib/mysql" \
  ${IMAGE}

docker exec -it mariadb mysql -h 127.0.0.1 -u root --password="${MARIADB_PASSWORD}" -e 'create database homeassistant'
