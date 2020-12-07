# Snapcast server with mopidy, spotify connect & bluetooth sink/source.

<b>Bluetooth sink</b>

- Connect a BT device by calling \<IP-ADRESS\>:8025/api/v1/bluetooth/connect?mac=\<BLUETOOTH MAC ADDRESS\>
- Disconnect a BT device by calling \<IP-ADRESS\>:8025/api/v1/bluetooth/connect?mac=\<BLUETOOTH MAC ADDRESS\>

While connected a snapclient will spawn playing audio. Only 1 connection is allowed at the same time.

<b>Bluetooth source</b>
 
Just connect your BT device and start playing music

<b>Docker Builds</b>

https://hub.docker.com/repository/docker/jorenn92/snapserver

<b>Run command</b> 

docker run -dti --privileged --device /dev/snd --net=host --device /dev/bus/usb -v /usr/apps/snapserver/devices:/var/lib/bluetooth --name snapserver --cap-add NET_ADMIN -v /usr/apps/snapserver/conf/:/root/.config/snapserver/ -v /var/run/dbus:/var/run/dbus -v /etc/localtime:/etc/localtime:ro --restart unless-stopped jorenn92/snapserver

<b>Extras </b>

disable bluetooth by adding the BLUETOOTH=false environment var.
