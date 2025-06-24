#!/bin/sh

echo "Toggling login state at $(date)" 

# path="/home/konsol/AnantOSLab/var/log/"
# file="AnantOS-$(date +'%d-%b-%Y').log"

# cd $path || exit 1
# touch "$file" || exit 1


LOG_DIR="/var/log"
FILENAME="AnantOS-$(date +'%d-%b-%Y').txt"
FULLPATH="$LOG_DIR/$FILENAME"

mkdir -p "$LOG_DIR" || exit 1


echo "Toggling login state at $(date)" >> "$FULLPATH"


# croneData=$(cat crontab | grep -E 'toggle-user.sh')
# echo "Current cron data: $croneData"

cron_line="0 7 * * * /home/konsol/AnantOSLab/usr/local/bin/toggle-user.sh"
(crontab -l 2>/dev/null | grep -Fv "$cron_line"; echo "$cron_line") | crontab -

cron_line="0 7 * * * /usr/local/bin/toggle-user.sh >> $file 2>&1"
(crontab -l 2>/dev/null | grep -Fv "$cron_line"; echo "$cron_line") | crontab -
