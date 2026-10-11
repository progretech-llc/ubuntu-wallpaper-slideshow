#!/usr/bin/env python3
"""Rotate local images through GNOME's light and dark wallpaper settings."""
import argparse
import signal
import subprocess
import time
from pathlib import Path

EXTENSIONS = {'.png', '.jpg', '.jpeg', '.webp'}
RUNNING = True


def stop(_signal, _frame):
    global RUNNING
    RUNNING = False


def images(directory):
    return sorted(p for p in directory.iterdir() if p.is_file() and p.suffix.lower() in EXTENSIONS)


def set_wallpaper(path):
    uri = path.resolve().as_uri()
    for key, value in [('picture-uri', uri), ('picture-uri-dark', uri), ('picture-options', 'zoom')]:
        subprocess.run(['gsettings', 'set', 'org.gnome.desktop.background', key, value], check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--directory', type=Path, default=Path.home() / 'Pictures' / 'Wallpapers')
    parser.add_argument('--interval', type=float, default=30, help='Seconds per image (default: 30)')
    args = parser.parse_args()
    if args.interval <= 0:
        parser.error('--interval must be positive')
    directory = args.directory.expanduser().resolve()
    if not directory.is_dir():
        parser.error(f'not a directory: {directory}')
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    while RUNNING:
        for image in images(directory):
            if not RUNNING:
                break
            set_wallpaper(image)
            print(f'Wallpaper: {image}', flush=True)
            deadline = time.monotonic() + args.interval
            while RUNNING and time.monotonic() < deadline:
                time.sleep(max(0, min(0.5, deadline - time.monotonic())))
        if RUNNING and not images(directory):
            print(f'No images in {directory}', flush=True)
            time.sleep(args.interval)


if __name__ == '__main__':
    main()
