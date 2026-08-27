#!/usr/bin/env bash

# Check if the active window is in a group
is_grouped=$(hyprctl activewindow -j | jq '.grouped | length')

# Direction argument (f for forward, b for backward)
direction=${1:-f}

if [ "$is_grouped" -gt 0 ]; then
    # If in a group, cycle through the tabs
    hyprctl dispatch changegroupactive "$direction"
else
    # If not in a group, cycle through windows on the workspace
    if [ "$direction" = "b" ]; then
        hyprctl dispatch cyclenext prev
    else
        hyprctl dispatch cyclenext
    fi
    hyprctl dispatch bringactivetotop
fi
