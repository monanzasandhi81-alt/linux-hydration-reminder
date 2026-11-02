#!/bin/bash
cd "$HOME/linux_project/hydrate"
source lib/functions.sh

while true; do
  echo "===== HYDRATION REMINDER ====="
  echo "1) Log water"
  echo "2) Daily total"
  echo "3) Days goal met"
  echo "4) Weekly chart"
  echo "5) Reminder schedule"
  echo "6) View data"
  echo "7) Backup data"
  echo "8) View activity log"
  echo "0) Exit"
  read -r -p "Choose: " ch
  case "$ch" in
    1) feature_1 ;;
    2) feature_2 ;;
    3) feature_3 ;;
    4) feature_4 ;;
    5) feature_5 ;;
    6) view_data ;;
    7) do_backup ;;
    8) show_log ;;
    0) exit 0 ;;
    *) echo "Invalid choice" ;;
  esac
done
