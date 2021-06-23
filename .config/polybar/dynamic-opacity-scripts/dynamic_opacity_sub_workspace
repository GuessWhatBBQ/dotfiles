#!/usr/bin/bash

# String to set for transparency
transparent_str="bg_current = \${colors.bg_transparent}"
# String to set for opacity
opaque_str="bg_current = \${colors.bg_opaque}"
# Config file location
config_file="$HOME/.config/polybar/config"

tmpfile=$(mktemp)

i3-msg -t subscribe -m '[ "workspace" ]' |
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

        if [ $window_count -ne 1 ] && [ $opaque -eq 1 ];
        then
            (
                flock --exclusive --nonblock 200 || exit
                sed "s/$opaque_str/$transparent_str/" "$config_file" > "${tmpfile}"
                cat ${tmpfile} > "$config_file"
            ) 200>/tmp/polybarconfiglock
        fi
    done
