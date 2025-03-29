#!/bin/bash

echo "$(date "+%Y-%m-%d %H:%M:%S")"

CRON_JOB="* * * * * /home/vagrant/log_time.sh >> /home/vagrant/output.txt 2>&1"

crontab -l 2>/dev/null | grep -F "$CRON_JOB" > /dev/null

if [ $? -ne 0 ]; then
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cron Job added."
else
    echo "Cron Job already created!"
fi
