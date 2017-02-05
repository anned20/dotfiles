#!/bin/bash
TMPBG=/tmp/screen.png
scrot $TMPBG
convert $TMPBG -spread 15 $TMPBG
i3lock -i $TMPBG
