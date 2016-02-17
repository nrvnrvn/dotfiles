#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

export BROWSER=chromium
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# localectl set-x11-keymap "us,ru" "" "" "grp:alt_space_toggle,ctrl:nocaps"

#xrandr --output DVI-0 --auto --output DVI-1 --auto --right-of DVI-0
convert -size 1x1 xc:#222 $HOME/.wallpaper.png
feh --bg-scale $HOME/.wallpaper.png
compton -fzcCGb --backend glx --paint-on-overlay -D5 -r10 -l-14 -t-13 --config /dev/null

while [ "$(sleep 5s; pgrep dwm)" ]; do
    [ $(command -v acpi) ] && batt=$(LC_ALL=C acpi -b)
    datetime=$(date +"%d.%m %R")
        case $batt in
        *Discharging*)
                batt="$(echo $batt|awk '{gsub(/\,/,""); print $4}') | "
                ;;
        *)
                batt=""
                ;;
        esac

    xsetroot -name "$batt$datetime"
done &
exec ssh-agent dwm
