## &#9995; - Installing `motion` _add-on_
Browse to the Home Assistant Web interface (n.b. don't forget `port` if not `80`) and visit the **Supervisor** via the icon in the lower left panel (see below).

[![example](samples/supervisor.png?raw=true "supervisor")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/supervisor.png)

Then select the `Add-on Store` and type in the address of this repository, for example:

[![example](samples/add-repository.png?raw=true "add-repository")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/add-repository.png)

When the system reloads, select the **Motion Server** _add-on_ from those available; when utilizing a locally attached USB camera, select the **Motion Video0** _add-on_; for example:

[![example](samples/dcmartin-repository.png?raw=true "dcmartin-repository")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/dcmartin-repository.png)

After selecting the appropriate _add-on_, install by clicking on the `'INSTALL` button, for example:

 [![example](samples/motion-server-addon.png?raw=true "motion-server-addon")](http://github.com/dcmartin/hassio-addons/tree/master/motion/samples/motion-server-addon.png)

For more information on configuring, please refer to the [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) documentation.

### Local camera

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
For network cameras that deposit video via FTP; the `username` and `password` apply the the `netcam_url` for access to the camera (n.b. direct, not through the `motion` port).

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
