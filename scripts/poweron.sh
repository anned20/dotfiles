#!/bin/bash
modprobe nvidia-378
modprobe nvidia-378-modeset
modprobe nvidia-378-drm
modprobe nvidia-378-uvm
echo ON > /proc/acpi/bbswitch
