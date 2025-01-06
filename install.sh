# This script will install dotfiles
# Usage: `sudo chmod +x install.sh && ./install.sh`

# Check if the system is arch or arch based
check_pacman() {
    if ! command -v pacman &>/dev/null; then
        printf "\e[31mPacman not found, it seems that the system is not Arch Linux or Arch based distros. Aborting...\e[0m\n"
        exit 1
    fi
}

# Check if the script is being run as root
check_root() {
    if [[ $(whoami) == "root" ]]; then
        echo -e "\e[31mThis script is NOT to be executed with sudo or as root. Aborting...\e[0m"
        exit 1
    fi
}

# Install yay
install_yay() {
    echo "Installing yay from AUR"
    #local initial_dir="$(pwd)"
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yaybuild
    cd /tmp/yaybuild
    makepkg -si --noconfirm
    cd ~
    #cd $initial_dir 
    rm -rf /tmp/yaybuild
    echo "Yay installed successfully!"
}

# Check if yay is installed
check_yay() {
    if ! command -v yay &>/dev/null; then
        echo -e "\e[33mYay not found. Yay is required for the installation of some dependencies\e[0m"
        get_user_confirmation "Do you want to install yay?" "install_yay"
        if $install_yay; then
            echo "Installing yay..."
            install_yay
        else
            echo "Yay installation skipped. Yay dependencies will not be installed, this may cause some dotfiles to not work properly."
            skip_yay_deps=true
        fi
    fi
}

# Get permission from the user
get_user_confirmation() {
    local question="$1"
    local varName="$2"
    local input=""

    while true; do
        read -p "$question (y/n): " input
        if [[ "$input" =~ ^[Yy]$ ]]; then
            eval "$varName=true"
            break
        elif [[ "$input" =~ ^[Nn]$ ]]; then
            eval "$varName=false"
            break
        else
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
        fi
    done
}

# Install dependencies
install_dependencies() {
    local deps_file="dependencies.txt"
    if [[ -f "$deps_file" ]]; then
        echo "Installing dependencies..."
        while IFS= read -r line; do
            if [[ "$line" == yay:* && "$skip_yay_deps" == true ]]; then
                package="${line#yay:}"
                echo "Skipping '$package' installation because yay is not installed."
                continue
            fi

            if [[ "$line" == yay:* ]]; then
                package="${line#yay:}"
                echo "Installing $package via yay..."
                yay -S --needed --noconfirm "$package"
            else
                echo "Installing $line via pacman..."
                sudo pacman -S --needed --noconfirm "$line"
            fi
        done < "$deps_file"
    else
        echo "Dependencies file not found ($deps_file)."
        echo "Skipping dependency installation, this may cause some dotfiles to not work properly."
    fi
}

# Update the system
update_system() {
    echo "Updating the system..."
    sudo pacman -Syu --noconfirm || { echo "System update failed."; exit 1; }
}

# Backup old dotfiles
backup_config() {
    local config_dir="/home/$(whoami)/.config"
    local backup_dir="$config_dir/.backup"
    mkdir -p "$backup_dir"
    echo "Backing up $config_dir to $backup_dir"
    rsync -av --progress "$config_dir/" "$backup_dir"
    echo "The backup process is complete. Location of your old config files: $backup_dir"
}

# Get monitor resolution and refresh rate
get_monitor_info() {
    echo "Fetching monitor resolution and refresh rate using hyprctl..."
    monitor_info=$(hyprctl monitors)

    monitor_resolution=$(echo "$monitor_info" | grep -oP '\d{3,4}x\d{3,4}' | head -n 1)  # Get first resolution found
    monitor_refresh_rate=$(echo "$monitor_info" | grep -oP '\d{1,3}\.\d{2}Hz' | head -n 1)  # Get first refresh rate found

    echo -e "\e[32mYour monitor will be set to the following configuration:\e[0m"
    echo -e "\e[34mResolution:\e[0m $monitor_resolution"
    echo -e "\e[34mRefresh Rate:\e[0m $monitor_refresh_rate"
}

