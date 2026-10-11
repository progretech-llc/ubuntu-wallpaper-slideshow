#!/usr/bin/env bash
set -euo pipefail
service=wallpaper-slideshow.service
choice=${1:-}
gui=false
if [[ -z $choice ]]; then
    if ! command -v zenity >/dev/null; then
        echo 'Usage: wallpaper-slideshow-control {status|start|stop|restart}' >&2
        exit 2
    fi
    choice=$(zenity --list --title='Wallpaper Slideshow Control' --column='Action' Status Start Stop Restart) || exit 0
    gui=true
fi
case ${choice,,} in
    status)
        status=$(systemctl --user status "$service" --no-pager 2>&1) || true
        if $gui; then
            zenity --text-info --title='Wallpaper Slideshow Status' --width=720 --height=440 <<< "$status"
        else
            printf '%s\n' "$status"
        fi
        ;;
    start|stop|restart)
        systemctl --user "${choice,,}" "$service"
        if $gui; then
            zenity --info --title='Wallpaper Slideshow' --text="Slideshow: ${choice,,} completed."
        fi
        ;;
    *) echo 'Choose status, start, stop, or restart' >&2; exit 2 ;;
esac
