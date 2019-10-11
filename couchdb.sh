#!/bin/bash
docker run \
  --name 'couchdb' \
  --restart always \
  -d \
  -p 5984:5984 \
  -v couchdb-data:/opt/couchdb/data \
  -v couchdb-admin:/opt/couchdb/etc/local.d \
  -e COUCHDB_USER=admin \
  -e COUCHDB_PASSWORD=password \
  couchdb
