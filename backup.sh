#!/bin/sh

# This script calls a dump script and then transferes the resulting file to FTP

set -e
set -o pipefail

# Run the backup script, send in $BACKUP_DIR, $BACKUP_FILE, the script may set $BACKUP_FILE to something different
BACKUP_DIR="/backup"
BACKUP_FILE="$BACKUP_FILE_PREFIX"_$(date +%Y-%m-%d_%H_%M_%N)
source ./dump.sh

# Upload to FTP
if [ "${BACKUP_FTP_URL}" != "**None**" ]; then
    echo "Uploading backup file ${BACKUP_FILE} to FTP..."
    curl --ftp-create-dirs -T $BACKUP_DIR/$BACKUP_FILE $BACKUP_FTP_URL -k --ftp-ssl
else
    echo "BACKUP_FTP_URL not specified, skipping FTP upload"
fi

# Cleanup the dump locally
if [ "${BACKUP_KEEP_DAYS}" != "**None**" ]; then
    echo "Cleaning up local backup files older than $BACKUP_KEEP_DAYS days..."
    find $BACKUP_DIR -type f -prune -mtime +$BACKUP_KEEP_DAYS -exec rm -f {} \;
else
    echo "Cleaning up local backup file"
    rm $BACKUP_DIR/$BACKUP_FILE
fi

# Message about success
echo "Dump and transfer completed, filename: $BACKUP_FILE"
