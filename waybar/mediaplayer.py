#!/usr/bin/env python3
import json
import subprocess

def get_field(field):
    try:
        return subprocess.check_output([
            "playerctl", "metadata", f"--format={{{{{field}}}}}"
        ]).decode("utf-8").strip()
    except:
        return ""

def main():
    status = get_field("status")
    title = get_field("title")
    artist = get_field("artist")
    player = get_field("playerName")

    if not title and not artist:
        print(json.dumps({
            "text": "",
            "tooltip": "No media playing",
            "class": "inactive",
            "alt": "inactive",
            "icon": "🎜"
        }))
        return

    icon_map = {
        "spotify": "",
        "firefox": "",
        "chromium": "",
        "chrome": "",
        "default": "🎵"
    }

    icon = icon_map.get(player.lower(), icon_map["default"])
    text = f"{artist} - {title}" if artist else title

    print(json.dumps({
        "text": text,
        "tooltip": text,
        "class": player.lower() if player else "default",
        "alt": status.lower() if status else "default",
        "icon": icon
    }))

if __name__ == "__main__":
    main()
