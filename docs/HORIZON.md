# `HORIZON.md`

[Open Horizon](http://github.com/open-horizon) is an open source project sponsored by IBM to provide an orchestration mechanism for Docker containers in edge scenarios.  Containers are composed into _services_ which are subsequently packaged into _patterns_ that can be deployed to _nodes_ connected to the _exchange_.  The patterns run by nodes are combinations of services that are designed to interoperate.

## Open Horizon setup
Installation instructions can be found [here](https://github.com/dcmartin/open-horizon/blob/master/setup/README.md).

### `exchange-api`
Once installation is complete, the _services_ and _patterns_ can be built and _published_ using the Open Horizon [`exchange-api`](https://github.com/open-horizon/exchange-api/blob/master/README.md) to an _exchange_ -- a server running a specified set of Docker containers, e.g. `http://alpha.edge-fabric.com/v1/`.  Those containers include both  PostgreSQL and MongoDB databases.

### `edge-sync-service`
The [`edge-sync-service`](https://github.com/open-horizon/edge-sync-service/blob/master/README.md) provides for bi-directional synchonization of binary objects between the server and the devices using the _node_ information in the _exchange_.  The client component is called the `ESS` and the service component is called the `CSS`.  Client and server poll for new objects and data; object data consumers indicate receipt.  A sample service, `esstest`, is available in another [repository](https://github.com/dcmartin/open-horizon/blob/master/esstest/README.md).

### `anax`
The [`anax`](https://github.com/open-horizon/anax/blob/master/README.md) control application runs on both the client and the server (n.b. as an _agbot_); the client version is installed on a supported device, for example the Raspberry Pi Model 3B+ (n.b. [instructions](https://github.com/dcmartin/open-horizon/blob/master/doc/RPI.md)), and then attempts to reach an _agreement_ with an _agbot_ on the server for the client's requested _pattern_ (e.g. [`yolo2mshubg`](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/README.md).

## Open Horizon usage

+ `MQTT_HOST` - the TCP/IP address or DNS name for the message broker; defaults to `core-mosquitto`
+ `MOTION_DEVICE` - unique name; defaults to `$(hostname -s)`; **do not use `-`** or reserved `MQTT` _topic_ characters
+ `MOTION_CLIENT` - the client for message topic; defaults to `MOTION_DEVICE`; for **all** clients specify `+`

These attributes may be specified through files with equivalent names containing the preferred value (see below).

In addition, the configuration depends on a listing of cameras, notably the file `motion/webcams.json` which must be created; there is a [template](http://github.com/dcmartin/horizon.dcmartin.com/blob/master/motion/webcams.json.tmpl) provided.


### Options for `motion` _add-on_
The `default` attributes for _cameras_ are utilized unless the _camera_ entry specifies an alternative; please note the `netcam_userpass` may be shared across cameras or specified for any.

 + `mqtt` - ensure `host`, `username`, and `password` match `MQTT` _add-on_ configuration
 + `group` - a _name_ collection of device(s), each with one or more cameras.
 + `device`- the unique _name_ used in the `MQTT` topic
 + `client` - the unique _name_ per `device` or `+` for all `group` camera(s)
 + `timezone` - for time across `group`
 + `cameras` - one or more `netcam`, `ftpd` cameras; at most one (1) `local` camera

After configuration, start the _add-on_.

#### &#9995; Naming
A `group`, `device`, or `camera` _name_ may **ONLY** include lower-case letters (`a-z`), numbers (`0-9`), and _underscore_ (`_`) as those `name` are used in `MQTT` _topics_.

## &#10126; - Configure `motion-ai` YAML
This repository provides a set of `YAML` files and templates specifically designed to consume information provided by the `motion` _add-on_.  These files provide a multi-view interface through both Lovelace and legacy user-interfaces.



## &#10128; - Reconfigure Home Assistant
Once the default Home Assistant installation has finished, the `motion` _add-on_ has been configured and started, and the `homeassistant/motion/webcams.json` file has been created, change the permissions on the Home Assistant directory to make the user the owner, and run the `make` program to generate the YAML files; for example:

```
cd /usr/share/hassio/
sudo chown -R ${USER} .
make
```

The default `configuration.yaml` provided in the installation of Home Assistant does not include any `motion-ai` generated YAML; to utilize the generated YAML, remove the default `configuration.yaml` file and replace with the provided `config-client.yaml.tmpl` file; for example:

```
cd /usr/share/hassio/homeassistant/
mv  configuration.yaml config-default.yaml
ln -s config-client.yaml.tmpl configuration.yaml
```

##  &#10129; - Restart Home Assistant

The configuration may now be updated and controlled using the `make` command, including the following:

+ `restart` - restart the Home Assistant server
+ `tidy` - remove any automatically constructed YAML configuration files
+ `clean` - perform `tidy` and then remove any log files and `.storage/` recorder files
+ `realclean` - perform `clean` and then remove all database files
+ `logs` - show the Home Assistant logs

Whenever the contents of the `homeassistant/motion/webcams.json` file is changed, the system may be restarted to regenerate the YAML files appropriate for the cameras specified; for example:

```
cd /usr/share/hassio
# edit homeassistant/motion/webcams.json ..
make restart
```


##  &#10130; - Start `yolo4motion` _service_
Start the `yolo4motion` service container by executing the provided [shell script](../sh/yolo4motion.sh); the options, which may be specified through equivalent environment variables or files:

+ `MQTT_HOST` - host for message broker; default: _hostname_
+ `MOTION_GROUP` - which clients to process; default: `motion`
+ `MOTION_DEVICE` - which clients to process; default: _hostname_
+ `MOTION_CLIENT` - which clients to process; default: `+`
+ `MOTION_CAMERA` - which camera to process; default: `+`
+ `YOLO_CONFIG` - may be `tiny`, `tiny-v2`, `tiny-v3`, `v2`, or `v3`; default: `tiny` _(pre-loaded)_
+ `YOLO_ENTITY` - entity to detect; default: `all`
+ `YOLO_SCALE` - size for image scaling prior to detect; default: `none`
+ `YOLO_THRESHOLD` - threshold for entity detection; default: `0.25`
+ `LOG_LEVEL` - logging level; default: `info`
+ `LOG_TO` - logging output; default: `/dev/stderr`

The `tiny` model (aka `tiny-v2`) only detects [these](https://github.com/dcmartin/openyolo/blob/master/darknet/data/voc.names) entities; the remaining models detect [these](https://github.com/dcmartin/openyolo/blob/master/darknet/data/coco.names) entities.

**Note:** The Docker container and the model's weights must be downloaded from the Internet; there may be a considerable delay given the device Internet connection bandwidth.  The container is only downloaded one time, but the model's weights  are downloaded each time the container is started.

For example:

```
cd /usr/share/hassio
echo debug > LOG_LEVEL
echo tiny-v3 > YOLO_CONFIG
./sh/yolo4motion.sh
... deleted ...
{
  "name": "yolo4motion",
  "id": "6d1765902d260f5b6e276f26391eb135eedef5388bf15ce77fa976adcf7a13c6",
  "service": {
    "label": "yolo4motion",
    "id": "com.github.dcmartin.open-horizon.yolo4motion",
    "tag": "0.1.2",
    "arch": "amd64",
    "ports": {
      "service": 80,
      "host": 4662
    }
  },
  "motion": {
    "group": "motion",
    "client": "+",
    "camera": "+"
  },
  "yolo": {
    "config": "tiny",
    "entity": "all",
    "scale": "none",
    "threshold": 0.25
  },
  "mqtt": {
    "host": "192.168.1.50",
    "port": 1883,
    "username": "username",
    "password": "password"
  },
  "debug": {
    "debug": false,
    "level": "info",
    "logto": "/dev/stderr"
  }
}
```

##  &#9989; - Start `face4motion`and `alpr4motion` (_optional_)
These two Open Horizon _services_ may also be started via shell scripts, namely [`alpr4motion.sh`](../sh/alpr4motion.sh) and [`face4motion`](../sh/face4motion.sh).  These scripts utilize the same environment variables for `MQTT`, `MOTION`, and `LOG` attributes as `yolo4motion.sh`, but have their own specific options rather than `YOLO`:

### `face4motion.sh`
+ `FACE_THRESHOLD` - floating point value between `0.0` and `0.99`; default: `0.5`

### `alpr4motion.sh`
+ `ALPR_COUNTRY` - designation for country specific license plates, may be `us` or `eu`; default: `us`
+ `ALPR_PATTERN` - pattern for plate recognition, may be regular expression; default: `none`
+ `ALPR_TOPN` - integer value between `1` and `20` limiting number `tag` predictions per `plate` 

##  &#9989; - Watch `MQTT` traffic (_optional_)
To monitor the `MQTT` traffic from one or more `motion` devices use the `./sh/watch.sh` script which runs a `MQTT` client to listen for various _topics_, including motion detection events, annotations, detections, and a specified detected entity (n.b. currently limited per device).  The script outputs information to `/dev/stderr` and runs in the background.  The shell script will utilize existing values for the `MQTT` host, etc.. as well as the `MOTION_CLIENT`, but those may be specified as well; for example:

```
echo motion > MOTION_GROUP
echo + > MOTION_CLIENT
./sh/watch.sh
```

# Reference

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
