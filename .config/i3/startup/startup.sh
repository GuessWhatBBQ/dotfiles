#!/usr/bin/bash

start () {
    nohup $@ > /dev/null &
}

start firefox
start discord-canary
start emacs

i3-msg workspace 2; start alacritty

sleep 0.3
start env LD_PRELOAD=/usr/lib/spotify-adblock.so spotify
