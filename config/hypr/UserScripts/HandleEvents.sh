#!/bin/bash
# TODO: adapt https://github.com/to268/DotFiles/blob/main/.config/hypr/handle_events.sh

SCRIPTSDIR="$HOME/.config/hypr/scripts"
monitor_dir="$HOME/.config/hypr/Monitor_Profiles"


### Profiles
MONITOR_TARGET="$HOME/.config/hypr/monitors.conf"
MONITOR_BUILTIN="$HOME/.config/hypr/Monitor_Profiles/builtin.conf"
MONITOR_G34WQI="$HOME/.config/hypr/Monitor_Profiles/xiaomi-g34wqi.conf"

function monitor_builtin_off() {
  cp "${MONITOR_G34WQI}" "${MONITOR_TARGET}"
  hyprctl keyword monitor eDP-1,disable
}

function monitor_builtin_on() {
  cp "${MONITOR_BUILTIN}" "${MONITOR_TARGET}"
  hyprctl reload
}

function lidopen() {
  MONITOR_COUNT=$(hyprctl monitors all -j | jq length)
  if [ "$MONITOR_COUNT" = "1" ]; then
    monitor_builtin_on
  else
    monitor_builtin_off
  fi
}

function lidclose() {
  MONITOR_COUNT=$(hyprctl monitors all -j | jq length)
  if [ "$MONITOR_COUNT" = "1" ]; then
    systemctl suspend
    return
  fi

  monitor_builtin_off
}

function monitor_event() {
  lid_state=$(awk '{print $2}' /proc/acpi/button/lid/LID0/state)

  case $lid_state in
    open) lidopen;;
    closedRB) lidclose;;    
  esac

  ${SCRIPTSDIR}/RefreshNoWaybar.sh &
}

function handle() {
  name=$(echo "$1" | cut -d'>' -f1)
  value=$(echo "$1" | cut -d'>' -f3)

  # echo -e "got event ${name} ${value}"
  # echo -e "raw value: $*"
  # echo -e "raw value \$1: $1"
  # echo -e "--------------------------------------------------------------"

  case $name in
    monitoradded) monitor_event "$value";;
    monitorremoved) monitor_event "$value";;
  esac
}

# Check if the socket file exists before attempting to connect
socket_path="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

if [[ ! -e "$socket_path" ]]; then
    echo "Socket file not found: $socket_path" >&2
    exit 1
fi

# Run socat and process each line
socat -U - "UNIX-CONNECT:${socket_path}" | while read -r line; do
    if [[ -n "$line" ]]; then
        handle "$line"
    fi
done