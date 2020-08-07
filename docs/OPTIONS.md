# `OPTIONS.md`

Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`MOTION_GROUP`|Name for the group of device(s) |`motion`|`motion-group`
`MOTION_DEVICE`|Name of the `motion` _addon_ host|_`HOST_NAME`_|`motion-device`
`MOTION_CLIENT`|Device(s) topic for `MQTT`|`+`|`motion-client`
`HOST_PORT`|Port number for Home Assistant|`8123`|`ha-port`
`HOST_NAME`|Host name for local reference |**`hostname -f`**|`ha-name`
`HOST_IPADDR`|Host LAN IP address or FQDN|**`hostname -I`**|`ha-ip`
`MOTIONCAM_USERNAME`|`MJPEG` stream from `motion` _add-on_ |`username`|`motioncam-username`
`MOTIONCAM_PASSWORD`|`MJPEG` stream from `motion` _add-on_ |`password`|`motioncam-password`
`MQTT_HOST`|Broker LAN IP address or FQDN |`core-mosquitto`|`mqtt-broker`
`MQTT_USERNAME`|Authentication |`username`|`mqtt-username`
`MQTT_PASSWORD`|Authentication |`password`|`mqtt-password`
`NETCAM_USERNAME`|Authentication for `netcam` _type_ cameras|`username`|`netcam-username`
`NETCAM_PASSWORD`|Authentication for `netcam` _type_ cameras|`password`|`netcam-password`
`YOLO_CONFIG`|||
`YOLO_SCALE`|||
`YOLO_THRESHOLD`|||
`FACE_SCALE`|||
`FACE_THRESHOLD`|||
`ALPR_SCALE`|||
`ALPR_COUNTRY`|||
`ALPR_THRESHOLD`|||
