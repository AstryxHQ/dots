#!/bin/bash

WALL_DIR="$HOME/wallpapers"
CACHE_FILE="$HOME/.cache/current_wallpaper"
WALL_SCRIPT="$HOME/.config/sway/scripts/wallpaper.sh"

# 1. Build the list for wofi
# Each line is just the filename, but we tell wofi where the icons are separately
LIST=$(ls "$WALL_DIR" | grep -E ".jpg$|.png$|.jpeg$|.webp$")

# 2. Show the wofi menu
# We use --img_sel to tell wofi to look for icons in the wallpaper folder
SELECTED=$(echo -e "$LIST" | wofi --dmenu --allow-images --allow-markup --prompt "Select Wallpaper" --width 600 --height 500 --cache-file /dev/null)

# 3. If the user picked something, save and run
if [ -n "$SELECTED" ]; then
    # Construct path carefully
    FULL_PATH="$WALL_DIR/$SELECTED"
    echo "$FULL_PATH" > "$CACHE_FILE"
    bash "$WALL_SCRIPT"
fi
