# ~/.config/waybar/scripts/powermenu.sh - Should be Excutable. To this use that command 'chmod +x ~/.config/waybar/scripts/powermenu.sh'.
#!/usr/bin/env bash

chosen=$(echo -e "⏻\n\n\n \n\n" | \
  rofi -theme ~/.config/rofi/powerMenuConfig.rasi -dmenu -p "Power Menu")

case "$chosen" in
  "⏻") systemctl poweroff ;;
  "") systemctl reboot ;;
  "") systemctl suspend ;;
  "") systemctl hibernate ;;
  "") loginctl lock-session ;;
  *) exit 0 ;;
esac
