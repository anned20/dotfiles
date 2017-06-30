#!/usr/bin/env bash

wget https://source.unsplash.com/random/1920x1080 -O /tmp/bg.jpg
DISPLAY=:0 feh --bg-max /tmp/bg.jpg
