#!/bin/bash

# Start a snapclient connected to a bluetooth device
if [[ ! -z $BLUETOOTH_CLIENT ]]; then
	if [[ $(cat /etc/alsa/conf.d/20-bluealsa.conf | grep -i 'defaults.bluealsa.device ') == "" ]]; then
		echo "defaults.bluealsa.device \"$BLUETOOTH_CLIENT\"" >> /etc/alsa/conf.d/20-bluealsa.conf
	fi
	
	bluetoothctl power on

	echo "scanning devices for 5 seconds.."
	bluetoothctl scan on &
	SCANPID=$!
	sleep 5
	kill -INT $SCANPID
	bluetoothctl trust $BLUETOOTH_CLIENT
	yes | bluetoothctl pair $BLUETOOTH_CLIENT
	bluetoothctl connect $BLUETOOTH_CLIENT
	echo "connection done.. If the device isn't available remove the /var/lib/bluetooth/bluetooth_setup_done file, set the device in pairing mode and re-create the container"
	snapclient -h 127.0.0.1 -s bluealsa
fi