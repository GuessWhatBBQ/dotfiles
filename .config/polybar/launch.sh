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

polybar --config=$HOME/.config/polybar/config notif_bar >> /tmp/polybar_notifbar.log 2>&1 &
ln -s /tmp/polybar_mqueue.$! /tmp/notif_bar
sleep 0.1

polybar --config=$HOME/.config/polybar/config -r bottombar >> /tmp/polybar_bottombar.log 2>&1 &
ln -s /tmp/polybar_mqueue.$! /tmp/bottombar
sleep 0.1

polybar --config=$HOME/.config/polybar/config -r topbar >> /tmp/polybar_topbar.log 2>&1 &
ln -s /tmp/polybar_mqueue.$! /tmp/topbar
sleep 0.1

# polybar-msg cmd hide

# Commands can be sent to individual bars using the following format
# $ echo cmd:hide >/tmp/barname

echo "Polybar launched..."

$HOME/.config/polybar/dynamic-opacity-scripts/dynamic_opacity_sub_workspace.sh &
$HOME/.config/polybar/dynamic-opacity-scripts/dynamic_opacity_sub_window.sh &
