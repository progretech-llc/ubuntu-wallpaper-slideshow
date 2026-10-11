# Ubuntu Wallpaper Slideshow

A small GNOME wallpaper rotation service and control script, adapted from a ProgreTech workstation setup. It updates both light and dark `picture-uri` settings. Images remain local and are never uploaded.

Requirements: GNOME, Python 3, `gsettings`, and a user systemd session. `zenity` is optional for the graphical control menu.

```bash
./install.sh
# Edit ~/.config/systemd/user/wallpaper-slideshow.service if your image folder differs.
systemctl --user daemon-reload
systemctl --user enable --now wallpaper-slideshow.service
./control.sh status
```

`./install.sh --enable` installs and starts it in one step. `./control.sh` opens a Zenity menu; `./control.sh stop` works in a terminal. To make a desktop shortcut, copy `wallpaper-slideshow-control.desktop.example` to `~/Desktop/Wallpaper Slideshow Control.desktop`, replace `YOUR_USER` with your login, and mark it executable. The service defaults to `~/Pictures/Wallpapers`, 30 seconds per image, sorted filenames, PNG/JPEG/WebP. Start `slideshow.py --directory PATH --interval SECONDS` for direct use.

To pause across logins: `systemctl --user disable --now wallpaper-slideshow.service`. To remove the installed service and scripts, disable it, delete the unit and `~/.local/share/wallpaper-slideshow`, then run `systemctl --user daemon-reload`. The original workstation images are not included.
