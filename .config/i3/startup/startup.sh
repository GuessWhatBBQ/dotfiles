#!/usr/bin/bash

function win_list_prod {
    declare -a windows_string=$(wmctrl -lx | cut -c -10)

    while read -r win_id;
    do
        window_list+=("$win_id")
    done <<< "$windows_string"
}



declare -a apps=("spotify" "terminator" "atom" "firefox" "discord")
declare -a pos=(5, 2, 4, 3, 6)

declare -a win_id=()
declare -a window_list=()
declare -a windows_string=()

let size=${#apps[@]}

for i in $(seq 0 $(($size-1)));
do

    win_list_prod
    last_added_window=${window_list[$((${#window_list[@]}-1))]}

    $(${apps[$i]} >> /tmp/prog.log 2>&1 &)
    sleep 1

    win_list_prod
    new_added_window=${window_list[$((${#window_list[@]}-1))]}

    while [[ last_added_window -eq new_added_window ]];
    do
        sleep 0.1
        win_list_prod
        new_added_window=${window_list[$((${#window_list[@]}-1))]}
    done

    echo $new_added_window ${pos[$i]}
    sleep 1
    # wmctrl -ir $new_added_window -t ${pos[$i]}
    i3-msg "[id="$new_added_window"] move container to workspace ${pos[$i]}"
done
