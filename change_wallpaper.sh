# This script will change your wallpaper and hyprland colors
# Usage ./change_wallpaper.sh /path/to/wallpaper.jpg (don't forget to `sudo chmod +x ./change_wallpaper.sh`)

# Paths
WALLPAPER_PATH="$1";
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf";
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
WAYBAR_COLORS="$HOME/.config/waybar/colors-waybar.css"
HYPRLAND_COLORS="$HOME/.config/hypr/colors-hyprland.conf"
WLOGOUT_COLORS="$HOME/.config/wlogout/colors-wlogout.css"
CAVA_CONF="$HOME/.config/cava/config"
PYWAL_COLORS="$HOME/.cache/wal/colors.json"

# Default colors (will be used if Pywal colors are not generated/available)
# Default colors for kitty
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
# Default colors for waybar
DEFAULT_WAYBAR_BACKGROUND="rgba(0, 0, 0, 0.7)"
DEFAULT_MODULE_BACKGROUND="rgba(36, 36, 36, 0.8)"
DEFAULT_TEXT_COLOR_LIGHT="rgb(255, 255, 255)"
DEFAULT_TEXT_COLOR_DARK="rgb(46, 46, 46)"
# Default colors for hyprland
DEFAULT_BORDER_COLOR="#6062a1"
# Default colors for wlogout
DEFAULT_WLOGOUT_BUTTON_COLOR="#242436"
DEFAULT_WLOGOUT_HOVER_COLOR="#6464c8"
DEFAULT_WLOGOUT_TEXT_COLOR="#7d9bba"
# Default colors for cava
DEFAULT_CAVA_GC1="#94e2d5"
DEFAULT_CAVA_GC2="#89dceb"
DEFAULT_CAVA_GC3="#74c7ec"
DEFAULT_CAVA_GC4="#89b4fa"
DEFAULT_CAVA_GC5="#cba6f7"
DEFAULT_CAVA_GC6="#f5c2e7"
DEFAULT_CAVA_GC7="#eba0ac"
DEFAULT_CAVA_GC8="#f38ba8"

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

# Function for user input
ask_user() {
    local question="$1"
    local varName="$2"
    local input=""
    
    while true; do
        read -p "$question (y/n): " input
        if [[ "$input" == "y" || "$input" == "Y" ]]; then
            eval "$varName=true"
            break
        elif [[ "$input" == "n" || "$input" == "N" ]]; then
            eval "$varName=false"
            break
        else
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
        fi
    done
}

# Wallpaper change
# If no parameter is provided, show an error message and exit
if [ -z "$WALLPAPER_PATH" ]; then
    echo "Error: Please specify a wallpaper path"
    echo "Usage: ./change_wallpaper.sh /path/to/wallpaper"
    exit 1
fi

# If the specified wallpaper file doesn't exist, show an error message and exit
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: The specified file could not be found: $WALLPAPER_PATH"
    exit 1
fi

# Check if the file is a valid image (jpg, png, jpeg, gif, bmp)
if ! [[ "$WALLPAPER_PATH" =~ \.(jpg|jpeg|png)$ ]]; then
    echo "Error: The specified file is not a valid image. Supported formats are: .jpg, .jpeg, .png"
    exit 1
fi

# Update the wallpaper path in the Hyprpaper configuration file
echo "Changing the wallpaper to: $WALLPAPER_PATH"
sed -i "s|^wallpaper = .*|wallpaper = , $WALLPAPER_PATH|" "$HYPRPAPER_CONF"
sed -i "s|^preload = .*|preload = $WALLPAPER_PATH|" "$HYPRPAPER_CONF"

# Reload Hyprpaper
echo "Reloading Hyprpaper..."
pkill hyprpaper
nohup hyprpaper &>/dev/null &

echo "Wallpaper changed!"

# User input for color change and check if Pywal is installed
ask_user "Do you want to change the colors of your components?" CHANGE_COLORS
if [ "$CHANGE_COLORS" == true ]; then
    echo "Checking if Pywal is installed..."

    if ! command -v wal &> /dev/null; then
        read -p "Pywal is not installed. Would you like to install? (y/n): " INSTALL_PYWAL
        if [[ "$INSTALL_PYWAL" == "y" || "$INSTALL_PYWAL" == "Y" ]]; then
            echo "Attempting to install pywal..."
            sudo pacman -Syu python-pywal

            if [ $? -eq 0 ]; then
                echo "Pywal has been installed successfully."
            else
                echo "Failed to install Pywal. Please install it manually."
                exit 1
            fi
        else
            echo "Pywal is required for this process. Exiting."
            exit 1
        fi
    else
        echo "Pywal is already installed."
    fi

    # Generate the color scheme with Pywal
    echo "Generating Pywal color scheme..."
    wal -i "$WALLPAPER_PATH"
    echo "Pywal color scheme generated!"
