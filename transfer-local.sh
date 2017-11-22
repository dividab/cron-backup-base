#!/bin/sh

set -e
set -o pipefail

if [ "${LOCAL_DIR}" != "**None**" ]; then

    echo "Transfering backup file to local directory $LOCAL_DIR"
    cp -a $BACKUP_FILE $LOCAL_DIR

    # Cleanup the dump locally
    if [ "${LOCAL_KEEP_DAYS}" != "**None**" ]; then
        echo "Cleaning up local backup files older than $LOCAL_KEEP_DAYS days..."
        find $BACKUP_DIR -type f -prune -mtime +$LOCAL_KEEP_DAYS -exec rm -f {} \;
    fi

else
    echo "LOCAL_DIR not specified, skipping local transfer"
fi
