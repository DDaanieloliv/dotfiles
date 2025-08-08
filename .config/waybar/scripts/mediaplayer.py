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
            # Primeiro obtemos o status
            status = subprocess.check_output(
                ["playerctl", "-p", player, "status"],
                stderr=subprocess.DEVNULL
            ).decode().strip()

            # Obtemos os metadados básicos
            metadata = subprocess.check_output([
                "playerctl", "-p", player, "metadata",
                "--format", r'{"artist": "{{artist}}", "title": "{{title}}", "length": {{mpris:length}}}'
            ], stderr=subprocess.DEVNULL).decode().strip()
            metadata = json.loads(metadata)

            # Obtemos a posição atual apenas se estiver tocando
            if status == "Playing":
                position = subprocess.check_output(
                    ["playerctl", "-p", player, "position"],
                    stderr=subprocess.DEVNULL
                ).decode().strip()
                self.last_position = float(position)
            # Se estiver pausado, usamos a última posição conhecida

            # Convertemos os tempos
            length_sec = metadata.get('length', 0) / 1000000
            position_sec = self.last_position

            position = self.format_time(position_sec)
            length = self.format_time(length_sec)

            status_icon = "" if status == "Playing" else ""
            self.last_status = status

            return {
                "text": f"{status_icon} {metadata.get('artist', '?')} - {metadata.get('title', '?')} ({position}/{length})",
                "tooltip": f"Artista: {metadata.get('artist', 'Desconhecido')}\nMúsica: {metadata.get('title', 'Desconhecida')}\nDuração: {position} de {length}",
                "alt": status.lower(),
                "class": status.lower()
            }
        except Exception as e:
            print(f"Erro: {e}", file=sys.stderr)
            return None

    def main(self):
        player = self.get_active_player()
        if player:
            media_info = self.get_media_info(player)
            if media_info:
                print(json.dumps(media_info))
                return
        
        print(json.dumps({
            "text": "󰈣 Nenhuma mídia",
            "tooltip": "Nenhuma mídia em reprodução",
            "alt": "stopped",
            "class": "stopped"
        }))

if __name__ == "__main__":
    media_status = MediaStatus()
    media_status.main()


# #!/usr/bin/env python3
# import json
# import subprocess
# import sys
#
# def get_active_player():
#     try:
#         players = subprocess.check_output(["playerctl", "-l"]).decode().strip().split('\n')
#         priority_players = ["spotify", "firefox", "chromium", "mpv"]
#         for player in priority_players:
#             if player in players:
#                 return player
#         return players[0] if players else None
#     except:
#         return None
#
# def format_time(seconds):
#     try:
#         seconds = float(seconds)
#         mins, secs = divmod(seconds, 60)
#         return f"{int(mins):02d}:{int(secs):02d}"
#     except:
#         return "--:--"
#
# def get_media_info(player):
#     try:
#         status = subprocess.check_output(
#             ["playerctl", "-p", player, "status"],
#             stderr=subprocess.DEVNULL
#         ).decode().strip()
#         
#         # Obtém metadados em um único comando
#         metadata = subprocess.check_output([
#             "playerctl", "-p", player, "metadata",
#             "--format", r'{"artist": "{{artist}}", "title": "{{title}}", "length": {{mpris:length}}, "position": {{position}}}'
#         ], stderr=subprocess.DEVNULL).decode().strip()
#         
#         metadata = json.loads(metadata)
#         
#         # Formata os tempos (convertendo de microssegundos para segundos)
#         position_sec = metadata.get('position', 0) / 1000000
#         length_sec = metadata.get('length', 0) / 1000000
#         
#         position = format_time(position_sec)
#         length = format_time(length_sec)
#         
#         status_icon = "" if status == "Playing" else ""
#         
#         return {
#             "text": f"{status_icon} {metadata.get('artist', '?')} - {metadata.get('title', '?')} ({position}/{length})",
#             "tooltip": f"Artista: {metadata.get('artist', 'Desconhecido')}\nMúsica: {metadata.get('title', 'Desconhecida')}\nDuração: {position} de {length}",
#             "alt": status.lower(),
#             "class": status.lower()
#         }
#     except Exception as e:
#         print(f"Erro: {e}", file=sys.stderr)
#         return None
#
# def main():
#     player = get_active_player()
#     if player:
#         media_info = get_media_info(player)
#         if media_info:
#             print(json.dumps(media_info))
#             return
#     
#     print(json.dumps({
#         "text": "󰈣 Nenhuma mídia",
#         "tooltip": "Nenhuma mídia em reprodução",
#         "alt": "stopped",
#         "class": "stopped"
#     }))
#
# if __name__ == "__main__":
#     main()


