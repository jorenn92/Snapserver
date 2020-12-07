#!/bin/bash

# Disconnect a connected bluetooth device
if [[ ! -z $BLUETOOTH_CLIENT ]]; then
	bluetoothctl disconnect $BLUETOOTH_CLIENT
	echo "Device $BLUETOOTH_CLIENT disconnected"
fi