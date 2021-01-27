#!/bin/bash

# Terminate dynamic polybar
pkill dynamic_opacity

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Clear polybar_mqueu files in /tmp/
rm $(ls /tmp/polybar*) /tmp/notif_bar /tmp/bottombar /tmp/topbar

# Launch Polybar, using default config location ~/.config/polybar/config

polybar --config=$HOME/.config/i3/polybar/config notif_bar &
ln -s /tmp/polybar_mqueue.$! /tmp/notif_bar
sleep 0.1

polybar --config=$HOME/.config/i3/polybar/config -r bottombar &
ln -s /tmp/polybar_mqueue.$! /tmp/bottombar
sleep 0.1

polybar --config=$HOME/.config/i3/polybar/config -r topbar &
ln -s /tmp/polybar_mqueue.$! /tmp/topbar
sleep 0.1

# polybar-msg cmd hide

# Commands can be sent to individual bars using the following format
# $ echo cmd:hide >/tmp/barname

echo "Polybar launched..."

/home/guesswhatbbq/.config/i3/polybar/dynamic_opacity_sub_workspace.sh &
/home/guesswhatbbq/.config/i3/polybar/dynamic_opacity_sub_window.sh &
