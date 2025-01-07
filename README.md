# Dotfiles

**Dotfiles** is a collection of configuration files aimed at setting up a personalized and efficient Linux environment. This repository includes configurations for various tools and applications, enhancing productivity and aesthetics.

## Depenencies
- hyprpaper (for wallpaper)
- waybar (for top bar)
- wofi (for launcher)
- wlogout (for logout menu)
- cava (for audio visualizer tool)
- grim (for screenshot tool)
- brightnessctl (to adjust the brightness)
- wpctl (to adjust the volume)
- "otf-font-awesome" and "ttf-jetbrains-mono-nerd" is required to be installed for waybar icons

## Installation

### Auto Installation

> [!Warning]
> The installation script includes a function that backs up your existing dotfiles. However, in the unlikely event that something goes wrong with the
> backup process, your current files might not be safely backed up. To avoid potential data loss, it is highly recommended to manually back up your
> dotfiles before running the installation script.

    cd ~/Downloads
    git clone https://github.com/ekinutkuu/dotfiles-hyprland
    cd dotfiles-hyprland/
    sudo chmod +x ./install.sh
    ./install.sh

### Manuel Installation

> [!IMPORTANT]
> Don't forget to install dependencies!

**1. Clone The Repository:**

    cd ~/Downloads
    git clone https://github.com/ekinutkuu/dotfiles-hyprland
    cd dotfiles-hyprland/

**2. Backup Existing Dotfiles:**

    mkdir -p ~/.config/.backup
    cp -r ~/.config/* ~/.config/.backup/

**3. Copy New Dotfiles:**

    cp -r cava/ ~/.config/
    cp -r hypr/ ~/.config/
    cp -r kitty/ ~/.config/
    cp -r neofetch/ ~/.config/
    cp -r waybar/ ~/.config/
    cp -r wlogout/ ~/.config/
    cp -r wofi/ ~/.config/

## Wallpaper and Theme Change Script

> [!Caution]
> Your old colors will not be backed up. Please back up your config directory if you do not want to lose your current color settings.

**Usage:**

    sudo chmod +x change_wallpaper.sh
    ./change_wallpaper.sh /path/of/your/wallpaper

When you run this script, it will change your wallpaper to the one specified in the command. Then, you'll be asked if you'd like to update the colors of various components such as **Kitty**, **Waybar**, **Hyprland** and many more... The colors of the these components will change according to the color scheme of your selected wallpaper.

## Keybindings

| Keys                                                                                                                 | Action                                                           |
| :------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------- |
| <kbd>super</kbd> + <kbd>t</kbd>                                                                                      | Open a terminal                                                  |
| <kbd>super</kbd> + <kbd>q</kbd>                                                                                      | Close active window                                              |
| <kbd>alt</kbd> + <kbd>space</kbd>                                                                                    | Open apps menu                                                   |
| <kbd>super</kbd> + <kbd>e</kbd>                                                                                      | Open file manager                                                |
| <kbd>super</kbd> + <kbd>t</kbd>                                                                                      | Open firefox                                                     |
| <kbd>prtsc</kbd>                                                                                                     | Take screenshot                                                  |
| <kbd>super</kbd> + <kbd>arrow keys</kbd>                                                                             | Change focus between windows in the specified direction          |
| <kbd>super</kbd> + <kbd>shift</kbd> + <kbd>arrow keys</kbd>                                                          | Move active window to a different position                       |
| <kbd>super</kbd> + <kbd>ctrl</kbd> + <kbd>arrow keys</kbd>                                                           | Resize active window                                             |
| <kbd>super</kbd> + <kbd>v</kbd>                                                                                      | Toggle floating mode                                             |
| <kbd>super</kbd> + <kbd>1</kbd> or <kbd>2</kbd> or <kbd>3</kbd> ...                                                  | Switch directly to specific workspace                            |
| <kbd>super</kbd> + <kbd>alt</kbd> + <kbd>left and right arrow keys</kbd>                                             | Move between workspaces one by one                               |
| <kbd>super</kbd> + <kbd>alt</kbd> + <kbd>1</kbd> or <kbd>2</kbd> or <kbd>3</kbd> ...                                 | Move active window to a workspace                                |
| <kbd>super</kbd> + <kbd>shift</kbd> + <kbd>l</kbd>                                                                   | Open a session menu (shut down, reboot, logout...)               |

## I USE ARCH (BTW)

![1](.screenshots/0.png)
![2](.screenshots/1.png)
![3](.screenshots/2.png)
![4](.screenshots/3.png)
![5](.screenshots/4.png)
![6](.screenshots/5.png)
![7](.screenshots/6.png)

## Another Waybar
![8](.screenshots/7.png)
![9](.screenshots/8.png)
