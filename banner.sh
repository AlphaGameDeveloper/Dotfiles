#!/bin/bash

# Colors
PAW_COLOR="\e[38;5;135m"
TEXT_COLOR="\e[38;5;81m"
TITLE_COLOR="\e[38;5;219m"
RESET="\e[0m"

# Placeholder values
OS=""
HOST=""
IP=""
PYTHON=""
JAVA=""
WIFI=""
HAS_INTERNET_ACCESS=""

draw_banner() {
  clear
  echo -en "${PAW_COLOR}"
  
  # Read banner from file
  local line_num=0
  banner_lines=0  # Initialize outside the if block so it's available globally
  
  if [[ -f "/opt/banner-art.txt" ]]; then
    # Save original cursor position
    echo -en "\033[s"
    
    # Count lines in the file first
    local total_lines=$(wc -l < "/opt/banner-art.txt")
    
    # Read the file line by line
    while IFS= read -r line; do
      # Add vertical line divider to all lines except the last one
      if [[ $line_num -lt $(( total_lines - 1 )) ]]; then
        case $line_num in
          0) echo "$line│" ;;
          1) echo "$line│   ${TITLE_COLOR}Damien's Den${PAW_COLOR}" ;;
          2) echo "$line│   ${TEXT_COLOR}OS:       $OS${PAW_COLOR}" ;;
          3) echo "$line│   ${TEXT_COLOR}Host:     $HOST${PAW_COLOR}" ;;
          4) echo "$line│   ${TEXT_COLOR}IP:       $IP${PAW_COLOR}" ;;
          5) echo "$line│   ${TEXT_COLOR}Python:   $PYTHON${PAW_COLOR}" ;;
          6) echo "$line│   ${TEXT_COLOR}Java:     $JAVA${PAW_COLOR}" ;;
          7) echo "$line│   ${TEXT_COLOR}Wi-Fi:    $WIFI${PAW_COLOR}" ;;
          8) echo "$line│   ${TEXT_COLOR}Internet Access: $HAS_INTERNET_ACCESS${PAW_COLOR}" ;;
          9) echo "$line│   ${TEXT_COLOR}Cloudflare WARP: $IS_CLOUDFLARE_WARP_ON${PAW_COLOR}" ;;
          10) echo "$line│" ;;
          11) echo "$line│" ;;
          12) echo "$line│" ;;
          *) echo "$line│" ;;
        esac
      else
        # Last line without divider
        echo "$line"
      fi
      ((line_num++))
    done < "/opt/banner-art.txt"
    
    # Use the actual number of lines we printed
    banner_lines=$line_num
  else
    echo -en "\033[s"  # Save cursor position
    echo "Banner art file not found: /opt/banner-art.txt"
    banner_lines=1  # Just the error message
  fi
}

# Draw initial banner (placeholders)
echo -en "\033[s"  # Save cursor position before first draw
draw_banner
BANNER_LINES=$banner_lines  # Save to global variable

# Async update
(
  #OS=$(uname -smo)
  OS=$(lsb_release -sd 2>/dev/null)
  HOST=$(hostname)
  IP=$(hostname -I | awk '{print $1}')
  PYTHON=$(python3 --version | cut -d' ' -f2)
  JAVA=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  WIFI=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d':' -f2)
  WIFI=${WIFI:-N/A}
  IS_CLOUDFLARE_WARP_ON=$(warp-cli status | grep -q 'Connected' && echo 'WARP Connected' || echo 'Not Connected')
  if ping -c 1 -W 0.5 8.8.8.8 &>/dev/null; then
    HAS_INTERNET_ACCESS="YES"
  else
    HAS_INTERNET_ACCESS="NO"
  fi
  # # Instead of using line count, restore cursor to original position
  # echo -en "\033[u"  # Restore cursor position
  
  # # Clear from cursor to end of screen
  # echo -en "\033[J"  

  # Redraw banner with real info
  draw_banner
  (( ${+functions[p10k]} )) && p10k reload
  
) & disown
