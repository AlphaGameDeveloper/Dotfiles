#!/usr/bin/env zsh

BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"

DOTFILES_GIT_REPO="https://github.com/AlphaGameDeveloper/Dotfiles.git"
DOTFILES_DIRECTORY="$HOME/.dotfiles"

if ["$DOTFILES_USE_SSH" -ne ""]; then
    DOTFILES_GIT_REPO="git@github.com:AlphaGameDeveloper/Dotfiles.git"
fi

ask_yes_no() {
    local prompt="$*"
    while true; do
        echo -n "$GREEN [?] $YELLOW $prompt $NORMAL:"
        read response
        case "$response" in
            [Yy]* ) return 0 ;;  # Return 0 for 'y' or 'Y'
            [Nn]* ) return 1 ;;  # Return 1 for 'n' or 'N'
            * ) echo "Please answer y or n." ;;  # Invalid input handling
        esac
    done
}

command_exists() {
    # Check if a command exists, exit if it doesn't
    command -v "$1" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        error "$1 is not installed. Please install it before running this script."
        exit 1
    fi
}
info() {
    echo "$YELLOW [+] $NORMAL $*"
}

error() {
    echo "$RED [!] $NORMAL $*"
}
echo "        _       _           _____   ____ _______ ______ _____ _      ______  _____ ";
echo "       | |     | |         |  __ \ / __ \__   __|  ____|_   _| |    |  ____|/ ____|";
echo "   __ _| |_ __ | |__   __ _| |  | | |  | | | |  | |__    | | | |    | |__  | (___  ";
echo "  / _\` | | '_ \| '_ \ / _\` | |  | | |  | | | |  |  __|   | | | |    |  __|  \___ \ ";
echo " | (_| | | |_) | | | | (_| | |__| | |__| | | |  | |     _| |_| |____| |____ ____) |";
echo "  \__,_|_| .__/|_| |_|\__,_|_____/ \____/  |_|  |_|    |_____|______|______|_____/ ";
echo "         | |                                                                       ";
echo "         |_|                                                                       ";

command_exists git
command_exists curl

echo "$RED +------------------------+$NORMAL"
echo "$RED |         WARNING        |$NORMAL"
echo "$RED +------------------------+$NORMAL"

echo "$RED This script can potentially be destructive."
echo "$RED Please read the script before running it."
echo ""
ask_yes_no "Are you sure that you want to continue?"
if [ $? -ne 0 ]; then
    echo "--> Exiting..."
    exit 1
fi

info "Verifying that Oh my ZSH is installed..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh my ZSH!"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null
else
    info "Oh my ZSH is already installed!"
fi

info "Downloading the dotfiles!"
# make sure that the dotfiles directory does not exist
if [ -d "$HOME/.dotfiles" ]; then
    info "Removing the existing dotfiles directory!"
    ask_yes_no "Do you want to remove the existing dotfiles directory?"
    if [ $? -eq 0 ]; then
        rm -rf "$HOME/.dotfiles"
    else
        echo "--> Exiting..."
        exit 1
    fi
    rm -rf "$HOME/dotfiles" || exit 1
fi

info "Cloning the dotfiles repository!"
git clone "$DOTFILES_GIT_REPO" "$DOTFILES_DIRECTORY" > /dev/null 2> /dev/null || exit 1

info "$GREEN Good news!  Dotfiles have been installed successfully! $NORMAL"
info "$GREEN Do you want to link it to ~/.zshrc? $NORMAL"
ask_yes_no "Do you want to link it to ~/.zshrc?"
if [ $? -eq 0 ]; then
    info "Linking the dotfiles to ~/.zshrc!"
    echo "source $DOTFILES_DIRECTORY/zsh/rc.sh" > "$HOME/.zshrc"
    info "$GREEN Good news!  Dotfiles have been linked to ~/.zshrc successfully! $NORMAL"
fi

info "$GREEN Looks like you're all set!"
info "$GREEN Enjoy your new shell! $NORMAL"
exit 0