else
    echo "Exiting."
    exit 0
fi

# Check if the Pywal color file exists (~/.cache/wal/colors.json)
echo "Looking for pywal colors..."
if [ ! -f "$PYWAL_COLORS" ]; then
    echo "Pywal colors not found, using default colors."
    echo "Attempted Path: $PYWAL_COLORS"
    # Default colors for kitty
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
    # Default colors for waybar
    WAYBAR_BACKGROUND=$DEFAULT_WAYBAR_BACKGROUND
    MODULE_BACKGROUND=$DEFAULT_MODULE_BACKGROUND
    TEXT_COLOR_LIGHT=$DEFAULT_TEXT_COLOR_LIGHT
    TEXT_COLOR_DARK=$DEFAULT_TEXT_COLOR_DARK
    # Default colors for hyprland
    BORDER_COLOR=$DEFAULT_BORDER_COLOR
    # Default colors for wlogout
    WLOGOUT_BUTTON_COLOR=$DEFAULT_WLOGOUT_BUTTON_COLOR
    WLOGOUT_HOVER_COLOR=$DEFAULT_WLOGOUT_HOVER_COLOR
    WLOGOUT_TEXT_COLOR=$DEFAULT_WLOGOUT_TEXT_COLOR
    # Default colors for cava
    CAVA_GC1=$DEFAULT_CAVA_GC1
    CAVA_GC2=$DEFAULT_CAVA_GC2
    CAVA_GC3=$DEFAULT_CAVA_GC3
    CAVA_GC4=$DEFAULT_CAVA_GC4
    CAVA_GC5=$DEFAULT_CAVA_GC5
    CAVA_GC6=$DEFAULT_CAVA_GC6
    CAVA_GC7=$DEFAULT_CAVA_GC7
    CAVA_GC8=$DEFAULT_CAVA_GC8
else
    echo "Pywal colors found, reading colors."
    # Color reading for kitty
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
    # Color reading for waybar
    WAYBAR_BACKGROUND=$COLOR1 # color8 or color4 or color6
    MODULE_BACKGROUND=$COLOR1 # or color3
    TEXT_COLOR_LIGHT=$COLOR7
    TEXT_COLOR_DARK=$COLOR0
    # Color reading for hyprland
    BORDER_COLOR=$COLOR7 #or color6
    # Color reading for wlogout
    WLOGOUT_BUTTON_COLOR=$COLOR1
    WLOGOUT_HOVER_COLOR=$COLOR3 # or color4
    WLOGOUT_TEXT_COLOR=$COLOR7
    # Color reading for cava
    CAVA_GC1=$COLOR0
    CAVA_GC2=$COLOR1
    CAVA_GC3=$COLOR2
    CAVA_GC4=$COLOR3
    CAVA_GC5=$COLOR4
    CAVA_GC6=$COLOR5
    CAVA_GC7=$COLOR6
    CAVA_GC8=$COLOR7
fi

# Kitty color change
ask_user "Do you want to change Kitty colors?" CHANGE_KITTY
if [ "$CHANGE_KITTY" == true ]; then
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
else
    echo "Kitty color update skipped."
    echo "No changes have been applied to Kitty colors."
fi

