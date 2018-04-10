#!/bin/bash
# TMPBG=/tmp/screen.png
# scrot $TMPBG
# convert $TMPBG -spread 15 $TMPBG

B='#000000ff'  # blank
C='#ffffffff'  # clear ish
D='#ffffffff'  # default
T='#ffffffff'  # text
W='#880000bb'  # wrong
V='#ffffffff'  # verifying

sleep 0.1s

i3lock                \
--insidevercolor=$C   \
--ringvercolor=$V     \
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
--timecolor=$T        \
--datecolor=$T        \
--keyhlcolor=$W       \
--screen=0            \
--blur=10             \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%A, %m %Y" \

# --veriftext="Drinking verification can..."
# --wrongtext="Nope!"
