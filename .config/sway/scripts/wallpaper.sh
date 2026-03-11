#!/bin/bash

CACHE_FILE="$HOME/.cache/current_wallpaper"

if [ -f "$CACHE_FILE" ]; then
    WALL=$(cat "$CACHE_FILE")
else
    WALL="$HOME/wallpapers/star-city.png"
fi

# 1. Start swww-daemon only if not already running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    while ! swww query > /dev/null 2>&1; do
        sleep 0.1
    done
fi

# 2. Run pywal
wal -i "$WALL" -n -q

# 3. Set wallpaper on both monitors with correct resolution
swww img "$WALL" \
    --outputs eDP-1 \
    --resize fit \
    --transition-type grow \
    --transition-step 90 \
    --transition-fps 60 &

swww img "$WALL" \
    --outputs HDMI-A-1 \
    --resize fit \
    --transition-type grow \
    --transition-step 90 \
    --transition-fps 60 &

wait

# 4. Reload cava and waybar
cp ~/.cache/wal/colors-cava ~/.config/cava/config
pkill -USR1 cava
pkill -USR2 waybar
