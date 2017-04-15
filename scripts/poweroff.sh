#!/bin/bash
line=$(</etc/prime-discrete)
if [ "$line" == "off" ] 
   then
   rmmod nvidia-drm
   rmmod nvidia-modeset
   rmmod nvidia
   bash -c 'echo OFF > /proc/acpi/bbswitch'
fi 
