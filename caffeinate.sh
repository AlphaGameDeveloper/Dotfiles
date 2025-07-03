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
