#!/usr/bin/env bash
set -euo pipefail
service=wallpaper-slideshow.service
choice=${1:-}
if [[ -z $choice ]]; then
    if ! command -v zenity >/dev/null; then
        echo 'Usage: wallpaper-slideshow-control {status|start|stop|restart}' >&2
        exit 2
    fi
    choice=$(zenity --list --title='Wallpaper Slideshow Control' --column='Action' Status Start Stop Restart) || exit 0
fi
case ${choice,,} in
    status) systemctl --user status "$service" --no-pager || true ;;
    start|stop|restart) systemctl --user "${choice,,}" "$service" ;;
    *) echo 'Choose status, start, stop, or restart' >&2; exit 2 ;;
esac
