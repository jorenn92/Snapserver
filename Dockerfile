#
# From python:ubuntu
#
FROM    ubuntu:20.04
MAINTAINER  "Jven"
LABEL   Description="Snapcast server with Audio delivered by Bluetooth, Spotify & Mopidy"

EXPOSE 1704 1705 1780 6600 6680 5555/udp

ENV BLUETOOTH=true

ADD api /opt/api/
COPY scripts/spotify_takeover.sh /etc/spotify_takeover.sh
COPY scripts/bluetooth.sh /etc/bluetooth.sh

# Bluetooth
RUN set -x && \
    apt-get update -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y git automake cmake libtool build-essential pkg-config python-docutils alsa && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y libasound2-dev libbluetooth-dev libdbus-1-dev libglib2.0-dev libsbc-dev libfdk-aac-dev && \
	mkdir /opt/libldac && \
	cd /opt/libldac && \
	git clone https://github.com/EHfive/ldacBT.git && \
	cd ldacBT && \
	git submodule update --init && \
	mkdir build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DINSTALL_LIBDIR=/usr/lib -DLDAC_SOFT_FLOAT=OFF .. && \
	make DESTDIR=$DEST_DIR install && \
	mkdir /opt/bluez-alsa && \
	cd /opt/bluez-alsa && \
	git clone https://github.com/Arkq/bluez-alsa.git && \
	cd bluez-alsa && \
	autoreconf --install --force && \ 
	mkdir build && \
	cd build && \
	../configure --enable-aac --enable-msbc --enable-ldac --enable-ofono --enable-debug && \
	make && \
	make install && \
	DEBIAN_FRONTEND=noninteractive apt-get remove -y git automake build-essential libtool pkg-config python-docutils && \
	DEBIAN_FRONTEND=noninteractive apt-get remove -y libasound2-dev libbluetooth-dev libdbus-1-dev libglib2.0-dev libsbc-dev libfdk-aac-dev && \
	DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
	DEBIAN_FRONTEND=noninteractive apt-get clean -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y libfdk-aac1 libgio-cil && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y dbus libfdk-aac1 libasound2 libbluetooth3 libbsd0 libglib2.0-0 libsbc1 rsyslog  bluez bluez-tools && \
	chmod +x /etc/spotify_takeover.sh /etc/bluetooth.sh
	
# Snapserver, spotify, mopidy & api
RUN set -x && \
    apt update -y && \
    apt upgrade -y && \
    apt -f install -y libusb-dev libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev git rustc cargo libasound2-dev libssl-dev pkg-config python3.8 python3.8-dev python3-pip pkg-config gcc libffi-dev libcairo2-dev python3-cairo-dev libgirepository1.0-dev && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    python3.8 -m pip install --ignore-installed PyGObject && \
    apt -f install -y curl wget libavahi-client3 libavahi-common3 libflac8 libogg0 libopus0 libvorbis0a libvorbisenc2 && \
    wget https://github.com/$(curl -L https://github.com/badaix/snapcast/releases/latest | grep "snapserver_"  | grep "amd64.deb" | grep "<a href=" | cut -d '"' -f 2 | head -n 1) && \
    apt -f install -y ./snapserver* && \
	wget https://github.com/$(curl -L https://github.com/badaix/snapcast/releases/latest | grep "snapclient_"  | grep "amd64.deb" | grep "<a href=" | cut -d '"' -f 2 | head -n 1) && \
    apt -f install -y ./snapclient* && \
    apt -f install -y supervisor mopidy alsa alsa-utils && \
    pip3 install Mopidy-iris && \
    pip3 install Mopidy-tunein && \
    pip3 install Mopidy-Mopify && \
    pip3 install Mopidy-Spotify && \
    ldconfig /usr/local/lib && \
    usermod -a -G audio root && \
    mkdir -p /root/.config/mopidy && \
    mkdir -p /opt/spotifyd && \
    cd /opt/spotifyd && \
	git clone https://github.com/Spotifyd/spotifyd.git && \
	cd spotifyd && \
	cargo build --release --no-default-features --features alsa_backend && \
	cd ../ && \
	mv spotifyd/target/release/spotifyd temp && \
	rm -rf spotifyd && \
	mv temp spotifyd && \
	# bluez dl on hold because of unmet dependencies
	#wget http://nl.archive.ubuntu.com/ubuntu/pool/main/b/bluez/$(curl -L http://nl.archive.ubuntu.com/ubuntu/pool/main/b/bluez/ | grep 'bluez_' | grep 'amd64.deb' | awk -F  '<a href='  '{print $2}' | cut -d '"' -f 2 | tail -n 1) && \
	#apt install ./bluez_*.deb && \
    apt -y remove git rustc cargo libasound2-dev libssl-dev pkg-config python3.8-dev pkg-config gcc libffi-dev python3-cairo-dev wget && \
    apt -y autoremove && \
	pip3 install flask && \
	chmod +x /opt/api/*

COPY conf/supervisord.conf /etc/supervisord.conf
COPY conf/spotifyd.conf /etc/spotifyd.conf
COPY conf/asound.conf /etc/asound.conf
COPY conf/mopidy.conf /root/.config/mopidy/mopidy.conf
COPY conf/bluetooth_main.conf /etc/bluetooth/main.conf
|
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
