#!/bin/bash

THEME="~/.config/mango/rofi/powermenu.rasi"

# Power options (6 items for 3x2 grid)
options="⏻ Shutdown\n⟳ Reboot\n⏾ Suspend\n⏼ Logout\n🔒 Lock\n✗ Cancel"

# Confirmation function
confirm() {
    echo -e "✓ Yes\n✗ No" | rofi -dmenu -i -p "$1" -theme "$THEME" -mesg "Are you sure?"
}

choice=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme "$THEME")

case "$choice" in
    *Shutdown)
        [[ $(confirm "Shutdown?") == *Yes* ]] && systemctl poweroff
        ;;
    *Reboot)
        [[ $(confirm "Reboot?") == *Yes* ]] && systemctl reboot
        ;;
    *Suspend)
        [[ $(confirm "Suspend?") == *Yes* ]] && systemctl suspend
        ;;
    *Logout)
        [[ $(confirm "Logout?") == *Yes* ]] && pkill -KILL -u "$USER"
        ;;
    *Lock)
        [[ $(confirm "Lock?") == *Yes* ]] && swaylock
        ;;
    *)
        exit 0
        ;;
esac

THEME="~/.config/mango/rofi/powermenu.rasi"

# Power options (6 items for 3x2 grid)
options="⏻ Shutdown\n⟳ Reboot\n⏾ Suspend\n⏼ Logout\n🔒 Lock\n✗ Cancel"

# Confirmation function
confirm() {
    echo -e "✓ Yes\n✗ No" | rofi -dmenu -i -p "$1" -theme "$THEME" -mesg "Are you sure?"
}

choice=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme "$THEME" -dim 50)

case "$choice" in
    *Shutdown)
        [[ $(confirm "Shutdown?") == *Yes* ]] && systemctl poweroff
        ;;
    *Reboot)
        [[ $(confirm "Reboot?") == *Yes* ]] && systemctl reboot
        ;;
    *Suspend)
        [[ $(confirm "Suspend?") == *Yes* ]] && systemctl suspend
        ;;
    *Logout)
        [[ $(confirm "Logout?") == *Yes* ]] && pkill -KILL -u "$USER"
        ;;
    *Lock)
        [[ $(confirm "Lock?") == *Yes* ]] && swaylock
        ;;
    *)
        exit 0
        ;;
esac
