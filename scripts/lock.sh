#!/bin/bash
ICON=$HOME/dotfiles/img/lock.png
TMPBG=/tmp/screen.png
scrot /tmp/screen.png
convert $TMPBG -spread 7 $TMPBG
i3lock -i $TMPBG
