#!/usr/bin/env bash
set -euo pipefail

# =================== wallpaper =============================
wallpapers=(
  "/home/prem/Pictures/Wallpapers/Castlevania/DraculaCastlePixel.png" 
  "/home/prem/Pictures/Wallpapers/Castlevania/dracula.png"
  "/home/prem/Pictures/Wallpapers/Castlevania/alucardMoon.png"
  "/home/prem/Pictures/Wallpapers/Castlevania/death.jpg"
  "/home/prem/Pictures/Wallpapers/Castlevania/Mordor.jpg"
)
state_file="$HOME/.cache/current_wallpaper_index"
# ===========================================================

# sanity: hyprctl must exist
if ! command -v hyprctl >/dev/null 2>&1; then
  echo "hyprctl not found. Install hyprpaper and ensure hyprctl is in \$PATH." >&2
  exit 1
fi

# ensure cache dir exists and state file
mkdir -p "$(dirname "$state_file")"
if [[ ! -f "$state_file" ]]; then
  printf "0" > "$state_file"
fi

# read current index and compute next
index=$(cat "$state_file" 2>/dev/null || echo 0)
# guard if index isn't a valid number
if ! [[ "$index" =~ ^[0-9]+$ ]]; then index=0; fi

next=$(( (index + 1) % ${#wallpapers[@]} ))

# preload then set wallpapers on all monitors
hyprctl hyprpaper preload "${wallpapers[$next]}"
# hyprctl hyprpaper wallpaper "eDP-1,${wallpapers[$next]}"
monitors=$(hyprctl monitors -j | jq -r '.[].name')
for m in $monitors; do
  hyprctl hyprpaper wallpaper "$m,${wallpapers[$next]}"
done

# save new index
printf "%d" "$next" > "$state_file"
