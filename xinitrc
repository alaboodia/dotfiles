#!/bin/sh
setxkbmap -model pc104 -layout us,ara -variant qwerty -option grp:alt_shift_toggle
picom -b
/usr/bin/pipewire &
/usr/bin/pipewire-pulse & 
/usr/bin/wire/plumber &
feh --bg-scale ~/theRiceVoid/background
~/theRiceVoid/./dwm_bar.sh
dbus-launch "dwm"

