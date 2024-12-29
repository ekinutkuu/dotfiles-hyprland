# This script will change your hyprland wallpaper via hyprpaper
# Usage ./update_wallpaper.sh /path/to/wallpaper.jpg (don't forget to `sudo chmod +x ./update_wallpaper.sh`)

# Function to check if pywal is installed
check_pywal() {
    if ! command -v wal &> /dev/null; then
        echo "Pywal is not installed."
        return 1
    else
        echo "Pywal is already installed."
        return 0
    fi
}

# Function to install pywal
install_pywal() {
    echo "Attempting to install pywal..."
    sudo pacman -Syu python-pywal

    if [ $? -eq 0 ]; then
        echo "Pywal has been installed successfully."
        return 0
    else
        echo "Failed to install pywal. Please install it manually."
        return 1
    fi
}

# Script starts here
WALLPAPER_PATH="$1";
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf";

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

# Ask user if they want to use Pywal for color scheme generation
echo "Do you want to use Pywal for generating a color scheme? (y/n)"
read -r USE_PYWAL

if [[ "$USE_PYWAL" == "y" || "$USE_PYWAL" == "Y" ]]; then
    echo "Checking if pywal is installed..."
    check_pywal
    if [ $? -eq 1 ]; then
        echo "Would you like to install pywal? (y/n)"
        read -r INSTALL_PYWAL

        if [[ "$INSTALL_PYWAL" == "y" || "$INSTALL_PYWAL" == "Y" ]]; then
            install_pywal
            if [ $? -eq 1 ]; then
                echo "Exiting due to installation failure."
                exit 1
            fi
        else
            echo "Pywal is required for this process. Exiting."
            exit 1
        fi
    fi

    # Extract the color scheme with Pywal
    echo "Extracting Pywal color scheme..."
    wal -i "$WALLPAPER_PATH"
    echo "Pywal color scheme applied!"
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
