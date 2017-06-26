#!/usr/bin/env sh

killall -q xfce4-panel

while pgrep -x xfce4-panel >/dev/null; do sleep 1; done

xfce4-panel --disable-wm-check &

killall i3bar 
