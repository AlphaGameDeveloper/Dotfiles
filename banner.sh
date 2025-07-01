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
    
    # First pass: find the maximum line length
    local max_length=0
    while IFS= read -r line; do
      local line_length=${#line}
      if (( line_length > max_length )); then
        max_length=$line_length
      fi
    done < "/opt/banner-art.txt"
    
    # Read the file line by line
    while IFS= read -r line; do
      # Pad the line with spaces to match max_length
      local padded_line="$line"
      local padding=$((max_length - ${#line}))
      if (( padding > 0 )); then
        padded_line="${padded_line}$(printf '%*s' $padding '')"
      fi
      
      # Add vertical line divider to all lines except the last one
      if [[ $line_num -lt $(( total_lines - 1 )) ]]; then
        case $line_num in
          0)  echo "$padded_line│" ;;
          1)  echo "$padded_line│   ${TITLE_COLOR}Damien's Den${PAW_COLOR}" ;;
          2)  echo "$padded_line│   ${TEXT_COLOR}OS:       $OS${PAW_COLOR}" ;;
          3)  echo "$padded_line│   ${TEXT_COLOR}Host:     $HOST${PAW_COLOR}" ;;
          4)  echo "$padded_line│   ${TEXT_COLOR}IP:       $IP${PAW_COLOR}" ;;
          5)  echo "$padded_line│   ${TEXT_COLOR}Python:   $PYTHON${PAW_COLOR}" ;;
          6)  echo "$padded_line│   ${TEXT_COLOR}Java:     $JAVA${PAW_COLOR}" ;;
          7)  echo "$padded_line│   ${TEXT_COLOR}Wi-Fi:    $WIFI${PAW_COLOR}" ;;
          8)  echo "$padded_line│   ${TEXT_COLOR}Internet Access: $HAS_INTERNET_ACCESS${PAW_COLOR}" ;;
          9)  echo "$padded_line│   ${TEXT_COLOR}Cloudflare WARP: $IS_CLOUDFLARE_WARP_ON${PAW_COLOR}" ;;
          10) echo "$padded_line│" ;;
          11) echo "$padded_line│" ;;
          12) echo "$padded_line│" ;;
          *)  echo "$padded_line│" ;;
        esac
      else
        echo -e "\e[4m$padded_line\e[0m${PAW_COLOR}│"
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

function redraw_prompt_with_newline() {
  print -n '\n'      # Print a newline
  zle reset-prompt   # Redraw the prompt
}

# Async update
(
  # Detect OS type
  OS_TYPE=$(uname -s)
  
  # Set OS info based on platform
  if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS specific commands
    OS=$(sw_vers -productName)" "$(sw_vers -productVersion)
    HOST=$(hostname -s)
    IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | grep -v 127 | awk '{print $2}' | head -n 1)
    PYTHON=$(python3 --version 2>/dev/null | cut -d' ' -f2)
    JAVA=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    WIFI=$(wdutil info | grep -A 1 "SSID" | tail -n 1 | awk -F': ' '{print $2}' | tr -d '"')
    WIFI=${WIFI:-"[REDACTED]"}
    IS_CLOUDFLARE_WARP_ON=$(pgrep "cloudflared" >/dev/null && echo 'WARP Connected' || echo 'Not Connected')
  else
    # Linux specific commands
    OS=$(lsb_release -sd 2>/dev/null)
    HOST=$(hostname)
    IP=$(hostname -I | awk '{print $1}')
    PYTHON=$(python3 --version | cut -d' ' -f2)
    JAVA=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    WIFI=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d':' -f2)
    WIFI=${WIFI:-N/A}
    IS_CLOUDFLARE_WARP_ON=$(warp-cli status | grep -q 'Connected' && echo 'WARP Connected' || echo 'Not Connected')
  fi
  
  # Internet check works the same on both platforms
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
  # (( ${+functions[p10k]} )) && p10k reload
  print -n $'\n'
  echo -en "\n"
  # Alternative approach if print doesn't work:
  # echo -en "\n"
  
) & disown
