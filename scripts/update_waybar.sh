# This script will change your waybar colors using pywal colors
# Usage ./update_waybar.sh (don't forget to `sudo chmod +x ./update_waybar.sh`)

# Path to the Pywal colors
PYWAL_COLORS="$HOME/.cache/wal/colors.json"

# Path to the custom Waybar colors
WAYBAR_COLORS="$HOME/.config/waybar/colors-waybar.css"

# Default colors (will be used if Pywal colors are not generated/available)
DEFAULT_WAYBAR_BACKGROUND="rgba(0, 0, 0, 0.7)"
DEFAULT_MODULE_BACKGROUND="rgba(36, 36, 36, 0.8)"
DEFAULT_TEXT_COLOR_LIGHT="rgb(255, 255, 255)"
DEFAULT_TEXT_COLOR_DARK="rgb(46, 46, 46)"

# Function to extract a value from JSON
get_json_value() {
    echo "$1" | grep -oP '"'"$2"'": *"\K[^"]*'
}

# Function to convert hex to rgba format and add transparency
hex_to_rgba() {
    hex=$1
    alpha=$2

    r=$(echo $hex | cut -c2-3)
    g=$(echo $hex | cut -c4-5)
    b=$(echo $hex | cut -c6-7)

    r=$((16#${r}))
    g=$((16#${g}))
    b=$((16#${b}))

    echo "rgba($r, $g, $b, $alpha)"
}

echo "Looking for pywal colors..."

if [ ! -f "$PYWAL_COLORS" ]; then
    echo "Pywal colors not found, using default colors."
    WAYBAR_BACKGROUND=$DEFAULT_WAYBAR_BACKGROUND
    MODULE_BACKGROUND=$DEFAULT_MODULE_BACKGROUND
    TEXT_COLOR_LIGHT=$DEFAULT_TEXT_COLOR_LIGHT
    TEXT_COLOR_DARK=$DEFAULT_TEXT_COLOR_DARK
else
    echo "Pywal colors found, reading colors."
    WAYBAR_BACKGROUND=$(get_json_value "$(cat $PYWAL_COLORS)" "color1") # color8 or color4 or color6
    echo "Using $WAYBAR_BACKGROUND for waybar background color"
    MODULE_BACKGROUND=$(get_json_value "$(cat $PYWAL_COLORS)" "color1") # color1 or color3
    echo "Using $MODULE_BACKGROUND for module background color"
    TEXT_COLOR_LIGHT=$(get_json_value "$(cat $PYWAL_COLORS)" "color7")
    echo "Using $TEXT_COLOR_LIGHT for light text color"
    TEXT_COLOR_DARK=$(get_json_value "$(cat $PYWAL_COLORS)" "color0")
    echo "Using $TEXT_COLOR_DARK for dark text color"
    

    # Add transparency using hex to rgba converter
    if [[ "$WAYBAR_BACKGROUND" =~ ^#[0-9a-fA-F]{6}$ ]]; then
        WAYBAR_BACKGROUND=$(hex_to_rgba $WAYBAR_BACKGROUND 0.4)
        echo "Waybar background color converted to rgba format and added transparency: $WAYBAR_BACKGROUND"
    fi
fi

# Update custom Waybar color file (~/.config/waybar/colors-waybar.css)
echo "Updating Waybar colors..."
sed -i "s/@define-color waybar-background .*/@define-color waybar-background $WAYBAR_BACKGROUND;/g" "$WAYBAR_COLORS"
sed -i "s/@define-color module-background .*/@define-color module-background $MODULE_BACKGROUND;/g" "$WAYBAR_COLORS"
sed -i "s/@define-color text-color-light .*/@define-color text-color-light $TEXT_COLOR_LIGHT;/g" "$WAYBAR_COLORS"
sed -i "s/@define-color text-color-dark .*/@define-color text-color-dark $TEXT_COLOR_DARK;/g" "$WAYBAR_COLORS"

# Restart Waybar to apply changes
echo "Restarting Waybar..."
pkill -x waybar
nohup waybar &>/dev/null &

echo "Waybar colors updated!"
