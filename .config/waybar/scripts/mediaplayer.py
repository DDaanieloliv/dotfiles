#!/usr/bin/env python3
import json
import subprocess

def get_active_player():
    """Retorna o player mais recente/ativo (priorizando apps de música)."""
    try:
        players = subprocess.check_output(["playerctl", "-l"]).decode().strip().split('\n')
        # Prioriza players específicos (Spotify, Firefox, mpv)
        priority_players = ["spotify", "firefox", "chromium", "mpv"]
        for player in priority_players:
            if player in players:
                return player
        return players[0] if players else None
    except:
        return None

def get_media_info(player):
    """Obtém metadados do player especificado."""
    try:
        data = subprocess.check_output([
            "playerctl", "-p", player, "metadata",
            "--format", '{"text": "{{artist}} - {{title}}", "tooltip": "{{artist}} - {{title}} ({{duration(position)}}/{{duration(mpris:length)}})", "alt": "{{status}}", "class": "{{status}}"}'
        ]).decode().strip()
        return json.loads(data) if data else None
    except:
        return None

def main():
    player = get_active_player()
    if player:
        media_info = get_media_info(player)
        if media_info:
            print(json.dumps(media_info))
            return
    
    # Fallback quando não houver player ativo ou música
    print(json.dumps({
        "text": " ",  # Ícone de "sem música"
        "tooltip": "Nenhuma mídia em reprodução",
        "alt": "stopped",
        "class": "stopped"
    }))

if __name__ == "__main__":
    main()

# #!/usr/bin/env python3
# import json
# import subprocess
#
# def get_active_player():
#     """Retorna o player mais recente/ativo (priorizando apps de música)."""
#     try:
#         players = subprocess.check_output(["playerctl", "-l"]).decode().strip().split('\n')
#         # Prioriza players específicos (Spotify, Firefox, mpv)
#         priority_players = ["spotify", "firefox", "chromium", "mpv"]
#         for player in priority_players:
#             if player in players:
#                 return player
#         return players[0] if players else None
#     except:
#         return None
#
# def get_media_info(player):
#     """Obtém metadados do player especificado."""
#     try:
#         data = subprocess.check_output([
#             "playerctl", "-p", player, "metadata",
#             "--format", '{"text": "{{artist}} - {{title}}", "tooltip": "{{artist}} - {{title}} ({{duration(position)}}/{{duration(mpris:length)}})", "alt": "{{status}}", "class": "{{status}}"}'
#         ]).decode().strip()
#         return json.loads(data) if data else None
#     except:
#         return None
#
# def main():
#     player = get_active_player()
#     if player:
#         media_info = get_media_info(player)
#         if media_info:
#             print(json.dumps(media_info))
#             return
#     # Fallback se não houver player ativo
#     print(json.dumps({"text": "", "tooltip": "", "alt": "stopped", "class": "stopped"}))
#
# if __name__ == "__main__":
#     main()
