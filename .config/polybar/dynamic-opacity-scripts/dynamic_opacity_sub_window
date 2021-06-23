#!/usr/bin/bash

# String to set for transparency
transparent_str="bg_current = \${colors.bg_transparent}"
# String to set for opacity
opaque_str="bg_current = \${colors.bg_opaque}"
# Config file location
config_file="$HOME/.config/polybar/config"

tmpfile=$(mktemp)

i3-msg -t subscribe -m '[ "window" ]' |
    while IFS= read -r event
    do
        if $(grep -Fxc "$opaque_str" "$config_file" > /dev/null 2<&1)
        then
            let opaque=1
        else
            let opaque=0
        fi

        let workspace_number=$(xprop -notype -root _NET_CURRENT_DESKTOP | cut -c 24-)
        let window_count=$(i3-msg -t get_tree | jq ".nodes[].nodes[]?.nodes["$workspace_number"]? | del(..?|.floating_nodes[]?) | ..? | .window? // empty" | wc -l)
        current_gaps=$(echo $(i3-msg -t get_tree | jq ".nodes[].nodes[]?.nodes["$workspace_number"]?.gaps[]?"))

        if [ $window_count -eq 1 ] && [ $opaque -eq 0 ]; then
            (
                flock --exclusive --nonblock 200 || exit
                sed "s/$transparent_str/$opaque_str/" "$config_file" > "${tmpfile}"
                cat ${tmpfile} > "$config_file"
            ) 200>/tmp/polybarconfiglock
        elif [ $window_count -ne 1 ] && [ $opaque -eq 1 ]; then
            (
                flock --exclusive --nonblock 200 || exit
                sed "s/$opaque_str/$transparent_str/" "$config_file" > "${tmpfile}"
                cat ${tmpfile} > "$config_file"
            ) 200>/tmp/polybarconfiglock
        fi

        (
            flock --exclusive --nonblock 200 || exit
            if [ "$current_gaps" == "5 5 5 5 5 5" ] || [ "$current_gaps" == "0 0 0 0 0 0 5 5 5 5 5 5" ] && [ $window_count -eq 1 ]; then
                i3-msg gaps inner current minus 5
                i3-msg gaps outer current minus 5
            elif [ "$current_gaps" == "0 0 0 0 0 0" ] || [ "$current_gaps" == "0 0 0 0 0 0 0 0 0 0 0 0" ] && [ $window_count -gt 1 ]; then
                i3-msg gaps inner current plus 5
                i3-msg gaps outer current plus 5
            fi
        ) 200>/tmp/polybarconfiglock
    done