# Waybar color change
ask_user "Do you want to change Waybar colors?" CHANGE_WAYBAR
if [ "$CHANGE_WAYBAR" == true ]; then
    echo "Using $WAYBAR_BACKGROUND for waybar background color"
    echo "Using $MODULE_BACKGROUND for module background color"
    echo "Using $TEXT_COLOR_LIGHT for light text color"
    echo "Using $TEXT_COLOR_DARK for dark text color"

    # Add transparency using hex to rgba converter
    if [[ "$WAYBAR_BACKGROUND" =~ ^#[0-9a-fA-F]{6}$ ]]; then
        WAYBAR_BACKGROUND=$(hex_to_rgba $WAYBAR_BACKGROUND 0.4)
        echo "Waybar background color converted to rgba format and added transparency: $WAYBAR_BACKGROUND"
    fi

    # Update Waybar colors (~/.config/waybar/colors-waybar.css)
    echo "Updating Waybar colors..."
    if [ ! -f "$WAYBAR_COLORS" ]; then
        echo "Waybar color file not found."
        echo "Attempted Path: $WAYBAR_COLORS"
    else
        sed -i "s/@define-color waybar-background .*/@define-color waybar-background $WAYBAR_BACKGROUND;/g" "$WAYBAR_COLORS"
        sed -i "s/@define-color module-background .*/@define-color module-background $MODULE_BACKGROUND;/g" "$WAYBAR_COLORS"
        sed -i "s/@define-color text-color-light .*/@define-color text-color-light $TEXT_COLOR_LIGHT;/g" "$WAYBAR_COLORS"
        sed -i "s/@define-color text-color-dark .*/@define-color text-color-dark $TEXT_COLOR_DARK;/g" "$WAYBAR_COLORS"
    fi

    # Restart Waybar to apply changes
    echo "Restarting Waybar..."
    pkill -x waybar
    nohup waybar &>/dev/null &
    echo "Waybar colors updated!"
else
    echo "Waybar color update skipped."
    echo "No changes have been applied to Waybar colors."
fi

# Hyprland color change
ask_user "Do you want to change Hyprland colors?" CHANGE_HYPRLAND
if [ "$CHANGE_HYPRLAND" == true ]; then
    echo "Using $BORDER_COLOR for hyprland border color"
    BORDER_COLOR="${BORDER_COLOR/#\#/}"

    # Update Hyprland colors (~/.config/hypr/colors-hyprland.conf)
    echo "Updating Hyprland colors..."
    if [ ! -f "$HYPRLAND_COLORS" ]; then
        echo "Hyprland color file not found."
        echo "Attempted Path: $HYPRLAND_COLORS"
    else
        sed -i "s|\$border_color = rgb([a-fA-F0-9]\{6\})|\$border_color = rgb($BORDER_COLOR)|" "$HYPRLAND_COLORS"
    fi

    # Reload Hyprland
    hyprctl reload &>/dev/null
    echo "Hyprland border colors updated!"
else
    echo "Hyprland color update skipped."
    echo "No changes have been applied to Hyprland colors."
fi

# Wlogout color change
ask_user "Do you want to change Wlogout colors?" CHANGE_WLOGOUT
if [ "$CHANGE_WLOGOUT" == true ]; then
    echo "Using $WLOGOUT_BUTTON_COLOR for wlogout button color"
    echo "Using $WLOGOUT_HOVER_COLOR for wlogout button color on hover"
    echo "Using $WLOGOUT_TEXT_COLOR for wlogout text color"

    # Update Wlogout colors (~/.config/wlogout/colors-wlogout.css)
    echo "Updating Wlogout colors..."
    if [ ! -f "$WLOGOUT_COLORS" ]; then
        echo "Wlogout color file not found."
        echo "Attempted Path: $WLOGOUT_COLORS"
    else
        sed -i "s/@define-color button-color .*/@define-color button-color $WLOGOUT_BUTTON_COLOR;/g" "$WLOGOUT_COLORS"
        sed -i "s/@define-color hover-color .*/@define-color hover-color $WLOGOUT_HOVER_COLOR;/g" "$WLOGOUT_COLORS"
        sed -i "s/@define-color text-color .*/@define-color text-color $WLOGOUT_TEXT_COLOR;/g" "$WLOGOUT_COLORS"
    fi
    echo "Wlogout colors updated!"
else
    echo "Wlogout color update skipped."
    echo "No changes have been applied to Wlogout colors."
fi

# Cava color change
ask_user "Do you want to change Cava colors?" CHANGE_CAVA
if [ "$CHANGE_CAVA" == true ]; then
    # Write the colors to the cava conf file
    echo "Updating Cava colors..."
    sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$CAVA_GC1'/" "$CAVA_CONF"
    sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$CAVA_GC2'/" "$CAVA_CONF"
    sed -i "s/^gradient_color_3 = .*/gradient_color_3 = '$CAVA_GC3'/" "$CAVA_CONF"
    sed -i "s/^gradient_color_4 = .*/gradient_color_4 = '$CAVA_GC4'/" "$CAVA_CONF"
    sed -i "s/^gradient_color_5 = .*/gradient_color_5 = '$CAVA_GC5'/" "$CAVA_CONF"
    sed -i "s/^gradient_color_6 = .*/gradient_color_6 = '$CAVA_GC6'/" "$CAVA_CONF"
    sed -i "s/^gradient_color_7 = .*/gradient_color_7 = '$CAVA_GC7'/" "$CAVA_CONF"
    sed -i "s/^gradient_color_8 = .*/gradient_color_8 = '$CAVA_GC8'/" "$CAVA_CONF"

    # Restart Cava to apply changes
    echo "Restarting Cava..."
    pkill -USR1 cava
    echo "Cava colors updated!"
else
    echo "Cava color update skipped."
    echo "No changes have been applied to Cava colors."
fi

echo "Completed! Exiting."