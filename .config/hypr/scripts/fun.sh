#!/usr/bin/env bash

hyprctl dispatch workspace 5

kitty --class fun-term -e bash -c "pipes.sh -f 30" &
