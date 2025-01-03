# This script will change your wlogout colors using pywal colors
# Usage ./update_wlogout.sh (don't forget to `sudo chmod +x ./update_wlogout.sh`)

# Path to the Pywal colors
PYWAL_COLORS="$HOME/.cache/wal/colors.json"

# Path to the Wlogout style file
WLOGOUT_COLORS="$HOME/.config/wlogout/colors-wlogout.css"

# Default colors (will be used if Pywal colors are not generated/available)
DEFAULT_BUTTON_COLOR="rgba(17, 17, 27, 0.97)"
DEFAULT_HOVER_COLOR="#6464c8"
DEFAULT_TEXT_COLOR="#7d9bba"

# Function to extract a value from JSON
get_json_value() {
    echo "$1" | grep -oP '"'"$2"'": *"\K[^"]*'
}

echo "Looking for pywal colors..."

if [ ! -f "$PYWAL_COLORS" ]; then
    echo "Pywal colors not found, using default colors."
    BUTTON_COLOR=$DEFAULT_BUTTON_COLOR
    HOVER_COLOR=$DEFAULT_HOVER_COLOR
    TEXT_COLOR=$DEFAULT_TEXT_COLOR
else
    echo "Pywal colors found, reading colors."
    BUTTON_COLOR=$(get_json_value "$(cat $PYWAL_COLORS)" "color1")
    echo "Using $BUTTON_COLOR for wlogout button color"
    HOVER_COLOR=$(get_json_value "$(cat $PYWAL_COLORS)" "color3") # or color3 or color4
    echo "Using $HOVER_COLOR for wlogout button color on hover"
    TEXT_COLOR=$(get_json_value "$(cat $PYWAL_COLORS)" "color7")
    echo "Using $TEXT_COLOR for wlogout text color"
fi

# Update Wlogout colors (~/.config/wlogout/colors-wlogout.css)
echo "Updating Wlogout colors..."
if [ ! -f "$WLOGOUT_COLORS" ]; then
    echo "Wlogout color file not found."
    echo "Attempted Path: $WLOGOUT_COLORS"
else
    sed -i "s/@define-color button-color .*/@define-color button-color $BUTTON_COLOR;/g" "$WLOGOUT_COLORS"
    sed -i "s/@define-color hover-color .*/@define-color hover-color $HOVER_COLOR;/g" "$WLOGOUT_COLORS"
    sed -i "s/@define-color text-color .*/@define-color text-color $TEXT_COLOR;/g" "$WLOGOUT_COLORS"
fi

echo "Wlogout colors updated!"
