#!/bin/sh

set -e
set -x

if [ "${SCHEDULE}" = "**None**" ]; then
  sh backup.sh
else
  exec go-cron -s $SCHEDULE -p $HEALTH_CHECK_PORT -- /bin/sh backup.sh
fi
