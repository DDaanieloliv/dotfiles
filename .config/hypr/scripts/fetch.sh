#!/usr/bin/env bash

hyprctl dispatch workspace 5

kitty --class fetch-term -e bash -c "clear && nitch; exec bash"
