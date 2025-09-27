#!/bin/bash

echo "Unbinding USB device 1-2..."
echo 1-2 | tee /sys/bus/usb/drivers/usb/unbind
sleep 1 # Give it a moment to unbind
echo "Binding USB device 1-2..."
echo 1-2 | tee /sys/bus/usb/drivers/usb/bind
echo "KVM USB reset script completed."
