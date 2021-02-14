#!/usr/bin/bash

let opaque=0
let hidden=1
polybar-msg cmd hide
while :
do
	sleep 0.5
	let window_count=$(xdotool search --all --onlyvisible --desktop $(xprop -notype -root _NET_CURRENT_DESKTOP | cut -c 24-) "" 2>/dev/null | wc -l)
	let window_number=$(xprop -notype -root _NET_CURRENT_DESKTOP | cut -c 24-)+1


	if [ $window_count -eq 1 ] && [ $opaque -eq 0 ] && [ $window_number -ne 1 ];
	then
		let opaque=1
#		echo setting to opaque
		sed -i "s/background = \${colors.bg_transparent}/background = \${colors.bg_opaque}/" .config/polybar/config
		echo $opaque $window_count

	fi
	if [ $window_count -ne 1 ] && [ $opaque -eq 1 ] && [ $window_number -ne 1 ];
	then
		let opaque=0
#		echo setting to transparent
		sed -i "s/background = \${colors.bg_opaque}/background = \${colors.bg_transparent}/" .config/polybar/config
		echo $opaque $window_count
	fi
	if [ $window_number -eq 1 ] && [ $hidden -eq 0 ];
	then
		echo $window_number
		polybar-msg cmd hide
		let hidden=1

	fi
	if [ $window_number -ne 1 ] && [ $hidden -eq 1 ];
	then
		echo $window_number
		polybar-msg cmd show
		let hidden=0

	fi
done
