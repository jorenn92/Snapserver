# Snapserver
Snapcast server with mopidy, spotify connect & bluetooth sink/source.

Bluetooth sink: 
 - Connect to a BT device by calling \<IP-ADRESS\>:8025/api/v1/bluetooth/connect?mac=\<device bluetooth mac address\>
 - Disconnect a BT device by calling \<IP-ADRESS\>:8025/api/v1/bluetooth/connect?mac=\<device bluetooth mac address\>
While connected a snapclient will spawn playing audio. Only 1 connection is allowed at the same time.

Bluetooth source: Just connect your BT device and start playing music 

Builds https://hub.docker.com/repository/docker/jorenn92/snapserver

Run command: docker run -dti --privileged --device /dev/snd --net=host --device /dev/bus/usb -v /usr/apps/snapserver/devices:/var/lib/bluetooth --name snapserver --cap-add NET_ADMIN -v /usr/apps/snapserver/conf/:/root/.config/snapserver/ -v /var/run/dbus:/var/run/dbus -v /etc/localtime:/etc/localtime:ro --restart unless-stopped jorenn92/snapserver

disable bluetooth by adding the BLUETOOTH=false environment var. 
