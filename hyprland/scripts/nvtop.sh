#!/usr/bin/env bash

hyprctl dispatch workspace 5

kitty --class nvtop-term -e nvtop
