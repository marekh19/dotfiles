#!/bin/bash

# Define the array of commands
commands=(
	'hyprctl hyprpaper wallpaper "DP-1,~/Pictures/Wallpapers/japan.png"'
	'hyprctl hyprpaper wallpaper "DP-1,~/Pictures/Wallpapers/mountains.png"'
	'hyprctl hyprpaper wallpaper "DP-1,~/Pictures/Wallpapers/shop.jpg"'
)

# Function to change wallpaper
change_wallpaper() {
	# Get the current command index
	current_index=$(cat /tmp/wallpaper_index 2>/dev/null || echo 0)

	# Execute the command
	eval "${commands[$current_index]}"

	# Increment the index or reset to 0 if it's the last command
	next_index=$(((current_index + 1) % ${#commands[@]}))

	# Save the next index to a file
	echo $next_index >/tmp/wallpaper_index
}

# Change wallpaper every 30 minutes
while true; do
	change_wallpaper
	sleep 1800 # 30 minutes sleep
done
