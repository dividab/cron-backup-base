#!/bin/sh

set -e

if [ "${BACKUP_SCHEDULE}" = "**None**" ]; then
  sh backup.sh
else
  exec go-cron "$BACKUP_SCHEDULE" /bin/sh backup.sh
fi
