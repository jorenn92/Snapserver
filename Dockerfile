#
# From python:ubuntu
#
FROM    ubuntu:20.04
MAINTAINER  "Jven"
LABEL   Description="Snapcast server with Audio delivered by Bluetooth, Spotify & Mopidy"

EXPOSE 1704 1705 1780 6600 6680 5555/udp

ENV BLUETOOTH=true
COPY supervisord.conf /etc/supervisord.conf
COPY spotifyd.conf /etc/spotifyd.conf
COPY asound.conf /etc/asound.conf
COPY mopidy.conf /root/.config/mopidy/mopidy.conf
COPY spotify_takeover.sh /etc/spotify_takeover.sh
COPY bluetooth.sh /etc/bluetooth.sh

# Bluetooth
RUN set -x && \
    apt-get update -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y git automake libtool build-essential pkg-config python-docutils alsa && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y libasound2-dev libbluetooth-dev libdbus-1-dev libglib2.0-dev libsbc-dev libfdk-aac-dev && \
	mkdir /opt/bluez-alsa && \
	cd /opt/bluez-alsa && \
	git clone https://github.com/Arkq/bluez-alsa.git && \
	cd bluez-alsa && \
	autoreconf --install --force && \ 
	mkdir build && \
	cd build && \
	../configure --enable-aac --enable-msbc --enable-ofono --enable-debug && \
	make && \
	make install && \
	DEBIAN_FRONTEND=noninteractive apt-get remove -y git automake build-essential libtool pkg-config python-docutils && \
	DEBIAN_FRONTEND=noninteractive apt-get remove -y libasound2-dev libbluetooth-dev libdbus-1-dev libglib2.0-dev libsbc-dev libfdk-aac-dev && \
	DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
	DEBIAN_FRONTEND=noninteractive apt-get clean -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y libfdk-aac1 libgio-cil && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y dbus libfdk-aac1 libasound2 libbluetooth3 libbsd0 libglib2.0-0 libsbc1 rsyslog  bluez bluez-tools && \
	chmod +x /etc/spotify_takeover.sh /etc/bluetooth.sh
	
# Snapserver, spotify & mopidy
RUN set -x && \
    apt update -y && \
    apt upgrade -y && \
    apt -f install -y python3.8 python3.8-dev python3-pip pkg-config gcc libffi-dev libcairo2-dev python3-cairo-dev libgirepository1.0-dev && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    python3.8 -m pip install --ignore-installed PyGObject && \
    apt -f install -y curl wget libavahi-client3 libavahi-common3 libflac8 libogg0 libopus0 libvorbis0a libvorbisenc2 && \
    wget https://github.com/$(curl -L https://github.com/badaix/snapcast/releases/latest | grep "snapserver_"  | grep "amd64.deb" | grep "<a href=" | cut -d '"' -f 2) && \
    apt -f install -y ./snapserver* && \
    apt -f install -y supervisor mopidy alsa alsa-utils && \
    pip3 install Mopidy-iris && \
    pip3 install Mopidy-tunein && \
    pip3 install Mopidy-Mopify && \
    ldconfig /usr/local/lib && \
    usermod -a -G audio root && \
    mkdir -p /root/.config/mopidy && \
    mkdir -p /opt/spotifyd && \
    cd /opt/spotifyd && \
    wget https://github.com/$(curl -L https://github.com/Spotifyd/spotifyd/releases/latest | grep "spotifyd-linux-slim.tar.gz"  | grep "<a href=" | cut -d '"' -f 2) && \
    tar -zxvf spotifyd-linux-slim.tar.gz && \
    apt -y remove python3.8-dev pkg-config gcc libffi-dev python3-cairo-dev wget && \
    apt -y autoremove

COPY bluetooth_main.conf /etc/bluetooth/main.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
