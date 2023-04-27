#!/bin/bash -e

BKG_DIR=$HOME/Pictures/backgrounds
RANDOM_PIC=$(find "$BKG_DIR" -name '*.jpg' -o -name '*.png' | shuf -n1)
[[ -n $UID ]] || UID=$(id -u)
[[ -n $DBUS_SESSION_BUS_ADDRESS ]] || DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus"
export DBUS_SESSION_BUS_ADDRESS

#dbus-launch --exit-with-session /usr/bin/gsettings set org.gnome.desktop.background picture-uri "file://$RANDOM_PIC"
#dbus-launch --exit-with-session /usr/bin/gsettings set org.gnome.desktop.screensaver picture-uri "file://$RANDOM_PIC"
DEFAULT_KEY=picture-uri
DARKMODE_KEY=$DEFAULT_KEY-dark

#declare -A URI_KEY
#URI_KEY[screensaver]=$DEFAULT_KEY
#if [[ $(gsettings get org.gnome.desktop.interface color-scheme) =~ dark ]]; then
#	URI_KEY[background]=$DEFAULT_KEY-dark
#else
#	URI_KEY[background]=$DEFAULT_KEY
#fi

#for gs_key in "${!URI_KEY[@]}"; do
#    gsettings set org.gnome.desktop.$gs_key ${URI_KEY[$gs_key]} "file://$RANDOM_PIC"
#done
gsettings set org.gnome.desktop.screensaver $DEFAULT_KEY "file://$RANDOM_PIC"
gsettings set org.gnome.desktop.background $DEFAULT_KEY "file://$RANDOM_PIC"
gsettings set org.gnome.desktop.background $DARKMODE_KEY "file://$RANDOM_PIC"
