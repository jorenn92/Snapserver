#!/bin/bash

# Start a snapclient connected to a bluetooth device
if [[ ! -z $BLUETOOTH_CLIENT ]]; then
	kill -9 $(pgrep snapclient)
	
	if [[ $(cat /etc/alsa/conf.d/20-bluealsa.conf | grep -i 'defaults.bluealsa.device ') == "" ]]; then
		echo "defaults.bluealsa.device \"$BLUETOOTH_CLIENT\"" >> /etc/alsa/conf.d/20-bluealsa.conf
	else
		sed -i "s/^defaults.bluealsa.device \".*/defaults.bluealsa.device \"${BLUETOOTH_CLIENT}\"/" /etc/alsa/conf.d/20-bluealsa.conf
	fi

	bluetoothctl power on
	
	if [[ $(bluetoothctl paired-devices) != *"$BLUETOOTH_CLIENT"* ]]; then
		echo "scanning devices for 5 seconds.."
		bluetoothctl scan on &
		SCANPID=$!
		sleep 5
		kill -INT $SCANPID
		bluetoothctl trust $BLUETOOTH_CLIENT
		yes | bluetoothctl pair $BLUETOOTH_CLIENT
		bluetoothctl connect $BLUETOOTH_CLIENT
		echo "connecting done.. If the device isn't available set the device in pairing mode and call the api again"
	else
		echo "Connecting to $BLUETOOTH_CLIENT"
		bluetoothctl disconnect $BLUETOOTH_CLIENT
		bluetoothctl connect $BLUETOOTH_CLIENT
	fi
	snapclient -h 127.0.0.1 -s bluealsa
fi
