# use this machine
HOST_IPADDR='192.168.1.40'

# test intranet against this machine
IPERF_HOST='192.168.1.50'

# use port 80, not 8123
echo '80' > HOST_PORT

# use this MQTT broker with these credentials
echo "${HOST_IPADDR}" > MQTT_HOST
echo 'username' > MQTT_USERNAME
echo 'password' > MQTT_PASSWORD

# name device uniquely and listen for all cameras (aka clients)
echo 'deviceName' > MOTION_DEVICE
echo '+' > MOTION_CLIENT

# use these credentials to access Motion Classic addon camera(s)
echo 'username' > MOTIONCAM_USERNAME
echo 'password' > MOTIONCAM_PASSWORD

# use these credentials to access network cameras directly
echo 'username' > NETCAM_USERNAME
echo 'password' > NETCAM_PASSWORD

# the yolo4motion.sh script is running here
echo "${HOST_IPADDR}" > YOLO_IP

# the iperf3 daemon is running here
echo "${IPERF_HOST}" > IPERF_HOST

# tune detection
echo 'true' > MOTION_DETECTED_ANIMAL_TUNE
echo 'true' > MOTION_DETECTED_PERSON_TUNE
echo 'true' > MOTION_DETECTED_VEHICLE_TUNE

# unmask media
echo 'false' > MOTION_MEDIA_MASK

# specify Google Maps APIKEY
echo 'APkikj32837e9u2' > MOTION_OVERVIEW_APIKEY

# specify alternative picture in www/images
echo 'screenshot.png' > MOTION_OVERVIEW_IMAGE

# discover TPLink devices
echo 'true' > TPLINK_DISCOVERY

# use the v2 configuration
echo 'v2' > YOLO_CONFIG
