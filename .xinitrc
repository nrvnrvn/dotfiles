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

export EDITOR=vim
export BROWSER=chromium
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# localectl set-x11-keymap "us,ru" "" "" "grp:alt_space_toggle,ctrl:nocaps"
xset m 6

feh --bg-fill $HOME/.wallpaper.png
compton -fzcCG --backend glx --paint-on-overlay -D5 -r10 -l-14 -t-13 &
$HOME/.statusbar &
exec dwm
