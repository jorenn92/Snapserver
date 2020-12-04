# Snapserver
Snapcast server with mopidy &amp; spotify connect

Note: Harcoded url in spotify_takeover.sh

Builds https://hub.docker.com/repository/docker/jorenn92/snapserver

Run command: docker run -dti --privileged --device /dev/snd --net=host --device /dev/bus/usb -v /usr/apps/snapserver/devices:/var/lib/bluetooth --name snapserver --cap-add NET_ADMIN -v /usr/apps/snapserver/conf/:/root/.config/snapserver/ -v /var/run/dbus:/var/run/dbus -v /etc/localtime:/etc/localtime:ro --restart unless-stopped jorenn92/snapserver
