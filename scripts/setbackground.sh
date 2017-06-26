#!/usr/bin/env bash

wget https://source.unsplash.com/random/3840x1080 -O /tmp/bg.jpg
DISPLAY=:0 feh --no-xinerama --bg-max /tmp/bg.jpg
