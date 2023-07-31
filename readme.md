# tix - **t**aki's n**ix** flake

---

some help I've gotten:

i3 + dunst indicators: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator

I've somewhat rewritten it. (see [this file](modules/home-manager/i3wm/duvolbr.nix))
It now uses nix functions :) no more pactl/playerctl/libnotify package dependencies.
Make sure you have something of the following tho:

* i3
* dunst
* pipewire with pulseaudio (or directly pulseaudio) enabled

polybar & playerctl: https://gitlab.com/Nmoleo/polybar_playerctl
