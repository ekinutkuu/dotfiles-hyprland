# This script will change your cava colors using pywal colors
# Usage ./update_cava.sh (don't forget to `sudo chmod +x ./update_cava.sh`)

# Path to the Pywal colors
PYWAL_COLORS="$HOME/.cache/wal/colors.json"

# Path to the Cava config file
CAVA_CONFIG_FILE="$HOME/.config/cava/config"

# Default colors (will be used if Pywal colors are not generated/available)
DEFAULT_GC_1="#94e2d5"
DEFAULT_GC_2="#89dceb"
DEFAULT_GC_3="#74c7ec"
DEFAULT_GC_4="#89b4fa"
DEFAULT_GC_5="#cba6f7"
DEFAULT_GC_6="#f5c2e7"
DEFAULT_GC_7="#eba0ac"
DEFAULT_GC_8="#f38ba8"

# Function to extract a value from JSON
get_json_value() {
    echo "$1" | grep -oP '"'"$2"'": *"\K[^"]*'
}

echo "Looking for pywal colors..."

if [ ! -f "$PYWAL_COLORS" ]; then
    echo "Pywal colors not found, using default colors."
    GC_1=$DEFAULT_GC_1
    GC_2=$DEFAULT_GC_2
    GC_3=$DEFAULT_GC_3
    GC_4=$DEFAULT_GC_4
    GC_5=$DEFAULT_GC_5
    GC_6=$DEFAULT_GC_6
    GC_7=$DEFAULT_GC_7
    GC_8=$DEFAULT_GC_8
else
    echo "Pywal colors found, reading colors."
    GC_1=$(get_json_value "$(cat "$PYWAL_COLORS")" "color0")
    GC_2=$(get_json_value "$(cat "$PYWAL_COLORS")" "color1")
    GC_3=$(get_json_value "$(cat "$PYWAL_COLORS")" "color2")
    GC_4=$(get_json_value "$(cat "$PYWAL_COLORS")" "color3")
    GC_5=$(get_json_value "$(cat "$PYWAL_COLORS")" "color4")
    GC_6=$(get_json_value "$(cat "$PYWAL_COLORS")" "color5")
    GC_7=$(get_json_value "$(cat "$PYWAL_COLORS")" "color6")
    GC_8=$(get_json_value "$(cat "$PYWAL_COLORS")" "color7")
fi

# Update Cava colors
echo "Updating Cava colors..."
sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$GC_1'/" "$CAVA_CONFIG_FILE"
sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$GC_2'/" "$CAVA_CONFIG_FILE"
sed -i "s/^gradient_color_3 = .*/gradient_color_3 = '$GC_3'/" "$CAVA_CONFIG_FILE"
sed -i "s/^gradient_color_4 = .*/gradient_color_4 = '$GC_4'/" "$CAVA_CONFIG_FILE"
sed -i "s/^gradient_color_5 = .*/gradient_color_5 = '$GC_5'/" "$CAVA_CONFIG_FILE"
sed -i "s/^gradient_color_6 = .*/gradient_color_6 = '$GC_6'/" "$CAVA_CONFIG_FILE"
sed -i "s/^gradient_color_7 = .*/gradient_color_7 = '$GC_7'/" "$CAVA_CONFIG_FILE"
sed -i "s/^gradient_color_8 = .*/gradient_color_8 = '$GC_8'/" "$CAVA_CONFIG_FILE"

# Restart Cava to apply changes
echo "Restarting Cava..."
pkill -USR1 cava
echo "Cava colors updated!"
