#	MIT License

#	Copyright (c) 2024 Damien Boisvert

#	Permission is hereby granted, free of charge, to any person obtaining a copy
#	of this software and associated documentation files (the "Software"), to deal
#	in the Software without restriction, including without limitation the rights
#	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the Software is
#	furnished to do so, subject to the following conditions:

#	The above copyright notice and this permission notice shall be included in all
#	copies or substantial portions of the Software.

#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#	SOFTWARE.


function load_file {
	source $SCRIPT_DIR/$1
}

if test -n "$BASH" ; then script=$BASH_SOURCE
elif test -n "$TMOUT"; then script=${.sh.file}
elif test -n "$ZSH_NAME" ; then script=${(%):-%x}
elif test ${0##*/} = dash; then x=$(lsof -p $$ -Fn0 | tail -1); script=${x#n}
else script=$0
fi


SCRIPT_DIR=$(dirname $script)

load_file exports.sh
load_file alias.sh
load_file warp.zsh
load_file copilot.zsh
load_file git/alias.sh
load_file git/config.sh
load_file git/identity.sh

if [ "$(uname)" = "Linux" ]; then
	echo "d: loading caffeinate"
	# Caffeinate for Linux
	caffeinate() {
	  local duration=""
	  local seconds=""
	  local verbose=true
	  local display=false
	  local inhibit_cmd=""
	  local session_type="${XDG_SESSION_TYPE:-unknown}"
	  local systemd_inhibit=""
	  local x11_prevent_sleep=""
	  local wayland_note=""
	
	  while [[ $# -gt 0 ]]; do
	    case $1 in
	      -t|--time)
	        seconds="$2"
	        duration="for $2 seconds"
	        shift 2
	        ;;
	      -d|--display)
	        display=true
	        shift
	        ;;
	      -q|--quiet)
	        verbose=false
	        shift
	        ;;
	      -h|--help)
	        echo "Usage: caffeinate [-t seconds] [-d] [-q]"
	        echo "  -t, --time <seconds>   Set a timeout"
	        echo "  -d, --display          Prevent display sleep (if possible)"
	        echo "  -q, --quiet            Disable verbose output"
	        return 0
	        ;;
	      *)
	        echo "Unknown option: $1"
	        return 1
	        ;;
	    esac
	  done
	
	  $verbose && echo "[☕] Starting Linux 'caffeinate' $duration..."
	
	  if command -v systemd-inhibit >/dev/null; then
	    systemd_inhibit="systemd-inhibit --why='Caffeinate Function' --mode=block sleep"
	  else
	    $verbose && echo "[!] systemd-inhibit not found; sleep may not be blocked at system level."
	  fi
	
	  if $display; then
	    if [[ "$session_type" == "x11" && -n "$DISPLAY" && -n "$XAUTHORITY" ]]; then
	      x11_prevent_sleep="xset s off -dpms"
	      $verbose && echo "[✔] Disabling X11 screen saver and DPMS (sleep)."
	    elif [[ "$session_type" == "wayland" ]]; then
	      wayland_note="[!] Wayland session detected — display sleep may not be blockable from CLI."
	      $verbose && echo "$wayland_note"
	    else
	      $verbose && echo "[!] Unknown session type: $session_type"
	    fi
	  fi
	
	  # Execute sleep prevention
	  eval "$x11_prevent_sleep"
	
	  if [[ -n "$seconds" ]]; then
	    if [[ -n "$systemd_inhibit" ]]; then
	      eval "$systemd_inhibit sleep $seconds"
	    else
	      sleep "$seconds"
	    fi
	  else
	    if [[ -n "$systemd_inhibit" ]]; then
	      eval "$systemd_inhibit bash -c 'echo Press Ctrl+C to exit; while :; do sleep 1; done'"
	    else
	      echo "Press Ctrl+C to exit"
	      while :; do sleep 1; done
	    fi
	  fi
	
	  if $display && [[ "$session_type" == "x11" ]]; then
	    $verbose && echo "[✔] Restoring X11 screen saver/DPMS settings..."
	    xset s on +dpms
	  fi
	
	  $verbose && echo "[☕] Caffeinate complete."
	}
fi

# -- go back to where you came from! --
cd $PRE_PWD
