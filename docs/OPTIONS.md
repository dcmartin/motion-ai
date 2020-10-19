# `OPTIONS.md`
Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`HOST_IPADDR`|Host LAN IP address or FQDN|**`hostname -I`**|`ha-ip`
`HOST_NAME`|Host name for local reference |**`hostname -f`**|`ha-name`
`HOST_PORT`|Port number for Home Assistant|`8123`|`ha-port`
`HOST_THEME`|||
`INFLUXDB_DATABASE`|||
`INFLUXDB_HOST`|||
`INFLUXDB_PASSWORD`|||
`INFLUXDB_USERNAME`|||
`INTERNET_SCAN_INTERVAL`|||
`INTRANET_SCAN_INTERVAL`|||
`LOGGER_AUTOMATION`||`info`|
`LOGGER_DEFAULT`||`info`|
`MOTIONCAM_PASSWORD`|`MJPEG` stream from `motion` _add-on_ |`password`|`motioncam-password`
`MOTIONCAM_PASSWORD`|||
`MOTIONCAM_USERNAME`|`MJPEG` stream from `motion` _add-on_ |`username`|`motioncam-username`
`MOTIONCAM_USERNAME`|||
`MOTION_CLIENT`|Device(s) topic for `MQTT`|`+`|`motion-client`
`MOTION_CLIENT`|||
`MOTION_DETECTED_ANIMAL_DEVIATION`|||
`MOTION_DETECTED_ANIMAL_TUNE`|||
`MOTION_DETECTED_PERSON_DEVIATION`|||
`MOTION_DETECTED_PERSON_TUNE`|||
`MOTION_DETECTED_VEHICLE_DEVIATION`|||
`MOTION_DETECTED_VEHICLE_TUNE`|||
`MOTION_DETECT_ENTITY`|||
`MOTION_DEVICE`|MQTT identifier of the `motion` _addon_ host|_`HOST_NAME`_ w/o -,+,#|`motion-device`
`MOTION_DEVICE`|||
`MOTION_EXPIRE_AFTER`||`5`|
`MOTION_FORCE_UPDATE`||`false`|
`MOTION_GROUP`|Name for the group of device(s) |`motion`|`motion-group`
`MOTION_MEDIA_MASK`|Mask animations|`true`|`motion-media-mask`
`MOTION_MEDIA_SAVE`|Save animations|`true`|`motion-media-save`
`MOTION_OVERVIEW_APIKEY`|Google Maps API key|`none`|`motion-overview-apikey`
`MOTION_OVERVIEW_IMAGE`|Local image file for `local` mode|`overview.jpg`|`motion-overview-image`
`MOTION_OVERVIEW_MODE`|Mode of overview picture (local,hybrid,satellite,road)|`local`|`motion-overview-mode`
`MOTION_OVERVIEW_ZOOM`|Zoom level (1-22) for Google Maps (non-`local`)|`20`|`motion-overview-zoom`
`MQTT_HOST`|Broker LAN IP address or FQDN |_`HOST_IPADDR`_|`mqtt-broker`
`MQTT_PASSWORD`|Authentication |`password`|`mqtt-password`
`MQTT_PORT`|||
`MQTT_USERNAME`|Authentication |`username`|`mqtt-username`
`NETCAM_PASSWORD`|Authentication for `netcam` _type_ cameras|`password`|`netcam-password`
`NETCAM_USERNAME`|Authentication for `netcam` _type_ cameras|`username`|`netcam-username`
`NETDATA_URL`|||
`TPLINK_DISCOVERY`||`false`|
`YOLO_CONFIG`|||
`YOLO_SCALE`|||
`YOLO_THRESHOLD`|||
`ALPR_COUNTRY`|||
`ALPR_SCALE`|||
`ALPR_THRESHOLD`|||
`FACE_SCALE`|||
`FACE_THRESHOLD`|||
