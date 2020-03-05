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
After client software installation, the device may be _registered_ to run a specific _pattern_ of services from the exchange.  The pattern specifies one or more services to be deployed to the device and registration records the device as a _node_ in the exchange requesting that pattern of services.

### Example: `yolo2msghub`
The [`yolo2msghub`](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/README.md) [_service_](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/service.json) is also defined as a [_pattern_](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/pattern.json).  The _service_ is composed of one Docker container deployed as `yolo2msghub`, and four (4) dependencies on `requiredServices`:

+ [`yolo`](https://github.com/dcmartin/open-horizon/blob/master/yolo/README.md) - Provide [YOLO]() image classification service
+ [`wan`](https://github.com/dcmartin/open-horizon/blob/master/wan/README.md) - Test Internet connectivity
+ [`hal`](https://github.com/dcmartin/open-horizon/blob/master/hal/README.md) - Inventory device attributes
+ [`cpu`](https://github.com/dcmartin/open-horizon/blob/master/cpu/README.md) - Calculate CPU utilization percent

Together these five (5) services provide an automated mechanism to capture pictures from a local camera, detect entities of interest (e.g. `person`), and report on presence using the Kafka messaging platform (aka _message hub_).  A sample screen capture (with development mode `on`) is below.

![sample.png](samples/sample.png?raw=true "SAMPLE")

##  `github.com/dcmartin` _patterns_ and _services_
A set of Open Horizon _services_ and _patterns_ is available in another [repository](http://github.com/dcmartin/open-horizon).  Some of the patterns are specified to interoperate with the Home Assistant _addons_, notably the **MQTT broker**, to process messages between services.

### `motion`
Provides a combination of multiple services for deployment target devices, including RaspberryPi and Jetson Nano.  The primary services in this pattern are:

+ `motion2mqtt` - process video from LINUX (V4L2), direct-attach, cameras; pub/sub MQTT topic: multiple
+ `yolo4motion` - process image using `yolo`; pub/sub MQTT topics to/from `motion` _addon_

### B.3.2 - `startup` 
The primary services in this pattern are:

+ `startup` - device, Docker, and node status; produce JSON on port: 3093; Kafka topic: `startup`

### B.3.3 - `hznsetup` 
The primary services in this pattern are:

+ `hznsetup` - automate setup of new devices as _nodes_; also available as _pattern_ with `hznmonitor`
+ `hznmonitor` - process JSON `startup` messages via Kafka; summarize JSON; publish MQTT topic: `startup`

## B.4 - `dcmartin` _services_
A set of Open Horizon _services_ and _patterns_ is available in another [repository](http://github.com/dcmartin/open-horizon).  Some of the patterns are specified to interoperate with the Home Assistant _addons_, notably the **MQTT broker**, to process messages between services.

### B.4.1 -  `motion2mqtt`
Using the open source [`motion`](https://motion-project.github.io/) package, process camera output and produce motion detection _events_ indicating the start (optional) and end of motion.  **Notice**: there are a wide variety of options to the `motion` package; not all are necessarily supported or exploited in this service.  
Visit  [`motion2mqtt`](https://github.com/dcmartin/open-horizon/blob/master/motion2mqtt/README.md) page for details. 

### B.4.2 - `yolo4motion`
Visit  [`yolo4motion`](https://github.com/dcmartin/open-horizon/blob/master/yolo4motion/README.md) page for details. 

### B.4.3 -  `mqtt`
Visit  [`yolo4motion`](https://github.com/dcmartin/open-horizon/blob/master/mqtt/README.md) page for details. 

### B.4.4 - `mqtt2mqtt`
Visit  [`yolo4motion`](https://github.com/dcmartin/open-horizon/blob/master/mqtt2mqtt/README.md) page for details. 

### B.4.5 - `startup`
Visit  [`startup`](https://github.com/dcmartin/open-horizon/blob/master/startup/README.md) page for details. 

### B.4.6 - `hznsetup`
Visit  [`hznsetup`](https://github.com/dcmartin/open-horizon/blob/master/hznsetup/README.md) page for details. 

### B.4.7 - `hznmonitor`
Visit  [`hznmonitor`](https://github.com/dcmartin/open-horizon/blob/master/hznmonitor/README.md) page for details. 

### B.4.8 - `sdr2msghub`
Visit  [`sdr2msghub`](https://github.com/dcmartin/open-horizon/blob/master/sdr2msghub/README.md) page for details. 

### B.4.9 - `yolo2msghub`
Visit  [`yolo2msghub`](https://github.com/dcmartin/open-horizon/blob/master/yolo2msghub/README.md) page for details. 

