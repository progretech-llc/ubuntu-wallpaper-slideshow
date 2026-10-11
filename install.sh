#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
bindir="${XDG_DATA_HOME:-$HOME/.local/share}/wallpaper-slideshow"
unitdir="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
mkdir -p "$bindir" "$unitdir"
install -m 755 "$root/slideshow.py" "$bindir/slideshow.py"
install -m 755 "$root/control.sh" "$bindir/control.sh"
cat > "$unitdir/wallpaper-slideshow.service" <<EOF
[Unit]
Description=GNOME wallpaper slideshow
After=graphical-session.target

[Service]
Type=simple
ExecStart=$bindir/slideshow.py --directory %h/Pictures/Wallpapers --interval 30
Restart=on-failure

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
if [[ ${1:-} == --enable ]]; then
    systemctl --user enable --now wallpaper-slideshow.service
fi
printf 'Installed. Set your image folder in %s, then run systemctl --user enable --now wallpaper-slideshow.service\n' "$unitdir/wallpaper-slideshow.service"
