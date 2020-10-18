# `OPTIONS.md`
Variable|Description|Default|`!secret`
:-------|:-------|:-------|:-------
`HOST_IPADDR`|Host LAN IP address or FQDN|**`hostname -I`**|`ha-ip`
`HOST_NAME`|Host name for local reference |**`hostname -f`**|`ha-name`
`HOST_PORT`|Port number for Home Assistant|`8123`|`ha-port`
`MOTIONCAM_PASSWORD`|`MJPEG` stream from `motion` _add-on_ |`password`|`motioncam-password`
`MOTIONCAM_USERNAME`|`MJPEG` stream from `motion` _add-on_ |`username`|`motioncam-username`
`MOTION_CLIENT`|Device(s) topic for `MQTT`|`+`|`motion-client`
`MOTION_DEVICE`|Name of the `motion` _addon_ host|_`HOST_NAME`_|`motion-device`
`MOTION_GROUP`|Name for the group of device(s) |`motion`|`motion-group`
`MOTION_MEDIA_MASK`|Mask animations|`true`|`motion-media-mask`
`MOTION_MEDIA_SAVE`|Save animations|`true`|`motion-media-save`
`MOTION_OVERVIEW_APIKEY`|Google Maps API key|`none`|`motion-overview-apikey`
`MOTION_OVERVIEW_IMAGE`|Local image file for `local` mode|`overview.jpg`|`motion-overview-image`
`MOTION_OVERVIEW_MODE`|Mode of overview picture (local,hybrid,satellite,road)|`local`|`motion-overview-mode`
`MOTION_OVERVIEW_ZOOM`|Zoom level (1-22) for Google Maps (non-`local`)|`20`|`motion-overview-zoom`
`MQTT_HOST`|Broker LAN IP address or FQDN |_`HOST_IPADDR`_|`mqtt-broker`
`MQTT_PASSWORD`|Authentication |`password`|`mqtt-password`
`MQTT_USERNAME`|Authentication |`username`|`mqtt-username`
`NETCAM_PASSWORD`|Authentication for `netcam` _type_ cameras|`password`|`netcam-password`
`NETCAM_USERNAME`|Authentication for `netcam` _type_ cameras|`username`|`netcam-username`
`ALPR_COUNTRY`|||
`ALPR_SCALE`|||
`ALPR_THRESHOLD`|||
`FACE_SCALE`|||
`FACE_THRESHOLD`|||
`YOLO_CONFIG`|||
`YOLO_SCALE`|||
`YOLO_THRESHOLD`|||
