#!/bin/bash
/usr/sbin/rsyslogd > /dev/null 2>&1 &
	
if [[ $BLUETOOTH == "true" ]]; then

	if [[ -e "/run/dbus/pid" ]]; then
			rm /run/dbus/pid
	fi
	/etc/init.d/bluetooth start && /usr/bin/dbus-daemon --system 
	/usr/lib/bluetooth/bluetoothd &
	/usr/bin/bluealsa -i hci0 -p a2dp-sink > /dev/null 2>&1 &
	
	bluetoothctl power on
	bluetoothctl agent on
	bluetoothctl discoverable on
	bluetoothctl pairable on
	bluetoothctl agent NoInputNoOutput
	bluetoothctl default-agent 
	bt-agent --capability=NoInputNoOutput > /dev/null 2>&1 &
	# Start listener
	bluealsa-aplay
fi