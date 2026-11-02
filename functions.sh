#!/bin/bash
DATA="$HOME/linux_project/hydrate/data/water.log"
LOG="$HOME/linux_project/hydrate/logs/activity.log"
REPORTS="$HOME/linux_project/hydrate/reports"
BACKUPS="$HOME/linux_project/hydrate/backups"
GOAL=2000

mkdir -p "$(dirname "$DATA")" "$(dirname "$LOG")" "$REPORTS" "$BACKUPS"
touch "$DATA" "$LOG"

log(){ echo "$(date '+%F %T') | $*" >> "$LOG"; }

feature_1(){
  read -r -p "Date (YYYY-MM-DD, Enter for today): " d
  d=${d:-$(date +%F)}
  read -r -p "Time (HH:MM): " t
  read -r -p "Water in ml: " ml
  if [[ "$d" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ && "$t" =~ ^[0-9]{2}:[0-9]{2}$ && "$ml" =~ ^[0-9]+$ ]] && ((ml>0)); then
    echo "$d,$t,$ml" >> "$DATA"
    echo "Water intake saved."
    log "Added $ml ml"
  else
    echo "Invalid input."
  fi
}

feature_2(){
  today=$(date +%F)
  total=$(awk -F, -v d="$today" '$1==d{s+=$3}END{print s+0}' "$DATA")
  echo "Today's intake: $total ml"
  echo "Daily goal: $GOAL ml"
  if ((total>=GOAL)); then echo "Goal achieved!"; else echo "$((GOAL-total)) ml remaining."; fi
  log "Daily total checked"
}

feature_3(){
  awk -F, -v g="$GOAL" '{s[$1]+=$3}END{n=0;for(d in s)if(s[d]>=g){print d,s[d]" ml - Goal met";n++}print "Days goal met:",n}' "$DATA"
}

feature_4(){
  for i in 6 5 4 3 2 1 0; do
    d=$(date -d "$i days ago" +%F)
    total=$(awk -F, -v d="$d" '$1==d{s+=$3}END{print s+0}' "$DATA")
    printf '%s | %s ml | ' "$d" "$total"
    for ((j=0;j<total/250 && j<40;j++)); do printf '#'; done
    printf '\n'
  done
}

feature_5(){
  echo "Reminder schedule:"
  echo "0 9-21/2 * * * /bin/bash $HOME/linux_project/hydrate/main.sh --cron"
}

view_data(){ cat "$DATA"; }
do_backup(){ tar -czf "$BACKUPS/data_$(date +%Y%m%d_%H%M%S).tar.gz" "$DATA" && echo "Backup created."; }
show_log(){ tail -n 15 "$LOG"; }
cron_task(){ echo "$(date): Water reminder - remember to drink water." >> "$REPORTS/reminders.txt"; echo "Reminder logged."; }