# Set custom monitor resolution and refresh rate
set_custom_monitor() {
    read -p "Please enter the resolution (e.g. 1920x1080): " custom_resolution
    read -p "Please enter the refresh rate (e.g. 60): " custom_refresh_rate
    echo "Setting custom monitor resolution: $custom_resolution and refresh rate: $custom_refresh_rate"
    config_file="hypr/hyprland.conf"

    sed -i "s/^monitor=.*/monitor=,$custom_resolution@$custom_refresh_rate,auto,1/" "$config_file"
    echo "Hyprland.conf file updated with custom settings."
}

# Clean directories and copy dotfiles
copy_config_files() {
    local dir="$1"
    local user_config_dir="/home/$(whoami)/.config/$dir"

    if [[ -d "$user_config_dir" ]]; then
        echo "$user_config_dir directory exists, cleaning contents..."
        rm -rf "$user_config_dir/*"
    else
        echo "$user_config_dir directory does not exist, creating..."
        mkdir -p "$user_config_dir"
    fi

    if [[ -d "$dir" ]]; then
        echo "$dir files moving into your config directory..."
        cp -r "$dir/"* "$user_config_dir/"
    fi

    echo "$dir files have been successfully updated."
}

########################
## Script Starts Here ##
########################

check_pacman
check_root
check_yay

# Checking for required directories
required_dotfiles=("cava" "hypr" "kitty" "waybar" "wlogout" "wofi")
current_dotfiles=()
missing_dotfiles=()

for dir in "${required_dotfiles[@]}"; do
    if [[ -d "$dir" ]]; then
        current_dotfiles+=("$dir")
    else
        missing_dotfiles+=("$dir")
    fi
done

if [[ ${#missing_dotfiles[@]} -gt 0 ]]; then
    echo "The following dotfiles are missing and will not be updated:"
    for dotfile in "${missing_dotfiles[@]}"; do
        echo "-$dotfile"
    done
else
    echo "All dotfile directories found."
fi

if [ ${#current_dotfiles[@]} -eq 0 ]; then
    echo "None of the dotfiles were found in the current location. Aborting installation..."
    exit 1
else
    echo "The following dotfiles will be updated:"
    for dotfile in "${current_dotfiles[@]}"; do
        echo "-$dotfile"
    done
fi

# Ask user if they want to update the system
get_user_confirmation "Do you want to update the system?" "update_system"
if $update_system; then
    update_system
else
    echo "System update skipped."
fi

# Ask user if they want to install dependencies
get_user_confirmation "Do you want to install dependencies?" "install_deps"
if $install_deps; then
    install_dependencies
else
    echo "Dependencies installation skipped. Dotfiles may not work properly."
fi

# Ask user if they want to backup their config files
get_user_confirmation "Do you want to backup your config files?" "backup_config"
if $backup_config; then
    backup_config
else
    echo "Backup process skipped."
fi

# Ask user if they want to set a custom monitor configuration
if [[ " ${current_dotfiles[@]} " =~ " hypr " ]]; then
    get_monitor_info
    get_user_confirmation "Do you want to set a custom monitor resolution and refresh rate?" "set_custom_monitor"
    if $set_custom_monitor; then
        set_custom_monitor
    else
        echo "Using default monitor settings."
    fi
else
    echo "Hypr dotfile is not found, skipping monitor configuration..."
fi

# Ask user before proceeding with updating all dotfiles
get_user_confirmation "Do you want to continue updating all dotfiles?" "update_dirs"
if $update_dirs; then
    echo "Updating all dotfiles..."
    for dir in "${current_dotfiles[@]}"; do
        copy_config_files "$dir"
    done
    echo "All dotfiles updated successfully."
else
    echo "Dotfile update skipped."
fi

echo "Installation completed."

# Ask user if they want to restart the computer
get_user_confirmation "Do you want to restart your computer? This may help resolve potential issues." "restart_computer"
if $restart_computer; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Reboot skipped. Please restart later."
fi
