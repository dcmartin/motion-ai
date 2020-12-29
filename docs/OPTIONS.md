# `OPTIONS.md`
The following table lists the _variables_ which may be specified as _variables_ using either the LINUX environment or local files with the same names in the top-level, for example:

```
cd ~/motion-ai
echo 80 > HOST_PORT
echo $(hostname -I) > MQTT_HOST
echo $(hostname -I) > MOTION_YOLO_IP
echo rtspcamlogin > NETCAM_USERNAME
echo rtspcampasswd > NETCAM_PASSWORD
echo "${GOOGLE_MAPS_APIKEY}" > MOTION_OVERVIEW_APIKEY
echo hybrid > MOTION_OVERVIEW_MODE
echo 'false' > MOTION_MEDIA_MASK
echo 'true' > TPLINK_DISCOVERY
```

When these values are modified the system needs to be restarted using `make` command-line, for example:

```
cd ~/motion-ai
make restart
```

## MQTT

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`MQTT_HOST`|Broker LAN IP address or FQDN |_`HOST_IPADDR`_|`mqtt-broker`
`MQTT_PASSWORD`|Authentication |`password`|`mqtt-password`
`MQTT_PORT`|TCP/IP port number|`1883`|`mqtt-port`
`MQTT_USERNAME`|Authentication |`username`|`mqtt-username`

## Identifiers
Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`MOTION_GROUP`|Name for the group of device(s) |`motion`|`motion-group`
`MOTION_DEVICE`|MQTT identifier of the `motion` _addon_ host|_`HOST_NAME`_ w/o -,+,#|`motion-device`
`MOTION_CLIENT`|Device(s) topic for `MQTT`|_`MOTION_DEVICE`_|`motion-client`

## Cameras
Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`MOTIONCAM_PASSWORD`|`MJPEG` stream from `motion` _add-on_ |`password`|`motioncam-password`
`MOTIONCAM_USERNAME`|`MJPEG` stream from `motion` _add-on_ |`username`|`motioncam-username`
`NETCAM_PASSWORD`|Authentication for `netcam` _type_ cameras|`password`|`netcam-password`
`NETCAM_USERNAME`|Authentication for `netcam` _type_ cameras|`username`|`netcam-username`

## Detection

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`MOTION_DETECT_ENTITY`|Which entity from [COCO](http://github.com/motion-ai/coco) ontology|`person`|`motion-detect-entity`
`MOTION_DETECTED_PERSON_DEVIATION`|Sigma level for person detection tuning|`0.5`|`motion-detected-person-deviation`
`MOTION_DETECTED_PERSON_TUNE`|Automatically tune person detection|`false`|`motion-detected-person-tune`
`MOTION_DETECTED_VEHICLE_DEVIATION`|Sigma level for vehicle detection tuning|`0.5`|`motion-detected-vehicle-deviation`
`MOTION_DETECTED_VEHICLE_TUNE`|Automatically tune vehicle detection|`false`|`motion-detected-vehicle-tune`
`MOTION_DETECTED_ANIMAL_DEVIATION`|Sigma level for animal detection tuning|`0.5`|`motion-detected-animal-deviation`
`MOTION_DETECTED_ANIMAL_TUNE`|Automatically tune animal detection|`false`|`motion-detected-animal-tune`

## Media

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`MOTION_MEDIA_MASK`|Mask animations|`true`|`motion-media-mask`
`MOTION_MEDIA_SAVE`|Save animations|`true`|`motion-media-save`

## Overview image
The `OVERVIEW` component of the Home-Assistant Lovelace UI depends upon a provided image; the `local` image or a Google Maps image may be used.

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`MOTION_OVERVIEW_APIKEY`|Google Maps API key|`none`|`motion-overview-apikey`
`MOTION_OVERVIEW_IMAGE`|Local image file for `local` mode|`overview.jpg`|`motion-overview-image`
`MOTION_OVERVIEW_MODE`|Mode of overview picture (local,hybrid,satellite,road)|`local`|`motion-overview-mode`
`MOTION_OVERVIEW_ZOOM`|Zoom level (1-22) for Google Maps (non-`local`)|`20`|`motion-overview-zoom`

## AI Services
These options are for the scripts which start the services, e.g. `yolo4motion.sh`; typically they do not need to be specified.

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`YOLO_CONFIG`|Model for inferencing; `tiny-v2`, `tiny-v3`, `v2`, or `v3`|`tiny-v2`|
`YOLO_SCALE`|Scaling of image|`640x480`|
`YOLO_THRESHOLD`|Percent minimum for detection|`0.2`|
`ALPR_COUNTRY`|Country of license place|`us`|
`ALPR_PATTERN`|Limit to specific set|`all`|
`ALPR_SCALE`|Scaling of image|`640x480`|
`ALPR_TOPN`|Number of results|`10`|
`FACE_SCALE`|Scaling of image|`640x480`|
`FACE_THRESHOLD`|Percent minimum for detection|`0.5`|

## Home-Assistant host

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`HOST_IPADDR`|Host LAN IP address or FQDN|**`hostname -I`**|`ha-ip`
`HOST_NAME`|Host name for local reference |**`hostname -f`**|`ha-name`
`HOST_PORT`|Port number for Home Assistant|`8123`|`ha-port`
`HOST_THEME`|Color scheme; `blue`,`green`,`red`,`yellow`,`purple`,`gray`|`default`|`ha-theme`

## InfluxDB

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`INFLUXDB_DATABASE`|Name of database for InfluxDB|_`HOST_NAME`_|`influxdb-database`
`INFLUXDB_HOST`|FQDN or IP address of InfluxDB server|`127.0.0.1`|`influxdb-host`
`INFLUXDB_PASSWORD`|Password for Influxdb|`homeassistant`|`influxdb-password`
`INFLUXDB_USERNAME`|Username for Influxdb|`homeassistant`|`influxdb-username`

## Miscellaneous

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`INTERNET_SCAN_INTERVAL`|||
`INTRANET_SCAN_INTERVAL`|||
`LOGGER_AUTOMATION`||`info`|
`LOGGER_DEFAULT`||`info`|
`TPLINK_DISCOVERY`||`false`|

## Subsystems

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`NETDATA_URL`|||

## Experimental

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`MOTION_EXPIRE_AFTER`|Seconds the MQTT signals remain valid|`5`|`motion-expire-after`
`MOTION_FORCE_UPDATE`|Update MQTT signals forcibly|`false`|`motion-force-update`
`MOTION_YOLO_IP`|FQDN or IP address of YOLO server|`$(hostname -I)`|`motion-yolo-ip`

