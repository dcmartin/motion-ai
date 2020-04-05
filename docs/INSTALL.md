## &#9995; - Installing `motion` _add-on_
Installation of the _add-on_ is through the Home Assistant Supervisor and the **Add-on Store**.

## Step 1
Browse to the Home Assistant Web interface (n.b. don't forget `port` if not `80`) and visit the **Supervisor** via the icon in the lower left panel (see below).

[![example](samples/supervisor.png?raw=true "supervisor")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/supervisor.png)

## Step 2
Select the `Add-on Store` and type in the address of this repository, for example:

[![example](samples/add-repository.png?raw=true "add-repository")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/add-repository.png)

## Step 3
When the system reloads, select the **Motion Server** _add-on_ from those available; when utilizing a locally attached USB camera, select the **Motion Video0** _add-on_; for example:

[![example](samples/dcmartin-repository.png?raw=true "dcmartin-repository")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/dcmartin-repository.png)

## Step 4
After selecting the appropriate _add-on_, install by clicking on the `'INSTALL` button, for example:

 [![example](samples/motion-server-addon.png?raw=true "motion-server-addon")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/motion-server-addon.png)

## Step 5
Configure the add-on using the following options:

+ `group` - the identifier for the group of cameras; default: `motion`
+ `
+ `mqtt` - `host`, `port`, `username`, and `password` for MQTT server
+ `cameras` - an array of `dict` structure for each camera
For more information on configuring, please refer to the [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) documentation.

### Local camera
The local camera is only defined to exist and be `/dev/video0` in the [Motion Video0](http://github.com/dcmartin/hassio-addons/tree/master/motion-video0/README.md) _add-on_; changing this device requires specification through the add-on [configuration](http://github.com/dcmartin/hassio-addons/tree/master/motion-video0/config.json).  The device connected to `/dev/video0` may be a [RaspberryPi v2]() camera, a Playstation3 [Eye]() camera, or any [VL42]() camera.

```
[
  {
    "name": "kitchencam",
    "type": "local",
    "netcam_url": "http://127.0.0.1:8090/1",
    "icon": "stove",
    "netcam_userpass": "username:password"
  }
]   
```

### Network camera
Network cameras may use the `rtsp`, `http`, or `mjpeg` protocol specifiers (n.b.  [`netcam_url`](https://motion-project.github.io/motion_config.html#netcam_url)) section of the [Motion Project](https://motion-project.github.io/motion_guide.html) documentation.

```
[
  {
    "name": "pondlive",
    "type": "netcam",
    "netcam_url": "mjpeg://192.168.1.174/img/video.mjpeg",
    "icon": "waves",
    "netcam_userpass": "!secret netcam-userpass"
  }
]
```

### FTP camera
For network cameras that deposit video via FTP; the `username` and `password` apply the the `netcam_url` for access to the camera (n.b. direct, not through the `motion` port).  If using this type of camera, please install an appropriate **FTP** _add-on_, e.g.  [`addon-ftp`](https://github.com/hassio-addons/addon-ftp).


```
[
  {
    "name": "backyard",
    "type": "ftpd",
    "netcam_url": "http://192.168.1.183/img/video.mjpeg",
    "icon": "texture-box",
     "netcam_userpass": "!secret netcam-userpass"
  }
]
```

### Complete example configuration for `motion` _add-on_
```
log_level: debug
log_motion_level: error
log_motion_type: ALL
default:
  brightness: 100
  changes: 'on'
  contrast: 50
  despeckle: EedDl
  event_gap: 10
  framerate: 2
  hue: 50
  interval: 60
  lightswitch: 0
  minimum_motion_frames: 10
  movie_max: 60
  movie_output: 'off'
  movie_quality: 80
  netcam_userpass: '!secret motioncam-userpass'
  palette: 15
  picture_quality: 80
  post_pictures: best
  saturation: 0
  stream_quality: 50
  text_scale: 2
  threshold_percent: 1
  username: '!secret motioncam-username'
  password: '!secret motioncam-password'
  width: 1920
  height: 1080
mqtt:
  host: 192.168.1.50
  port: '1883'
  username: username
  password: password
group: motion
device: netcams
client: netcams
timezone: America/Los_Angeles
cameras:
  - name: poolcam
    type: netcam
    icon: water
    netcam_url: 'http://192.168.1.162/nphMotionJpeg?Resolution=640x480&Quality=Clarity'
    netcam_userpass: '!secret netcam-userpass'
    width: 640
    height: 480
    framerate: 5
  - name: road
    type: netcam
    icon: road
    netcam_url: 'http://192.168.1.36:8081/'
    netcam_userpass: '!secret netcam-userpass'
    width: 640
    height: 480
    framerate: 5
  - name: dogshed
    type: netcam
    icon: dog
    netcam_url: 'rtsp://192.168.1.221/live'
  - name: dogshedfront
    type: netcam
    icon: home-floor-1
    netcam_url: 'rtsp://192.168.1.222/live'
  - name: sheshed
    type: netcam
    icon: window-shutter-open
    netcam_url: 'rtsp://192.168.1.223/live'
  - name: dogpond
    type: netcam
    icon: waves
    netcam_url: 'rtsp://192.168.1.224/live'
  - name: pondview
    type: netcam
    icon: waves
    netcam_url: 'rtsp://192.168.1.225/live'
```
