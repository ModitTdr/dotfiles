#!/bin/bash
#
# Wallpaper Manager for Sway
# Supports auto and interactive modes with safe environment checks.
#

WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
DEFAULT_WALLPAPER="$HOME/Pictures/Wallpapers/Anime-Purple-eyes.png"
SELECTED_FILE="$HOME/.wallpaper_selected"
LOG_FILE="$HOME/.wallpaper_log"

# -------------------------------------------------------------
# Helper: write messages to both stdout and log
# -------------------------------------------------------------
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# -------------------------------------------------------------
# Check for a running wayland session
# -------------------------------------------------------------
if [ -z "$WAYLAND_DISPLAY" ]; then
    log "❌ No Wayland session detected (WAYLAND_DISPLAY is empty). Cannot set wallpaper."
    exit 1
fi

# -------------------------------------------------------------
# Function: set wallpaper
# -------------------------------------------------------------
set_wallpaper() {
    local img="$1"

    if [ ! -f "$img" ]; then
        log "⚠️  Wallpaper not found: $img"
        exit 1
    fi

    log "🖼️  Setting wallpaper: $img"
    pkill swaybg 2>/dev/null

    # Run swaybg in background
    swaybg -i "$img" -m fill &
    local SWAYBG_PID=$!

    # Wait a bit and verify
    sleep 0.3
    if ps -p $SWAYBG_PID > /dev/null; then
        log "✅ Wallpaper applied successfully."
    else
        log "❌ Failed to start swaybg."
        exit 1
    fi
}

# -------------------------------------------------------------
# Mode: AUTO (used at startup)
# -------------------------------------------------------------
if [ "$1" = "auto" ]; then
    if [ -f "$SELECTED_FILE" ]; then
        SELECTED=$(cat "$SELECTED_FILE")
        log "Auto mode: using saved wallpaper -> $SELECTED"
    else
        log "Auto mode: no saved wallpaper found, using default."
        SELECTED="$DEFAULT_WALLPAPER"
    fi

    set_wallpaper "$SELECTED"
    exit 0
fi

# -------------------------------------------------------------
# Mode: INTERACTIVE (manual selection via rofi)
# -------------------------------------------------------------
if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ]; then
    log "❌ No graphical display found. Rofi cannot run."
    exit 1
fi

if [ ! -d "$WALLPAPER_DIR" ]; then
    log "❌ Directory does not exist: $WALLPAPER_DIR"
    exit 1
fi

WALLPAPER_LIST=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | sort)

SELECTED=$(echo "$WALLPAPER_LIST" | rofi -dmenu -i -p "Select wallpaper:")

# Exit cleanly if user cancels
if [ -z "$SELECTED" ]; then
    log "Cancelled by user."
    exit 0
fi

echo "$SELECTED" > "$SELECTED_FILE"
log "User selected: $SELECTED"

set_wallpaper "$SELECTED"
