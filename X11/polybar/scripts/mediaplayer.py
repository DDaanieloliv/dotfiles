#!/usr/bin/env python3
import json
import subprocess
import sys

class MediaStatus:
    def __init__(self):
        self.last_position = 0
        self.last_status = "Stopped"

    def get_active_player(self):
        try:
            players = subprocess.check_output(["playerctl", "-l"]).decode().strip().split('\n')
            priority_players = ["spotify", "firefox", "chromium", "mpv"]
            for player in priority_players:
                if player in players:
                    return player
            return players[0] if players else None
        except:
            return None

    def format_time(self, seconds):
        try:
            seconds = float(seconds)
            mins, secs = divmod(seconds, 60)
            return f"{int(mins):02d}:{int(secs):02d}"
        except:
            return "--:--"

    def get_media_info(self, player):
        try:
            status = subprocess.check_output(
                ["playerctl", "-p", player, "status"],
                stderr=subprocess.DEVNULL
            ).decode().strip()

            metadata = subprocess.check_output([
                "playerctl", "-p", player, "metadata",
                "--format", r'{"artist": "{{artist}}", "title": "{{title}}", "length": {{mpris:length}}}'
            ], stderr=subprocess.DEVNULL).decode().strip()
            metadata = json.loads(metadata)

            if status == "Playing":
                position = subprocess.check_output(
                    ["playerctl", "-p", player, "position"],
                    stderr=subprocess.DEVNULL
                ).decode().strip()
                self.last_position = float(position)

            length_sec = metadata.get('length', 0) / 1000000
            position_sec = self.last_position

            position = self.format_time(position_sec)
            length = self.format_time(length_sec)

            status_icon = "󰐊" if status == "Playing" else "󰏤"
            self.last_status = status

            artist = metadata.get('artist', '?')[:20]
            title = metadata.get('title', '?')[:20]
            
            return f"{status_icon} {artist} - {title} ({position}/{length})"
            
        except Exception as e:
            print(f"Erro: {e}", file=sys.stderr)
            return None

    def main(self):
        player = self.get_active_player()
        if player:
            media_info = self.get_media_info(player)
            if media_info:
                print(media_info)
                return
        
        print("󰈣 Nenhuma mídia")

if __name__ == "__main__":
    media_status = MediaStatus()
    media_status.main()
