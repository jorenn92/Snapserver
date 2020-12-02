# Snapserver
Snapcast server with mopidy &amp; spotify connect

Builds https://hub.docker.com/repository/docker/jorenn92/snapserver

Run command: docker run -dti --device /dev/snd --net=host --name snapserver -v /usr/apps/snapserver/conf/:/root/.config/snapserver/ --restart unless-stopped jorenn92/snapserver