# #!/usr/bin/env python3
# import json
# import subprocess
# import sys
#
# def get_active_player():
#     try:
#         players = subprocess.check_output(["playerctl", "-l"]).decode().strip().split('\n')
#         priority_players = ["spotify", "firefox", "chromium", "mpv"]
#         for player in priority_players:
#             if player in players:
#                 return player
#         return players[0] if players else None
#     except:
#         return None
#
# def format_time(seconds):
#     try:
#         seconds = float(seconds)
#         mins, secs = divmod(seconds, 60)
#         return f"{int(mins):02d}:{int(secs):02d}"
#     except:
#         return "--:--"
#
# def get_media_info(player):
#     try:
#         status = subprocess.check_output(
#             ["playerctl", "-p", player, "status"]
#         ).decode().strip()
#         
#         metadata = subprocess.check_output([
#             "playerctl", "-p", player, "metadata",
#             "--format", '{"artist": "{{artist}}", "title": "{{title}}", "length": "{{duration(mpris:length)}}", "position": "{{duration(position)}}"}'
#         ]).decode().strip()
#         metadata = json.loads(metadata)
#         
#         position = format_time(metadata.get('position', 0))
#         length = format_time(metadata.get('length', 0))
#         
#         status_icon = "" if status == "Playing" else ""
#         
#         return {
#             "text": f"{status_icon} {metadata.get('artist', '?')} - {metadata.get('title', '?')} [{position}/{length}]",
#             "tooltip": f"{status_icon} {metadata.get('artist', 'Artista desconhecido')} - {metadata.get('title', 'Título desconhecido')}\nTempo: {position} / {length}",
#             "alt": status.lower(),
#             "class": status.lower()
#         }
#     except Exception as e:
#         print(f"Erro: {e}", file=sys.stderr)
#         return None
#
# def main():
#     player = get_active_player()
#     if player:
#         media_info = get_media_info(player)
#         if media_info:
#             print(json.dumps(media_info))
#             return
#     
#     print(json.dumps({
#         "text": "󰈣 Nenhuma mídia",
#         "tooltip": "Nenhuma mídia em reprodução",
#         "alt": "stopped",
#         "class": "stopped"
#     }))
#
# if __name__ == "__main__":
#     main()

# #!/usr/bin/env python3
# import json
# import subprocess
# import sys
#
# def get_active_player():
#     """Retorna o player mais recente/ativo."""
#     try:
#         players = subprocess.check_output(["playerctl", "-l"]).decode().strip().split('\n')
#         priority_players = ["spotify", "firefox", "chromium", "mpv"]
#         for player in priority_players:
#             if player in players:
#                 return player
#         return players[0] if players else None
#     except:
#         return None
#
# def format_time(seconds):
#     """Converte segundos para formato MM:SS."""
#     try:
#         seconds = float(seconds)
#         mins, secs = divmod(seconds, 60)
#         return f"{int(mins):02d}:{int(secs):02d}"
#     except:
#         return "--:--"
#
# def get_media_info(player):
#     """Obtém metadados com tratamento especial para status."""
#     try:
#         # Primeiro verifica o status
#         status = subprocess.check_output(
#             ["playerctl", "-p", player, "status"]
#         ).decode().strip()
#         
#         # Obtém todos os metadados de uma vez
#         metadata = subprocess.check_output([
#             "playerctl", "-p", player, "metadata",
#             "--format", '{"artist": "{{artist}}", "title": "{{title}}", "length": "{{duration(mpris:length)}}", "position": "{{duration(position)}}"}'
#         ]).decode().strip()
#         metadata = json.loads(metadata)
#         
#         # Formata os tempos
#         position = format_time(metadata.get('position', 0))
#         length = format_time(metadata.get('length', 0))
#         
#         # Define ícone de status
#         status_icon = {
#             "Playing": "",
#             "Paused": "",
#             "Stopped": ""
#         }.get(status, "")
#         
#         return {
#             "text": f"{status_icon} {metadata.get('artist', '?')} - {metadata.get('title', '?')}",
#             "tooltip": f"{metadata.get('artist', 'Artista desconhecido')} - {metadata.get('title', 'Título desconhecido')}\n{position} / {length}",
#             "alt": status.lower(),
#             "class": status.lower()
#         }
#     except Exception as e:
#         print(f"Erro: {e}", file=sys.stderr)
#         return None
#
# def main():
#     player = get_active_player()
#     if player:
#         media_info = get_media_info(player)
#         if media_info:
#             print(json.dumps(media_info))
#             return
#     
#     # Fallback quando não houver player ativo
#     print(json.dumps({
#         "text": "󰈣",
#         "tooltip": "Nenhuma mídia em reprodução",
#         "alt": "stopped",
#         "class": "stopped"
#     }))
#
# if __name__ == "__main__":
#     main()


