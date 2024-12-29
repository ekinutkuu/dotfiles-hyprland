# This script will change your kitty terminal colors with pywal color scheme
# Usage ./update_kitty.sh (don't forget to `sudo chmod +x ./update_kitty.sh`)

# Path to the Pywal colors
PYWAL_COLORS="$HOME/.cache/wal/colors.json"

# Path to the Kitty configuration file
KITTY_CONF="$HOME/.config/kitty/kitty.conf"

# Default colors (will be used if Pywal colors are not generated/available)
DEFAULT_BACKGROUND="#0A0D1D"
DEFAULT_FOREGROUND="#ced3e3"
DEFAULT_CURSOR="#e6b7b7"
DEFAULT_COLOR0="#0A0D1D"
DEFAULT_COLOR1="#5062A1"
DEFAULT_COLOR2="#4E67B1"
DEFAULT_COLOR3="#5171CE"
DEFAULT_COLOR4="#6C88B6"
DEFAULT_COLOR5="#6290D2"
DEFAULT_COLOR6="#8DA4DB"
DEFAULT_COLOR7="#ced3e3"
DEFAULT_COLOR8="#90939e"
DEFAULT_COLOR9="#5062A1"
DEFAULT_COLOR10="#4E67B1"
DEFAULT_COLOR11="#5171CE"
DEFAULT_COLOR12="#6C88B6"
DEFAULT_COLOR13="#6290D2"
DEFAULT_COLOR14="#8DA4DB"
DEFAULT_COLOR15="#ced3e3"

# Check if pywal is installed
echo "Checking if pywal is installed..."
if ! command -v wal &> /dev/null; then
    echo "Pywal is not installed."

    # Ask if user wants to install pywal
    echo "Would you like to install pywal? (y/n)"
    read -r INSTALL_PYWAL

    if [[ "$INSTALL_PYWAL" == "y" || "$INSTALL_PYWAL" == "Y" ]]; then
        echo "Attempting to install pywal..."
        sudo pacman -Syu python-pywal

        if [ $? -eq 0 ]; then
            echo "Pywal has been installed successfully."
        else
            echo "Failed to install pywal. Please install it manually."
            exit 1
        fi
    else
        echo "Pywal is required for this process. Exiting."
        exit 1
    fi
else
    echo "Pywal is already installed."
fi

get_json_value() {
    echo "$1" | grep -oP '"'"$2"'": *"\K[^"]*'
}

echo "Looking for pywal colors..."
if [ ! -f "$PYWAL_COLORS" ]; then
    echo "Pywal colors not found, using default colors."
    COLOR_BACKGROUND=$DEFAULT_BACKGROUND
    COLOR_FOREGROUND=$DEFAULT_FOREGROUND
    COLOR_CURSOR=$DEFAULT_CURSOR
    COLOR0=$DEFAULT_COLOR0
    COLOR1=$DEFAULT_COLOR1
    COLOR2=$DEFAULT_COLOR2
    COLOR3=$DEFAULT_COLOR3
    COLOR4=$DEFAULT_COLOR4
    COLOR5=$DEFAULT_COLOR5
    COLOR6=$DEFAULT_COLOR6
    COLOR7=$DEFAULT_COLOR7
    COLOR8=$DEFAULT_COLOR8
    COLOR9=$DEFAULT_COLOR9
    COLOR10=$DEFAULT_COLOR10
    COLOR11=$DEFAULT_COLOR11
    COLOR12=$DEFAULT_COLOR12
    COLOR13=$DEFAULT_COLOR13
    COLOR14=$DEFAULT_COLOR14
    COLOR15=$DEFAULT_COLOR15
else
    echo "Pywal colors found, reading colors."
    COLOR_BACKGROUND=$(get_json_value "$(cat $PYWAL_COLORS)" "background")
    COLOR_FOREGROUND=$(get_json_value "$(cat $PYWAL_COLORS)" "foreground")
    COLOR_CURSOR=$(get_json_value "$(cat $PYWAL_COLORS)" "cursor")
    COLOR0=$(get_json_value "$(cat $PYWAL_COLORS)" "color0")
    COLOR1=$(get_json_value "$(cat $PYWAL_COLORS)" "color1")
    COLOR2=$(get_json_value "$(cat $PYWAL_COLORS)" "color2")
    COLOR3=$(get_json_value "$(cat $PYWAL_COLORS)" "color3")
    COLOR4=$(get_json_value "$(cat $PYWAL_COLORS)" "color4")
    COLOR5=$(get_json_value "$(cat $PYWAL_COLORS)" "color5")
    COLOR6=$(get_json_value "$(cat $PYWAL_COLORS)" "color6")
    COLOR7=$(get_json_value "$(cat $PYWAL_COLORS)" "color7")
    COLOR8=$(get_json_value "$(cat $PYWAL_COLORS)" "color8")
    COLOR9=$(get_json_value "$(cat $PYWAL_COLORS)" "color9")
    COLOR10=$(get_json_value "$(cat $PYWAL_COLORS)" "color10")
    COLOR11=$(get_json_value "$(cat $PYWAL_COLORS)" "color11")
    COLOR12=$(get_json_value "$(cat $PYWAL_COLORS)" "color12")
    COLOR13=$(get_json_value "$(cat $PYWAL_COLORS)" "color13")
    COLOR14=$(get_json_value "$(cat $PYWAL_COLORS)" "color14")
    COLOR15=$(get_json_value "$(cat $PYWAL_COLORS)" "color15")
fi

# Write the colors to the kitty.conf file
echo "Updating Kitty colors..."
sed -i "s/^background .*/background $COLOR_BACKGROUND/" "$KITTY_CONF"
sed -i "s/^foreground .*/foreground $COLOR_FOREGROUND/" "$KITTY_CONF"
sed -i "s/^cursor .*/cursor $COLOR_CURSOR/" "$KITTY_CONF"
sed -i "s/^color0 .*/color0 $COLOR0/" "$KITTY_CONF"
sed -i "s/^color1 .*/color1 $COLOR1/" "$KITTY_CONF"
sed -i "s/^color2 .*/color2 $COLOR2/" "$KITTY_CONF"
sed -i "s/^color3 .*/color3 $COLOR3/" "$KITTY_CONF"
sed -i "s/^color4 .*/color4 $COLOR4/" "$KITTY_CONF"
sed -i "s/^color5 .*/color5 $COLOR5/" "$KITTY_CONF"
sed -i "s/^color6 .*/color6 $COLOR6/" "$KITTY_CONF"
sed -i "s/^color7 .*/color7 $COLOR7/" "$KITTY_CONF"
sed -i "s/^color8 .*/color8 $COLOR8/" "$KITTY_CONF"
sed -i "s/^color9 .*/color9 $COLOR9/" "$KITTY_CONF"
sed -i "s/^color10 .*/color10 $COLOR10/" "$KITTY_CONF"
sed -i "s/^color11 .*/color11 $COLOR11/" "$KITTY_CONF"
sed -i "s/^color12 .*/color12 $COLOR12/" "$KITTY_CONF"
sed -i "s/^color13 .*/color13 $COLOR13/" "$KITTY_CONF"
sed -i "s/^color14 .*/color14 $COLOR14/" "$KITTY_CONF"
sed -i "s/^color15 .*/color15 $COLOR15/" "$KITTY_CONF"

# Restart Kitty
echo "Restarting Kitty terminal..."
pkill -USR1 kitty

echo "Kitty colors updated!"
