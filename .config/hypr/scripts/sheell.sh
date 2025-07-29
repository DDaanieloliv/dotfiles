#!/usr/bin/env bash

hyprctl dispatch workspace 5

kitty --class sheell-term -e bash -c "nitch; exec bash" &

