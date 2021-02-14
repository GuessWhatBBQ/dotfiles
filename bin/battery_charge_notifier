#!/usr/bin/bash

notif_id="998877"

function battery_info {
    time_to_empty=$(upower -i $(upower -e | grep 'BAT') | grep "$1")
    delimiter=' '
    s=$time_to_empty$delimiter
    array=()
    while [[ $s ]]; do
        array+=( "${s%%"$delimiter"*}" )
        s=${s#*"$delimiter"}
    done
}

while true; do
    battery_info "time to empty"
    echo "$(date): Time to empty battery is ${array[(${#array[@]}-2)]} ${array[(${#array[@]}-1)]}" >> /home/guesswhatbbq/.config/i3/battery_stats/low_batter.log
    if [ "${array[(${#array[@]}-1)]}" == "minutes" ]; then
        is_less=$(echo "${array[(${#array[@]}-2)]} <= 10" | bc)
        echo IsLess $is_less >> /home/guesswhatbbq/.config/i3/battery_stats/low_batter.log
        if [ "$is_less" -eq "1" ]; then
            dunstify -a "Battery Status" -u critical -r $notif_id -i battery-010 "Low Battery" "Please connect the device to a charger"
            while true; do
                sleep 1
                echo "$(date): Waiting to be plugged in" >> /home/guesswhatbbq/.config/i3/battery_stats/low_batter.log
                dbus-send --print-reply --system --dest=org.freedesktop.UPower "/org/freedesktop/UPower/devices/battery_BAT0" "org.freedesktop.UPower.Device.Refresh"
                battery_info "state"
                if [ "${array[(${#array[@]}-1)]}" == "charging" ]; then
                    dunstify --close $notif_id
                    break
                fi
            done
        fi
    fi
    sleep 120
done
