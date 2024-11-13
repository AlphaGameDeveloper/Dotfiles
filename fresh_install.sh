#!/usr/bin/env zsh

ask_yes_no() {
    local prompt="$*"
    while true; do
        echo -n "$prompt (y/n): "
        read response
        case "$response" in
            [Yy]* ) return 0 ;;  # Return 0 for 'y' or 'Y'
            [Nn]* ) return 1 ;;  # Return 1 for 'n' or 'N'
            * ) echo "Please answer y or n." ;;  # Invalid input handling
        esac
    done
}

echo "        _       _           _____   ____ _______ ______ _____ _      ______  _____ ";
echo "       | |     | |         |  __ \ / __ \__   __|  ____|_   _| |    |  ____|/ ____|";
echo "   __ _| |_ __ | |__   __ _| |  | | |  | | | |  | |__    | | | |    | |__  | (___  ";
echo "  / _\` | | '_ \| '_ \ / _\` | |  | | |  | | | |  |  __|   | | | |    |  __|  \___ \ ";
echo " | (_| | | |_) | | | | (_| | |__| | |__| | | |  | |     _| |_| |____| |____ ____) |";
echo "  \__,_|_| .__/|_| |_|\__,_|_____/ \____/  |_|  |_|    |_____|______|______|_____/ ";
echo "         | |                                                                       ";
echo "         |_|                                                                       ";
