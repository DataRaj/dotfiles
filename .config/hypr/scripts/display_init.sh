#!/usr/bin/env bash
# ~/.config/hypr/scripts/display_init.sh

# Kill old instances
killall -q gammastep
hyprshade off

# Small delay so Wayland session is ready
sleep 2

# Start gammastep in background with permanent values
gammastep -m wayland \
    -O 6700 \
    -g 0.83:0.88:0.97 \
    -b 1 &

# # Wait a bit before shader layer
sleep 1

# Start hyprshade
if command -v hyprshade &>/dev/null; then
    hyprshade on color_tuning
fi
