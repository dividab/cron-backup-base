#!/bin/sh

set -e

if [ "${SCHEDULE}" = "**None**" ]; then
  sh backup.sh
else
  exec go-cron -p $HEALTH_CHECK_PORT "$SCHEDULE" /bin/sh backup.sh
fi
