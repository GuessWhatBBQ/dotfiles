#!/usr/bin/env bash

icon='/tmp/lock_icon.png'
tmpbg='/tmp/background_with_effects.png'
contrast_snippet='/tmp/contrast_snippet.png'
# finding the background image filename (saved to $4)
eval "set -- $(sed 1d "/home/guesswhatbbq/.fehbg")"

# blur the background
convert "$4" -resize 1920x1080^ -gravity center -extent 1920x1080 -brightness-contrast -0x0 -filter Gaussian -blur 0x8 "$tmpbg"

convert "/home/guesswhatbbq/.config/i3/i3-lock/lock_icon.png" -scale 18% "$icon"

convert "$tmpbg" -gravity center -extent 550x170-620+400 "$contrast_snippet"
contrast=$(echo "$(convert "$contrast_snippet" -colorspace Gray -format "%[fx:image.mean]" info:) > 0.5" | bc)

if [ "$contrast" -eq "1" ]; then
    color="111111ff"
else
    color="d1cbbfff"
fi
# overlay the icon onto the image
convert "$tmpbg" "$icon" -gravity center -composite "$tmpbg"

# lock the screen with the blurred image


i3lock --nofork  \
    --ignore-empty-password  \
    \
    --image="$tmpbg"  \
    \
    --force-clock  \
    --timestr="%I:%M:%S %p"  \
    --time-font="Noto Sans"  \
    --timesize=90  \
    --timepos="iy-850:iy+10"  \
    --timecolor=$color	\
    --time-align=1  \
    \
    --datestr="%A, %d %B"	\
    --datecolor=$color	\
    --date-font="Noto Sans"	\
    --datesize=35		\
    --datepos="tx+10:ty+50"	\
    --date-align=1  \
    \
    --indpos="690:940"  \
    --radius=50  \
    --insidecolor="00000077"  \
    --insidevercolor="000000aa"  \
    --ringcolor="ffffffaa"  \
    --ringvercolor="ffffffff"  \
    --ring-width=5  \
    --keyhlcolor="222222"  \
    --bshlcolor="222222"  \
    --line-uses-inside  \
    --separatorcolor="222222"  \
    \
    --veriftext=""  \
    --wrongtext=""  \
    --noinputtext=""  \

rm $tmpbg
rm $icon
rm $contrast_snippet
