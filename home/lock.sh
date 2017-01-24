#!/bin/bash
ICON=$HOME/dotfiles/img/lock.png
TMPBG=/tmp/screen.png
scrot /tmp/screen.png
convert $TMPBG -scale 10% -scale 1000% $TMPBG
convert $TMPBG $ICON -gravity northwest -composite -matte $TMPBG
i3lock -u -i $TMPBG