# #!/usr/bin/env python3
# import json
# import subprocess
#
# def get_active_player():
#     """Retorna o player mais recente/ativo."""
#     try:
#         players = subprocess.check_output(["playerctl", "-l"]).decode().strip().split('\n')
#         priority_players = ["spotify", "firefox", "chromium", "mpv"]
#         for player in priority_players:
#             if player in players:
#                 return player
#         return players[0] if players else None
#     except:
#         return None
#
# def get_media_info(player):
#     """Obtém metadados com tratamento especial para status pausado."""
#     try:
#         # Primeiro verifica o status
#         status = subprocess.check_output(
#             ["playerctl", "-p", player, "status"]
#         ).decode().strip()
#         
#         # Obtém os metadados básicos
#         metadata = subprocess.check_output([
#             "playerctl", "-p", player, "metadata",
#             "--format", '{"artist": "{{artist}}", "title": "{{title}}", "length": "{{duration(mpris:length)}}"}'
#         ]).decode().strip()
#         metadata = json.loads(metadata)
#         
#         # Só busca a posição atual se estiver tocando
#         if status == "Playing":
#             position = subprocess.check_output(
#                 ["playerctl", "-p", player, "position"]
#             ).decode().strip()
#             time_info = f"{format_time(position)}/{format_time(metadata['length'])}"
#         else:
#             time_info = f"-:--/{format_time(metadata['length'])}"
#         
#         return {
#             "text": f"{metadata.get('artist', '?')} - {metadata.get('title', '?')}",
#             "tooltip": f"{metadata.get('artist', 'Artista desconhecido')} - {metadata.get('title', 'Título desconhecido')} ({time_info})",
#             "alt": status.lower(),
#             "class": status.lower()
#         }
#     except Exception as e:
#         print(f"Erro: {e}", file=sys.stderr)
#         return None
#
# def format_time(seconds):
#     """Converte segundos para formato MM:SS."""
#     try:
#         seconds = float(seconds)
#         mins, secs = divmod(seconds, 60)
#         return f"{int(mins):02d}:{int(secs):02d}"
#     except:
#         return "-:--"
#
# def main():
#     player = get_active_player()
#     if player:
#         media_info = get_media_info(player)
#         if media_info:
#             print(json.dumps(media_info))
#             return
#     
#     # Fallback quando não houver player ativo
#     print(json.dumps({
#         "text": "󰈣",
#         "tooltip": "Nenhuma mídia em reprodução",
#         "alt": "stopped",
#         "class": "stopped"
#     }))
#
# if __name__ == "__main__":
#     import sys
#     main()

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
#     
#     # Fallback quando não houver player ativo ou música
#     print(json.dumps({
#         "text": " ",  # Ícone de "sem música"
#         "tooltip": "Nenhuma mídia em reprodução",
#         "alt": "stopped",
#         "class": "stopped"
#     }))
#
# if __name__ == "__main__":
#     main()

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
