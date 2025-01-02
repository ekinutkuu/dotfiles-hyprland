# This script will change your hyprland border color using pywal colors
# Usage ./update_hyprborder.sh (don't forget to `sudo chmod +x ./update_hyprborder.sh`)

PYWAL_COLORS="$HOME/.cache/wal/colors.json"

HYPRLAND_COLORS="$HOME/.config/hypr/colors-hyprland.conf"

DEFAULT_BORDER_COLOR="rgba(6062a1ee)"

get_json_value() {
    echo "$1" | grep -oP '"'"$2"'": *"\K[^"]*'
}

echo "Looking for pywal colors..."

if [ ! -f "$PYWAL_COLORS" ]; then
    echo "Pywal colors not found, using default colors."
    BORDER_COLOR=$DEFAULT_BORDER_COLOR
else
    echo "Pywal colors found, reading colors."
    BORDER_COLOR=$(get_json_value "$(cat $PYWAL_COLORS)" "color6") #color6 or color7
    echo "Using $BORDER_COLOR for hyprland border color"
    BORDER_COLOR="${BORDER_COLOR/#\#/}"
fi

# Update Hyprland border colors (~/.config/hypr/colors-hyprland.conf)
echo "Updating Hyprland border colors..."
if [ ! -f "$HYPRLAND_COLORS" ]; then
    echo "Hyprland color file not found."
    echo "Attempted Path: $HYPRLAND_COLORS"
else
    sed -i "s|\$border_color = rgb([a-fA-F0-9]\{6\})|\$border_color = rgb($BORDER_COLOR)|" "$HYPRLAND_COLORS"
fi

# Reload Hyprland
hyprctl reload &>/dev/null
echo "Hyprland border colors updated!"
